package com.petmillie.weather.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.petmillie.weather.service.WeatherService;
import com.petmillie.weather.vo.WeatherProductRecommendation;

@Controller
public class WeatherController {

    @Autowired
    private WeatherService weatherService;

    @GetMapping("/weather")
    public String showWeather(Model model) {
        String currentWeather = "맑음"; // 날씨 API에서 받아온 값 사용

        WeatherProductRecommendation rec = weatherService.getRecommendation(currentWeather);
        model.addAttribute("weatherRecommendation", rec);

        return "weatherView";
    }
}