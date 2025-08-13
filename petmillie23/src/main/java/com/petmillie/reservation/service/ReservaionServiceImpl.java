package com.petmillie.reservation.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.petmillie.business.vo.PensionVO; // PensionVO를 사용하기 위해 import 추가
import com.petmillie.reservation.dao.ReservaionDAO;

@Service("ReservaionService")
public class ReservaionServiceImpl implements ReservaionService {

    @Autowired
    private ReservaionDAO reservaionDAO;

    // ReservationService 인터페이스의 메서드를 구현합니다.
    @Override
    public List<PensionVO> listAllPensions() throws Exception {
        // DAO를 호출하여 펜션 목록을 가져옵니다.
        return reservaionDAO.selectAllPensionList();
    }
}