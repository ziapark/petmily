package com.petmillie.mypage.dao;

import java.util.List;
import java.util.Map;

import org.springframework.dao.DataAccessException;

import com.petmillie.member.vo.MemberVO;
import com.petmillie.mypage.vo.GoodsReviewVO;
import com.petmillie.mypage.vo.LikeGoodsVO;
import com.petmillie.mypage.vo.PetVO;
import com.petmillie.order.vo.OrderVO;

public interface MyPageDAO {
	/*
	 * public List<OrderVO> selectMyOrderList(String member_id) throws
	 * DataAccessException;
	 */
	public List selectMyOrderInfo(String order_id) throws DataAccessException;
	public List<OrderVO> selectMyOrderHistoryList(Map dateMap) throws DataAccessException;
	public void updateMyInfo(Map memberMap) throws DataAccessException;
	public MemberVO selectMyDetailInfo(String member_id) throws DataAccessException;
	public void updateMyOrderCancel(String order_id) throws DataAccessException;
	public void insertGoodsReview(GoodsReviewVO goodsReviewVO) throws DataAccessException;
	public List<OrderVO> selectMyOrderList(Map<String, Object> params) throws DataAccessException;
	public GoodsReviewVO getReviewDetailByReviewId (int review_id) throws DataAccessException;
	public void deleteReview(int review_id) throws DataAccessException;
	public void updateReview(GoodsReviewVO goodsReviewVO) throws DataAccessException;
	boolean existsReview(int orderNum, String memberId);
	public List<GoodsReviewVO> selectGoodsReview(String member_id) throws DataAccessException;
	
	public List<LikeGoodsVO> likeGoodsList(String member_id) throws DataAccessException;
	List<Integer> selectLikedGoodsNums(String member_id) throws Exception;
	public int existsLikeGoods(Map<String, Object> params) throws Exception ;
	public void insertLikeGoods(Map<String, Object> params) throws Exception;
	public void deleteLikeGoods(Map<String, Object> params) throws Exception;
	public int likeGoodsDelete(int like_goods_id) throws Exception;
	
	
	public List<PetVO> selectMyPetList(String member_id) throws Exception;
	public int selectPetCount(String member_id) throws Exception;
	public int insertPet(PetVO petVO) throws Exception;
	public PetVO selectPet(int pet_id) throws Exception;
	public int updatePet(PetVO petVO) throws Exception;
	public int deletePet(int pet_id) throws Exception;
	
}
