package com.petmillie.main;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.petmillie.common.base.BaseController;
import com.petmillie.goods.service.GoodsService;
import com.petmillie.goods.vo.GoodsVO;
import com.petmillie.weather.controller.WeatherSummaryExample;
import com.petmillie.weather.controller.WeatherSummaryExample.WeatherData;
import com.petmillie.weather.controller.WeatherSummaryExample.WeatherSummary;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Controller("mainController")
@EnableAspectJAutoProxy
public class MainController extends BaseController {
	@Autowired
	private GoodsService goodsService;

	@RequestMapping(value = "/main/main.do", method = { RequestMethod.POST, RequestMethod.GET })
	public ModelAndView main(HttpServletRequest request, HttpServletResponse response) throws Exception {
	    HttpSession session;
	    String viewName = (String) request.getAttribute("viewName");
	    ModelAndView mav = new ModelAndView("/common/layout");
	    mav.addObject("body", "/WEB-INF/views" + viewName + ".jsp");

	    session = request.getSession();
	    session.setAttribute("side_menu", "user");

	    Map<String, List<GoodsVO>> goodsMap = goodsService.listGoods();
	    mav.addObject("goodsMap", goodsMap);

	    // 날씨 API 호출
	    String apiUrl = "https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst";
	    apiUrl += "?serviceKey=IX5Ur3cyKoMyeGHmNfpMu19SR911eW5KFrGogiTIYxZHp76mPrq8TOH9TKOnF2msSzo9h37p1gcAj%2FRB4uf2DA%3D%3D";
	    apiUrl += "&numOfRows=100&pageNo=1&dataType=JSON&base_date=20250801&base_time=0500&nx=60&ny=127";

	    URL url = new URL(apiUrl);
	    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
	    conn.setRequestMethod("GET");

	    BufferedReader rd;
	    if (conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
	        rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
	    } else {
	        rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
	    }

	    StringBuilder sb = new StringBuilder();
	    String line;
	    while ((line = rd.readLine()) != null) {
	        sb.append(line);
	    }
	    rd.close();
	    conn.disconnect();

	    System.out.println("👉 날씨 API 응답: " + sb.toString());

	    // JSON 파싱 및 null 방어
	    try {
	        JSONObject json = JSONObject.fromObject(sb.toString());
	        JSONObject responseObj = json.optJSONObject("response");

	        if (responseObj != null) {
	            JSONObject header = responseObj.optJSONObject("header");
	            String resultCode = header != null ? header.optString("resultCode") : "UNKNOWN";
	            System.out.println("▶ resultCode: " + resultCode);

	            if ("00".equals(resultCode)) {
	                JSONObject body = responseObj.optJSONObject("body");
	                JSONObject items = body != null ? body.optJSONObject("items") : null;
	                JSONArray itemArray = items != null ? items.optJSONArray("item") : null;

	                if (itemArray != null && !itemArray.isEmpty()) {
	                    Map<String, Map<String, String>> timeWeatherMap = new HashMap<>();

	                    for (int i = 0; i < itemArray.size(); i++) {
	                        JSONObject item = itemArray.getJSONObject(i);
	                        String category = item.getString("category");
	                        String fcstValue = item.getString("fcstValue");
	                        String fcstTime = item.getString("fcstTime");

	                        timeWeatherMap.putIfAbsent(fcstTime, new HashMap<>());
	                        timeWeatherMap.get(fcstTime).put(category, fcstValue);
	                    }

	                    List<WeatherData> weatherDataList = new ArrayList<>();
	                    for (String fcstTime : timeWeatherMap.keySet()) {
	                        Map<String, String> data = timeWeatherMap.get(fcstTime);
	                        if (data.containsKey("TMP") && data.containsKey("SKY") && data.containsKey("PTY")) {
	                            int hour = Integer.parseInt(fcstTime.substring(0, 2));
	                            double tmp = Double.parseDouble(data.get("TMP"));
	                            String sky = mapSkyCodeToString(data.get("SKY"));
	                            String precipitation = mapPtyCodeToString(data.get("PTY"));

	                            weatherDataList.add(new WeatherData(hour, tmp, sky, precipitation));
	                        }
	                    }

	                    List<WeatherSummary> summaries = WeatherSummaryExample.summarizeByPeriod(weatherDataList);
	                    mav.addObject("weatherSummaries", summaries);
	                } else {
	                    System.out.println("⚠️ item 배열이 없거나 비어 있음");
	                }
	            } else {
	                System.out.println("❌ 기상청 API 오류: " + header.optString("resultMsg"));
	            }
	        } else {
	            System.out.println("❌ response 객체 자체가 null임");
	        }
	    } catch (Exception e) {
	        System.out.println("💥 날씨 API 파싱 오류 발생:");
	        e.printStackTrace();  // 개발 중일 때만 콘솔 출력
	    }

	    return mav;
	}

	private String mapSkyCodeToString(String code) {
	    switch (code) {
	        case "1": return "맑음";
	        case "3": return "구름많음";
	        case "4": return "흐림";
	        default: return "정보없음";
	    }
	}

	private String mapPtyCodeToString(String code) {
	    switch (code) {
	        case "0": return "없음";
	        case "1": return "비";
	        case "2": return "비/눈";
	        case "3": return "눈";
	        case "4": return "소나기";
	        default: return "정보없음";
	    }
	}
}
