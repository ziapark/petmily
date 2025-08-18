package com.petmillie.cart.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.petmillie.cart.dao.CartDAO;
import com.petmillie.cart.vo.CartVO;

@Service("cartService")
@Transactional(propagation=Propagation.REQUIRED)
public class CartServiceImpl  implements CartService{
	@Autowired
	private CartDAO cartDAO;
	
	@Override
	public String addOrIncreaseGoodsInCart(CartVO cartVO) throws Exception {
	    int count = cartDAO.selectCountInCart(cartVO);
	    if (count > 0) {
	        cartDAO.increaseCartQty(cartVO);
	        return "increase_success";
	    } else {
	        cartDAO.insertGoodsInCart(cartVO);
	        return "add_success";
	    }
	}
	
	public List<CartVO> myCartList(String member_id) throws Exception{
		return cartDAO.myCartList(member_id);
	}	
	
	public boolean modifyCartQty(CartVO cartVO) throws Exception{
		boolean result=true;
		cartDAO.updateCartGoodsQty(cartVO);
		return result;
	}
	public void removeCartGoods(int cart_id) throws Exception{
		cartDAO.deleteCartGoods(cart_id);
	}
	
}
