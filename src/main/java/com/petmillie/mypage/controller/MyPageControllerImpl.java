package com.petmillie.mypage.controller;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.petmillie.common.base.BaseController;
import com.petmillie.member.service.MemberService;
import com.petmillie.member.vo.MemberVO;
import com.petmillie.mypage.service.MyPageService;
import com.petmillie.mypage.vo.GoodsReviewVO;
import com.petmillie.mypage.vo.LikeGoodsVO;
import com.petmillie.mypage.vo.PetVO;
import com.petmillie.order.vo.OrderVO;

@Controller("myPageController")
@RequestMapping(value="/mypage")
public class MyPageControllerImpl extends BaseController  implements MyPageController{
	@Autowired
	private MyPageService myPageService;	
	@Autowired
	private GoodsReviewVO goodsReviewVO;	
	@Autowired
	private MemberVO memberVO;	
	@Autowired
	private MemberService memberService;
	
	@Override
	@RequestMapping(value="/myPageMain.do" ,method = RequestMethod.GET)
	public ModelAndView myPageMain(@RequestParam Map<String, String> dateMap, @RequestParam(required = false,value="message") String message,
	                               HttpServletRequest request, HttpServletResponse response)  throws Exception {
	    memberVO = (MemberVO) request.getSession().getAttribute("memberInfo");
	    if(memberVO == null || memberVO.getMember_id() == null) {
	        return new ModelAndView("redirect:/member/loginForm.do");
	    }

	    HttpSession session = request.getSession();
	    session.setAttribute("side_menu", "my_page"); 

	    String viewName = (String) request.getAttribute("viewName");
	    ModelAndView mav = new ModelAndView("/common/layout");
	    mav.addObject("title", "마이페이지");
	    mav.addObject("body", "/WEB-INF/views" + viewName + ".jsp");

	    String member_id = memberVO.getMember_id();
	    Map<String, Object> params = new HashMap<>();
	    params.put("member_id", member_id);
	    params.put("offset", 0);
	    params.put("limit", 10);

	    List<OrderVO> myOrderList = myPageService.listMyOrderGoods(params);

	    
	    mav.addObject("message", message);
	    mav.addObject("myOrderList", myOrderList);

	    return mav;
	}
	@Override
	@RequestMapping(value="/myOrderDetail.do" ,method = RequestMethod.GET)
	public ModelAndView myOrderDetail(@RequestParam("order_id")  String order_id,HttpServletRequest request, HttpServletResponse response)  throws Exception {
		String viewName=(String)request.getAttribute("viewName");
		ModelAndView mav = new ModelAndView(viewName);
		HttpSession session=request.getSession();
		MemberVO orderer=(MemberVO)session.getAttribute("memberInfo");
		
		List<OrderVO> myOrderList=myPageService.findMyOrderInfo(order_id);
		mav.addObject("orderer", orderer);
		mav.addObject("myOrderList",myOrderList);
		return mav;
	}
	
