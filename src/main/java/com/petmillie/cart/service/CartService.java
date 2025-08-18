package com.petmillie.cart.service;

import java.util.List;
import java.util.Map;

import com.petmillie.cart.vo.CartVO;

public interface CartService {
	public String addOrIncreaseGoodsInCart(CartVO cartVO) throws Exception;
	public List<CartVO> myCartList(String member_id) throws Exception;

	public boolean modifyCartQty(CartVO cartVO) throws Exception;
	public void removeCartGoods(int cart_id) throws Exception;
}
