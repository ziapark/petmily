package com.petmillie.business.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.petmillie.business.vo.BusinessVO;
import com.petmillie.business.vo.PensionVO;
import com.petmillie.business.vo.RoomVO;

public interface BusinessController {
	public ResponseEntity addSeller(@ModelAttribute("BusinessVO") BusinessVO businessVO, HttpServletRequest request, HttpServletResponse response) throws Exception;
	public String overlapped(@RequestParam("id") String id,HttpServletRequest request, HttpServletResponse response) throws Exception;
	public ModelAndView login(@RequestParam("seller_id") String seller_id, @RequestParam("seller_pw") String seller_pw, HttpServletRequest request, HttpServletResponse response) throws Exception;
	public ModelAndView myPageMain(@RequestParam(value="business_id", required = false) String business_id,  HttpServletRequest request, HttpServletResponse response)  throws Exception;
	public ModelAndView businessDetailInfo(HttpServletRequest request, HttpServletResponse response)  throws Exception;	
	public ResponseEntity modifyMyInfo(@RequestParam("attribute")  String attribute,@RequestParam("value")  String value, HttpServletRequest request, HttpServletResponse response)  throws Exception;
	public ResponseEntity addpension(@ModelAttribute("pensionVO") PensionVO pensionVO, @RequestParam("mainImage") MultipartFile mainImage, HttpServletRequest request, HttpServletResponse response) throws Exception;
	public ModelAndView pensiondetailInfo(@RequestParam("p_num") int p_num, HttpServletRequest request, HttpServletRequest response) throws Exception;
	public ModelAndView modifypension(@ModelAttribute("pensionVO") PensionVO pensionVO,
            @RequestParam("mainImage") MultipartFile mainImage,
            @RequestParam("originalFileName") String originalFileName,
            HttpServletRequest request, HttpServletResponse response) throws Exception;
	public ModelAndView roomdetailInfo(int room_id, HttpServletRequest request, HttpServletResponse response) throws Exception;
	public ResponseEntity modifyroom(String attribute, String value, @RequestParam("room_id") String room_id, HttpServletRequest request, HttpServletResponse response) throws Exception;
	public String removepension(String p_num, HttpServletRequest request, HttpServletResponse response) throws Exception;
	public String removeroom(@RequestParam String room_id, HttpServletRequest request, HttpServletResponse response) throws Exception;
	public ResponseEntity addNewGoods(MultipartHttpServletRequest multipartRequest, HttpServletResponse response) throws Exception;
	public String restoreroom(@RequestParam("room_id") String room_id, HttpServletRequest request, HttpServletResponse response) throws Exception;
	public ModelAndView deleteForm(HttpServletRequest request, HttpServletResponse response) throws Exception;
	public String deleteMember (@RequestParam("seller_id") String seller_id, HttpSession session, RedirectAttributes redirectAttributes) throws Exception;
	public ModelAndView businessOrderMain(@RequestParam Map<String, String> dateMap, HttpServletRequest request, HttpServletResponse response) throws Exception;
	public String addpension2(RoomVO roomVO, 
			  @RequestParam(value="files", required = false) List<MultipartFile> files, 
            HttpServletRequest request, 
            HttpServletResponse response, 
            Model model, 
            RedirectAttributes redirectAttributes) throws Exception;
}