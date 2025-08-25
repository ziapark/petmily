package com.petmillie.leisure.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

import com.petmillie.leisure.vo.LeisureVO;

@Repository("LeisureDAO")
public class LeisureDAOImpl implements LeisureDAO{

    @Autowired
    private SqlSession sqlSession;

    @Override
    public List<LeisureVO> searchLeisure(Map<String, Object> paramMap) throws DataAccessException {
        return sqlSession.selectList("mapper.leisure.searchLeisure", paramMap);
    }

}
