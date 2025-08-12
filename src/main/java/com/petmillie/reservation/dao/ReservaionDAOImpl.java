package com.petmillie.reservation.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.petmillie.business.vo.PensionVO;
import com.petmillie.reservation.vo.ReservaionVO;

@Repository("reservaionDAO")
public class ReservaionDAOImpl implements ReservaionDAO {

    @Autowired
    private SqlSession sqlSession;
    
    // 기존 매퍼(펜션 조회 등)가 남아있는 네임스페이스
    private static final String NAMESPACE_ORIG = "com.petmillie.reservation.dao.ReservaionDAO.";
    // 새로 분리한 관리자 전용 매퍼 (adminReseravtion.xml)
    private static final String NAMESPACE_ADMIN = "mapper.adminReser.";

    // 사업자(관리자)용 예약 목록 — 새 매퍼로 호출
    @Override
    public List<ReservaionVO> selectReservaionList(String business_id) throws Exception {
        return sqlSession.selectList(NAMESPACE_ADMIN + "reservationList", business_id);
    }

    // ----------------------------------------------------
    // 일반 회원용 펜션 목록/상세 (기존 매퍼 사용)
    // ----------------------------------------------------
    @Override
    public List<PensionVO> selectAllPensionList() throws Exception {
        return sqlSession.selectList(NAMESPACE_ORIG + "selectAllPensionList");
    }
    
    @Override
    public PensionVO selectPensionById(int pensionId) throws Exception {
        return sqlSession.selectOne(NAMESPACE_ORIG + "selectPensionById", pensionId);
    }
    
    
    @Override
    public PensionVO selectPensionDetail(String p_num) throws Exception {
        // 기존의 NAMESPACE_ORIG 방식을 그대로 사용해서 매퍼의 selectPensionDetail 쿼리를 호출합니다.
        return sqlSession.selectOne(NAMESPACE_ORIG + "selectPensionDetail", p_num);
    }
}
