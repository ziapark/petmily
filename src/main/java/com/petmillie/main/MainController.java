package com.petmillie.main;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
import com.petmillie.mypage.service.MyPageService;
import com.petmillie.mypage.vo.LikeGoodsVO;
import com.petmillie.weather.service.WeatherService;
import com.petmillie.weather.vo.WeatherProductRecommendation;
import com.petmillie.weather.vo.WeatherSummaryVO;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Controller("mainController")
@EnableAspectJAutoProxy
public class MainController extends BaseController {
    @Autowired
    private GoodsService goodsService;
    @Autowired
    private WeatherService weatherService;
    @Autowired
    private MyPageService myPageService;
    @RequestMapping(value = "/main/main.do", method = {RequestMethod.POST, RequestMethod.GET})
    public ModelAndView main(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession();
        String viewName = (String) request.getAttribute("viewName");
        ModelAndView mav = new ModelAndView("/common/layout");
        mav.addObject("body", "/WEB-INF/views" + viewName + ".jsp");
        session.setAttribute("side_menu", "user");

        Map<String, List<GoodsVO>> goodsMap = goodsService.listGoods();
        mav.addObject("goodsMap", goodsMap);

        // base_date, base_time 계산 (기존 코드 유지)
        Calendar now = Calendar.getInstance();
        int[] baseTimes = {2300, 2000, 1700, 1400, 1100, 800, 500, 200};
        int hour = now.get(Calendar.HOUR_OF_DAY);
        int minute = now.get(Calendar.MINUTE);

        int baseTimeInt = 0;
        for (int t : baseTimes) {
            int tHour = t / 100;
            if (hour > tHour || (hour == tHour && minute >= 40)) {
                baseTimeInt = t;
                break;
            }
        }
        if (baseTimeInt == 0) {
            baseTimeInt = 2300;
            now.add(Calendar.DATE, -1);
        }

        String baseDate = new SimpleDateFormat("yyyyMMdd").format(now.getTime());
        String baseTime = "0800";  // 고정해도 되고 baseTimeInt로 동적으로 써도 됨
        
        System.out.println("현재 baseDate: " + baseDate);
        System.out.println("현재 baseTime: " + baseTime);

        // 기상청 API 호출 URL 생성
        String apiUrl = "https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst";
        apiUrl += "?serviceKey=IX5Ur3cyKoMyeGHmNfpMu19SR911eW5KFrGogiTIYxZHp76mPrq8TOH9TKOnF2msSzo9h37p1gcAj%2FRB4uf2DA%3D%3D";
        apiUrl += "&numOfRows=100&pageNo=1&dataType=JSON&base_date=" + baseDate + "&base_time=" + baseTime + "&nx=60&ny=127";

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

        String result = sb.toString();
        System.out.println("📦 기상청 API 응답: " + result);

        if (!result.trim().startsWith("{")) {
            System.out.println("⚠ JSON 형식 아님: API 호출 실패 또는 XML 응답");
            mav.addObject("weatherSummaries", Collections.emptyList());
            return mav;
        }

        JSONObject json = JSONObject.fromObject(result);
        JSONObject responseObj = json.optJSONObject("response");
        if (responseObj == null) {
            System.out.println("⚠ response 객체가 null");
            mav.addObject("weatherSummaries", Collections.emptyList());
            return mav;
        }

        JSONObject headerObj = responseObj.optJSONObject("header");
        if (headerObj != null) {
            String resultCode = headerObj.optString("resultCode");
            String resultMsg = headerObj.optString("resultMsg");
            if (!"00".equals(resultCode)) {
                System.out.println("⚠ API 오류 발생: " + resultCode + " / " + resultMsg);
                mav.addObject("weatherError", "기상청 API 오류: " + resultMsg);
                mav.addObject("weatherSummaries", Collections.emptyList());
                return mav;
            }
        }

        JSONObject bodyObj = responseObj.optJSONObject("body");
        if (bodyObj == null) {
            System.out.println("⚠ body 객체가 null");
            mav.addObject("weatherSummaries", Collections.emptyList());
            return mav;
        }

        JSONObject itemsObj = bodyObj.optJSONObject("items");
        if (itemsObj == null) {
            System.out.println("⚠ items 객체가 null");
            mav.addObject("weatherSummaries", Collections.emptyList());
            return mav;
        }

        JSONArray items = itemsObj.optJSONArray("item");
        if (items == null || items.isEmpty()) {
            System.out.println("⚠ item 배열이 null 또는 비어있음");
            mav.addObject("weatherSummaries", Collections.emptyList());
            return mav;
        }

        // 시간별 카테고리별 데이터 저장
        Map<String, Map<String, String>> timeWeatherMap = new HashMap<>();
        for (int i = 0; i < items.size(); i++) {
            JSONObject item = items.getJSONObject(i);
            String category = item.getString("category");
            String fcstValue = item.getString("fcstValue");
            String fcstTime = item.getString("fcstTime");

            timeWeatherMap.putIfAbsent(fcstTime, new HashMap<>());
            timeWeatherMap.get(fcstTime).put(category, fcstValue);
        }

        // 오전, 오후 데이터 리스트로 분류
        Map<String, List<WeatherSummaryVO>> periodWeatherMap = new HashMap<>();
        periodWeatherMap.put("오전", new ArrayList<>());
        periodWeatherMap.put("오후", new ArrayList<>());

        for (String fcstTime : timeWeatherMap.keySet()) {
            Map<String, String> data = timeWeatherMap.get(fcstTime);
            if (data.containsKey("TMP") && data.containsKey("SKY") && data.containsKey("PTY") && data.containsKey("POP")) {
                int hourVal = Integer.parseInt(fcstTime.substring(0, 2));
                double tmp = Double.parseDouble(data.get("TMP"));
                String sky = mapSkyCodeToString(data.get("SKY"));
                String precipitation = mapPtyCodeToString(data.get("PTY"));
                String pop = data.get("POP");

                WeatherSummaryVO wd = new WeatherSummaryVO(hourVal, tmp, sky, precipitation, pop);

                if (hourVal >= 6 && hourVal <= 11) {
                    periodWeatherMap.get("오전").add(wd);
                } else if (hourVal >= 12 && hourVal <= 17) {
                    periodWeatherMap.get("오후").add(wd);
                }
            }
        }

        // 오전/오후 평균값 계산
        Map<String, WeatherSummaryVO> avgWeatherMap = calculateAverageWeather(periodWeatherMap);
        // 뷰에 평균값, 원본 데이터 넘기기
        mav.addObject("avgWeatherMap", avgWeatherMap);
        mav.addObject("periodWeatherMap", periodWeatherMap);
        mav.addObject("goodsMap", goodsMap);

        // 현재 날씨 판단 (추천상품용)
        String currentWeather = determineCurrentWeather(timeWeatherMap);
        WeatherProductRecommendation rec = weatherService.getRecommendationFromDB(currentWeather);
        mav.addObject("weatherRecommendation", rec);

        
        List<LikeGoodsVO> wishlist = myPageService.selectBestWish(3);
        
		/*
		 * for(LikeGoodsVO w : wishlist) { System.out.println("관심상품 파일명" +
		 * w.getGoods_fileName()); }
		 */
        
        mav.addObject("wishlist", wishlist);
        return mav;
    }