	@Override
	@RequestMapping(value="/listMyOrderHistory.do", method = RequestMethod.GET)
	public ModelAndView listMyOrderHistory(@RequestParam Map<String, String> dateMap,
	                                       HttpServletRequest request, HttpServletResponse response) throws Exception {
	    HttpSession session = request.getSession();
	    session.setAttribute("side_menu", "my_page");  // 메뉴 설정 동일
	    
	    String viewName = (String) request.getAttribute("viewName");
	    ModelAndView mav = new ModelAndView("/common/layout");  // 동일하게 layout 사용
	    
	    mav.addObject("title", "마이페이지 - 주문 내역 조회");  // 페이지 타이틀
	    mav.addObject("body", "/WEB-INF/views" + viewName + ".jsp");  // 보여줄 body 설정

	    memberVO = (MemberVO) session.getAttribute("memberInfo");
	    String member_id = memberVO.getMember_id();

	    String fixedSearchPeriod = dateMap.get("fixedSearchPeriod");
	    String[] tempDate = calcSearchPeriod(fixedSearchPeriod).split(",");
	    String beginDate = tempDate[0];
	    String endDate = tempDate[1];
	    dateMap.put("beginDate", beginDate);
	    dateMap.put("endDate", endDate);
	    dateMap.put("member_id", member_id);
	    dateMap.put("offset", "0");    // ✅ null 아니어야 함
	    dateMap.put("limit", "10");    // ✅ null 아니어야 함

	    // 날짜 정보 추가
	    String[] beginDateArr = beginDate.split("-");
	    String[] endDateArr = endDate.split("-");
	    mav.addObject("beginYear", beginDateArr[0]);
	    mav.addObject("beginMonth", beginDateArr[1]);
	    mav.addObject("beginDay", beginDateArr[2]);
	    mav.addObject("endYear", endDateArr[0]);
	    mav.addObject("endMonth", endDateArr[1]);
	    mav.addObject("endDay", endDateArr[2]);

	 // 주문 내역 조회
	    List<OrderVO> myOrderHistList = myPageService.listMyOrderHistory(dateMap);

	    // 각 주문별 리뷰 여부 체크
	    for (OrderVO order : myOrderHistList) {
	    	
	        boolean hasReview = myPageService.existsReview(order.getOrder_num(), member_id);
	        order.setHasReview(hasReview);
	    }

	    mav.addObject("myOrderHistList", myOrderHistList);
	    
	    return mav;
	}

	@Override
	@RequestMapping(value="/cancelMyOrder.do" ,method = RequestMethod.POST)
	public ModelAndView cancelMyOrder(@RequestParam("order_id")  String order_id,
			                         HttpServletRequest request, HttpServletResponse response)  throws Exception {
		ModelAndView mav = new ModelAndView();
		myPageService.cancelOrder(order_id);
		mav.addObject("message", "cancel_order");
		mav.setViewName("redirect:/mypage/myPageMain.do");
		return mav;
	}
	
	@Override
	@RequestMapping(value="/myDetailInfo.do" ,method = RequestMethod.GET)
	public ModelAndView myDetailInfo(HttpServletRequest request, HttpServletResponse response)  throws Exception {
		HttpSession session=request.getSession();
		String viewName=(String)request.getAttribute("viewName");
		String id = (String)session.getId();
		System.out.println(session.getId());
		ModelAndView mav = new ModelAndView("/common/layout");
		mav.addObject("title", "회원정보관리");
		mav.addObject("body", "/WEB-INF/views" + viewName + ".jsp");
		
		MemberVO member = myPageService.myDetailInfo(id);
		mav.addObject("memberInfo", member);
		
		return mav;
	}

	
	@Override
	@RequestMapping(value="/modifyMyInfo.do" ,method = RequestMethod.POST)
	public ResponseEntity modifyMyInfo(@RequestParam("attribute")  String attribute,
			                 @RequestParam("value")  String value,
			               HttpServletRequest request, HttpServletResponse response)  throws Exception {
		Map<String,String> memberMap=new HashMap<String,String>();
		String val[]=null;
		HttpSession session=request.getSession();
		memberVO=(MemberVO)session.getAttribute("memberInfo");
		String  member_id=memberVO.getMember_id();
		if(attribute.equals("member_birth")){
			val=value.split(",");
			memberMap.put("member_birth_y",val[0]);
			memberMap.put("member_birth_m",val[1]);
			memberMap.put("member_birth_d",val[2]);
			memberMap.put("member_birth_gn",val[3]);
		}else if(attribute.equals("tel")){
			val=value.split(",");
			memberMap.put("tel1",val[0]);
			memberMap.put("tel2",val[1]);
			memberMap.put("tel3",val[2]);
			memberMap.put("smssts_yn", val[3]);
		}else if(attribute.equals("email")){
			val=value.split(",");
			memberMap.put("email1",val[0]);
			memberMap.put("email2",val[1]);
			memberMap.put("emailsts_yn", val[2]);
		}else if(attribute.equals("address")){
			val=value.split(",");
			memberMap.put("zipcode",val[0]);
			memberMap.put("roadAddress",val[1]);
			memberMap.put("jibunAddress", val[2]);
			memberMap.put("namujiAddress", val[3]);
		}else {
			memberMap.put(attribute,value);	
		}
		
		memberMap.put("member_id", member_id);
		
		memberVO=(MemberVO)myPageService.modifyMyInfo(memberMap);
		session.removeAttribute("memberInfo");
		session.setAttribute("memberInfo", memberVO);
		
		String message = null;
		ResponseEntity resEntity = null;
		HttpHeaders responseHeaders = new HttpHeaders();
		message  = "mod_success";
		resEntity =new ResponseEntity(message, responseHeaders, HttpStatus.OK);
		return resEntity;
	}	
	@Override
	@RequestMapping(value="/removeMember.do", method=RequestMethod.POST)
	@ResponseBody
	public String removeMember(@RequestParam("id")String id, HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		System.out.println("컨트롤러로 넘어온 아이디 : " + id);
		int result = memberService.removeMember(id);
		return (result == 0 ) ? "false" : "true";
	}
	
