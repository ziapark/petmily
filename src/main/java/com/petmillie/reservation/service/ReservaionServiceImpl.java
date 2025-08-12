package com.petmillie.reservation.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.petmillie.business.vo.PensionVO;
import com.petmillie.business.vo.RoomVO; // RoomVO import 추가
import com.petmillie.reservation.dao.ReservaionDAO;

@Service("ReservaionService")
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
	public PensionVO getPensionDetail(int p_num) throws Exception { // 파라미터 int로 변경
		// DAO의 'selectPensionDetail' 메서드를 호출합니다.
		return reservaionDAO.selectPensionDetail(p_num); // 파라미터 int로 전달
	}
	
	/**
	 * [ ✨ 추가된 메서드 구현 ]
	 * DAO의 selectRoomList를 호출하여 결과를 Controller에 그대로 반환합니다.
	 */
	@Override
	public List<RoomVO> getRoomList(int p_num) throws Exception {
		return reservaionDAO.selectRoomList(p_num);
	}
}