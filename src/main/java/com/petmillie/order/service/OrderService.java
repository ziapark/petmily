package com.petmillie.order.service;

import java.util.List;

import com.petmillie.goods.vo.GoodsVO;
import com.petmillie.order.vo.OrderItemDto;
import com.petmillie.order.vo.OrderVO;
import com.petmillie.order.vo.PayVO;

public interface OrderService {
	public void addNewOrder(OrderVO orderVO) throws Exception;
	public void removeOrderedItemsFromCart(List<OrderItemDto> orderItems, String member_id) throws Exception;
	public GoodsVO goodsDetailForOrder(int goods_num) throws Exception;
    public List<OrderVO> listMyOrderGoods(OrderVO orderVO) throws Exception;
    public OrderVO findMyOrder(String order_id) throws Exception;
    public void addNewpay(PayVO payVO)throws Exception; 
}