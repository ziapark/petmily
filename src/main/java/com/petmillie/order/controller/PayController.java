package com.petmillie.order.controller;

import com.petmillie.order.vo.ApiResponse;
import com.petmillie.order.vo.PayVO;

public interface PayController {
	
	public ApiResponse insertPay(PayVO payVO)throws Exception;

}
