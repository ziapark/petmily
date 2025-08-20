package com.petmillie.reservation.controller;

import java.util.Map; 

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.http.ResponseEntity; 
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody; 
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.petmillie.reservation.vo.ReservationVO;

public interface ReservaionController {


	public ModelAndView serachReservaion(HttpServletRequest request, HttpServletResponse response) throws Exception;
	public ModelAndView listPensions(HttpServletRequest request, HttpServletResponse response) throws Exception;
	public ModelAndView pensionDetail(@RequestParam("p_num") int p_num, HttpServletRequest request, HttpServletResponse response) throws Exception;
	public ModelAndView reservationForm(@RequestParam("p_num") int p_num, @RequestParam("roomId") int roomId, HttpServletRequest request, HttpServletResponse response) throws Exception;
	public ModelAndView makeReservation(@ModelAttribute("reservation") ReservationVO reservationVO, HttpServletRequest request, HttpServletResponse response) throws Exception;
	public ModelAndView reservationComplete(HttpServletRequest request, HttpServletResponse response) throws Exception;
	public ModelAndView listMyReservations(HttpServletRequest request, HttpServletResponse response) throws Exception;
	public ModelAndView modifyForm(@RequestParam("reservationId") int reservationId, HttpServletRequest request, HttpServletResponse response) throws Exception;
	public ModelAndView updateReservation(@ModelAttribute("reservation") ReservationVO reservationVO, HttpServletRequest request, HttpServletResponse response) throws Exception;

	/*
	 * ===================================================================
	 * ▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼ [ Ajax 상태 변경 메소드 선언 추가 ] ▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
	 * ===================================================================
	 */
	
	/**
	 * 예약 상태를 Ajax로 업데이트
	 */
	public ResponseEntity<Map<String, Object>> updateReservationStatus(@RequestBody Map<String, Object> payload);
	  public String cancelReservation(@RequestParam("reservation_id") int reservationId) throws Exception;
}