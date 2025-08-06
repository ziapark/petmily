 package com.petmillie.weather.controller;
 
 import java.io.BufferedReader;
 import java.io.InputStreamReader;
 import java.net.HttpURLConnection;
 import java.net.URL;
 import java.net.URLEncoder;
 import java.util.HashMap;
 import java.util.Map;

 import org.springframework.http.MediaType;
 import org.springframework.stereotype.Controller;
 import org.springframework.web.bind.annotation.*;

 import net.sf.json.JSONArray;
 import net.sf.json.JSONObject;

 import javax.servlet.http.HttpServletResponse;

 @Controller
 public class LocationController {

     private static final String KAKAO_REST_API_KEY = "eec97458ce1a7c5f6ccd7f2cb8445e67"; // REST API 키

     @PostMapping(value = "/location", produces = MediaType.APPLICATION_JSON_VALUE)
     @ResponseBody
     public Map<String, Object> getAddressFromCoordinates(@RequestBody Map<String, Object> body, HttpServletResponse response) throws Exception {
         double latitude = Double.parseDouble(body.get("latitude").toString());
         double longitude = Double.parseDouble(body.get("longitude").toString());

         String coord = longitude + "," + latitude;

         String apiUrl = "https://dapi.kakao.com/v2/local/geo/coord2regioncode.json?x=" + 
                          URLEncoder.encode(String.valueOf(longitude), "UTF-8") + 
                          "&y=" + URLEncoder.encode(String.valueOf(latitude), "UTF-8");

         URL url = new URL(apiUrl);
         HttpURLConnection conn = (HttpURLConnection) url.openConnection();
         conn.setRequestProperty("Authorization", "KakaoAK " + KAKAO_REST_API_KEY);
         conn.setRequestMethod("GET");

         BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
         StringBuilder sb = new StringBuilder();
         String line;
         while((line = br.readLine()) != null) {
             sb.append(line);
         }

         br.close();
         conn.disconnect();

         JSONObject json = JSONObject.fromObject(sb.toString());
         JSONArray documents = json.optJSONArray("documents");

         String addressName = "위치 정보 없음";
         if (documents != null && !documents.isEmpty()) {
             JSONObject region = documents.getJSONObject(0);
             addressName = region.optString("region_2depth_name"); // 예: 유성구
         }

         Map<String, Object> result = new HashMap<>();
         result.put("address", addressName);
         return result;
     }
 }