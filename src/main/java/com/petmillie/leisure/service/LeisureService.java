package com.petmillie.leisure.service;

import java.util.List;
import java.util.Map;

import com.petmillie.leisure.vo.LeisureVO;

public interface LeisureService {
	 List<LeisureVO> searchLeisure(Map<String, Object> paramMap) ;
	
}
