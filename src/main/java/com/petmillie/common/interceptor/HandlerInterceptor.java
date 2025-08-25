package com.petmillie.common.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

public interface HandlerInterceptor {
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception;
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception;
}
