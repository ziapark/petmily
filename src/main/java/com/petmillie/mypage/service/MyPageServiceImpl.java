package com.petmillie.mypage.service;

import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.petmillie.member.vo.MemberVO;
import com.petmillie.mypage.dao.MyPageDAO;
import com.petmillie.mypage.vo.GoodsReviewVO;
import com.petmillie.mypage.vo.LikeGoodsVO;
import com.petmillie.mypage.vo.PetVO;
import com.petmillie.order.vo.OrderVO;

@Service("myPageService")
@Transactional(propagation=Propagation.REQUIRED)
public class MyPageServiceImpl  implements MyPageService{
	@Autowired
	private MyPageDAO myPageDAO;

	public List<OrderVO> listMyOrderGoods(Map<String, Object> params) throws Exception {
	   
	    return myPageDAO.selectMyOrderList(params);
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
		
		myPageDAO.updateReview(goodsReviewVO);
		
	}

	@Override
	public boolean existsReview(int orderNum, String memberId) throws Exception {
		 return myPageDAO.existsReview(orderNum, memberId);
	}

	@Override
	public List<LikeGoodsVO> likeGoodsList(String member_id) throws Exception {
		return myPageDAO.likeGoodsList(member_id);
	}


	@Override
	public Map<String, Object> toggleLikeGoods(String member_id, int goods_num) throws Exception {
	    Map<String, Object> params = new HashMap<>();
	    params.put("member_id", member_id);
	    params.put("goods_num", goods_num);

	    Map<String, Object> result = new HashMap<>();

	    int count = myPageDAO.existsLikeGoods(params);

	    if(count > 0) {
	        myPageDAO.deleteLikeGoods(params);
	        result.put("success", true);
	        result.put("status", "deleted");
	    } else {
	        myPageDAO.insertLikeGoods(params);
	        result.put("success", true);
	        result.put("status", "added");
	    }

	    return result;
	}

	@Override
	public Set<Integer> getLikedGoodsSet(String member_id) throws Exception {
		List<Integer> likedGoodsList = myPageDAO.selectLikedGoodsNums(member_id);
	    return new HashSet<>(likedGoodsList);
	}

	@Override
	public int likeGoodsDelete(int like_goods_id) throws Exception {
		return myPageDAO.likeGoodsDelete(like_goods_id);
	}
	
	@Override
	public List<PetVO> listMyPets(String member_id) throws Exception {
		return myPageDAO.selectMyPetList(member_id);
	}

	@Override
	public boolean canAddMorePets(String member_id) throws Exception {
		return myPageDAO.selectPetCount(member_id) < 3;
	}

	@Override
	public void addPet(PetVO petVO) throws Exception {
		myPageDAO.insertPet(petVO);
	}

	@Override
	public PetVO findPetInfo(int pet_id) throws Exception {
		return myPageDAO.selectPet(pet_id);
	}

	@Override
	public void modifyPet(PetVO petVO) throws Exception {
		myPageDAO.updatePet(petVO);
	}

	@Override
	public void removePet(int pet_id) throws Exception {
		myPageDAO.deletePet(pet_id);
	}

}
