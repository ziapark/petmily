package com.petmillie.cart.service;

import java.util.List;
import java.util.Map;

import com.petmillie.cart.vo.CartVO;

public interface CartService {
	public Map<String ,List> myCartList(CartVO cartVO) throws Exception;
	public int findCartGoods(CartVO cartVO) throws Exception;
	public void addGoodsInCart(CartVO cartVO) throws Exception;
	public boolean modifyCartQty(CartVO cartVO) throws Exception;
	public void removeCartGoods(int cart_id) throws Exception;
	public String addOrIncreaseGoodsInCart(CartVO cartVO) throws Exception;
}