    // 오전/오후별 평균 계산 메서드
    private Map<String, WeatherSummaryVO> calculateAverageWeather(Map<String, List<WeatherSummaryVO>> periodWeatherMap) {
        Map<String, WeatherSummaryVO> avgMap = new HashMap<>();
        for (String period : periodWeatherMap.keySet()) {
            List<WeatherSummaryVO> list = periodWeatherMap.get(period);
            if (list == null || list.isEmpty()) continue;
            avgMap.put(period, calculateAverage(list));
        }
        return avgMap;
    }

    // 리스트 내 항목 평균 계산
    private WeatherSummaryVO calculateAverage(List<WeatherSummaryVO> list) {
        double sumTemp = 0;
        int sumPop = 0;
        Map<String, Integer> skyCount = new HashMap<>();
        Map<String, Integer> ptyCount = new HashMap<>();

        for (WeatherSummaryVO w : list) {
            sumTemp += w.getTemperature();
            try {
                sumPop += Integer.parseInt(w.getPop());
            } catch (NumberFormatException e) {
                // 숫자가 아니면 0으로 처리
            }
            skyCount.put(w.getSky(), skyCount.getOrDefault(w.getSky(), 0) + 1);
            ptyCount.put(w.getPrecipitation(), ptyCount.getOrDefault(w.getPrecipitation(), 0) + 1);
        }
        int count = list.size();
        double avgTemp = sumTemp / count;
        int avgPop = sumPop / count;

        String mostCommonSky = getMostFrequent(skyCount);
        String mostCommonPty = getMostFrequent(ptyCount);

        int representativeHour = list.get(count / 2).getHour();

        return new WeatherSummaryVO(representativeHour, avgTemp, mostCommonSky, mostCommonPty, String.valueOf(avgPop));
    }

    private String getMostFrequent(Map<String, Integer> map) {
        return map.entrySet().stream()
                .max(Map.Entry.comparingByValue())
                .map(Map.Entry::getKey)
                .orElse("정보없음");
    }

    // 현재 날씨 판단 메서드 (추천 상품용)
    private String determineCurrentWeather(Map<String, Map<String, String>> timeWeatherMap) {
        String currentWeather = "맑음";
        String checkTime = "0900";
        Map<String, String> weatherData = timeWeatherMap.get(checkTime);

        if (weatherData != null) {
            String pty = weatherData.get("PTY");
            String sky = weatherData.get("SKY");

            if (pty != null && !"0".equals(pty)) {
                switch (pty) {
                    case "1": case "4":
                        return "비";
                    case "2": case "3":
                        return "눈";
                }
            } else if (sky != null) {
                if ("4".equals(sky) || "3".equals(sky)) {
                    return "흐림";
                }
            }
        }

        return currentWeather;
    }

    // 코드 변환용 헬퍼 메서드
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
