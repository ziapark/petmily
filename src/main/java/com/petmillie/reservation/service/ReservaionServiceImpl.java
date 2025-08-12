package com.petmillie.reservation.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.petmillie.business.vo.PensionVO;
import com.petmillie.reservation.dao.ReservaionDAO;

@Service("ReservaionService")
public class ReservaionServiceImpl implements ReservaionService {

    @Autowired
    private ReservaionDAO reservaionDAO;

    // 펜션 목록 조회
    @Override
    public List<PensionVO> listAllPensions() throws Exception {
        return reservaionDAO.selectAllPensionList();
    }
    
    // 펜션 상세 조회 (주소 포함)
    @Override
    public PensionVO getPensionDetail(String p_num) throws Exception {
        // DAO의 'selectPensionDetail' 메서드를 호출해서 주소 정보가 포함된 결과를 받습니다.
        return reservaionDAO.selectPensionDetail(p_num);
    }
}