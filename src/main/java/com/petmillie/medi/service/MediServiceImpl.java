package com.petmillie.medi.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.petmillie.medi.dao.MediDAO;
import com.petmillie.medi.vo.MediVO;

@Service("mediService")
public class MediServiceImpl implements MediService{

    @Autowired
    private MediDAO mediDAO;

    @Override
    public List<MediVO> searchAll(Map<String, Object> params) {
        System.out.println("서비스 진입, params = " + params);
        return mediDAO.searchAll(params);
    }

}