	@RequestMapping(value="/deleteForm.do", method=RequestMethod.GET)
	public ModelAndView Form(HttpServletRequest request, HttpServletResponse response) throws Exception{
	    HttpSession session = request.getSession();
	    MemberVO memberVO =(MemberVO) session.getAttribute("memberInfo");
		String viewName=(String)request.getAttribute("viewName");
		ModelAndView mav=new ModelAndView("/common/layout");
		mav.addObject("title", "메인페이지");
		mav.addObject("body", "/WEB-INF/views" + viewName + ".jsp");
		mav.addObject("memberInfo", memberVO);
		
		return mav;
	}
	
	
	@RequestMapping("/writeReviewForm.do")
	public ModelAndView writeForm(@ModelAttribute OrderVO orderVO,HttpServletRequest request) {
		
		
		String viewName = (String) request.getAttribute("viewName");
		ModelAndView mav = new ModelAndView("/common/layout");
		mav.addObject("body", "/WEB-INF/views" + viewName + ".jsp");
		System.out.println("viewName = " + viewName);
		int order_num = orderVO.getOrder_num();
		String order_name = orderVO.getOrder_name();
		String goods_name = orderVO.getGoods_name();
		mav.addObject("order_num", order_num);
		mav.addObject("order_name", order_name);
		mav.addObject("goods_name", goods_name);
		
		System.out.println("order_num" + order_num);
		
	    return mav;
	}

	@Override
	@RequestMapping("/addReview.do")
	public ModelAndView addReview(@ModelAttribute GoodsReviewVO goodsReviewVO, @RequestParam("uploadFile") MultipartFile file, HttpServletRequest request) throws Exception {
		
		
		String viewName = (String) request.getAttribute("viewName");
	    ModelAndView mav=new ModelAndView("/common/layout");
		mav.addObject("title", "펫밀리");
		mav.addObject("body", "/WEB-INF/views" + viewName + ".jsp");
		
		HttpSession session = request.getSession();
	    MemberVO memberInfo = (MemberVO) session.getAttribute("memberInfo");

	    if (memberInfo == null) {
	        return new ModelAndView("redirect:/member/loginForm.do");
	    }
	    
	    String memberId = memberInfo.getMember_id();
	    goodsReviewVO.setMember_id(memberId);
	    
	    
	    // **C드라이브에 저장할 경로 설정** 
	    String saveDir = "C:\\petupload\\goodsreivew\\";
	    File uploadPath = new File(saveDir);
	    if (!uploadPath.exists()) uploadPath.mkdirs();

	    if (!file.isEmpty()) {
	        String originalFileName = file.getOriginalFilename();
	        String savedFileName = UUID.randomUUID().toString() + "_" + originalFileName;

	        file.transferTo(new File(saveDir + savedFileName));
	        goodsReviewVO.setFile_name(savedFileName);
	    } else {
	    	goodsReviewVO.setFile_name(null);
	    }

	    myPageService.writeGoodsReview(goodsReviewVO);

	    return new ModelAndView("redirect:/mypage/listMyOrderHistory.do?");

	}
	
