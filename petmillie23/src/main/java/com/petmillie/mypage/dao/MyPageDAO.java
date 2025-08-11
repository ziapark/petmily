package com.petmillie.mypage.dao;

import java.util.List;
import java.util.Map;

import org.springframework.dao.DataAccessException;

import com.petmillie.member.vo.MemberVO;
import com.petmillie.mypage.vo.GoodsReviewVO;
import com.petmillie.order.vo.OrderVO;

public interface MyPageDAO {
	public List<OrderVO> selectMyOrderList(String member_id) throws DataAccessException;
	public List selectMyOrderInfo(String order_id) throws DataAccessException;
	public List<OrderVO> selectMyOrderHistoryList(Map dateMap) throws DataAccessException;
	public void updateMyInfo(Map memberMap) throws DataAccessException;
	public MemberVO selectMyDetailInfo(String member_id) throws DataAccessException;
	public void updateMyOrderCancel(String order_id) throws DataAccessException;
	public void insertGoodsReview(GoodsReviewVO goodsReviewVO) throws DataAccessException;
	public List<GoodsReviewVO> selectGoodsReview(String member_id) throws DataAccessException;
}
