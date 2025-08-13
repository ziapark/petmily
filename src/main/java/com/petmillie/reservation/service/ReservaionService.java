package com.petmillie.reservation.service;

import java.util.List;

import com.petmillie.business.vo.PensionVO;
import com.petmillie.business.vo.RoomVO;
import com.petmillie.reservation.vo.ReservationDTO;

public interface ReservaionService {

	/**
	 * 모든 펜션 목록 조회
	 */
	public List<PensionVO> listAllPensions() throws Exception;

	/**
	 * 펜션 상세 정보 조회 (p_num 기준)
	 */
	public PensionVO getPensionDetail(int p_num) throws Exception;

	/**
	 * 특정 펜션의 객실 목록 조회
	 */
	public List<RoomVO> getRoomList(int p_num) throws Exception;

	/*
	 * ===================================================================
	 * ▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼ [ 신규 기능 선언 추가 ] ▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
	 * ===================================================================
	 */

	 // --- 신규 기능 메서드 ---
		public RoomVO getRoomDetail(int roomId) throws Exception;
		// 파라미터 타입을 ReservationDTO로 변경
		public int addReservation(ReservationDTO reservationDTO) throws Exception;
}