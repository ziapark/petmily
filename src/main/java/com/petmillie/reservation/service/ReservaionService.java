package com.petmillie.reservation.service;

import java.util.List;
import com.petmillie.business.vo.PensionVO;

public interface ReservaionService {
    
    /**
     * 모든 펜션 목록 조회
     */
	public List<PensionVO> listAllPensions() throws Exception;
	
	/**
	 * 펜션 상세 정보 조회 (p_num 기준, 주소 포함)
	 */
	public PensionVO getPensionDetail(String p_num) throws Exception;
}