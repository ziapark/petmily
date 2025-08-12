package com.petmillie.reservation.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

public interface ReservaionController {

	/**
	 * 사업자 예약 내역 조회 (기존 기능 유지)
	 */
	public ModelAndView serachReservaion(HttpServletRequest request, HttpServletResponse response) throws Exception;

	/**
	 * 일반 회원용 펜션 목록 조회 (기존 기능 유지)
	 */
	public ModelAndView listPensions(HttpServletRequest request, HttpServletResponse response) throws Exception;

	/**
	 * 펜션 상세 정보 조회 (지도 표시 기능)
	 */
	public ModelAndView pensionDetail(@RequestParam("p_num") String p_num, HttpServletRequest request, HttpServletResponse response) throws Exception;
}