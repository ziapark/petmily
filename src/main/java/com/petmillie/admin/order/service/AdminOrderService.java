package com.petmillie.admin.order.service;

import java.util.List;
import java.util.Map;

import com.petmillie.order.vo.OrderVO;

public interface AdminOrderService {
	public List<OrderVO> listNewOrder(Map condMap) throws Exception;
	public void modifyDeliveryState(Map deliveryMap) throws Exception;
	public Map<String, Object> orderDetail(int order_id) throws Exception;
}