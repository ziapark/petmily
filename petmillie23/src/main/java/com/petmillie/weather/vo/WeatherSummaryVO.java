package com.petmillie.weather.vo;

public class WeatherSummaryVO {
	private int hour;
    private double temperature;
    private String sky;
    private String precipitation;
    private String pop; // 강수확률

    public WeatherSummaryVO(int hour, double temperature, String sky, String precipitation, String pop) {
        this.hour = hour;
        this.temperature = temperature;
        this.sky = sky;
        this.precipitation = precipitation;
        this.pop = pop;
    }

	public int getHour() {
		return hour;
	}

	public void setHour(int hour) {
		this.hour = hour;
	}

	public double getTemperature() {
		return temperature;
	}

	public void setTemperature(double temperature) {
		this.temperature = temperature;
	}

	public String getSky() {
		return sky;
	}

	public void setSky(String sky) {
		this.sky = sky;
	}

	public String getPrecipitation() {
		return precipitation;
	}

	public void setPrecipitation(String precipitation) {
		this.precipitation = precipitation;
	}

	public String getPop() {
		return pop;
	}

	public void setPop(String pop) {
		this.pop = pop;
	}
}