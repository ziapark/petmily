package com.petmillie.reservation.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.petmillie.reservation.vo.ReservationDTO;

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
	public ModelAndView pensionDetail(@RequestParam("p_num") int p_num, HttpServletRequest request, HttpServletResponse response) throws Exception;
	
	
	/*
	 * ===================================================================
	 * ▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼ [ 신규 기능 선언 추가 ] ▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
	 * ===================================================================
	 */
	
	/**
	 * 예약하기 폼 페이지 요청
	 * @param p_num 펜션 번호
	 * @param roomId 객실 번호
	 */
public ModelAndView reservationForm(@RequestParam("p_num") int p_num, @RequestParam("roomId") int roomId, HttpServletRequest request, HttpServletResponse response) throws Exception;
	
	// 파라미터 타입을 ReservationDTO로 변경
	public ModelAndView makeReservation(@ModelAttribute("reservation") ReservationDTO reservationDTO, HttpServletRequest request, HttpServletResponse response) throws Exception;
}
