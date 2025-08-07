package com.petmillie.reservation.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

public interface ReservaionController {

    // 사업자 예약 내역 조회
    public ModelAndView serachReservaion(HttpServletRequest request, HttpServletResponse response) throws Exception;

//    // 일반 회원 예약 메인 페이지 (펜션 목록)
//    public ModelAndView showReservationMain(HttpServletRequest request, HttpServletResponse response) throws Exception;
}
