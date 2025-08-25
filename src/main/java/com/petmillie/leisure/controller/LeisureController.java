package com.petmillie.leisure.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.petmillie.leisure.service.LeisureService;
import com.petmillie.leisure.vo.LeisureVO;

@Controller("leisureController")
@RequestMapping("/leisure")
public class LeisureController {

    @Autowired
    private LeisureService leisureService;
    
    
    // 기존 JSP 레이아웃 호출
    @RequestMapping("/leisure.do")
    public ModelAndView hptAndPms(HttpServletRequest request) {
        String viewName = (String) request.getAttribute("viewName");
        ModelAndView mav = new ModelAndView("/common/layout");
        mav.addObject("title", "펫밀리");
        mav.addObject("body", "/WEB-INF/views" + viewName + ".jsp");
        return mav;
    }
    
    // 검색 기능
    @RequestMapping("/search.do")
    public ModelAndView search(
            @RequestParam(required=false) String sido,
            @RequestParam(required=false) String gungu,
            @RequestParam(required=false) String keyword,
            HttpServletRequest request) {

        Map<String, Object> params = new HashMap<>();
        params.put("sido", sido);
        params.put("gungu", gungu);
        params.put("keyword", keyword);

        List<LeisureVO> leisureList = leisureService.searchLeisure(params);

        ModelAndView mav = new ModelAndView("/common/layout");
        mav.addObject("title", "문화시설 정보");
        mav.addObject("body", "/WEB-INF/views/leisure/leisure.jsp");
        mav.addObject("leisureList", leisureList); 

        return mav;
    }
}
