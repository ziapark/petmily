package com.petmillie.reservation.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

public interface ReservaionController {
	
	public ModelAndView serachReservaion(HttpServletRequest request, HttpServletResponse response) throws Exception;
	

}
