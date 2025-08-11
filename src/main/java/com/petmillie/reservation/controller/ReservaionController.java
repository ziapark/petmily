package com.petmillie.reservation.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.bind.annotation.RequestParam; // @RequestParam 사용을 위해 import
import org.springframework.web.servlet.ModelAndView;

public interface ReservaionController {

	// 사업자 예약 내역 조회
	public ModelAndView serachReservaion(HttpServletRequest request, HttpServletResponse response) throws Exception;
	
	// 일반 회원용 펜션 목록 조회
	public ModelAndView listPensions(HttpServletRequest request, HttpServletResponse response) throws Exception;
	
	// 펜션 상세 정보 조회
    // Impl 클래스와 시그니처를 맞추기 위해 @RequestParam 어노테이션을 추가해주는 것이 좋습니다.
	public ModelAndView pensionDetail(@RequestParam("pensionId") int pensionId, HttpServletRequest request, HttpServletResponse response) throws Exception;
	
	// 예약 폼으로 이동 (새로 추가된 메서드 선언)
	public ModelAndView reservationForm(@RequestParam("p_num") int p_num, HttpServletRequest request, HttpServletResponse response) throws Exception;

}