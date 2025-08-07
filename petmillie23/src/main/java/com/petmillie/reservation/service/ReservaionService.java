package com.petmillie.reservation.service;

import java.util.List;

import com.petmillie.business.vo.PensionVO; // PensionVO를 import 합니다.

public interface ReservaionService {

    /**
     * 일반 회원이 보는 펜션 목록을 모두 조회합니다.
     * @return 펜션 목록을 담은 List<PensionVO>
     * @throws Exception
     */
    public List<PensionVO> listAllPensions() throws Exception;
}