package com.petmillie.common.interceptor;


import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

@Component
public class LocaleInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        // 요청 파라미터 lang 체크
        String langParam = request.getParameter("lang");
        if (langParam != null && !langParam.isEmpty()) {
            request.getSession().setAttribute("lang", langParam);
        }
        return true; // 다음 핸들러 진행
    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response,
                           Object handler, ModelAndView modelAndView) throws Exception {
        if (modelAndView != null) {
            String lang = (String) request.getSession().getAttribute("lang");
            if (lang == null) {
                lang = request.getLocale().getLanguage(); // 기본 로케일
            }
            modelAndView.addObject("lang", lang);
        }
    }
}
