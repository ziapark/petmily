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
        // SQL 매퍼 파일에 정의된 "selectAllPensionList" 쿼리를 실행합니다.
        // 이때, 쿼리문은 펜션 정보를 담고 있는 테이블에서 데이터를 가져와야 합니다.
        // 예를 들어, <select id="selectAllPensionList" ...> 으로 정의된 쿼리입니다.
        return sqlSession.selectList("mapper.reservation.selectAllPensionList");
    }

}