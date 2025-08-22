package com.petmillie.order.dao;

import java.util.List;
import java.util.Map;

import org.springframework.dao.DataAccessException;

import com.petmillie.cart.vo.CartVO;
import com.petmillie.goods.vo.GoodsVO;
import com.petmillie.order.vo.OrderVO;

public interface OrderDAO {
	public void insertNewOrder(OrderVO orderVO) throws Exception;
	public void deleteCartItems(Map<String, Object> params) throws Exception;
	public void updateOrderStatusToCancel(String imp_uid) throws Exception;
	public void restorePoints(Map<String, Object> params) throws Exception;
	public GoodsVO goodsDetailForOrder(int goods_num) throws DataAccessException;
	public List<OrderVO> listMyOrderGoods(OrderVO orderBean) throws DataAccessException;
	public OrderVO findMyOrder(String order_id) throws DataAccessException;
    public void removeGoodsFromCart(List<OrderVO> myOrderList)throws DataAccessException;
    public Integer selectCartIdByMemberAndGoods(CartVO cartVO) throws DataAccessException;
}
