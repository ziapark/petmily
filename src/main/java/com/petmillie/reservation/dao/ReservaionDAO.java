package com.petmillie.reservation.dao;

import java.util.List;

import com.petmillie.business.vo.PensionVO;
import com.petmillie.reservation.vo.ReservaionVO;

public interface ReservaionDAO {

    // 사업자 예약 내역 조회
    public List<ReservaionVO> selectReservaionList(String business_id) throws Exception;

    // 일반 회원용 펜션 목록 조회
    public List<PensionVO> selectAllPensionList() throws Exception;
    public PensionVO selectPensionById(int pensionId) throws Exception;
   
 // ▼▼▼ [이 부분을 추가하세요!] ▼▼▼
 	/**
 	 * 펜션 상세 정보 조회 (p_num 기준, 주소 포함)
 	 */
 	public PensionVO selectPensionDetail(String p_num) throws Exception;
}