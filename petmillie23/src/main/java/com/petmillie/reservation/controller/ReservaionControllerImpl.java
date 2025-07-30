package com.petmillie.reservation.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

@Controller("ReservaionController")
@RequestMapping("/reservation")
public class ReservaionControllerImpl implements ReservaionController {
	
	@RequestMapping(value="/*Form.do", method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView Form(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String viewName = (String) request.getAttribute("viewName");
		ModelAndView mav = new ModelAndView("/common/layout");
		mav.addObject("title", "메인페이지");
		mav.addObject("body", "/WEB-INF/views" + viewName + ".jsp");
		return mav;
	}

	@Override
	@RequestMapping(value="reservaion.do", method= {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView serachReservaion(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		return null;
	}
	
	

}
