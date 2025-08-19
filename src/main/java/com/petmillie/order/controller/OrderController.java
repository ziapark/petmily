package com.petmillie.order.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.petmillie.order.vo.OrderVO;

public interface OrderController {
	public ModelAndView orderEachGoods(@ModelAttribute("orderVO") OrderVO _orderVO,HttpServletRequest request, HttpServletResponse response) throws Exception;
	public ModelAndView orderAllCartGoods(@RequestParam("goods_num") int[] goods_num_arr, @RequestParam("cart_goods_qty") int[] cart_goods_qty_arr, HttpServletRequest request, HttpServletResponse response) throws Exception;
	public ModelAndView payComplete(HttpServletRequest request, HttpServletResponse response) throws Exception;
}
