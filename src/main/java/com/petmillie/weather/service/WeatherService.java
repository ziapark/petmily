package com.petmillie.weather.service;

import java.util.Collections;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.petmillie.goods.dao.GoodsDAO;
import com.petmillie.goods.vo.GoodsVO;
import com.petmillie.weather.vo.WeatherProductRecommendation;

@Service("weatherService")
public class WeatherService {
	@Autowired
	private GoodsDAO goodsDAO;
	
	public WeatherProductRecommendation getRecommendationFromDB(String currentWeather) {
		List<GoodsVO> allMatchedGoods = goodsDAO.selectGoodsByRecommendation(currentWeather);
		
	    Collections.shuffle(allMatchedGoods);
	    List<GoodsVO> selected = allMatchedGoods.stream().limit(3).toList();

	    WeatherProductRecommendation rec = new WeatherProductRecommendation();
	    rec.setWeatherCondition(currentWeather);
	    rec.setComment(currentWeather + " 날씨에 추천하는 상품이에요!");
	    rec.setGoodsList(selected);

	    return rec;
	}
}
