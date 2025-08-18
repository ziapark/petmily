package com.petmillie.order.dao;

import java.util.List;

import org.springframework.dao.DataAccessException;

import com.petmillie.cart.vo.CartVO;
import com.petmillie.goods.vo.GoodsVO;
import com.petmillie.order.vo.OrderVO;

public interface OrderDAO {
	public GoodsVO goodsDetailForOrder(int goods_num) throws DataAccessException;
	public List<OrderVO> listMyOrderGoods(OrderVO orderBean) throws DataAccessException;
	public void insertNewOrder(List<OrderVO> myOrderList) throws DataAccessException;
	public OrderVO findMyOrder(String order_id) throws DataAccessException;
    public void removeGoodsFromCart(List<OrderVO> myOrderList)throws DataAccessException;
    public Integer selectCartIdByMemberAndGoods(CartVO cartVO) throws DataAccessException;
    public void deleteCartGoods(int cart_id) throws DataAccessException;
}
