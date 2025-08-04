package com.petmillie.weather.controller;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class WeatherSummaryExample {
	
    // 1) 데이터 클래스
    public static class WeatherData {
        int hour;        // 0~23 시각 숫자
        double tmp;      // 기온
        String sky;      // 하늘 상태
        String precipitation; // 강수 형태

        public WeatherData(int hour, double tmp, String sky, String precipitation) {
            this.hour = hour;
            this.tmp = tmp;
            this.sky = sky;
            this.precipitation = precipitation;
        }
        public int getHour() { return hour; }
        public double getTmp() { return tmp; }
        public String getSky() { return sky; }
        public String getPrecipitation() { return precipitation; }
    }

    // 2) 요약 클래스
    public static class WeatherSummary {
        String period;       // 오전, 오후, 밤
        double avgTmp;
        String mainSky;
        String mainPrecipitation;
        public String getPeriod() {
            return period;
        }

        public double getAvgTmp() {
            return avgTmp;
        }

        public String getMainSky() {
            return mainSky;
        }

        public String getMainPrecipitation() {
            return mainPrecipitation;
        }
        public WeatherSummary(String period, double avgTmp, String mainSky, String mainPrecipitation) {
            this.period = period;
            this.avgTmp = avgTmp;
            this.mainSky = mainSky;
            this.mainPrecipitation = mainPrecipitation;
        }

        @Override
        public String toString() {
            return String.format("%s | 평균기온: %.1f℃ | 하늘상태: %s | 강수형태: %s",
                    period, avgTmp, mainSky, mainPrecipitation);
        }
    }

    // 3) 시간대별 그룹핑 & 요약 메서드
    public static List<WeatherSummary> summarizeByPeriod(List<WeatherData> allData) {
        Map<String, List<WeatherData>> grouped = new LinkedHashMap<>();
        grouped.put("오전", new ArrayList<>());
        grouped.put("오후", new ArrayList<>());
		/*
		 * grouped.put("밤", new ArrayList<>());
		 */
        for (WeatherData wd : allData) {
            int hour = wd.getHour();
            if (6 <= hour && hour <= 11) grouped.get("오전").add(wd);
            else if (12 <= hour && hour <= 17) grouped.get("오후").add(wd);
			/* else if (18 <= hour && hour <= 23) grouped.get("밤").add(wd); */
        }

        List<WeatherSummary> result = new ArrayList<>();

        for (Map.Entry<String, List<WeatherData>> entry : grouped.entrySet()) {
            String period = entry.getKey();
            List<WeatherData> list = entry.getValue();
            if (list.isEmpty()) continue;
            double avgTmp = Math.round(list.stream().mapToDouble(WeatherData::getTmp).average().orElse(0) * 10) / 10.0;

            String mainSky = list.stream()
                    .collect(Collectors.groupingBy(WeatherData::getSky, Collectors.counting()))
                    .entrySet().stream()
                    .max(Map.Entry.comparingByValue())
                    .map(Map.Entry::getKey)
                    .orElse("정보없음");

            String mainPrecip = list.stream()
                    .collect(Collectors.groupingBy(WeatherData::getPrecipitation, Collectors.counting()))
                    .entrySet().stream()
                    .max(Map.Entry.comparingByValue())
                    .map(Map.Entry::getKey)
                    .orElse("정보없음");
            

            result.add(new WeatherSummary(period, avgTmp, mainSky, mainPrecip));
        }
        return result;
    }

}
