package com.petmillie.leisure.dao;

import java.util.List;
import java.util.Map;

import org.springframework.dao.DataAccessException;

import com.petmillie.leisure.vo.LeisureVO;

public interface LeisureDAO {
	 List<LeisureVO> searchLeisure(Map<String, Object> paramMap)  throws DataAccessException ;

}
