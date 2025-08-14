package com.petmillie.reservation.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.petmillie.reservation.vo.ReservationVO;

public interface ReservaionController {

	/**
	 * 사업자 예약 내역 조회
	 */
	public ModelAndView serachReservaion(HttpServletRequest request, HttpServletResponse response) throws Exception;

	/**
	 * 일반 회원용 펜션 목록 조회
	 */
	public ModelAndView listPensions(HttpServletRequest request, HttpServletResponse response) throws Exception;

	/**
	 * 펜션 상세 정보 조회
	 */
	public ModelAndView pensionDetail(@RequestParam("p_num") int p_num, HttpServletRequest request, HttpServletResponse response) throws Exception;
	
	/**
	 * 예약하기 폼 페이지 요청
	 */
	public ModelAndView reservationForm(@RequestParam("p_num") int p_num, @RequestParam("roomId") int roomId, HttpServletRequest request, HttpServletResponse response) throws Exception;
	
	/**
	 * 예약 실행
	 */
	public ModelAndView makeReservation(@ModelAttribute("reservation") ReservationVO reservationVO, HttpServletRequest request, HttpServletResponse response) throws Exception;

	/**
	 * 예약 완료 페이지
	 */
	public ModelAndView reservationComplete(HttpServletRequest request, HttpServletResponse response) throws Exception;
	
	/*
	 * ===================================================================
	 * ▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼ [ 신규 기능 선언 추가 ] ▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
	 * ===================================================================
	 */
	
	/**
	 * 일반 회원용 나의 예약 내역 조회
	 */
	public ModelAndView listMyReservations(HttpServletRequest request, HttpServletResponse response) throws Exception;
}
