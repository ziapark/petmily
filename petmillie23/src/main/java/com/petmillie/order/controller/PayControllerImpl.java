package com.petmillie.order.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.petmillie.order.service.PayService;
import com.petmillie.order.vo.ApiResponse;
import com.petmillie.order.vo.PayVO;

@Controller("payController")
public class PayControllerImpl implements PayController {
	@Autowired
	private PayService payService;

	@Override
	@RequestMapping(value="/payment", method={RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public ApiResponse insertPay(PayVO payVO) throws Exception {
		try {
		payService.insertPay(payVO);
		return new ApiResponse(true, "결제 정보 저장 성공");
		}catch(Exception e) {
			e.printStackTrace();
			return new ApiResponse(false, "결제 정보 저장 성공", e.getMessage());
		}
	}

}
