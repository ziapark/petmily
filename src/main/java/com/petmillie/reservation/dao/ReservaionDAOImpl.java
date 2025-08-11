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
    
    // MyBatis 매퍼 XML의 namespace와 일치해야 합니다.
    private static final String NAMESPACE = "com.petmillie.reservation.dao.ReservaionDAO";

    @Override
    public List<ReservaionVO> selectReservaionList(String business_id) throws Exception {
        // 이 부분은 다른 기능(사업자용)이므로 기존 로직을 유지합니다.
        return sqlSession.selectList("mapper.adminReser.reservationList", business_id);
    }

    /**
     * 전체 펜션 목록을 조회하는 메서드
     */
    @Override
    public List<PensionVO> selectAllPensions() throws Exception {
        return sqlSession.selectList(NAMESPACE + ".selectAllPensions");
    }
    
    /**
     * ID로 특정 펜션 정보를 조회하는 메서드
     */
    @Override
    public PensionVO selectPensionById(int pensionId) throws Exception {
        return sqlSession.selectOne(NAMESPACE + ".selectPensionById", pensionId);
    }

    /**
     * 예약 정보를 데이터베이스에 삽입하는 메서드
     */
    @Override
    public int insertReservation(ReservaionVO reservationVO) throws Exception {
        return sqlSession.insert(NAMESPACE + ".insertReservation", reservationVO);
    }
}