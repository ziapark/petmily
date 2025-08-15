package com.petmillie.weather.service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
//	
//    private final Map<String, WeatherProductRecommendation> recommendationMap = new HashMap<>();
//
//    public WeatherService() {
//        initRecommendations();
//    }
//
//    private void initRecommendations() {
//        // ☀️ 맑음
//        List<GoodsVO> sunnyGoods = new ArrayList<>();
//        sunnyGoods.add(makeGoods(101, "강아지 우비", "raincoat.jpg"));
//        sunnyGoods.add(makeGoods(102, "산책 하네스", "harness.jpg"));
//        sunnyGoods.add(makeGoods(103, "쿨매트", "coolmat.jpg"));
//
//        recommendationMap.put("맑음", makeRecommendation("맑음☀️", "햇살 가득한 날! 산책용품 준비됐나요?", sunnyGoods));
//
//        // 🌧️ 비
//        List<GoodsVO> rainGoods = new ArrayList<>();
//        rainGoods.add(makeGoods(201, "펫 전용 우비", "raincoat.jpg"));
//        rainGoods.add(makeGoods(202, "방수 산책화", "shoes.jpg"));
//        rainGoods.add(makeGoods(203, "흡수 타올", "towel.jpg"));
//
//        recommendationMap.put("비", makeRecommendation("비🌧️", "비 오는 날엔 우비가 필수에요 ☔", rainGoods));
//
//        // ☁️ 흐림 (예시)
//        List<GoodsVO> cloudyGoods = new ArrayList<>();
//        cloudyGoods.add(makeGoods(301, "간식 모음 세트", "snacks.jpg"));
//        cloudyGoods.add(makeGoods(302, "장난감 랜덤박스", "toys.jpg"));
//        cloudyGoods.add(makeGoods(303, "실내용 하우스", "indoor.jpg"));
//
//        recommendationMap.put("흐림", makeRecommendation("흐림☁", "실내에서 놀아볼까요?", cloudyGoods));
//    }
//
//    private GoodsVO makeGoods(int num, String name, String fileName) {
//        GoodsVO goods = new GoodsVO();
//        goods.setGoods_num(num);
//        goods.setGoods_name(name);
//        return goods;
//    }
//
//    private WeatherProductRecommendation makeRecommendation(String condition, String comment, List<GoodsVO> goodsList) {
//        WeatherProductRecommendation rec = new WeatherProductRecommendation();
//        rec.setWeatherCondition(condition);
//        rec.setComment(comment);
//        rec.setGoodsList(goodsList);
//        return rec;
//    }
//
//    public WeatherProductRecommendation getRecommendation(String weatherCondition) {
//        return recommendationMap.getOrDefault(weatherCondition, null);
//    }
}
