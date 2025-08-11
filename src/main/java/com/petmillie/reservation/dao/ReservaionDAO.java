package com.petmillie.reservation.dao;

import java.util.List;
import com.petmillie.business.vo.PensionVO;
import com.petmillie.reservation.vo.ReservaionVO;

public interface ReservaionDAO {

    // 사업자용 예약 목록 조회
    public List<ReservaionVO> selectReservaionList(String business_id) throws Exception;

    // 모든 펜션 정보를 조회하는 메서드
    public List<PensionVO> selectAllPensions() throws Exception;

    // ID로 특정 펜션 정보를 조회하는 메서드
    public PensionVO selectPensionById(int pensionId) throws Exception;

    // 예약 정보를 삽입하는 메서드
    public int insertReservation(ReservaionVO reservationVO) throws Exception;
    
}