package com.petmillie.account.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.petmillie.account.dao.AccountDAO;
import com.petmillie.account.vo.AccountVO;

@Service("accountService")
public class AccountServiceImpl implements AccountService{
    @Autowired
    private AccountDAO AccountDAO;

    @Override
    public List<AccountVO> getStoreRanking(Map<String, String> dateMap) throws Exception {
        return AccountDAO.selectStoreRanking(dateMap);
    }

    @Override
    public void updateCommissionRate(Map<String, Object> commissionMap) throws Exception {
    	AccountDAO.updateCommissionRate(commissionMap);
    }
    
    @Override
    public Map<String, Object> getStoreAccountDetail(Map<String, String> dateMap) throws Exception {
        // 컨트롤러에 전달할 최종 결과물을 담을 Map을 생성합니다.
        Map<String, Object> result = new HashMap<>();
        
        String storeName = AccountDAO.selectStoreName(dateMap.get("sellerId"));
        Map<String, Object> summary = AccountDAO.selectStoreSummary(dateMap);
        List<Map<String, Object>> dailySalesList = AccountDAO.selectDailySales(dateMap);
        List<Map<String, Object>> transactionList = AccountDAO.selectTransactionList(dateMap);
        
        result.put("storeName", storeName);
        result.put("summary", summary);
        result.put("dailySalesList", dailySalesList);
        result.put("transactionList", transactionList);
        
        return result;
    }
}
