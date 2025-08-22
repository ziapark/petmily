package com.petmillie.reservation.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

import com.petmillie.business.vo.PensionVO;
import com.petmillie.business.vo.RoomVO;
import com.petmillie.reservation.vo.ReservationVO;

@Repository("reservaionDAO")
public class ReservaionDAOImpl implements ReservaionDAO {

	@Autowired
	private SqlSession sqlSession;
	
	private static final String NAMESPACE = "mapper.reservation"; 

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
	public int insertReservation(ReservationVO reservationVO) throws Exception {
		sqlSession.insert(NAMESPACE + ".insertReservation", reservationVO);
		return reservationVO.getReservation_id();
	}

	@Override
	public List<ReservationVO> selectReservationsByBusinessId(String business_id) throws Exception {
		return sqlSession.selectList(NAMESPACE + ".selectReservationsByBusinessId", business_id);
	}
	
	// [추가] 회원 ID로 예약 목록을 조회하는 메서드 구현
	@Override
	public List<ReservationVO> selectReservationsByMemberId(String memberId) throws DataAccessException {
		return sqlSession.selectList(NAMESPACE + ".selectReservationsByMemberId", memberId);
	}
	@Override
	public ReservationVO selectReservationById(int reservationId) throws Exception {
	    return sqlSession.selectOne("mapper.reservation.selectReservationById", reservationId);
	}

	@Override
	public void updateReservation(ReservationVO reservationVO) throws Exception {
	    sqlSession.update("mapper.reservation.updateReservation", reservationVO);
	}

	@Override
	public void updateReservationStatus(int reservationId, String status) throws DataAccessException {
		Map<String, Object> params = new HashMap<>();
		params.put("reservationId", reservationId);
		params.put("status", status);
		sqlSession.update("mapper.reservation.updateReservationStatus", params);
}
	

	
	@Override
    public int updateReservationStatusToCancel(int reservationId) throws DataAccessException {
        int result = sqlSession.update("mapper.reservation.updateReservationStatusToCancel", reservationId);
        return result;
    }
	
	 @Override
	    public int selectRoomPrice(int roomId) throws DataAccessException {
	        return sqlSession.selectOne("mapper.reservation.selectRoomPrice", roomId);
	    }
	
	// [추가] 관리자가 모든 예약을 조회
	 @Override
	 public List<ReservationVO> selectAllReservations() throws Exception {
	     return sqlSession.selectList(NAMESPACE + ".selectAllReservations");
	 }

}
