package com.petmillie.order.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.petmillie.cart.vo.CartVO;
import com.petmillie.order.dao.OrderDAO;
import com.petmillie.order.dao.PayDAO;
import com.petmillie.order.vo.OrderVO;
import com.petmillie.order.vo.PayVO;


@Service("orderService")
@Transactional(propagation=Propagation.REQUIRED)
public class OrderServiceImpl implements OrderService {
	@Autowired
	private OrderDAO orderDAO;
	@Autowired
	private PayDAO payDAO;
	
	public List<OrderVO> listMyOrderGoods(OrderVO orderVO) throws Exception{
		List<OrderVO> orderGoodsList;
		orderGoodsList=orderDAO.listMyOrderGoods(orderVO);
		return orderGoodsList;
	}
	
	public void addNewOrder(List<OrderVO> myOrderList) throws Exception{
		orderDAO.insertNewOrder(myOrderList);
	}	
    @Override
    public void addNewpay(PayVO payVO) throws Exception{
        payDAO.insertPay(payVO);
        
    }
    
    public OrderVO findMyOrder(String order_id) throws Exception{
        return orderDAO.findMyOrder(order_id);
    }
    
    @Override
    public void removeCartItem(String member_id, int goods_num) throws Exception {
        CartVO cartVO = new CartVO();
        cartVO.setMember_id(member_id);
        cartVO.setGoods_num(goods_num);
        

        Integer cart_id = orderDAO.selectCartIdByMemberAndGoods(cartVO);
        if (cart_id != null) {
            orderDAO.deleteCartGoods(cart_id);
        } else {
            System.out.println("🟡 삭제할 장바구니 항목이 없습니다.");
        }
    }
    
}
