package com.petmillie.order.portone;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;

public interface PortoneService {
	public boolean verifyPayment(String impUid, String merchantUid)throws JsonMappingException, JsonProcessingException;
}
