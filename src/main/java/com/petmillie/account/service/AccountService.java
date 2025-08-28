package com.petmillie.account.service;

import java.util.List;
import java.util.Map;

import com.petmillie.account.vo.AccountVO;

public interface AccountService {
    public List<AccountVO> getStoreRanking(Map<String, String> dateMap) throws Exception;
    public void updateCommissionRate(Map<String, Object> commissionMap) throws Exception;
    public Map<String, Object> getStoreAccountDetail(Map<String, String> dateMap) throws Exception;
}
