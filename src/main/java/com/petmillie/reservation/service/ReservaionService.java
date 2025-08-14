package com.petmillie.reservation.service;

import java.util.List;

import com.petmillie.business.vo.PensionVO;
import com.petmillie.business.vo.RoomVO;
import com.petmillie.reservation.vo.ReservationVO;

public interface ReservaionService {

	// 펜션 목록 조회
	public List<PensionVO> listAllPensions() throws Exception;
	
	// 펜션 상세 조회
	public PensionVO getPensionDetail(int p_num) throws Exception;
	
	// 특정 펜션의 객실 목록 조회
	public List<RoomVO> getRoomList(int p_num) throws Exception;

	// 객실 상세 조회
	public RoomVO getRoomDetail(int roomId) throws Exception;

	// 예약 추가
	public int addReservation(ReservationVO reservationVO) throws Exception;
	
	/**
	 * [추가] 사업자 ID로 예약 목록을 조회하는 메서드
	 * 컨트롤러에서 이 기능을 호출하므로 인터페이스에 선언이 필요합니다.
	 */
	public List<ReservationVO> getReservationsByBusinessId(String business_id) throws Exception;
	public List<ReservationVO> getReservationsByMemberId(String memberId) throws Exception;
	
}
