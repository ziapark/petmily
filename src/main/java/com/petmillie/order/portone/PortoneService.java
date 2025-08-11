package com.petmillie.order.portone;

public interface PortoneService {
	public boolean verifyPayment(String impUid, int expectAmount) throws Exception;
}
