package com.petmillie.leisure.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.petmillie.leisure.dao.LeisureDAO;
import com.petmillie.leisure.vo.LeisureVO;
@Service("LeisureService")
public class LeisureServiceImpl implements LeisureService{
	 @Autowired
	    private LeisureDAO leisureDAO;

	 @Override
	    public List<LeisureVO> searchLeisure(Map<String, Object> paramMap) {
	        return leisureDAO.searchLeisure(paramMap);
	    }

}
