package com.petmillie.order.portone;

public interface PortoneService {
	public boolean verifyPayment(String impUid, int expectAmount) throws Exception;
	public String getAccessToken() throws Exception;
	public void cancelPayment(String imp_uid, int amount) throws Exception;
}
