package com.petmillie.cart.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

import com.petmillie.cart.vo.CartVO;
import com.petmillie.goods.vo.GoodsVO;

@Repository("cartDAO")
public class CartDAOImpl  implements  CartDAO{
	@Autowired
	private SqlSession sqlSession;
	
	@Override
	public int selectCountInCart(CartVO cartVO) throws DataAccessException {
		return sqlSession.selectOne("mapper.cart.selectCountInCart",cartVO);
	}
	
	@Override
	public void increaseCartQty(CartVO cartVO) throws DataAccessException {
	    sqlSession.update("mapper.cart.increaseCartQty", cartVO);
	}
	
	@Override
	public void insertGoodsInCart(CartVO cartVO) throws DataAccessException{
		sqlSession.insert("mapper.cart.insertGoodsInCart",cartVO);
	}
	
	@Override
	public List<CartVO> myCartList(String member_id) throws DataAccessException {
		return sqlSession.selectList("mapper.cart.myCartList", member_id);
	}

	public void updateCartGoodsQty(CartVO cartVO) throws DataAccessException{
		sqlSession.insert("mapper.cart.updateCartGoodsQty",cartVO);
	}
	
	public void deleteCartGoods(int cart_id) throws DataAccessException{
		sqlSession.delete("mapper.cart.deleteCartGoods",cart_id);
	}
}
