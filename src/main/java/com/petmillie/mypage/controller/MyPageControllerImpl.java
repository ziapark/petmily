package com.petmillie.mypage.controller;

import java.io.File;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.petmillie.common.base.BaseController;
import com.petmillie.common.file.FileDownloadController;
import com.petmillie.goods.service.GoodsService;
import com.petmillie.member.service.MemberService;
import com.petmillie.member.vo.MemberVO;
import com.petmillie.mypage.service.MyPageService;
import com.petmillie.mypage.vo.GoodsReviewVO;
import com.petmillie.mypage.vo.LikeGoodsVO;
import com.petmillie.mypage.vo.PetVO;
import com.petmillie.order.service.OrderService;
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
	@Autowired
	private OrderService orderService;
	@Autowired
	private GoodsService goodsService;
	  
    
        @Autowired
        private FileDownloadController fileDownloadController;
        
        // ▼▼▼ 2. 400 에러 방지를 위한 날짜 변환 코드(@InitBinder) 추가 ▼▼▼
        @InitBinder
        public void initBinder(WebDataBinder binder) {
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            binder.registerCustomEditor(Date.class, new CustomDateEditor(dateFormat, true));
        }
        
        
        
        
    
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
	        @RequestParam(value="page", defaultValue="1") int page,
	        HttpServletRequest request, HttpServletResponse response) throws Exception {

	    HttpSession session = request.getSession();
	    session.setAttribute("side_menu", "my_page");

	    String viewName = (String) request.getAttribute("viewName");
	    ModelAndView mav = new ModelAndView("/common/layout");

	    mav.addObject("title", "마이페이지 - 주문 내역 조회");
	    mav.addObject("body", "/WEB-INF/views" + viewName + ".jsp");

	    memberVO = (MemberVO) session.getAttribute("memberInfo");
	    String member_id = memberVO.getMember_id();

	    // 검색 기간 계산
	    String fixedSearchPeriod = dateMap.get("fixedSearchPeriod");
	    String[] tempDate = calcSearchPeriod(fixedSearchPeriod).split(",");
	    String beginDate = tempDate[0];
	    String endDate = tempDate[1];
	    dateMap.put("beginDate", beginDate);
	    dateMap.put("endDate", endDate);
	    dateMap.put("member_id", member_id);

	    // 날짜 정보 JSP 전달
	    String[] beginDateArr = beginDate.split("-");
	    String[] endDateArr = endDate.split("-");
	    mav.addObject("beginYear", beginDateArr[0]);
	    mav.addObject("beginMonth", beginDateArr[1]);
	    mav.addObject("beginDay", beginDateArr[2]);
	    mav.addObject("endYear", endDateArr[0]);
	    mav.addObject("endMonth", endDateArr[1]);
	    mav.addObject("endDay", endDateArr[2]);

	    // 페이지네이션 설정
	    int limit = 10;
	    int offset = (page - 1) * limit;
	    dateMap.put("offset", String.valueOf(offset));
	    dateMap.put("limit", String.valueOf(limit));

	    // 전체 주문 수
	//     int totalCount = myPageService.countMyOrderHistory(dateMap);

	    // 주문 내역 조회
	    List<OrderVO> myOrderHistList = myPageService.listMyOrderHistory(dateMap);

	    // order_id별 rowspan, 합계 계산
	    Map<Integer, Integer> countMap = new HashMap<>();
	    Map<Integer, Integer> totalAmountMap = new HashMap<>();
	    Map<Integer, Integer> totalQtyMap = new HashMap<>();

	    for (OrderVO order : myOrderHistList) {
	        int orderId = order.getOrder_id();
	        int goodsPrice = order.getGoods_sales_price();
	        int goodsQty = Integer.parseInt(order.getGoods_qty());

	        // rowspan count
	        countMap.put(orderId, countMap.getOrDefault(orderId, 0) + 1);

	        // 주문별 합계 금액 & 수량
	        int amount = goodsPrice * goodsQty;
	        totalAmountMap.put(orderId, totalAmountMap.getOrDefault(orderId, 0) + amount);
	        totalQtyMap.put(orderId, totalQtyMap.getOrDefault(orderId, 0) + goodsQty);
	    }

	    // 첫 Row 여부 + 마지막 Row 여부 + 합계 세팅
	    Map<Integer, Integer> remainCountMap = new HashMap<>(countMap);
	    Set<Integer> seen = new HashSet<>();

	    for (OrderVO order : myOrderHistList) {
	        int orderId = order.getOrder_id();
	        int count = remainCountMap.get(orderId);

	        // rowspan
	        order.setRowspanCount(countMap.get(orderId));

	        // 첫 row
	        if (!seen.contains(orderId)) {
	            order.setFirstRow(true);
	            seen.add(orderId);
	        } else {
	            order.setFirstRow(false);
	        }

	        // 합계 값 세팅
	        order.setOrderTotalAmount(totalAmountMap.get(orderId));
	        order.setOrderTotalQty(totalQtyMap.get(orderId));

	        // 마지막 row 여부
	        remainCountMap.put(orderId, count - 1);
	        order.setLastRow(count - 1 == 0);
	    }

	    mav.addObject("myOrderHistList", myOrderHistList);

	    // 페이지네이션 정보
	  //  int totalPage = (int) Math.ceil((double) totalCount / limit);
	    mav.addObject("currentPage", page);
	  //  mav.addObject("totalPage", totalPage);

	    return mav;
	}
	
	//구매확정
	@RequestMapping(value="/confirmPurchase.do" ,method = RequestMethod.POST)
	public String confirmPurchase(@RequestParam("order_id") String order_id, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		HttpSession session = request.getSession();
		MemberVO memberVO = (MemberVO)session.getAttribute("memberInfo");
		String member_id = memberVO.getMember_id();

		Map<String, String> orderMap = new HashMap<>();
		orderMap.put("order_id", order_id);
		orderMap.put("member_id", member_id);
		
		// 서비스를 호출하여 주문 상태 변경 및 포인트 적립을 처리합니다.
		myPageService.confirmPurchase(orderMap);
		
	    memberVO = memberService.login(memberVO.getMember_id(), memberVO.getMember_pw());
	    session.setAttribute("memberInfo", memberVO);
		
		return "redirect:/mypage/listMyOrderHistory.do";
	}
	
	//반품
	@RequestMapping(value="/returnOrder.do" ,method = RequestMethod.POST)
	public ModelAndView returnOrder(@RequestParam String order_id) {
		ModelAndView mav = new ModelAndView();
		try {
			myPageService.updateDeliveryState(order_id, "returning_goods");
		} catch (Exception e) {
			e.printStackTrace();
		}

		mav.addObject("message", "반품신청되었습니다.");
		mav.setViewName("redirect:/mypage/listMyOrderHistory.do");
		return mav;
	}
	
	@Override
	@RequestMapping(value="/myDetailInfo.do" ,method = RequestMethod.GET)
	public ModelAndView myDetailInfo(HttpServletRequest request, HttpServletResponse response)  throws Exception {
		HttpSession session=request.getSession();
		String viewName=(String)request.getAttribute("viewName");
		String id = (String)session.getId();

		ModelAndView mav = new ModelAndView("/common/layout");
		mav.addObject("title", "회원정보관리");
		mav.addObject("body", "/WEB-INF/views" + viewName + ".jsp");
		
		MemberVO member = myPageService.myDetailInfo(id);
		mav.addObject("memberInfo", member);
		
		return mav;
	}

	@Override
	@RequestMapping(value="/updateMember.do" ,method = RequestMethod.POST)
	public ModelAndView updateMember(@ModelAttribute MemberVO memberVO, HttpSession session, HttpServletRequest request, HttpServletResponse response)  throws Exception {
		ModelAndView mav = new ModelAndView("/common/layout");
		mav.addObject("title", "회원정보관리");
		mav.addObject("body", "/WEB-INF/views/mypage/myDetailInfo.jsp");
		
		try {
			int result = myPageService.updateMember(memberVO);
			
	        if (result > 0) {
	        	mav.addObject("message", "회원정보가 성공적으로 수정되었습니다.");
	            session.setAttribute("memberInfo", memberVO);
	        } else {
	        	mav.addObject("message", "회원정보 수정에 실패했습니다.");
	        }                 
        } catch (Exception e) {
            e.printStackTrace();

        }				
		return mav;
	}
	
	@Override
	@RequestMapping(value="/removeMember.do", method=RequestMethod.POST)
	@ResponseBody
	public String removeMember(@RequestParam("id")String id, HttpServletRequest request, HttpServletResponse response) throws Exception {
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

		int order_num = orderVO.getOrder_num();
		int goods_num = orderVO.getGoods_num();
		String goods_name = orderVO.getGoods_name();
		
		HttpSession session = request.getSession();
		MemberVO memberVO =(MemberVO) session.getAttribute("memberInfo");
		

		mav.addObject("order_num", order_num);
		mav.addObject("goods_num", goods_num);
		mav.addObject("goods_name", goods_name);
		
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
	    String saveDir = "C:\\petrepo\\goodsreivew\\";
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
	    System.out.println("리뷰리뷰리뷰리뷰" + review);
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
	public ModelAndView updateReview(@ModelAttribute GoodsReviewVO goodsReviewVO, @RequestParam("uploadFile") MultipartFile file, @RequestParam("originalFileName") String originalFileName, HttpServletRequest request) throws Exception {
	
		String saveDir = "C:\\petrepo\\goodsreivew\\";	
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
    
    

        // 3. 기존 addPet 메소드를 아래 코드로 완전히 교체합니다.
        @Override
        @RequestMapping(value="/addPet.do", method=RequestMethod.POST)
        public ModelAndView addPet(@ModelAttribute PetVO petVO,
        							@RequestParam("uploadFile") MultipartFile file,
        							HttpServletRequest request) throws Exception {
            
            HttpSession session = request.getSession();
            MemberVO memberInfo = (MemberVO) session.getAttribute("memberInfo");
            if (memberInfo == null) {
                return new ModelAndView("redirect:/member/loginForm.do");
            }
            System.out.println("안녕???");
            // 파일 업로드 처리
    	    // **C드라이브에 저장할 경로 설정** 
    	    String saveDir = "C:\\petrepo\\mypet";
    	    File uploadPath = new File(saveDir);
    	    if (!uploadPath.exists()) uploadPath.mkdirs();

    	    if (!file.isEmpty()) {
    	        String originalFileName = file.getOriginalFilename();
    	        String savedFileName = UUID.randomUUID().toString() + "_" + originalFileName;
    	        file.transferTo(new File(saveDir + "\\" + savedFileName));
    	        petVO.setPet_image(savedFileName); // pet_image에 저장
    	    } else {
    	        petVO.setPet_image(null);
    	    }
            
            
            //String savedFileName = fileDownloadController.uploadPetImage(file);
            
            petVO.setMember_id(memberInfo.getMember_id());
            
            // DB에 저장
            myPageService.addPet(petVO);
            
            return new ModelAndView("redirect:/mypage/myPetInfo.do");
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