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
import com.petmillie.reservation.service.ReservaionService;
import com.petmillie.reservation.vo.ReservaionVO;

@Controller("ReservationController")
@RequestMapping("/reservation")
public class ReservaionControllerImpl implements ReservaionController {

	@Autowired
	private BusinessService businessService;

	@Autowired
	private ReservaionService reservationService;
	
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
	    System.out.println("list : " + list);
		String viewName = (String) request.getAttribute("viewName");
	    ModelAndView mav = new ModelAndView("/common/layout");
	    mav.addObject("title", "예약 내역");
	    mav.addObject("body", "/WEB-INF/views/"+viewName+".jsp"); // 뷰 경로 확인
	    mav.addObject("reservation", list); // 뷰에 전달
	    
	    return mav;
	}
	
	/**
	 * 전체 펜션 목록을 보여주는 메서드
	 */
	@RequestMapping(value="/pensionList.do", method=RequestMethod.GET)
	public ModelAndView listPensions(HttpServletRequest request, HttpServletResponse response) throws Exception {
	    
	    List<PensionVO> pensionList = reservationService.listAllPensions();
	    
	    String viewName = "reservation/pensionList"; 
	    
	    ModelAndView mav = new ModelAndView("/common/layout");
	    
	    mav.addObject("body", "/WEB-INF/views/" + viewName + ".jsp");
	    mav.addObject("title", "펜션 목록");
	    mav.addObject("pensionList", pensionList);
	    
	    System.out.println("펜션 목록을 가져왔습니다. 갯수: " + pensionList.size());
	    
	    return mav;
	}

	/**
	 * 펜션 상세 정보를 보여주는 메서드
	 */
	@RequestMapping(value="/pensionDetail.do", method=RequestMethod.GET)
	public ModelAndView pensionDetail(@RequestParam("pensionId") int pensionId,
	                                  HttpServletRequest request, HttpServletResponse response) throws Exception {

	    // 서비스를 호출해서 펜션 정보 가져오기
	    PensionVO pensionVO = reservationService.getPensionDetail(pensionId);

	    // 최종적으로 보여줄 JSP와 레이아웃 설정
	    ModelAndView mav = new ModelAndView("/common/layout");
	    mav.addObject("body", "/WEB-INF/views/reservation/pensionDetail.jsp");
	    mav.addObject("title", "펜션 상세 정보");

	    // 서비스가 가져온 펜션 정보를 "pension"이라는 이름으로 JSP에 전달
	    mav.addObject("pension", pensionVO);

	    return mav;
	}
	
	/**
	 * 상세 페이지에서 '예약하기' 버튼을 클릭했을 때, 예약 폼 페이지로 이동시켜주는 메서드
	 */
	@RequestMapping(value="/reservationForm.do", method=RequestMethod.GET)
	public ModelAndView reservationForm(@RequestParam("p_num") int p_num,
	                                    HttpServletRequest request, HttpServletResponse response) throws Exception {

	    // p_num을 사용하여 DB에서 예약할 펜션의 상세 정보를 가져옵니다.
	    PensionVO pensionVO = reservationService.getPensionDetail(p_num);

	    // 최종적으로 보여줄 JSP와 레이아웃을 설정합니다.
	    ModelAndView mav = new ModelAndView("/common/layout");
	    mav.addObject("body", "/WEB-INF/views/reservation/reservationForm.jsp");
	    mav.addObject("title", pensionVO.getP_name() + " 예약하기");

	    // 조회한 펜션 정보를 "pension"이라는 이름으로 JSP에 전달합니다.
	    mav.addObject("pension", pensionVO);

	    return mav;
	}
}