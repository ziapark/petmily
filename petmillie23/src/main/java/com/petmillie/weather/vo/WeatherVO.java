package com.petmillie.weather.vo;

import org.springframework.stereotype.Component;

@Component("WeatherVO")
public class WeatherVO {
    private String category;  // 예: TMP, SKY, etc.
    private String fcstTime;  // 예: 0600
    private String fcstValue; // 예: 27 (기온)
    private String timePeriod; // 오전 / 오후 / 밤
	public String getCategory() {
		return category;
	}
	public void setCategory(String category) {
		this.category = category;
	}
	public String getFcstTime() {
		return fcstTime;
	}
	public void setFcstTime(String fcstTime) {
		this.fcstTime = fcstTime;
	}
	public String getFcstValue() {
		return fcstValue;
	}
	public void setFcstValue(String fcstValue) {
		this.fcstValue = fcstValue;
	}

	public String getTimePeriod() { return timePeriod; }

    private String classifyTimePeriod(String time) {
        int hour = Integer.parseInt(time.substring(0, 2));
        if (hour >= 6 && hour < 12) return "오전";
        else if (hour >= 12 && hour < 18) return "오후";
        else return "밤";
    }
}