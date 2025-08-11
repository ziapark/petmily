package com.petmillie.admin.order.dao;

import java.util.ArrayList;
import java.util.Map;

import org.springframework.dao.DataAccessException;

import com.petmillie.member.vo.MemberVO;
import com.petmillie.order.vo.OrderVO;

public interface AdminOrderDAO {
	public ArrayList<OrderVO> selectNewOrderList(Map condMap) throws DataAccessException;
	public void  updateDeliveryState(Map deliveryMap) throws DataAccessException;
	public ArrayList<OrderVO> selectOrderDetail(int order_id) throws DataAccessException;
	public MemberVO selectOrderer(String member_id) throws DataAccessException;
}
