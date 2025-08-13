package com.petmillie.mypage.service;

import java.util.List;
import java.util.Map;
import java.util.Set;

import com.petmillie.member.vo.MemberVO;
import com.petmillie.mypage.vo.GoodsReviewVO;
import com.petmillie.mypage.vo.LikeGoodsVO;
import com.petmillie.order.vo.OrderVO;

public interface MyPageService{
	public List<OrderVO> listMyOrderGoods(Map<String, Object> params) throws Exception;
	public List findMyOrderInfo(String order_id) throws Exception;
	public List<OrderVO> listMyOrderHistory(Map dateMap) throws Exception;
	public MemberVO  modifyMyInfo(Map memberMap) throws Exception;
	public void cancelOrder(String order_id) throws Exception;
	public MemberVO myDetailInfo(String member_id) throws Exception;
	public void writeGoodsReview(GoodsReviewVO goodsReviewVO) throws Exception;
	public List<GoodsReviewVO> getReviewById(String member_id) throws Exception ;
	public GoodsReviewVO getReviewDetailByReviewId(int review_id) throws Exception;
	public void deleteReview(int review_id) throws Exception; 
	public void updateReview(GoodsReviewVO goodsReviewVO) throws Exception;
	boolean existsReview(int orderNum, String memberId) throws Exception;
	public List<LikeGoodsVO> likeGoodsList(String member_id) throws Exception;
	public Map<String, Object> toggleLikeGoods(String member_id, int goods_num) throws Exception;
	Set<Integer> getLikedGoodsNums(String member_id) throws Exception;
	
}
