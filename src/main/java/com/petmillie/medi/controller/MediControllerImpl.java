package com.petmillie.medi.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;
@Controller("mediController")
@RequestMapping(value="/medi")
public class MediControllerImpl {
	@RequestMapping("/hptAndPms.do")
	public ModelAndView hptAndPms(HttpServletRequest request) {
		String viewName = (String) request.getAttribute("viewName");
	    ModelAndView mav = new ModelAndView("/common/layout");
	    mav.addObject("title", "펫밀리");
	    mav.addObject("body", "/WEB-INF/views" + viewName + ".jsp");
	    
		return mav;
	}
	

}
