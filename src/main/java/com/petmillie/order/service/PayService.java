package com.petmillie.order.service;

import com.petmillie.order.vo.PayVO;

public interface PayService {
	public void insertPay(PayVO payVO) throws Exception;
}
