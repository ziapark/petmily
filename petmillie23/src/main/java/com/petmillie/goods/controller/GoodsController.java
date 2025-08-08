package com.petmillie.goods.controller;

import java.util.List; // List import 추가
import java.util.Map;  // Map import 추가

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.petmillie.goods.vo.GoodsVO; // GoodsVO import 추가

public interface GoodsController {
    // 기존 메서드들
    public ModelAndView goodsDetail(@RequestParam("goods_num") int goods_num, HttpServletRequest request, HttpServletResponse response) throws Exception;
    public @ResponseBody String keywordSearch(@RequestParam("keyword") String keyword, HttpServletRequest request, HttpServletResponse response) throws Exception;
    public ModelAndView searchGoods(@RequestParam("searchWord") String searchWord, HttpServletRequest request, HttpServletResponse response) throws Exception;
    public Map<String, List<GoodsVO>> listGoods() throws Exception; 
}