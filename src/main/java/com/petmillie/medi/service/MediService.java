package com.petmillie.medi.service;

import java.util.List;
import java.util.Map;

import com.petmillie.medi.vo.MediVO;

public interface MediService {
    List<MediVO> searchAll(Map<String,Object> params);

}