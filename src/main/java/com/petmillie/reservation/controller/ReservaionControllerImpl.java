package com.petmillie.reservation.controller;

import java.util.List; // List import 추가
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
import com.petmillie.business.vo.RoomVO; // RoomVO import 추가
import com.petmillie.reservation.service.ReservaionService;
import com.petmillie.reservation.vo.ReservaionVO;

@Controller("ReservationController")
@RequestMapping("/reservation")
public class ReservaionControllerImpl implements ReservaionController {

	@Autowired
	private BusinessService businessService;

	@Autowired
	private ReservaionService reservationService;

	/**
	 * 사업자 예약 내역 조회 (기존 코드 유지)
	 */
	@Override
	@RequestMapping(value = "/reserForm.do", method = { RequestMethod.GET, RequestMethod.POST })
	public ModelAndView serachReservaion(HttpServletRequest request, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();
		BusinessVO businessVO = (BusinessVO) session.getAttribute("businessInfo");

		if (businessVO == null) {
			return new ModelAndView("redirect:/business/loginForm.do");
		}

		String business_id = businessVO.getBusiness_id();
		List<ReservaionVO> list = businessService.reservationList(business_id);

		String viewName = (String) request.getAttribute("viewName");
		ModelAndView mav = new ModelAndView("/common/layout");
		mav.addObject("title", "예약 내역");
		mav.addObject("body", "/WEB-INF/views/" + viewName + ".jsp");
		mav.addObject("reservation", list);

		return mav;
	}

	/**
	 * 일반 회원용 펜션 목록 조회 (기존 코드 유지)
	 */
	@Override
	@RequestMapping(value = "/pensionList.do", method = RequestMethod.GET)
	public ModelAndView listPensions(HttpServletRequest request, HttpServletResponse response) throws Exception {
		List<PensionVO> pensionList = reservationService.listAllPensions();

		String viewName = "reservation/pensionList";

		ModelAndView mav = new ModelAndView("/common/layout");
		mav.addObject("body", "/WEB-INF/views/" + viewName + ".jsp");
		mav.addObject("title", "펜션 목록");
		mav.addObject("pensionList", pensionList);

		return mav;
	}

	/**
	 * 펜션 상세 정보 및 객실 목록 조회 (기능 추가)
	 */
	@Override
	@RequestMapping(value = "/pensionDetail.do", method = RequestMethod.GET)
	public ModelAndView pensionDetail(@RequestParam("p_num") int p_num, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		// 1. 펜션 상세 정보 조회
		PensionVO pension = reservationService.getPensionDetail(p_num);
		
		// 2. 해당 펜션의 객실 목록 조회 (새로 추가된 부분)
		List<RoomVO> roomList = reservationService.getRoomList(p_num);

		ModelAndView mav = new ModelAndView("/common/layout");
		mav.addObject("body", "/WEB-INF/views/reservation/pensionDetail.jsp");

		if (pension != null) {
			mav.addObject("title", pension.getP_name() + " 상세 정보");
		} else {
			mav.addObject("title", "펜션 정보 없음");
		}

		// 3. ModelAndView에 펜션 정보와 '객실 목록'을 추가
		mav.addObject("pension", pension);
		mav.addObject("roomList", roomList); // JSP로 객실 목록 전달

		return mav;
	}
}