package com.petmillie.order.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

import com.petmillie.cart.vo.CartVO;
import com.petmillie.goods.vo.GoodsVO;
import com.petmillie.order.vo.OrderVO;

@Repository("orderDAO")
public class OrderDAOImpl implements OrderDAO {
	@Autowired
	private SqlSession sqlSession;
	
    @Override
    public void insertNewOrder(OrderVO orderVO) throws Exception {
        sqlSession.insert("mapper.order.insertNewOrder", orderVO);
    }
    
    @Override
    public void deleteCartItems(Map<String, Object> params) throws Exception {
        sqlSession.delete("mapper.order.deleteCart", params);
    }
    
	@Override
	public void updateOrderStatusToCancel(String imp_uid) throws Exception {
		sqlSession.update("mapper.order.updatePayStatusToCancel", imp_uid);
		sqlSession.update("mapper.order.updateOrderStatusToCancel", imp_uid);
	}

	@Override
	public void restorePoints(Map<String, Object> params) throws Exception {
		sqlSession.update("mapper.order.restorePoints", params);
	}
	
    @Override
    public GoodsVO goodsDetailForOrder(int goods_num) throws DataAccessException {
        return sqlSession.selectOne("mapper.order.goodsDetailForOrder", goods_num);
    }
    
	public List<OrderVO> listMyOrderGoods(OrderVO orderVO) throws DataAccessException{
		List<OrderVO> orderGoodsList=new ArrayList<OrderVO>();
		orderGoodsList=(ArrayList)sqlSession.selectList("mapper.order.selectMyOrderList",orderVO);
		return orderGoodsList;
	}
	
	public OrderVO findMyOrder(String order_id) throws DataAccessException{
		OrderVO orderVO=(OrderVO)sqlSession.selectOne("mapper.order.selectMyOrder",order_id);		
		return orderVO;
	}
	
	public void removeGoodsFromCart(OrderVO orderVO)throws DataAccessException{
		sqlSession.delete("mapper.order.deleteGoodsFromCart",orderVO);
	}
	
	public void removeGoodsFromCart(List<OrderVO> myOrderList)throws DataAccessException{
		for(int i=0; i<myOrderList.size();i++){
			OrderVO orderVO =(OrderVO)myOrderList.get(i);
			sqlSession.delete("mapper.order.deleteGoodsFromCart",orderVO);		
		}
	}	
    @Override
    public Integer selectCartIdByMemberAndGoods(CartVO cartVO) throws DataAccessException {
        return sqlSession.selectOne("mapper.cart.selectCartIdByMemberAndGoods", cartVO);
    }
}

