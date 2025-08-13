package com.petmillie.reservation.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.petmillie.business.vo.PensionVO;
import com.petmillie.business.vo.RoomVO;
import com.petmillie.reservation.vo.ReservaionVO;
import com.petmillie.reservation.vo.ReservationDTO;

@Repository("reservaionDAO")
public class ReservaionDAOImpl implements ReservaionDAO {

	@Autowired
	private SqlSession sqlSession;
	
	// 네임스페이스는 기존 것을 그대로 사용합니다.
	private static final String NAMESPACE_ORIG = "mapper.reservation"; // 매퍼 XML의 namespace와 일치시킵니다.
	// 관리자용 네임스페이스 (기존 코드 유지)
	private static final String NAMESPACE_ADMIN = "mapper.adminReser.";

	@Override
	public List<ReservaionVO> selectReservaionList(String business_id) throws Exception {
		return sqlSession.selectList(NAMESPACE_ADMIN + "reservationList", business_id);
	}

	@Override
	public List<PensionVO> selectAllPensionList() throws Exception {
		// 사용하는 네임스페이스를 실제 매퍼에 맞게 수정했습니다.
		return sqlSession.selectList(NAMESPACE_ORIG + ".selectAllPensionList");
	}
	
	@Override
	public PensionVO selectPensionById(int pensionId) throws Exception {
		return sqlSession.selectOne(NAMESPACE_ORIG + ".selectPensionById", pensionId);
	}
	
	
	@Override
	public PensionVO selectPensionDetail(int p_num) throws Exception {
		return sqlSession.selectOne(NAMESPACE_ORIG + ".selectPensionDetail", p_num);
	}

	@Override
	public List<RoomVO> selectRoomList(int p_num) throws Exception {
		return sqlSession.selectList(NAMESPACE_ORIG + ".selectRoomList", p_num);
	}

	/*
	 * ===================================================================
	 * ▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼ [ 신규 기능 구현 추가 ] ▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
	 * ===================================================================
	 */
	// --- 신규 기능 메서드 (수정됨) ---
		@Override
		public RoomVO selectRoomDetail(int roomId) throws Exception {
			return sqlSession.selectOne(NAMESPACE_ORIG + ".selectRoomDetail", roomId);
		}

		@Override
		// 파라미터 타입을 ReservationDTO로 변경
		public int insertReservation(ReservationDTO reservationDTO) throws Exception {
			sqlSession.insert(NAMESPACE_ORIG + ".insertReservation", reservationDTO);
			return reservationDTO.getReservation_id();
		}
}