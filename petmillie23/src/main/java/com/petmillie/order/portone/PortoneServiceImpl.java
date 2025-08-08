package com.petmillie.order.portone;

import java.util.HashMap;
import java.util.Map;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

@Service("PortoneService")
public class PortoneServiceImpl implements PortoneService {

    // PortOne 테스트키 (운영은 실제로 발급받은 키로!)
    private final String impKey = "5512642516132355";
    private final String impSecret = "aX2wc3UbDVv04KJ23SLKrYn06Ia7MIJKNjf2IG9CH61MkoxgZLC19sofmessLvDtYoHFAftXSeTrkC7c";

    // paymentKey 기준으로만 결제내역 조회 (PortOne v2 공식 방식)
    public boolean verifyPayment(String paymentKey, int expectAmount) throws Exception {
        System.out.println("🔎 [결제검증] paymentKey: " + paymentKey);

        RestTemplate restTemplate = new RestTemplate();
        String tokenUrl = "https://api.iamport.kr/users/getToken";
        Map<String, String> params = new HashMap<>();
        params.put("imp_key", impKey);
        params.put("imp_secret", impSecret);

        ResponseEntity<String> tokenResponse = restTemplate.postForEntity(tokenUrl, params, String.class);
        ObjectMapper mapper = new ObjectMapper();
        String accessToken = mapper.readTree(tokenResponse.getBody())
                .path("response").path("access_token").asText();
        System.out.println("accessToken :" + accessToken);

        // PortOne v2 결제내역 조회 URL
        String paymentUrl = "https://api.portone.io/payments/paymentKey/" + paymentKey;
        System.out.println("🔥 PortOne v2 결제내역 조회 URL: " + paymentUrl);

        HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", accessToken);
        HttpEntity<?> entity = new HttpEntity<>(headers);
        System.out.println("Authorization: " + accessToken);
        System.out.println("paymentKey: " + paymentKey);
        System.out.println("결제내역 URL: " + paymentUrl);

        ResponseEntity<String> paymentResponse = null;
        int retry = 0, maxRetry = 5;
        while (retry < maxRetry) {
            try {
                paymentResponse = restTemplate.exchange(
                        paymentUrl, HttpMethod.GET, entity, String.class
                );
                break; // 성공하면 루프 탈출
            } catch (org.springframework.web.client.HttpClientErrorException e) {
                // 404/401 등은 최대 5번 재시도 후 실패 처리
                if (e.getStatusCode().value() == 404 && retry < maxRetry - 1) {
                    System.out.println("🚨 [PortOne 결제내역 404] 1.2초 후 재시도(" + (retry + 1) + "/" + maxRetry + ")");
                    Thread.sleep(1200);
                    retry++;
                } else {
                    // 프론트엔드로 JSON 형식의 에러 메시지 전달
                    String errorMsg = String.format("{\"success\":false,\"message\":\"PortOne 결제내역 조회 실패 (%s): %s\"}",
                            e.getStatusCode(), e.getResponseBodyAsString());
                    throw new RuntimeException(errorMsg);
                }
            }
        }

        if (paymentResponse == null) {
            throw new RuntimeException("{\"success\":false,\"message\":\"PortOne 결제내역 조회에 실패했습니다. (응답 없음)\"}");
        }

        JsonNode responseNode = mapper.readTree(paymentResponse.getBody()).path("response");
        int amount = responseNode.path("amount").asInt();
        String status = responseNode.path("status").asText();

        System.out.println("결제상태=" + status + ", 결제금액=" + amount + ", 기대금액=" + expectAmount);

        // 결제 상태가 'paid'고, 금액이 맞는지 체크
        return ("paid".equals(status) && amount == expectAmount);
    }
}
