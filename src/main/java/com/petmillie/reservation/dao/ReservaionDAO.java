package com.petmillie.reservation.dao;

import java.util.List;

import com.petmillie.business.vo.PensionVO;
import com.petmillie.business.vo.RoomVO;
import com.petmillie.reservation.vo.ReservaionVO;
import com.petmillie.reservation.vo.ReservationDTO;

public interface ReservaionDAO {

	// 사업자 예약 내역 조회
	public List<ReservaionVO> selectReservaionList(String business_id) throws Exception;

	// 일반 회원용 펜션 목록 조회
	public List<PensionVO> selectAllPensionList() throws Exception;
	public PensionVO selectPensionById(int pensionId) throws Exception;
	
	/**
	 * 펜션 상세 정보 조회 (p_num 기준)
	 */
	public PensionVO selectPensionDetail(int p_num) throws Exception;

	/**
	 * 특정 펜션에 속한 객실 목록 조회
	 */
	public List<RoomVO> selectRoomList(int p_num) throws Exception;

	/*
	 * ===================================================================
	 * ▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼ [ 신규 기능 선언 추가 ] ▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
	 * ===================================================================
	 */

	// --- 신규 기능 메서드 ---
		public RoomVO selectRoomDetail(int roomId) throws Exception;
		// 파라미터 타입을 ReservationDTO로 변경
		public int insertReservation(ReservationDTO reservationDTO) throws Exception;
}