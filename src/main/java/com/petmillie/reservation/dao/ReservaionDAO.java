package com.petmillie.reservation.dao;

import java.util.List;

import com.petmillie.business.vo.PensionVO;
import com.petmillie.business.vo.RoomVO; // RoomVO import 추가
import com.petmillie.reservation.vo.ReservaionVO;

public interface ReservaionDAO {

	// 사업자 예약 내역 조회
	public List<ReservaionVO> selectReservaionList(String business_id) throws Exception;

	// 일반 회원용 펜션 목록 조회
	public List<PensionVO> selectAllPensionList() throws Exception;
	public PensionVO selectPensionById(int pensionId) throws Exception;
	
	/**
	 * 펜션 상세 정보 조회 (p_num 기준, 주소 포함)
	 * Controller와 일관성을 맞추기 위해 파라미터를 int로 변경합니다.
	 */
	public PensionVO selectPensionDetail(int p_num) throws Exception;

	/**
	 * [ ✨ 추가된 메서드 ]
	 * 특정 펜션에 속한 객실 목록을 조회합니다.
	 */
	public List<RoomVO> selectRoomList(int p_num) throws Exception;
}