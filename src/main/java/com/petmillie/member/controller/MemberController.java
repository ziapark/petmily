package com.petmillie.member.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.petmillie.member.vo.MemberVO;

public interface MemberController {
	public ModelAndView login(@RequestParam("member_id") String member_id, @RequestParam("member_pw") String member_pw, HttpServletRequest request, HttpServletResponse response) throws Exception;
	public ModelAndView logout(HttpServletRequest request, HttpServletResponse response) throws Exception;
	public ResponseEntity  addMember(@ModelAttribute("member") MemberVO member, HttpServletRequest request, HttpServletResponse response) throws Exception;
	public String overlapped(@RequestParam("id") String id,HttpServletRequest request, HttpServletResponse response) throws Exception;
	public String sendAuthCode(@RequestParam("email1") String email1, @RequestParam("email2") String email2) throws Exception;
	public String kakaoLogin(@RequestParam("code") String code, HttpSession session) throws Exception;
	public String deleteMember(@RequestParam("member_id") String member_id, HttpSession session, RedirectAttributes redirectAttributes) throws Exception;
	public ModelAndView findId(@ModelAttribute("memberVO") MemberVO memberVO, HttpServletRequest request, HttpServletResponse response) throws Exception;
	public ModelAndView findPw(@ModelAttribute("memberVO") MemberVO memberVO, HttpServletRequest request, HttpServletResponse response) throws Exception;
}
