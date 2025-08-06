package com.petmillie.admin.order.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.petmillie.admin.order.dao.AdminOrderDAO;
import com.petmillie.member.vo.MemberVO;
import com.petmillie.order.vo.OrderVO;


@Service("adminOrderService")
@Transactional(propagation=Propagation.REQUIRED)
public class AdminOrderServiceImpl implements AdminOrderService {
	@Autowired
	private AdminOrderDAO adminOrderDAO;

	public List<OrderVO> listNewOrder(Map condMap) throws Exception{
		return adminOrderDAO.selectNewOrderList(condMap);
	}

	@Override
	public void modifyDeliveryState(Map deliveryMap) throws Exception{
		adminOrderDAO.updateDeliveryState(deliveryMap);
	}

	@Override
	public Map orderDetail(int order_id) throws Exception{
		Map orderMap = new HashMap();

		// DB에서 주문 상세 정보를 조회합니다.
		List<OrderVO> orderList = adminOrderDAO.selectOrderDetail(order_id);

		// 여기서 문제의 원인인 'Index 0 out of bounds' 예외가 발생합니다.
		// 리스트가 비어있지 않은지 먼저 확인해야 합니다.
		if (orderList != null && !orderList.isEmpty()) {
			OrderVO deliveryInfo = orderList.get(0);
			String member_id = deliveryInfo.getMember_id();

			MemberVO orderer = adminOrderDAO.selectOrderer(member_id);

			orderMap.put("orderList", orderList);
			orderMap.put("deliveryInfo", deliveryInfo);
			orderMap.put("orderer", orderer);
		}

		return orderMap;
	}
}