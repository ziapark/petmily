package com.petmillie.reservation.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.petmillie.business.vo.PensionVO;
import com.petmillie.reservation.dao.ReservaionDAO;

// [수정] @Service의 이름은 일반적으로 소문자로 시작합니다. (예: "reservationService")
@Service("reservationService") 
public class ReservaionServiceImpl implements ReservaionService {

    @Autowired
    private ReservaionDAO reservaionDAO;

    /**
     * 전체 펜션 목록을 조회
     */
    @Override
    public List<PensionVO> listAllPensions() throws Exception {
        // [수정] DAO의 'selectAllPensions()' 메서드를 호출하도록 변경했습니다.
        return reservaionDAO.selectAllPensions();
    }
    
    /**
     * 특정 펜션의 상세 정보를 조회
     */
    @Override
    public PensionVO getPensionDetail(int pensionId) throws Exception {
        return reservaionDAO.selectPensionById(pensionId);
    }
}