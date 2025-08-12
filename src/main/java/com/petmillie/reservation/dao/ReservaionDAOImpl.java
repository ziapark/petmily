package com.petmillie.reservation.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.petmillie.business.vo.PensionVO;
import com.petmillie.business.vo.RoomVO; // RoomVO import 추가
import com.petmillie.reservation.vo.ReservaionVO;

@Repository("reservaionDAO")
public class ReservaionDAOImpl implements ReservaionDAO {

	@Autowired
	private SqlSession sqlSession;
	
	// 네임스페이스는 기존 것을 그대로 사용한다고 가정합니다.
	private static final String NAMESPACE_ORIG = "com.petmillie.reservation.dao.ReservaionDAO";
	// 관리자용 네임스페이스 (기존 코드 유지)
	private static final String NAMESPACE_ADMIN = "mapper.adminReser.";

	@Override
	public List<ReservaionVO> selectReservaionList(String business_id) throws Exception {
		return sqlSession.selectList(NAMESPACE_ADMIN + "reservationList", business_id);
	}

	@Override
	public List<PensionVO> selectAllPensionList() throws Exception {
		return sqlSession.selectList(NAMESPACE_ORIG + ".selectAllPensionList");
	}
	
	@Override
	public PensionVO selectPensionById(int pensionId) throws Exception {
		return sqlSession.selectOne(NAMESPACE_ORIG + ".selectPensionById", pensionId);
	}
	
	
	@Override
	// 파라미터 타입을 int로 변경합니다.
	public PensionVO selectPensionDetail(int p_num) throws Exception {
		return sqlSession.selectOne(NAMESPACE_ORIG + ".selectPensionDetail", p_num);
	}

	/**
	 * [ ✨ 추가된 메서드 구현 ]
	 * MyBatis 매퍼의 'selectRoomList' 쿼리를 호출하여 객실 목록을 가져옵니다.
	 */
	@Override
	public List<RoomVO> selectRoomList(int p_num) throws Exception {
		// selectList를 사용하여 여러 개의 RoomVO 객체를 리스트로 받아옵니다.
		return sqlSession.selectList(NAMESPACE_ORIG + ".selectRoomList", p_num);
	}
}