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
// 클래스 레벨에 트랜잭션을 적용하여 모든 public 메서드가 하나의 트랜잭션 단위로 묶이도록 합니다.
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


    // --- 신규 기능 메서드 (수정됨) ---
	@Override
	public RoomVO getRoomDetail(int roomId) throws Exception {
		return reservaionDAO.selectRoomDetail(roomId);
	}

	@Override
	// 파라미터 타입을 ReservationDTO로 변경
	public int addReservation(ReservationDTO reservationDTO) throws Exception {
		return reservaionDAO.insertReservation(reservationDTO);
	}
}