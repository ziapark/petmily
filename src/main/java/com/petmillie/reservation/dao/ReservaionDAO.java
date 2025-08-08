package com.petmillie.reservation.dao;

import java.util.List;

import com.petmillie.business.vo.PensionVO;
import com.petmillie.reservation.vo.ReservaionVO;

public interface ReservaionDAO {

    // 사업자 예약 내역 조회
    public List<ReservaionVO> selectReservaionList(String business_id) throws Exception;

    // 일반 회원용 펜션 목록 조회
    public List<PensionVO> selectAllPensionList() throws Exception;

}