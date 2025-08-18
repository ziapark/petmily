package com.petmillie.medi.dao;

import java.util.List;
import java.util.Map;
import com.petmillie.medi.vo.MediVO;

public interface MediDAO {
    List<MediVO> searchAll(Map<String,Object> params);
}