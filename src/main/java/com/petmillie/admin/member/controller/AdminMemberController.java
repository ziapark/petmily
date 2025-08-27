package com.petmillie.admin.member.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

public interface AdminMemberController {
	public ModelAndView adminMemberMain(@RequestParam Map<String, String> dateMap,HttpServletRequest request, HttpServletResponse response)  throws Exception;
	public ModelAndView memberDetail(HttpServletRequest request, HttpServletResponse response)  throws Exception;
	public void modifyMemberInfo(HttpServletRequest request, HttpServletResponse response)  throws Exception;
	
	public void deleteMember(HttpServletRequest request, HttpServletResponse response) throws Exception;

	public ModelAndView adminSellerMemberDetailInfo(@RequestParam("seller_id") String seller_id, HttpServletRequest request, HttpServletResponse response) throws Exception;

}