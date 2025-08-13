package com.petmillie.reservation.dao;

import java.util.List;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import com.petmillie.business.vo.PensionVO;
import com.petmillie.business.vo.RoomVO;
import com.petmillie.reservation.vo.ReservationDTO;

@Repository("reservaionDAO")
public class ReservaionDAOImpl implements ReservaionDAO {

	@Autowired
	private SqlSession sqlSession;
	
	private static final String NAMESPACE = "mapper.reservation"; // 네임스페이스를 하나로 통일

	@Override
	public List<PensionVO> selectAllPensionList() throws Exception {
		return sqlSession.selectList(NAMESPACE + ".selectAllPensionList");
	}
	
	@Override
	public PensionVO selectPensionDetail(int p_num) throws Exception {
		return sqlSession.selectOne(NAMESPACE + ".selectPensionDetail", p_num);
	}

	@Override
	public List<RoomVO> selectRoomList(int p_num) throws Exception {
		return sqlSession.selectList(NAMESPACE + ".selectRoomList", p_num);
	}

	@Override
	public RoomVO selectRoomDetail(int roomId) throws Exception {
		return sqlSession.selectOne(NAMESPACE + ".selectRoomDetail", roomId);
	}

	@Override
	public int insertReservation(ReservationDTO reservationDTO) throws Exception {
		sqlSession.insert(NAMESPACE + ".insertReservation", reservationDTO);
		return reservationDTO.getReservation_id();
	}

	/**
	 * [추가] 사업자 ID로 예약 목록을 조회하는 메서드 구현
	 * 이 메서드는 매퍼 XML의 쿼리를 호출합니다.
	 */
	@Override
	public List<ReservationDTO> selectReservationsByBusinessId(String business_id) throws Exception {
		return sqlSession.selectList(NAMESPACE + ".selectReservationsByBusinessId", business_id);
	}
}