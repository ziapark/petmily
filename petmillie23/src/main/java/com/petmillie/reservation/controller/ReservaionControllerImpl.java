package com.petmillie.reservation.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.petmillie.business.service.BusinessService;
import com.petmillie.business.vo.BusinessVO;
import com.petmillie.reservation.vo.ReservaionVO;

@Controller("ReservationController")
@RequestMapping("/reservation")
public class ReservaionControllerImpl implements ReservaionController {
	@Autowired
	private BusinessService businessService;
	
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

	
	

}
