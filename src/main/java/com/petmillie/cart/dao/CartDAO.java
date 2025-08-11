package com.petmillie.cart.dao;

import java.util.List;

import org.springframework.dao.DataAccessException;

import com.petmillie.cart.vo.CartVO;
import com.petmillie.goods.vo.GoodsVO;

public interface CartDAO {
	public List<CartVO> selectCartList(CartVO cartVO) throws DataAccessException;
	public List<GoodsVO> selectGoodsList(List<CartVO> cartList) throws DataAccessException;
	public int selectCountInCart(CartVO cartVO) throws DataAccessException;
	public void insertGoodsInCart(CartVO cartVO) throws DataAccessException;
	public void updateCartGoodsQty(CartVO cartVO) throws DataAccessException;
	public void deleteCartGoods(int cart_id) throws DataAccessException;
	public void increaseCartQty(CartVO cartVO) throws DataAccessException;
	

}
