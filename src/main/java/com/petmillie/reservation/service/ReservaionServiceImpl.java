package com.petmillie.reservation.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.petmillie.business.vo.PensionVO;
import com.petmillie.business.vo.RoomVO;
import com.petmillie.reservation.dao.ReservaionDAO;
import com.petmillie.reservation.vo.ReservationDTO;

@Service("ReservaionService")
@Transactional(propagation = Propagation.REQUIRED)
public class ReservaionServiceImpl implements ReservaionService {

	@Autowired
	private ReservaionDAO reservaionDAO;

	// 펜션 목록 조회
	@Override
	public List<PensionVO> listAllPensions() throws Exception {
		return reservaionDAO.selectAllPensionList();
	}
	
	// 펜션 상세 조회 (주소 포함)
	@Override
	public PensionVO getPensionDetail(int p_num) throws Exception {
		return reservaionDAO.selectPensionDetail(p_num);
	}
	
	// 특정 펜션의 객실 목록 조회
	@Override
	public List<RoomVO> getRoomList(int p_num) throws Exception {
		return reservaionDAO.selectRoomList(p_num);
	}

	// 객실 상세 조회
	@Override
	public RoomVO getRoomDetail(int roomId) throws Exception {
		return reservaionDAO.selectRoomDetail(roomId);
	}

	// 예약 추가
	@Override
	public int addReservation(ReservationDTO reservationDTO) throws Exception {
		return reservaionDAO.insertReservation(reservationDTO);
	}

	/**
	 * [추가] 사업자 ID로 예약 목록을 조회하는 메서드 구현
	 * 이 메서드는 DAO를 호출하여 DB에서 데이터를 가져옵니다.
	 */
	@Override
	public List<ReservationDTO> getReservationsByBusinessId(String business_id) throws Exception {
		return reservaionDAO.selectReservationsByBusinessId(business_id);
	}
	
	@Override
	public List<ReservationDTO> getReservationsByMemberId(String memberId) throws Exception {
	    return reservaionDAO.selectReservationsByMemberId(memberId);
	}
}
