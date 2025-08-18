package com.petmillie.medi.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.petmillie.medi.service.MediService;
import com.petmillie.medi.vo.MediVO;


@Controller("mediController")
@RequestMapping(value="/medi")
public class MediControllerImpl implements MediController {

    @Autowired 
    private MediService mediService;

    // 기존 JSP 레이아웃 호출
    @RequestMapping("/hptAndPms.do")
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

        List<MediVO> places = mediService.searchAll(params);

        ModelAndView mav = new ModelAndView("/common/layout");
        mav.addObject("title", "전국 동물병원/약국 정보");
        mav.addObject("body", "/WEB-INF/views/medi/hptAndPms.jsp");
        mav.addObject("places", places); // 검색 결과 전달

        return mav;
    }
}