	@Override
	@RequestMapping("/myReview.do")
	public ModelAndView myReview(HttpServletRequest request) throws Exception {
		String viewName = (String) request.getAttribute("viewName");
	    ModelAndView mav=new ModelAndView("/common/layout");
		mav.addObject("title", "펫밀리");
		mav.addObject("body", "/WEB-INF/views" + viewName + ".jsp");
		
		HttpSession session = request.getSession();
	    MemberVO memberInfo = (MemberVO) session.getAttribute("memberInfo");

	    if (memberInfo == null) {
	        return new ModelAndView("redirect:/member/loginForm.do");
	    }
	    
	    String member_id = memberInfo.getMember_id();
	    
	    List<GoodsReviewVO> goodsReviewVO = myPageService.getReviewById(member_id);
 
	    mav.addObject("goodsReviewVO", goodsReviewVO);
	    
	    return mav;

	}
	
	@Override
	@RequestMapping("/myReviewDetail.do")
	public ModelAndView myReviewDetail(HttpServletRequest request, @RequestParam("review_id") int review_id) throws Exception {
		String viewName = (String) request.getAttribute("viewName");
	    ModelAndView mav = new ModelAndView("/common/layout");
	    mav.addObject("title", "펫밀리");
		mav.addObject("body", "/WEB-INF/views" + viewName + ".jsp");
	    GoodsReviewVO review = myPageService.getReviewDetailByReviewId(review_id);
	    mav.addObject("review", review);
	    return mav;
	}
	
	@Override
	@RequestMapping("/deleteReview.do")
	public ModelAndView deleteReview(HttpServletRequest request, @RequestParam("review_id") int review_id) throws Exception {
		String viewName = (String) request.getAttribute("viewName");
	    ModelAndView mav = new ModelAndView("/common/layout");
	    mav.addObject("title", "펫밀리");
		mav.addObject("body", "/WEB-INF/views" + viewName + ".jsp");
	    myPageService.deleteReview(review_id);
	
	    return new ModelAndView("redirect:/mypage/myReview.do");
	}
	
	@Override
	@RequestMapping("/updateReviewForm.do")
	public ModelAndView updateReviewForm(HttpServletRequest request, int review_id) throws Exception {
		String viewName = (String) request.getAttribute("viewName");
	    ModelAndView mav = new ModelAndView("/common/layout");
	    mav.addObject("title", "펫밀리");
		mav.addObject("body", "/WEB-INF/views" + viewName + ".jsp");
		
		GoodsReviewVO review = myPageService.getReviewDetailByReviewId(review_id);
		mav.addObject("review", review);
	    return mav;
	}
	
