package com.petmillie.order.portone;

import java.util.HashMap;
import java.util.Map;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

@Service("PortoneService")
public class PortoneServiceImpl implements PortoneService {

	@Override
	public boolean verifyPayment(String impUid, String merchantUid) throws JsonMappingException, JsonProcessingException {
	    String impKey = "imp_apikey";    // 테스트용 발급 키!
	    String impSecret = "imp_secret"; // 테스트용 발급 시크릿!
	    RestTemplate restTemplate = new RestTemplate();

	    // 토큰 발급
	    String tokenUrl = "https://api.iamport.kr/users/getToken";
	    Map<String, String> tokenParams = new HashMap<>();
	    tokenParams.put("imp_key", impKey);
	    tokenParams.put("imp_secret", impSecret);

	    ResponseEntity<String> tokenResponse = restTemplate.postForEntity(tokenUrl, tokenParams, String.class);
	    ObjectMapper mapper = new ObjectMapper();
	    String accessToken = mapper.readTree(tokenResponse.getBody()).path("response").path("access_token").asText();

	    // 결제내역 조회
	    String paymentUrl = "https://api.iamport.kr/payments/" + impUid;
	    HttpHeaders headers = new HttpHeaders();
	    headers.set("Authorization", accessToken);
	    HttpEntity<String> entity = new HttpEntity<>(headers);

	    ResponseEntity<String> paymentResponse = restTemplate.exchange(paymentUrl, HttpMethod.GET, entity, String.class);
	    JsonNode responseJson = mapper.readTree(paymentResponse.getBody());
	    JsonNode payInfo = responseJson.path("response");

	    String status = payInfo.path("status").asText();
	    String payMerchantUid = payInfo.path("merchant_uid").asText();
	    int amount = payInfo.path("amount").asInt();

	    // 테스트니까 일단 status가 'paid'인지, 주문번호가 맞는지만 체크!
	    if (!"paid".equals(status)) return false;
	    if (!merchantUid.equals(payMerchantUid)) return false;
	    // (테스트라면 금액도 비교 가능)

	    return true;
	}

	
}
