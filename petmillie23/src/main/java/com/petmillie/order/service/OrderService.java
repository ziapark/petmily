package com.petmillie.order.service;

import java.util.List;
import java.util.Map;

import com.petmillie.order.vo.OrderVO;
import com.petmillie.order.vo.PayVO;

public interface OrderService {
	public List<OrderVO> listMyOrderGoods(OrderVO orderVO) throws Exception;
	public void addNewOrder(List<OrderVO> myOrderList) throws Exception;
	public OrderVO findMyOrder(String order_id) throws Exception;
	public void addNewpay(PayVO payVO)throws Exception;
	public void removeCartItem(String member_id, int goods_num) throws Exception;
	
}
