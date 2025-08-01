package com.petmillie.weather.vo;

public class WeatherVO {
    private String category;  // 예: TMP, SKY, etc.
    private String fcstTime;  // 예: 0600
    private String fcstValue; // 예: 27 (기온)
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

 
}