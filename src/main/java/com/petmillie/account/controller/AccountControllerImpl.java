package com.petmillie.account.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.petmillie.account.service.AccountService;
import com.petmillie.account.vo.AccountVO;

@Controller("accountController")
@RequestMapping(value="/account")
public class AccountControllerImpl implements AccountController {
	@Autowired
	private AccountService accountService;
	
	@RequestMapping(value="/accountMain.do" ,method={RequestMethod.POST,RequestMethod.GET})
	public ModelAndView accountMain(@RequestParam(required = false) Map<String, String> dateMap, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String viewName=(String)request.getAttribute("viewName");
		ModelAndView mav=new ModelAndView("/common/layout");
		mav.addObject("title", "마이페이지");
		mav.addObject("body", "/WEB-INF/views" + viewName + ".jsp");

        List<AccountVO> storeRankingList = accountService.getStoreRanking(dateMap);
        
        mav.addObject("storeRankingList", storeRankingList);
		
		return mav;
	}
	
	// 수수료율 수정을 처리하는 메소드
    @RequestMapping(value="/updateCommission.do", method = RequestMethod.POST)
    public ResponseEntity<String> updateCommission(@RequestParam("seller_id") String seller_id,
                                                   @RequestParam("commission_rate") double commission_rate,
                                                   HttpServletRequest request, HttpServletResponse response) throws Exception {
        try {
            Map<String, Object> commissionMap = new HashMap<>();
            commissionMap.put("seller_id", seller_id);
            commissionMap.put("commission_rate", commission_rate);

            accountService.updateCommissionRate(commissionMap);
            
            return new ResponseEntity<>("success", HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>("failed", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    
    @RequestMapping(value="/accountDetail.do", method = {RequestMethod.GET, RequestMethod.POST})
    public ModelAndView detail(@RequestParam("seller_id") String seller_id,
                               @RequestParam(required = false) Map<String, String> dateMap,
                               HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        String viewName = (String)request.getAttribute("viewName");
        ModelAndView mav = new ModelAndView("/common/layout");
        mav.addObject("body", "/WEB-INF/views" + viewName + ".jsp");

        dateMap.put("seller_id", seller_id);

        Map<String, Object> accountDetailMap = accountService.getStoreAccountDetail(dateMap);
        
        mav.addObject("storeName", accountDetailMap.get("storeName"));
        mav.addObject("summary", accountDetailMap.get("summary"));
        mav.addObject("dailySalesList", accountDetailMap.get("dailySalesList"));
        mav.addObject("transactionList", accountDetailMap.get("transactionList"));
        
        return mav;
    }
}
