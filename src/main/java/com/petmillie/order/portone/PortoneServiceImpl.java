package com.petmillie.order.portone;

import java.util.HashMap;
import java.util.Map;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

@Service("PortoneService")
public class PortoneServiceImpl implements PortoneService {

    // V1 방식에서는 API Key와 API Secret이 모두 필요합니다.
    // ※주의: 이 값들은 실제 결제가 이루어진 storeId에 해당하는 '진짜' 키여야 합니다.
    private final String impKey = "0744426732083731";
    private final String impSecret = "WBYvzwfTmkM0TLAJXiMQaE4ymcOZ0grGJ4SA90nKMxdTLtPNmWKN3zjYa0G51OCzPXMA813R0UNDwwXw";

    private final RestTemplate restTemplate = new RestTemplate();
    private final ObjectMapper objectMapper = new ObjectMapper();

    /**
     * [V1 방식] 포트원 API 인증 토큰을 발급받는 메소드
     * @return String accessToken
     * @throws Exception
     */
    @Override
    public String getAccessToken() throws Exception {
        String url = "https://api.iamport.kr/users/getToken";

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        Map<String, String> body = new HashMap<>();
        body.put("imp_key", this.impKey);
        body.put("imp_secret", this.impSecret);
        
        HttpEntity<Map<String, String>> request = new HttpEntity<>(body, headers);
        ResponseEntity<String> response = restTemplate.postForEntity(url, request, String.class);
        
        JsonNode root = objectMapper.readTree(response.getBody());
        String accessToken = root.path("response").path("access_token").asText();
        
        if (accessToken == null || accessToken.trim().isEmpty()) {
            throw new RuntimeException("포트원 인증 토큰을 발급받지 못했습니다. API Key와 Secret을 확인해주세요.");
        }
        return accessToken;
    }

    /**
     * [V1 방식] 결제 정보를 검증하는 메소드
     * @param imp_uid 포트원 거래 고유번호
     * @param expectAmount 예상 결제 금액
     * @return boolean 검증 성공 여부
     * @throws Exception
     */
    @Override
    public boolean verifyPayment(String imp_uid, int expectAmount) throws Exception {
        System.out.println("🔎 [V1 결제검증] imp_uid: " + imp_uid);

        String accessToken = this.getAccessToken();
        System.out.println("   > accessToken 발급 성공");

        String paymentUrl = "https://api.iamport.kr/payments/" + imp_uid;
        
        HttpHeaders headers = new HttpHeaders();
        headers.setBearerAuth(accessToken);
        HttpEntity<?> entity = new HttpEntity<>(headers);

        try {
            ResponseEntity<String> paymentResponse = restTemplate.exchange(
                    paymentUrl, HttpMethod.GET, entity, String.class
            );

            JsonNode responseNode = objectMapper.readTree(paymentResponse.getBody()).path("response");
            int amount = responseNode.path("amount").asInt();
            String status = responseNode.path("status").asText();

            System.out.println("   > 결제상태=" + status + ", 결제금액=" + amount + ", 기대금액=" + expectAmount);
            return ("paid".equals(status) && amount == expectAmount);

        } catch (HttpClientErrorException e) {
            System.err.println("   > [V1] 결제 정보 조회 실패: " + e.getResponseBodyAsString());
            return false;
        }
    }
    
    /**
     * [V1 방식] 결제를 취소하고 상세한 과정을 로그로 남기는 메소드
     * @param imp_uid DB에서 가져온, 취소할 주문의 imp_uid
     * @throws Exception
     */
    @Override
    public void cancelPayment(String imp_uid) throws Exception {
        System.out.println("\n=======================[ V1 결제 취소 프로세스 시작 ]=======================");
        System.out.println("1. DB에서 전달된 취소 요청 imp_uid: " + imp_uid);

        try {
            System.out.println("2. API 키 확인 (Java 코드에 직접 입력된 값)");
            System.out.println("   - imp_key: " + this.impKey);
            System.out.println("   - imp_secret (앞 4자리): " + (this.impSecret != null && this.impSecret.length() > 4 ? this.impSecret.substring(0, 4) : "SECRET_KEY_IS_TOO_SHORT_OR_NULL"));

            System.out.println("3. 인증 토큰 발급 요청 시작...");
            String accessToken = getAccessToken();
            System.out.println("   > 토큰 발급 성공! (토큰 앞 10자리): " + (accessToken != null && accessToken.length() > 10 ? accessToken.substring(0, 10) : "TOKEN_IS_TOO_SHORT_OR_NULL"));

            String url = "https://api.iamport.kr/payments/cancel";
            System.out.println("4. 결제 취소 API 호출...");
            System.out.println("   - 요청 URL: " + url);
            System.out.println("   - 전달하는 imp_uid: " + imp_uid);

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            headers.setBearerAuth(accessToken);

            Map<String, String> body = new HashMap<>();
            body.put("imp_uid", imp_uid);
            
            HttpEntity<Map<String, String>> request = new HttpEntity<>(body, headers);
            ResponseEntity<String> response = restTemplate.postForEntity(url, request, String.class);
            
            System.out.println("5. 포트원으로부터 응답 수신:");
            System.out.println("   - 응답 내용: " + response.getBody());

            JsonNode root = objectMapper.readTree(response.getBody());
            int code = root.path("code").asInt();
            
            if (code != 0) {
                String message = root.path("message").asText();
                System.err.println("   > 취소 실패! (응답 코드: " + code + ", 메시지: " + message + ")");
                throw new RuntimeException(message);
            }

            System.out.println("✅ 6. 최종 성공: 결제 취소 요청이 정상 처리되었습니다.");

        } catch (HttpClientErrorException e) {
            System.err.println("❌ HTTP 클라이언트 에러 발생! (예: 401 Unauthorized, 404 Not Found)");
            System.err.println("   - 상태 코드: " + e.getStatusCode());
            System.err.println("   - 응답 내용: " + e.getResponseBodyAsString());
            throw new RuntimeException("포트원 통신 중 에러가 발생했습니다. 서버 로그를 확인해주세요.", e);
        } catch (Exception e) {
            System.err.println("❌ 예상치 못한 에러 발생!");
            e.printStackTrace();
            throw e;
        } finally {
            System.out.println("========================[ V1 결제 취소 프로세스 종료 ]=======================\n");
        }
    }
}
