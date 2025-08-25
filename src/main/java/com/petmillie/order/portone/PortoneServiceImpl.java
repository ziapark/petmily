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

    private final String storeApiSecret = "FvoPZ7XPTJQMZCWDKHRq0Gx80qbymRsX1D7Z2tTJJxXC3rxO7ZqMqmPGftmptzAwzqiKEDTgb2evvwSj";

    private final RestTemplate restTemplate = new RestTemplate();
    private final ObjectMapper objectMapper = new ObjectMapper();

    @Override
    public String getAccessToken() throws Exception {
        return null;
    }

    @Override
    public boolean verifyPayment(String imp_uid, int expectAmount) throws Exception {
        return true;
    }
    
    @Override
    public void cancelPayment(String imp_uid, int amount) throws Exception {
        System.out.println("\n=======================[ V2 API 결제 취소 시도 ]=======================");
        
        try {
            String url = "https://api.portone.io/payments/" + imp_uid + "/cancel";
            
            System.out.println("4. [v2 API 최종] 결제 취소 API 호출...");
            System.out.println("   - 요청 URL: " + url);

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            
            // v2 인증 방식: 'PortOne {SECRET_KEY}'
            headers.set("Authorization", "PortOne " + this.storeApiSecret);

            Map<String, Object> body = new HashMap<>();
            body.put("reason", "고객 요청으로 인한 주문 취소");
            body.put("amount", amount); 
            
            HttpEntity<Map<String, Object>> request = new HttpEntity<>(body, headers);
            ResponseEntity<String> response = restTemplate.postForEntity(url, request, String.class);
            
            System.out.println("5. 포트원으로부터 응답 수신:");
            System.out.println("   - 응답 내용: " + response.getBody());

            if (response.getStatusCode().is2xxSuccessful()) {
                 System.out.println("✅ 6. 최종 성공: 결제 취소 요청이 정상 처리되었습니다.");
            } else {
                JsonNode root = objectMapper.readTree(response.getBody());
                String message = root.path("message").asText("알 수 없는 오류");
                throw new RuntimeException(message);
            }

        } catch (HttpClientErrorException e) {
            System.err.println("❌ HTTP 클라이언트 에러 발생!");
            System.err.println("   - 상태 코드: " + e.getStatusCode());
            String errorMessage = e.getResponseBodyAsString();
            System.err.println("   - 응답 내용: " + errorMessage);
            try {
                JsonNode root = objectMapper.readTree(errorMessage);
                errorMessage = root.path("message").asText(errorMessage);
            } catch (Exception parsingEx) {
                // 파싱 실패 시 원본 메시지 사용
            }
            throw new RuntimeException(errorMessage, e);
        } catch (Exception e) {
            System.err.println("❌ 예상치 못한 에러 발생!");
            e.printStackTrace();
            throw e;
        } finally {
            System.out.println("========================[ V2 API 결제 취소 종료 ]=======================\n");
        }
    }
}
