package com.petmillie.reservation.service;

import java.util.List;
import com.petmillie.business.vo.PensionVO;

public interface ReservaionService {

    // 전체 펜션 목록을 조회하는 기능
    public List<PensionVO> listAllPensions() throws Exception;

    // 특정 펜션의 상세 정보를 조회하는 기능
    public PensionVO getPensionDetail(int pensionId) throws Exception;
    
}