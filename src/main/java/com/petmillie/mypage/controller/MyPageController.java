package com.petmillie.mypage.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.petmillie.mypage.vo.GoodsReviewVO;
import com.petmillie.mypage.vo.PetVO;

public interface MyPageController {
	public ModelAndView myPageMain(@RequestParam Map<String, String> dateMap, @RequestParam(required = false,value="message")  String message,
			HttpServletRequest request, HttpServletResponse response)  throws Exception;
	public ModelAndView myOrderDetail(@RequestParam("order_id")  String order_id,HttpServletRequest request, HttpServletResponse response)  throws Exception;
	public ModelAndView cancelMyOrder(@RequestParam("order_id")  String order_id,HttpServletRequest request, HttpServletResponse response)  throws Exception;
	public ModelAndView listMyOrderHistory(@RequestParam Map<String, String> dateMap,HttpServletRequest request, HttpServletResponse response)  throws Exception;
	public ModelAndView myDetailInfo(HttpServletRequest request, HttpServletResponse response)  throws Exception;
	public ResponseEntity modifyMyInfo(@RequestParam("attribute")  String attribute,
					@RequestParam("value")  String value,
					HttpServletRequest request, HttpServletResponse response)  throws Exception;
	public String removeMember(@RequestParam("id") String id, HttpServletRequest request, HttpServletResponse response) throws Exception;
	
	public ModelAndView addReview(@ModelAttribute GoodsReviewVO goodsReviewVO, @RequestParam("uploadFile") MultipartFile file, HttpServletRequest request) throws Exception;
	public ModelAndView myReview(HttpServletRequest request) throws Exception;
	public ModelAndView myReviewDetail(HttpServletRequest request, @RequestParam("review_id") int review_id) throws Exception;
	public ModelAndView deleteReview(HttpServletRequest request, @RequestParam("review_id") int review_id) throws Exception;
	public ModelAndView updateReviewForm(HttpServletRequest request, int review_id) throws Exception;
	public ModelAndView updateReview(@ModelAttribute GoodsReviewVO goodsReviewVO, @RequestParam("uploadFile") MultipartFile file,
  						@RequestParam("originalFileName") String originalFileName, 
  						HttpServletRequest request) throws Exception;
	public ModelAndView likeGoods(HttpServletRequest request) throws Exception;
	public Map<String, Object> toggleLikeGoods(@RequestParam String member_id, @RequestParam int goods_num)  throws Exception;
	public String likeGoodsDelete(@RequestParam int like_goods_id) throws Exception;

	// ✅ 새로 추가된 반려동물 정보 페이지 메서드
	public ModelAndView myPetInfo(HttpServletRequest request, HttpServletResponse response) throws Exception;
	// ✅ 새로 추가된 반려동물 등록 관련 메서드
		public ModelAndView addPetForm(HttpServletRequest request, HttpServletResponse response) throws Exception;
		public ModelAndView addPet(@ModelAttribute PetVO petVO, HttpServletRequest request, HttpServletResponse response) throws Exception;
		// ✅ 새로 추가된 반려동물 수정/삭제 관련 메서드
		public ModelAndView modifyPetForm(@RequestParam("pet_id") int pet_id, HttpServletRequest request, HttpServletResponse response) throws Exception;
		public ModelAndView modifyPet(@ModelAttribute PetVO petVO, HttpServletRequest request, HttpServletResponse response) throws Exception;
		public ModelAndView removePet(@RequestParam("pet_id") int pet_id, HttpServletRequest request, HttpServletResponse response) throws Exception;
	}
