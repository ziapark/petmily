package com.petmillie.business.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.petmillie.business.vo.BusinessVO;
import com.petmillie.business.vo.PensionVO;
import com.petmillie.business.vo.RoomVO;

public interface BusinessController {
	public ResponseEntity addSeller(@ModelAttribute("BusinessVO") BusinessVO businessVO, HttpServletRequest request, HttpServletResponse response) throws Exception;
	public String overlapped(@RequestParam("id") String id,HttpServletRequest request, HttpServletResponse response) throws Exception;
	public ModelAndView login(@RequestParam Map<String, String> loginMap, HttpServletRequest request, HttpServletResponse response) throws Exception;
	public ModelAndView myPageMain(@RequestParam(required = false,value="message")  String message, String p_num, HttpServletRequest request, HttpServletResponse response)  throws Exception;
	public ModelAndView businessDetailInfo(HttpServletRequest request, HttpServletResponse response)  throws Exception;	
	public ResponseEntity modifyMyInfo(@RequestParam("attribute")  String attribute,@RequestParam("value")  String value, HttpServletRequest request, HttpServletResponse response)  throws Exception;
	public ResponseEntity addpension(@ModelAttribute("PensionVO") PensionVO pensionVO, HttpServletRequest request, HttpServletResponse response) throws Exception;
	public String addpension2(@ModelAttribute("RoomVO") RoomVO roomVO, HttpServletRequest request, HttpServletResponse response, Model model, RedirectAttributes redirectAttributes) throws Exception;
	public ModelAndView pensiondetailInfo(String p_num, HttpServletRequest request, HttpServletRequest response) throws Exception;
	public ModelAndView modifypension(HttpServletRequest request, HttpServletResponse response) throws Exception;
	public ModelAndView roomdetailInfo(String room_id, HttpServletRequest request, HttpServletResponse response) throws Exception;
	public ResponseEntity modifyroom(String attribute, String value, HttpServletRequest request, HttpServletResponse response) throws Exception;
	public String removepension(String p_num, HttpServletRequest request, HttpServletResponse response) throws Exception;
	public String removeroom(@RequestParam String room_id, HttpServletRequest request, HttpServletResponse response) throws Exception;
}