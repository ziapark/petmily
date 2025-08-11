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
    
    // (기존 코드) 사업자 예약 내역 조회 메서드
    @Override
    public List<ReservaionVO> selectReservaionList(String business_id) throws Exception {
        // 이 부분은 기존에 구현되어 있는 코드로 가정합니다.
        return null;
    }

    // ----------------------------------------------------
    // ** 일반 회원용 펜션 목록 조회 기능 추가 **
    // ----------------------------------------------------
    @Override
    public List<PensionVO> selectAllPensionList() throws Exception {
        // ▼▼▼ 1. 이 부분의 문자열을 수정했습니다! ▼▼▼
        return sqlSession.selectList("com.petmillie.reservation.dao.ReservaionDAO.selectAllPensionList");
    }
    
    @Override
    public PensionVO selectPensionById(int pensionId) throws Exception {
        // ▼▼▼ 2. 이 부분의 문자열도 함께 수정했습니다! ▼▼▼
        return sqlSession.selectOne("com.petmillie.reservation.dao.ReservaionDAO.selectPensionById", pensionId);
    }
    
}