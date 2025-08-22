package com.petmillie.reservation.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.petmillie.business.dao.BusinessDAO;
import com.petmillie.business.vo.PensionVO;
import com.petmillie.business.vo.RoomVO;
import com.petmillie.reservation.dao.ReservaionDAO;
import com.petmillie.reservation.vo.ReservationVO;

@Service("ReservaionService")
@Transactional(propagation = Propagation.REQUIRED)
public class ReservaionServiceImpl implements ReservaionService {

	@Autowired
    private BusinessDAO businessDAO;
	
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

	@Override
	public int addReservation(ReservationVO reservationVO) throws Exception {
		// 1. 예약 정보를 reservation 테이블에 추가
		reservaionDAO.insertReservation(reservationVO);
		
		// 2. 해당 객실의 상태를 '예약대기'로 변경
		Map<String, Object> roomMap = new HashMap<>();
		roomMap.put("roomId", reservationVO.getRoom_id());
		roomMap.put("status", "예약대기");
		businessDAO.updateRoomStatus(roomMap);
		
		return reservationVO.getReservation_id();
	}

	@Override
	public List<ReservationVO> getReservationsByBusinessId(String business_id) throws Exception {
		return reservaionDAO.selectReservationsByBusinessId(business_id);
	}
	
	@Override
	public List<ReservationVO> getReservationsByMemberId(String memberId) throws Exception {
	    return reservaionDAO.selectReservationsByMemberId(memberId);
	}
	
	@Override
	public ReservationVO getReservationById(int reservationId) throws Exception {
	    return reservaionDAO.selectReservationById(reservationId);
	}

	@Override
	public void updateReservation(ReservationVO reservationVO) throws Exception {
	    reservaionDAO.updateReservation(reservationVO);
	}

	/**
	 * [수정] '예약대기' 상태일 때도 룸 상태를 함께 변경하는 로직 추가
	 */
	@Override
	public void updateReservationStatus(int reservationId, String status) throws Exception {
		// 1. 먼저 변경할 예약 정보를 가져와서 room_id를 확보합니다.
		ReservationVO reservation = reservaionDAO.selectReservationById(reservationId);
		if (reservation == null) {
			throw new Exception("존재하지 않는 예약입니다.");
		}
		int roomId = reservation.getRoom_id();

		// 2. reservation 테이블의 상태를 업데이트합니다.
		reservaionDAO.updateReservationStatus(reservationId, status);

		// 3. 새로운 예약 상태(status)에 따라 room 테이블의 상태를 업데이트합니다.
		Map<String, Object> roomMap = new HashMap<>();
		roomMap.put("roomId", roomId);

		if ("예약완료".equals(status)) {
			roomMap.put("status", "예약중");
			businessDAO.updateRoomStatus(roomMap);
		} else if ("예약취소".equals(status)) {
			roomMap.put("status", "예약가능");
			businessDAO.updateRoomStatus(roomMap);
		} else if ("예약대기".equals(status)) {
			roomMap.put("status", "예약대기");
			businessDAO.updateRoomStatus(roomMap);
		}
	}
	
	@Override
    public int cancelReservation(int reservationId) throws Exception {
        return reservaionDAO.updateReservationStatusToCancel(reservationId);
    }
	
	@Override
    public int getRoomPrice(int roomId) throws Exception {
        return reservaionDAO.selectRoomPrice(roomId);
    }
	@Override
	public List<ReservationVO> getAllReservations() throws Exception {
	    return reservaionDAO.selectAllReservations(); }
	
}
