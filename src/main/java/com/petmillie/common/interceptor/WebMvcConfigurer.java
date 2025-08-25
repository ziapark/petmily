package com.petmillie.common.interceptor;

import org.springframework.web.servlet.config.annotation.InterceptorRegistry;

public interface WebMvcConfigurer {
	 public void addInterceptors(InterceptorRegistry registry);
}
