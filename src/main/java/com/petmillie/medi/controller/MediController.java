package com.petmillie.medi.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.servlet.ModelAndView;

public interface MediController {
	public ModelAndView hptAndPms(HttpServletRequest request) throws Exception;
}
