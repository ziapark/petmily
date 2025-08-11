package com.petmillie.mypage.dao;


import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

import com.petmillie.member.vo.MemberVO;
import com.petmillie.mypage.vo.GoodsReviewVO;
import com.petmillie.order.vo.OrderVO;

@Repository("myPageDAO")
public class MyPageDAOImpl implements MyPageDAO{
	@Autowired
	private SqlSession sqlSession;
	
	public List<OrderVO> selectMyOrderList(String member_id) throws DataAccessException{
		List<OrderVO> orderGoodsList=(List)sqlSession.selectList("mapper.order.selectMyOrderList",member_id);
		return orderGoodsList;
	}
	
	public List selectMyOrderInfo(String order_id) throws DataAccessException{
		List myOrderList=(List)sqlSession.selectList("mapper.mypage.selectMyOrderInfo",order_id);
		return myOrderList;
	}	

	public List<OrderVO> selectMyOrderHistoryList(Map dateMap) throws DataAccessException{
		List<OrderVO> myOrderHistList=(List)sqlSession.selectList("mapper.order.selectMyOrderList",dateMap);
		return myOrderHistList;
	}
	
	public void updateMyInfo(Map memberMap) throws DataAccessException{
		sqlSession.update("mapper.mypage.updateMyInfo",memberMap);
	}
	
	public MemberVO selectMyDetailInfo(String member_id) throws DataAccessException{
		MemberVO memberVO=(MemberVO)sqlSession.selectOne("mapper.mypage.selectMyDetailInfo",member_id);
		return memberVO;
		
	}
	
	public void updateMyOrderCancel(String order_id) throws DataAccessException{
		sqlSession.update("mapper.mypage.updateMyOrderCancel",order_id);
	}

	@Override
	public void insertGoodsReview(GoodsReviewVO goodsReviewVO) throws DataAccessException {
		
		sqlSession.insert("mapper.mypage.insertGoodsReview", goodsReviewVO); 
		
	}
	@Override
	public List<GoodsReviewVO> selectGoodsReview(String member_id) throws DataAccessException{
		List<GoodsReviewVO> mygoodsReviewList= sqlSession.selectList("mapper.mypage.selectGoodsReview",member_id);
		System.out.println(mygoodsReviewList);
		return mygoodsReviewList;
	}

	@Override
	public GoodsReviewVO getReviewDetailByReviewId(int review_id) throws DataAccessException {
		
		return sqlSession.selectOne("mapper.mypage.getReviewDetailByReviewId", review_id); 
	}

	@Override
	public void deleteReview(int review_id) throws DataAccessException {
		
		sqlSession.delete("mapper.mypage.deleteReview",review_id);
	}

	@Override
	public void updateReview(GoodsReviewVO goodsReviewVO) throws DataAccessException {
		System.out.println("dao진입: 작성내용" + goodsReviewVO.getContent() +"별점"+ goodsReviewVO.getRating() + "리뷰아이디"+ goodsReviewVO.getReview_id() + "파일명"+ goodsReviewVO.getFile_name());
		sqlSession.update("mapper.mypage.updateReview", goodsReviewVO); 
		
	}

}
