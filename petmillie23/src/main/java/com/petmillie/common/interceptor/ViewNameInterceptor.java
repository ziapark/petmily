package com.petmillie.common.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

public class ViewNameInterceptor extends  HandlerInterceptorAdapter{
		@Override
		public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {
		    try {
		        String viewName = getViewName(request);
		        request.setAttribute("viewName", viewName);
	
		        if (request instanceof MultipartHttpServletRequest) {
		            return true; // 넘긴다
		        }
		        // 👉 여기에 side_menu 설정 추가!
		        String uri = request.getRequestURI();
	
		        if (uri.contains("/admin/")) {
		            request.setAttribute("side_menu", "admin_mode");
		        } else if (uri.contains("/mypage/")) {
		            request.setAttribute("side_menu", "my_page");
		        } else {
		            request.setAttribute("side_menu", "user_mode");
		        }
	
		    } catch (Exception e) {
		        e.printStackTrace();
		    }
		    return true;
		}

	   
	   
	   @Override
	   public void postHandle(HttpServletRequest request, HttpServletResponse response,
	                           Object handler, ModelAndView modelAndView) throws Exception {
	   }

	   @Override
	   public void afterCompletion(HttpServletRequest request, HttpServletResponse response,
	                                    Object handler, Exception ex)    throws  Exception {
	   }
	   
	   private String getViewName(HttpServletRequest request) throws Exception {
			String contextPath = request.getContextPath();
			String uri = (String) request.getAttribute("javax.servlet.include.request_uri");
			if (uri == null || uri.trim().equals("")) {
				uri = request.getRequestURI();
			}

			int begin = 0;
			if (!((contextPath == null) || ("".equals(contextPath)))) {
				begin = contextPath.length();
			}

			int end;
			if (uri.indexOf(";") != -1) {
				end = uri.indexOf(";");
			} else if (uri.indexOf("?") != -1) {
				end = uri.indexOf("?");
			} else {
				end = uri.length();
			}

			String fileName = uri.substring(begin, end);
			if (fileName.indexOf(".") != -1) {
				fileName = fileName.substring(0, fileName.lastIndexOf("."));
			}
			if (fileName.lastIndexOf("/") != -1) {
				fileName = fileName.substring(fileName.lastIndexOf("/",1), fileName.length());
			}
			return fileName;
		}
	}
