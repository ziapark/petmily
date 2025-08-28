package com.petmillie.order.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.petmillie.goods.vo.GoodsVO;
import com.petmillie.member.vo.MemberVO;
import com.petmillie.order.dao.OrderDAO;
import com.petmillie.order.dao.PayDAO;
import com.petmillie.order.vo.OrderItemDto;
import com.petmillie.order.vo.OrderVO;
import com.petmillie.order.vo.PayVO;

@Service("orderService")
@Transactional(propagation=Propagation.REQUIRED)
public class OrderServiceImpl implements OrderService {
	@Autowired
	private OrderDAO orderDAO;
	@Autowired
	private PayDAO payDAO;
	
    @Override
    public void addNewOrder(OrderVO orderVO) throws Exception {
        orderDAO.insertNewOrder(orderVO);
    }
    
    @Override
    public void addNewpay(PayVO payVO) throws Exception{
        payDAO.insertPay(payVO);      
    }
    
    @Override
    public void removeOrderedItemsFromCart(List<OrderItemDto> orderItems, String member_id) throws Exception {
        List<Integer> goodsNumList = new ArrayList<>();
        for (OrderItemDto item : orderItems) {
            goodsNumList.add(item.getGoods_num());
        }

        Map<String, Object> params = new HashMap<>();
        params.put("member_id", member_id);
        params.put("goodsNumList", goodsNumList);

        orderDAO.deleteCartItems(params);
    }
    
    @Override
    public void deductionPoint(String member_id, int final_point) throws Exception{
    	MemberVO memberVO = new MemberVO();
    	
    	memberVO.setMember_id(member_id);
    	memberVO.setPoint(final_point);
        payDAO.deductionPoint(memberVO);      
    }
    
    @Override
    public void updateOrderStatusToCancel(String imp_uid) throws Exception {
        orderDAO.updateOrderStatusToCancel(imp_uid);
    }

    @Override
    public void restorePoints(Map<String, Object> params) throws Exception {
        orderDAO.restorePoints(params);
    }
    
    @Override
    public GoodsVO goodsDetailForOrder(int goods_num) throws Exception {
        return orderDAO.goodsDetailForOrder(goods_num);
    }
	
	public List<OrderVO> listMyOrderGoods(OrderVO orderVO) throws Exception{
		List<OrderVO> orderGoodsList;
		orderGoodsList=orderDAO.listMyOrderGoods(orderVO);
		return orderGoodsList;
	}
  
    public OrderVO findMyOrder(String order_id) throws Exception{
        return orderDAO.findMyOrder(order_id);
    }

   
}
