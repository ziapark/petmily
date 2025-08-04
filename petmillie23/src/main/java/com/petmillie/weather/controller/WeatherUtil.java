package com.petmillie.weather.controller;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.petmillie.weather.vo.WeatherVO;

public class WeatherUtil {

    public static List<WeatherVO> getWeatherData(String baseDate, String baseTime, int nx, int ny) throws Exception {
        String serviceKey = "IX5Ur3cyKoMyeGHmNfpMu19SR911eW5KFrGogiTIYxZHp76mPrq8TOH9TKOnF2msSzo9h37p1gcAj%2FRB4uf2DA%3D%3D";
        String urlStr = "https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst"
                + "?serviceKey=" + serviceKey
                + "&pageNo=1"
                + "&numOfRows=1000"
                + "&dataType=JSON"
                + "&base_date=" + baseDate
                + "&base_time=" + baseTime
                + "&nx=" + nx
                + "&ny=" + ny;

        URL url = new URL(urlStr);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");

        BufferedReader rd = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = rd.readLine()) != null) {
            sb.append(line);
        }
        rd.close();

        // JSON 파싱
        ObjectMapper objectMapper = new ObjectMapper();
        JsonNode rootNode = objectMapper.readTree(sb.toString());
        JsonNode itemsNode = rootNode.path("response").path("body").path("items").path("item");

        List<WeatherVO> weatherList = new ArrayList<>();
        for (JsonNode item : itemsNode) {
            WeatherVO vo = new WeatherVO();
            vo.setCategory(item.get("category").asText());
            vo.setFcstTime(item.get("fcstTime").asText());
            vo.setFcstValue(item.get("fcstValue").asText());
            weatherList.add(vo);
        }

        return weatherList;
    }
}