	@Override
	@RequestMapping("/updateReview.do")
	public ModelAndView updateReview(@ModelAttribute GoodsReviewVO goodsReviewVO, 
									@RequestParam("uploadFile") MultipartFile file,
						            @RequestParam("originalFileName") String originalFileName, 
						            HttpServletRequest request) throws Exception {
	
		String saveDir = "C:\\petupload\\goodsreivew\\";	
	    File uploadPath = new File(saveDir);
	    if (!uploadPath.exists()) uploadPath.mkdirs();

	    // 새 파일 업로드 했을 경우
	    if (!file.isEmpty()) {
	        // 기존 파일 삭제
	        if (originalFileName != null && !originalFileName.isEmpty()) {
	            File oldFile = new File(saveDir + originalFileName);
	            if (oldFile.exists()) {
	                oldFile.delete(); // 삭제
	            }
	        }

	        // 새 파일 저장
	        String originalFileNameNew = file.getOriginalFilename();
	        String savedFileName = UUID.randomUUID().toString() + "_" + originalFileNameNew;
	        file.transferTo(new File(saveDir + savedFileName));
	        goodsReviewVO.setFile_name(savedFileName);
	    } else {
	        // 파일 안 바꿨으면 기존 파일 유지
	    	goodsReviewVO.setFile_name(originalFileName);
	    }
		    
	    myPageService.updateReview(goodsReviewVO);
	    return new ModelAndView("redirect:/mypage/myReview.do");
	}
	@Override
	@RequestMapping("/likeGoods.do")
	public ModelAndView likeGoods(HttpServletRequest request) throws Exception {
		String viewName = (String) request.getAttribute("viewName");
	    ModelAndView mav = new ModelAndView("/common/layout");
	    mav.addObject("title", "펫밀리");
		mav.addObject("body", "/WEB-INF/views" + viewName + ".jsp");

	    // 세션에서 member_id 가져오기
	    HttpSession session = request.getSession();
	    MemberVO member = (MemberVO) session.getAttribute("memberInfo");
	    if (member == null) {
	        mav.setViewName("redirect:/member/loginForm.do");
	        return mav;
	    }
	    String member_id = member.getMember_id();
	    
	    List<LikeGoodsVO> likeGoodsList = myPageService.likeGoodsList(member_id);
	    
	    mav.addObject("likeGoodsList", likeGoodsList);
		return mav;
	}
	
	@RequestMapping(value = "/toggleLikeGoods.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> toggleLikeGoods(@RequestParam String member_id, @RequestParam int goods_num)  throws Exception {
	    Map<String, Object> result = new HashMap<>();
	    try {
	        result = myPageService.toggleLikeGoods(member_id, goods_num);
	    } catch (Exception e) {
	        e.printStackTrace();
	        result.put("success", false);
	    }
	    return result;
	}
	@Override
	@RequestMapping(value ="/likeGoodsDelete.do", method = RequestMethod.POST)
	@ResponseBody
	public String likeGoodsDelete(@RequestParam int like_goods_id) throws Exception {
	    
		int result = myPageService.likeGoodsDelete(like_goods_id);
	    return (result > 0) ? "success" : "fail";
	 
	}
	
	
	
//	@RequestMapping(value="/myPetInfo.do", method=RequestMethod.GET)
//	public ModelAndView myPetInfo(HttpServletRequest request, HttpServletResponse response) throws Exception {
//	    HttpSession session = request.getSession();
//	    MemberVO memberInfo = (MemberVO) session.getAttribute("memberInfo");
//
//	    if (memberInfo == null) {
//	        return new ModelAndView("redirect:/member/loginForm.do");
//	    }
//	    
//	    // 사이드 메뉴 활성화 처리를 위해 session에 "my_pet_info"를 저장합니다.
//	    session.setAttribute("side_menu", "my_pet_info"); 
//	    
//	    String viewName = (String) request.getAttribute("viewName");
//	    ModelAndView mav = new ModelAndView("/common/layout");
//	    mav.addObject("title", "나의 반려동물 정보");
//	    mav.addObject("body", "/WEB-INF/views" + viewName + ".jsp");
//	    
//	    // 나중에 MyPageService를 통해 반려동물 목록을 조회하여 mav에 추가할 예정입니다.
//	    // List<PetVO> petList = myPageService.listMyPets(memberInfo.getMember_id());
//	    // mav.addObject("petList", petList);
//	    
//	    return mav;
//	}
	
	@Override
	@RequestMapping(value="/myPetInfo.do", method=RequestMethod.GET)
	public ModelAndView myPetInfo(HttpServletRequest request, HttpServletResponse response) throws Exception {
	    HttpSession session = request.getSession();
	    MemberVO memberInfo = (MemberVO) session.getAttribute("memberInfo");

	    if (memberInfo == null) {
	        return new ModelAndView("redirect:/member/loginForm.do");
	    }
	    
	    session.setAttribute("side_menu", "my_pet_info"); 
	    
	    String viewName = (String) request.getAttribute("viewName");
	    ModelAndView mav = new ModelAndView("/common/layout");
	    mav.addObject("title", "나의 반려동물 정보");
	    mav.addObject("body", "/WEB-INF/views" + viewName + ".jsp");
	    
		List<PetVO> petList = myPageService.listMyPets(memberInfo.getMember_id());
		mav.addObject("petList", petList);
	    
	    return mav;
	}
	
