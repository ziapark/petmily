package com.petmillie.mypage.dao;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

import com.petmillie.member.vo.MemberVO;
import com.petmillie.mypage.vo.GoodsReviewVO;
import com.petmillie.mypage.vo.LikeGoodsVO;
import com.petmillie.order.vo.OrderVO;

@Repository("myPageDAO")
public class MyPageDAOImpl implements MyPageDAO{
	@Autowired
	private SqlSession sqlSession;
	
	public List<OrderVO> selectMyOrderList(Map<String, Object> params) throws DataAccessException {
	    List<OrderVO> orderGoodsList = sqlSession.selectList("mapper.order.selectMyOrderList", params);
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
		
		sqlSession.update("mapper.mypage.updateReview", goodsReviewVO); 
		
	}

	@Override
	public boolean existsReview(int orderNum, String memberId) {
	    Map<String, Object> params = new HashMap<>();
	    params.put("order_num", orderNum);
	    params.put("member_id", memberId);

	    Integer count = sqlSession.selectOne("mapper.mypage.existsReview", params);
	    
	    return count != null && count > 0;
	}
	@Override
	public List<LikeGoodsVO> likeGoodsList(String member_id) throws DataAccessException {

		return sqlSession.selectList("mapper.mypage.selectLikeGoodsList", member_id);
	}

	@Override
	public List<Integer> selectLikedGoodsNums(String member_id) throws Exception {
		return sqlSession.selectList("mapper.mypage.selectLikedGoodsNums", member_id);
	}
	@Override
	public int existsLikeGoods(Map<String, Object> params) throws Exception {
	    return sqlSession.selectOne("mapper.mypage.existsLikeGoods", params);
	}

	@Override
	public void insertLikeGoods(Map<String, Object> params) throws Exception {
	    sqlSession.insert("mapper.mypage.insertLikeGoods", params);
	}

	@Override
	public void deleteLikeGoods(Map<String, Object> params) throws Exception {
	    sqlSession.delete("mapper.mypage.deleteLikeGoods", params);
	}



	

}
