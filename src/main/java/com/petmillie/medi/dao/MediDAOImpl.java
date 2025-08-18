package com.petmillie.medi.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.petmillie.medi.service.MediService;
import com.petmillie.medi.vo.MediVO;

@Repository("mediDAO")
public class MediDAOImpl implements MediDAO {

  @Autowired
    private SqlSessionTemplate sqlSession;
  @Autowired
  private MediService mediService;
    private static final String namespace = "mapper.medi";

	    @Override
	    public List<MediVO> searchAll(Map<String, Object> params) {
	    	System.out.println("mediService = " + mediService);
	    	System.out.println("params = " + params);
	    	List<MediVO> places = sqlSession.selectList("mapper.medi.searchAll", params);
	    	System.out.println("places = " + places);
	      
	        return sqlSession.selectList("mapper.medi.searchAll", params);
	    }

}
