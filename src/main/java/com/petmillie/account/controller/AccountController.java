package com.petmillie.account.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

public interface AccountController {
	public ModelAndView accountMain(@RequestParam(required = false) Map<String, String> dateMap, HttpServletRequest request, HttpServletResponse response) throws Exception;
	public ResponseEntity<String> updateCommission(@RequestParam("seller_id") String sellerId,
            @RequestParam("commission_rate") double commissionRate,
            HttpServletRequest request, HttpServletResponse response) throws Exception;
    public ModelAndView detail(@RequestParam("seller_id") String seller_id,
            @RequestParam(required = false) Map<String, String> dateMap,
            HttpServletRequest request, HttpServletResponse response) throws Exception;
}