	// ✅ 반려동물 등록 폼 페이지로 이동하는 메서드
    @RequestMapping(value="/addPetForm.do", method=RequestMethod.GET)
    public ModelAndView addPetForm(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession();
        MemberVO memberInfo = (MemberVO) session.getAttribute("memberInfo");
        
        if (memberInfo == null) {
            return new ModelAndView("redirect:/member/loginForm.do");
        }
        
        String viewName = (String) request.getAttribute("viewName");
        ModelAndView mav = new ModelAndView("/common/layout");
        mav.addObject("title", "반려동물 등록");
        mav.addObject("body", "/WEB-INF/views" + viewName + ".jsp");
        
        boolean canAddMorePets = myPageService.canAddMorePets(memberInfo.getMember_id());
        mav.addObject("canAddMorePets", canAddMorePets);
        
        if (!canAddMorePets) {
            mav.addObject("message", "최대 3마리까지 등록 가능합니다.");
        }
        
        return mav;
    }
    
	// ✅ 반려동물 등록 처리 메서드
    @RequestMapping(value="/addPet.do", method=RequestMethod.POST)
    public ModelAndView addPet(@ModelAttribute PetVO petVO, HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession();
        MemberVO memberInfo = (MemberVO) session.getAttribute("memberInfo");
        
        if (memberInfo == null) {
            return new ModelAndView("redirect:/member/loginForm.do");
        }
        
        petVO.setMember_id(memberInfo.getMember_id());
        
        myPageService.addPet(petVO);
        
        ModelAndView mav = new ModelAndView("redirect:/mypage/myPetInfo.do");
        return mav;
    }

	// ✅ 반려동물 수정 폼 페이지로 이동하는 메서드
	@RequestMapping(value="/modifyPetForm.do", method=RequestMethod.GET)
	public ModelAndView modifyPetForm(@RequestParam("pet_id") int pet_id, HttpServletRequest request, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();
		MemberVO memberInfo = (MemberVO) session.getAttribute("memberInfo");

		if (memberInfo == null) {
			return new ModelAndView("redirect:/member/loginForm.do");
		}
		
		String viewName = (String) request.getAttribute("viewName");
		ModelAndView mav = new ModelAndView("/common/layout");
		mav.addObject("title", "반려동물 정보 수정");
		mav.addObject("body", "/WEB-INF/views" + viewName + ".jsp");

		PetVO petVO = myPageService.findPetInfo(pet_id);
		mav.addObject("petVO", petVO);

		return mav;
	}

	// ✅ 반려동물 수정 처리 메서드
	@RequestMapping(value="/modifyPet.do", method=RequestMethod.POST)
	public ModelAndView modifyPet(@ModelAttribute PetVO petVO, HttpServletRequest request, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();
		MemberVO memberInfo = (MemberVO) session.getAttribute("memberInfo");

		if (memberInfo == null) {
			return new ModelAndView("redirect:/member/loginForm.do");
		}
		
		myPageService.modifyPet(petVO);
		
		ModelAndView mav = new ModelAndView("redirect:/mypage/myPetInfo.do");
		return mav;
	}

	// ✅ 반려동물 삭제 처리 메서드
	@RequestMapping(value="/removePet.do", method=RequestMethod.GET)
	public ModelAndView removePet(@RequestParam("pet_id") int pet_id, HttpServletRequest request, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();
		MemberVO memberInfo = (MemberVO) session.getAttribute("memberInfo");
		
		if (memberInfo == null) {
			return new ModelAndView("redirect:/member/loginForm.do");
		}

		myPageService.removePet(pet_id);

		ModelAndView mav = new ModelAndView("redirect:/mypage/myPetInfo.do");
		return mav;
	}
	
}