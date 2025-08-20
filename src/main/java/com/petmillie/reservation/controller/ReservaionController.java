package com.petmillie.reservation.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.http.ResponseEntity;
import org.springframework.web.servlet.ModelAndView;

import com.petmillie.reservation.vo.ReservationVO;

public interface ReservaionController {

    public ModelAndView serachReservaion(HttpServletRequest request, HttpServletResponse response) throws Exception;

    public ModelAndView listPensions(HttpServletRequest request, HttpServletResponse response) throws Exception;

    // 인터페이스에서는 @RequestParam 어노테이션을 제거합니다.
    public ModelAndView pensionDetail(int p_num, HttpServletRequest request, HttpServletResponse response) throws Exception;

    // 인터페이스에서는 @RequestParam 어노테이션을 제거합니다.
    public ModelAndView reservationForm(int p_num, int roomId, HttpServletRequest request, HttpServletResponse response) throws Exception;

    // 인터페이스에서는 @ModelAttribute 어노테이션을 제거합니다.
    public ModelAndView makeReservation(ReservationVO reservationVO, HttpServletRequest request, HttpServletResponse response) throws Exception;

    public ModelAndView reservationComplete(HttpServletRequest request, HttpServletResponse response) throws Exception;

    public ModelAndView listMyReservations(HttpServletRequest request, HttpServletResponse response) throws Exception;

    // 인터페이스에서는 @RequestParam 어노테이션을 제거합니다.
    public ModelAndView modifyForm(int reservationId, HttpServletRequest request, HttpServletResponse response) throws Exception;

    // 인터페이스에서는 @ModelAttribute 어노테이션을 제거합니다.
    public ModelAndView updateReservation(ReservationVO reservationVO, HttpServletRequest request, HttpServletResponse response) throws Exception;

    // 인터페이스에서는 @RequestBody 어노테이션을 제거합니다.
    public ResponseEntity<Map<String, Object>> updateReservationStatus(Map<String, Object> payload);
    
    // 인터페이스에서는 @RequestParam 어노테이션을 제거하고, 특수 공백 문자를 제거합니다.
    public String cancelReservation(int reservationId) throws Exception;

    // 인터페이스에서는 @RequestParam 어노테이션을 제거하고, 특수 공백 문자를 제거합니다.
    public Map<String, Object> calculatePrice(int roomId, String checkinDateStr, String checkoutDateStr) throws Exception;

}