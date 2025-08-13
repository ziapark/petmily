package com.petmillie.reservation.dao;

import java.util.List;
import com.petmillie.business.vo.PensionVO;
import com.petmillie.business.vo.RoomVO;
import com.petmillie.reservation.vo.ReservationDTO;
// 사용하지 않는 ReservaionVO import는 제거해도 됩니다.

public interface ReservaionDAO {

	// 펜션 목록 조회
	public List<PensionVO> selectAllPensionList() throws Exception;
	
	// 펜션 상세 조회
	public PensionVO selectPensionDetail(int p_num) throws Exception;
	
	// 특정 펜션의 객실 목록 조회
	public List<RoomVO> selectRoomList(int p_num) throws Exception;

	// 객실 상세 조회
	public RoomVO selectRoomDetail(int roomId) throws Exception;

	// 예약 추가
	public int insertReservation(ReservationDTO reservationDTO) throws Exception;
	
	/**
	 * [추가] 사업자 ID로 예약 목록을 조회하는 메서드
	 * 서비스 계층에서 이 기능을 호출하므로 인터페이스에 선언이 필요합니다.
	 */
	public List<ReservationDTO> selectReservationsByBusinessId(String business_id) throws Exception;

}

