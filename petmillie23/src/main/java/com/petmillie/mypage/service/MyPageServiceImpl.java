package com.petmillie.mypage.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.petmillie.member.vo.MemberVO;
import com.petmillie.mypage.dao.MyPageDAO;
import com.petmillie.mypage.vo.GoodsReviewVO;
import com.petmillie.order.vo.OrderVO;

@Service("myPageService")
@Transactional(propagation=Propagation.REQUIRED)
public class MyPageServiceImpl  implements MyPageService{
	@Autowired
	private MyPageDAO myPageDAO;

	public List<OrderVO> listMyOrderGoods(String member_id) throws Exception{
		return myPageDAO.selectMyOrderList(member_id);
	}
	
	public List findMyOrderInfo(String order_id) throws Exception{
		return myPageDAO.selectMyOrderInfo(order_id);
	}
	
	public List<OrderVO> listMyOrderHistory(Map dateMap) throws Exception{
		return myPageDAO.selectMyOrderHistoryList(dateMap);
	}
	
	public MemberVO  modifyMyInfo(Map memberMap) throws Exception{
		 String member_id=(String)memberMap.get("member_id");
		 myPageDAO.updateMyInfo(memberMap);
		 return myPageDAO.selectMyDetailInfo(member_id);
	}
	
	public void cancelOrder(String order_id) throws Exception{
		myPageDAO.updateMyOrderCancel(order_id);
	}
	public MemberVO myDetailInfo(String member_id) throws Exception{
		return myPageDAO.selectMyDetailInfo(member_id);
	}
	
    @Override
    public void writeGoodsReview(GoodsReviewVO goodsReviewVO) {

    	myPageDAO.insertGoodsReview(goodsReviewVO);
    }

	@Override
	public List<GoodsReviewVO> getReviewById(String member_id) throws Exception {
		
		return myPageDAO.selectGoodsReview(member_id);
		
	}

	@Override
	public GoodsReviewVO getReviewDetailByReviewId(int review_id) throws Exception {
		return myPageDAO.getReviewDetailByReviewId(review_id);
	}

	@Override
	public void deleteReview(int review_id) throws Exception {
		myPageDAO.deleteReview(review_id);
		
	}

	@Override
	public void updateReview(GoodsReviewVO goodsReviewVO) throws Exception {
		System.out.println("서비스진입 내용:" + goodsReviewVO.getContent()+"리뷰아이디:"+goodsReviewVO.getReview_id());
		myPageDAO.updateReview(goodsReviewVO);
		
	}
	
	
	
}
