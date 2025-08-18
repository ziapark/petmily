package com.petmillie.reservation.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity; // 👈 [추가] import
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping; // 👈 [추가] import
import org.springframework.web.bind.annotation.RequestBody; // 👈 [추가] import
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.petmillie.business.service.BusinessService;
import com.petmillie.business.vo.BusinessVO;
import com.petmillie.business.vo.PensionVO;
import com.petmillie.business.vo.RoomVO;
import com.petmillie.member.vo.MemberVO;
import com.petmillie.reservation.service.ReservaionService;
import com.petmillie.reservation.vo.ReservationVO;

@Controller("ReservationController")
@RequestMapping("/reservation")
public class ReservaionControllerImpl implements ReservaionController {

	@Autowired
	private BusinessService businessService;

	@Autowired
	private ReservaionService reservationService;

	/**
	 * [수정] 사업자 예약 내역 조회
	 * 이 메서드가 reservation_check.jsp 페이지를 담당하도록 수정합니다.
	 */
	@Override
	@RequestMapping(value = "/reservation_check.do", method = { RequestMethod.GET, RequestMethod.POST })
	public ModelAndView serachReservaion(HttpServletRequest request, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();
		BusinessVO businessVO = (BusinessVO) session.getAttribute("businessInfo");

		if (businessVO == null) {
			return new ModelAndView("redirect:/business/loginForm.do");
		}
		String business_id = businessVO.getBusiness_id();

		List<ReservationVO> reservationList = reservationService.getReservationsByBusinessId(business_id);

		ModelAndView mav = new ModelAndView("/common/layout");
		mav.addObject("body", "/WEB-INF/views/reservation/reservation_check.jsp");
		mav.addObject("title", "사업자 예약 내역");
		mav.addObject("reservation", reservationList);

		return mav;
	}

	// ... (기존의 다른 메소드들은 그대로 유지) ...
	
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

	@Override
	@RequestMapping(value = "/pensionDetail.do", method = RequestMethod.GET)
	public ModelAndView pensionDetail(@RequestParam("p_num") int p_num, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		PensionVO pension = reservationService.getPensionDetail(p_num);
		List<RoomVO> roomList = reservationService.getRoomList(p_num);
		ModelAndView mav = new ModelAndView("/common/layout");
		mav.addObject("body", "/WEB-INF/views/reservation/pensionDetail.jsp");
		if (pension != null) {
			mav.addObject("title", pension.getP_name() + " 상세 정보");
		} else {
			mav.addObject("title", "펜션 정보 없음");
		}
		mav.addObject("pension", pension);
		mav.addObject("roomList", roomList);
		return mav;
	}
	
	@Override
	@RequestMapping(value = "/roomReservation.do", method = RequestMethod.GET)
	public ModelAndView reservationForm(@RequestParam("p_num") int p_num, @RequestParam("roomId") int roomId,
			HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView("/common/layout");
		mav.addObject("body", "/WEB-INF/views/reservation/roomReservation.jsp");
		mav.addObject("title", "객실 예약하기");
		PensionVO pension = reservationService.getPensionDetail(p_num);
		RoomVO room = reservationService.getRoomDetail(roomId);
		mav.addObject("pension", pension);
		mav.addObject("room", room);
		return mav;
	}

	@Override
	@RequestMapping(value = "/makeReservation.do", method = RequestMethod.POST)
	public ModelAndView makeReservation(@ModelAttribute("reservation") ReservationVO reservationVO,
	        HttpServletRequest request, HttpServletResponse response) throws Exception {
	    HttpSession session = request.getSession();
	    MemberVO memberVO = (MemberVO) session.getAttribute("memberInfo");
	    if(memberVO == null) {
	        return new ModelAndView("redirect:/member/loginForm.do");
	    }
	    reservationVO.setMember_id(memberVO.getMember_id());
	    reservationVO.setReservation_status("예약완료");
	    int reservationId = reservationService.addReservation(reservationVO);
	    ModelAndView mav = new ModelAndView("redirect:/reservation/reservationComplete.do");
	    mav.addObject("reservationId", reservationId);
	    return mav;
	}

	@RequestMapping(value="/reservationComplete.do", method=RequestMethod.GET)
	public ModelAndView reservationComplete(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView("/common/layout");
		mav.addObject("body", "/WEB-INF/views/reservation/reservationComplete.jsp");
		mav.addObject("title", "예약 완료");
		return mav;
	}
	
