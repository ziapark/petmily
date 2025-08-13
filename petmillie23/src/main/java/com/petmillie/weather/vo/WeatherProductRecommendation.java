package com.petmillie.weather.vo;

import java.util.List;

import com.petmillie.goods.vo.GoodsVO;

public class WeatherProductRecommendation {
	private String weatherCondition; // ex. "맑음", "비", "흐림"
    private String comment; // 날씨 멘트
    private List<GoodsVO> goodsList;
	public String getWeatherCondition() {
		return weatherCondition;
	}
	public void setWeatherCondition(String weatherCondition) {
		this.weatherCondition = weatherCondition;
	}
	public String getComment() {
		return comment;
	}
	public void setComment(String comment) {
		this.comment = comment;
	}
	public List<GoodsVO> getGoodsList() {
		return goodsList;
	}
	public void setGoodsList(List<GoodsVO> goodsList) {
		this.goodsList = goodsList;
	}

    
}
