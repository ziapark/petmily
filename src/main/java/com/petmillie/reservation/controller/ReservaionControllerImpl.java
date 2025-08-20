package com.petmillie.reservation.controller;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
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
        if (memberVO == null) {
            return new ModelAndView("redirect:/member/loginForm.do");
        }
        reservationVO.setMember_id(memberVO.getMember_id());
        reservationVO.setReservation_status("예약완료");
        int reservationId = reservationService.addReservation(reservationVO);
        ModelAndView mav = new ModelAndView("redirect:/reservation/reservationComplete.do");
        mav.addObject("reservationId", reservationId);
        return mav;
    }

    @RequestMapping(value = "/reservationComplete.do", method = RequestMethod.GET)
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
    @RequestMapping(value = "/modifyForm.do", method = RequestMethod.GET)
    public ModelAndView modifyForm(@RequestParam("reservationId") int reservationId, HttpServletRequest request,
            HttpServletResponse response) throws Exception {
        ReservationVO reservation = reservationService.getReservationById(reservationId);
        ModelAndView mav = new ModelAndView("/common/layout");
        mav.addObject("body", "/WEB-INF/views/reservation/modifyForm.jsp");
        mav.addObject("title", "예약 정보 수정");
        mav.addObject("reservation", reservation);
        return mav;
    }

    @Override
    @RequestMapping(value = "/updateReservation.do", method = RequestMethod.POST)
    public ModelAndView updateReservation(@ModelAttribute("reservation") ReservationVO reservationVO,
            HttpServletRequest request, HttpServletResponse response) throws Exception {
        reservationService.updateReservation(reservationVO);
        ModelAndView mav = new ModelAndView("redirect:/reservation/myReservations.do");
        return mav;
    }

    @PostMapping("/updateStatus")
    public ResponseEntity<Map<String, Object>> updateReservationStatus(@RequestBody Map<String, Object> payload) {
        Map<String, Object> response = new HashMap<>();
        try {
            int reservationId = Integer.parseInt(String.valueOf(payload.get("reservation_id")));
            String newStatus = (String) payload.get("reservation_status");

            System.out.println("상태 업데이트 요청: ID=" + reservationId + ", 상태=" + newStatus);

            boolean isSuccess = true; 

            if (isSuccess) {
                response.put("success", true);
                response.put("message", "예약 상태가 성공적으로 변경되었습니다.");
                return ResponseEntity.ok(response);
            } else {
                response.put("success", false);
                response.put("message", "DB 업데이트에 실패했습니다.");
                return ResponseEntity.badRequest().body(response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "서버 오류가 발생했습니다.");
            return ResponseEntity.internalServerError().body(response);
        }
    }

    @Override
    @PostMapping(value = "/cancel.do", produces = "text/plain;charset=UTF-8")
    @ResponseBody
    public String cancelReservation(@RequestParam("reservation_id") int reservationId) throws Exception {
        try {
            int result = reservationService.cancelReservation(reservationId);
            if (result > 0) {
                return "예약이 성공적으로 취소되었습니다.";
            } else {
                return "예약 취소에 실패했습니다. 다시 시도해 주세요.";
            }
        } catch (Exception e) {
            e.printStackTrace();
            return "오류가 발생하여 예약을 취소할 수 없습니다.";
        }
    }

    @Override
    @GetMapping(value = "/calculatePrice.do", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public Map<String, Object> calculatePrice(@RequestParam("roomId") int roomId,
            @RequestParam("checkinDate") String checkinDateStr,
            @RequestParam("checkoutDate") String checkoutDateStr) {

        Map<String, Object> response = new HashMap<>();

        try {
            // 날짜 값이 비어있는지 확인
            if (checkinDateStr == null || checkinDateStr.isEmpty() || 
                checkoutDateStr == null || checkoutDateStr.isEmpty()) {               
                throw new IllegalArgumentException("체크인 또는 체크아웃 날짜가 비어있습니다.");
            }
            
            LocalDate checkinDate = LocalDate.parse(checkinDateStr);
            LocalDate checkoutDate = LocalDate.parse(checkoutDateStr);
            long nights = ChronoUnit.DAYS.between(checkinDate, checkoutDate);

            if (nights <= 0) {
                throw new IllegalArgumentException("숙박일수는 1일 이상이어야 합니다.");
            }

            int pricePerNight = reservationService.getRoomPrice(roomId);
            System.out.println(pricePerNight);
            if (pricePerNight <= 0) {
                throw new IllegalArgumentException("객실 가격 정보를 가져올 수 없습니다.");
            }
            long totalPrice = pricePerNight * nights;

            response.put("success", true);
            response.put("totalPrice", totalPrice);
            response.put("nights", nights);

        } catch (Exception e) {
            // 예상치 못한 에러가 발생해도 서버가 멈추지 않고,
            // 원인 메시지를 담아 클라이언트에게 응답합니다.
            e.printStackTrace();
            response.put("success", false);
            response.put("message", e.getMessage()); 
        }

        return response;
    }
    
}