	@Override
	@RequestMapping(value = "/myReservations.do", method = RequestMethod.GET)
	public ModelAndView listMyReservations(HttpServletRequest request, HttpServletResponse response) throws Exception {
	    HttpSession session = request.getSession();
	    MemberVO memberVO = (MemberVO) session.getAttribute("memberInfo");

	    if (memberVO == null) {
	        return new ModelAndView("redirect:/member/loginForm.do");
	    }

	    String memberId = memberVO.getMember_id();
	    List<ReservationVO> reservationList = reservationService.getReservationsByMemberId(memberId);
	    
	    ModelAndView mav = new ModelAndView("/common/layout");
	    mav.addObject("body", "/WEB-INF/views/reservation/myReservations.jsp");
	    mav.addObject("title", "나의 예약 내역");
	    mav.addObject("myReservations", reservationList);
	    return mav;
	}
	
	@Override
	@RequestMapping(value="/modifyForm.do", method=RequestMethod.GET)
	public ModelAndView modifyForm(@RequestParam("reservationId") int reservationId, HttpServletRequest request, HttpServletResponse response) throws Exception {
	    ReservationVO reservation = reservationService.getReservationById(reservationId);
	    ModelAndView mav = new ModelAndView("/common/layout");
	    mav.addObject("body", "/WEB-INF/views/reservation/modifyForm.jsp");
	    mav.addObject("title", "예약 정보 수정");
	    mav.addObject("reservation", reservation);
	    return mav;
	}

	@Override
	@RequestMapping(value="/updateReservation.do", method=RequestMethod.POST)
	public ModelAndView updateReservation(@ModelAttribute("reservation") ReservationVO reservationVO, HttpServletRequest request, HttpServletResponse response) throws Exception {
	    reservationService.updateReservation(reservationVO);
	    ModelAndView mav = new ModelAndView("redirect:/reservation/myReservations.do");
	    return mav;
	}
	
	// ▼▼▼ [ Ajax 요청 처리 ] 이 메소드를 클래스 맨 아래에 추가하세요 ▼▼▼
	/**
	 * JSP 페이지에서 보낸 Ajax 요청을 받아 예약 상태를 DB에 업데이트합니다.
	 * @param payload - 클라이언트에서 온 JSON 데이터 ({ "reservation_id": "...", "reservation_status": "..." })
	 * @return 처리 결과를 담은 ResponseEntity 객체
	 */
	@PostMapping("/updateStatus")
	public ResponseEntity<Map<String, Object>> updateReservationStatus(@RequestBody Map<String, Object> payload) {
		Map<String, Object> response = new HashMap<>();
		try {
			// JSP에서 보낸 reservation_id와 reservation_status를 추출합니다.
			// JavaScript에서 id를 문자열로 보냈을 수 있으므로 Integer.parseInt로 변환합니다.
			int reservationId = Integer.parseInt(String.valueOf(payload.get("reservation_id")));
			String newStatus = (String) payload.get("reservation_status");
			
			System.out.println("상태 업데이트 요청: ID=" + reservationId + ", 상태=" + newStatus);
			
			// TODO: ReservationService와 DAO/Mapper에 아래 메소드를 실제로 구현해야 합니다.
			// 예: reservationService.updateReservationStatus(reservationId, newStatus);
			// 이 예제에서는 DB 업데이트가 성공했다고 가정합니다.
			boolean isSuccess = true; // 실제로는 서비스 계층의 DB 업데이트 성공 여부를 반환받아야 합니다.
			
			if (isSuccess) {
				response.put("success", true);
				response.put("message", "예약 상태가 성공적으로 변경되었습니다.");
				return ResponseEntity.ok(response); // 성공 시 200 OK 응답
			} else {
				response.put("success", false);
				response.put("message", "DB 업데이트에 실패했습니다.");
				return ResponseEntity.badRequest().body(response); // 실패 시 400 Bad Request 응답
			}

		} catch (Exception e) {
			e.printStackTrace();
			response.put("success", false);
			response.put("message", "서버 오류가 발생했습니다.");
			return ResponseEntity.internalServerError().body(response); // 서버 에러 시 500 Internal Server Error 응답
		}
	}
}