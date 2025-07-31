package com.petmillie.reservation.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.petmillie.reservation.dao.ReservaionDAO;
import com.petmillie.reservation.vo.ReservaionVO;

@Service("ReservaionService")
public class ReservaionServiceImpl implements ReservaionService { // ← implements 추가됨

    @Autowired
    private ReservaionDAO reservaionDAO;

}
