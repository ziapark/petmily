package com.petmillie.reservation.service;

import java.util.List;
import com.petmillie.business.vo.PensionVO;
import com.petmillie.business.vo.RoomVO; // RoomVO import 추가

public interface ReservaionService {

	/**
	 * 모든 펜션 목록 조회
	 */
	public List<PensionVO> listAllPensions() throws Exception;

	/**
	 * 펜션 상세 정보 조회 (p_num 기준, 주소 포함)
	 * // Controller, DAO와 일관성을 맞추기 위해 파라미터를 int로 변경
	 */
	public PensionVO getPensionDetail(int p_num) throws Exception;

	/**
	 * [ ✨ 추가된 메서드 ]
	 * 특정 펜션의 객실 목록 조회
	 */
	public List<RoomVO> getRoomList(int p_num) throws Exception;
}