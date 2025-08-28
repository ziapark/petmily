package com.petmillie.account.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.petmillie.account.vo.AccountVO;

@Repository("accountDAO")
public class AccountDAOImpl implements AccountDAO{
    @Autowired
    private SqlSession sqlSession;

    @Override
    public List<AccountVO> selectStoreRanking(Map<String, String> dateMap) throws Exception {
        return sqlSession.selectList("mapper.account.selectStoreRanking", dateMap);
    }

    @Override
    public void updateCommissionRate(Map<String, Object> commissionMap) throws Exception {
        sqlSession.update("mapper.account.updateCommissionRate", commissionMap);
    }
    
    @Override
    public String selectStoreName(String sellerId) throws Exception {
        return sqlSession.selectOne("mapper.account.selectStoreName", sellerId);
    }

    @Override
    public Map<String, Object> selectStoreSummary(Map<String, String> dateMap) throws Exception {
        return sqlSession.selectOne("mapper.account.selectStoreSummary", dateMap);
    }

    @Override
    public List<Map<String, Object>> selectDailySales(Map<String, String> dateMap) throws Exception {
        return sqlSession.selectList("mapper.account.selectDailySales", dateMap);
    }

    @Override
    public List<Map<String, Object>> selectTransactionList(Map<String, String> dateMap) throws Exception {
        return sqlSession.selectList("mapper.account.selectTransactionList", dateMap);
    }
}
