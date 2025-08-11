package com.petmillie.reservation.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

public interface ReservaionController {

    // 사업자 예약 내역 조회
    public ModelAndView serachReservaion(HttpServletRequest request, HttpServletResponse response) throws Exception;
    
    // 일반 회원용 펜션 목록 조회
    public ModelAndView listPensions(HttpServletRequest request, HttpServletResponse response) throws Exception;
    public ModelAndView pensionDetail(int pensionId, HttpServletRequest request, HttpServletResponse response) throws Exception;
}