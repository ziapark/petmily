package com.petmillie.reservation.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.petmillie.business.service.BusinessService;
import com.petmillie.business.vo.BusinessVO;
import com.petmillie.business.vo.PensionVO;
import com.petmillie.reservation.service.ReservaionService; // import 추가
import com.petmillie.reservation.vo.ReservaionVO;

@Controller("ReservationController")
@RequestMapping("/reservation")
public class ReservaionControllerImpl implements ReservaionController {

	@Autowired
	private BusinessService businessService;

	@Autowired
	private ReservaionService reservationService; // 이 줄을 추가해야 합니다.
	
	@Override
	@RequestMapping(value="/reserForm.do", method= {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView serachReservaion(HttpServletRequest request, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();
	    BusinessVO businessVO = (BusinessVO) session.getAttribute("businessInfo");

	    // 로그인 안했을 경우 대비
	    if (businessVO == null) {
	        return new ModelAndView("redirect:/business/loginForm.do");
	    }

	    String business_id = businessVO.getBusiness_id();
	    System.out.println("가져온 비즈니스 아이디 : " + business_id);
	    
	    List<ReservaionVO> list = businessService.reservationList(business_id);
	    System.out.println("lis1t : " + list);
		String viewName = (String) request.getAttribute("viewName");
	    ModelAndView mav = new ModelAndView("/common/layout");
	    mav.addObject("title", "예약 내역");
	    mav.addObject("body", "/WEB-INF/views/"+viewName+".jsp"); // 뷰 경로 확인
	    mav.addObject("reservation", list); // 뷰에 전달
	    
	    return mav;
	}
	
//	@RequestMapping(value="/pensionList.do", method=RequestMethod.GET)
//	public ModelAndView listPensions(HttpServletRequest request, HttpServletResponse response) throws Exception {
//	    
//	    // 1. 모든 펜션 목록을 가져옵니다.
//	    List<PensionVO> pensionList = reservationService.listAllPensions();
//	    
//	    // 2. ModelAndView 객체를 생성하고, 조회된 목록을 추가합니다.
//	    String viewName = (String) request.getAttribute("viewName");
//	    ModelAndView mav = new ModelAndView("/common/layout");
//	    mav.setViewName("reservation/pensionList"); // WEB-INF/views/reservation/pensionList.jsp를 바라보게 설정
//	    mav.addObject("pensionList", pensionList);
//	    
//	    System.out.println("펜션 목록을 가져왔습니다. 갯수: " + pensionList.size());
//	    
//	    return mav;
//	}
//	
//	
//	
//	
	
	
	
	
	
	
	@RequestMapping(value="/pensionList.do", method=RequestMethod.GET)
	public ModelAndView listPensions(HttpServletRequest request, HttpServletResponse response) throws Exception {
	    
	    List<PensionVO> pensionList = reservationService.listAllPensions();
	    
	    String viewName = "reservation/pensionList"; // 뷰 이름만 지정합니다.
	    
	    // ModelAndView 객체를 생성하고, 레이아웃 페이지를 뷰 이름으로 지정합니다.
	    ModelAndView mav = new ModelAndView("/common/layout");
	    
	    // 실제 콘텐츠가 들어갈 뷰 경로를 'body'라는 이름으로 addObject 합니다.
	    mav.addObject("body", "/WEB-INF/views/" + viewName + ".jsp");
	    
	    // 제목도 추가하면 레이아웃에 표시됩니다.
	    mav.addObject("title", "펜션 목록");
	    
	    // 조회된 펜션 목록을 'pensionList'라는 이름으로 뷰에 전달합니다.
	    mav.addObject("pensionList", pensionList);
	    
	    System.out.println("펜션 목록을 가져왔습니다. 갯수: " + pensionList.size());
	    
	    return mav;
	}
	
	
	
	// ▼▼▼▼▼ [ 이 부분을 복사해서 추가하세요! ] ▼▼▼▼▼
		@RequestMapping(value="/pensionDetail.do", method=RequestMethod.GET)
	    public ModelAndView pensionDetail(@RequestParam("pensionId") int pensionId,
	                                      HttpServletRequest request, HttpServletResponse response) throws Exception {

	        // 2단계에서 만든 서비스를 호출해서 펜션 정보 가져오기
	        PensionVO pensionVO = reservationService.getPensionDetail(pensionId);

	        // 최종적으로 보여줄 JSP와 레이아웃 설정
	        ModelAndView mav = new ModelAndView("/common/layout");
	        mav.addObject("body", "/WEB-INF/views/reservation/pensionDetail.jsp");
	        mav.addObject("title", "펜션 상세 정보");

	        // 서비스가 가져온 펜션 정보를 "pension"이라는 이름으로 JSP에 전달
	        mav.addObject("pension", pensionVO);

	        return mav;
	    }
		// ▲▲▲▲▲ [ 여기까지 추가하면 됩니다! ] ▲▲▲▲▲
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}