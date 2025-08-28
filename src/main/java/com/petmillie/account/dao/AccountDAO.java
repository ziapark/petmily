package com.petmillie.account.dao;

import java.util.List;
import java.util.Map;

import com.petmillie.account.vo.AccountVO;

public interface AccountDAO {
    public List<AccountVO> selectStoreRanking(Map<String, String> dateMap) throws Exception;
    public void updateCommissionRate(Map<String, Object> commissionMap) throws Exception;
    public String selectStoreName(String sellerId) throws Exception;
    public Map<String, Object> selectStoreSummary(Map<String, String> dateMap) throws Exception;
    public List<Map<String, Object>> selectDailySales(Map<String, String> dateMap) throws Exception;
    public List<Map<String, Object>> selectTransactionList(Map<String, String> dateMap) throws Exception;

}
