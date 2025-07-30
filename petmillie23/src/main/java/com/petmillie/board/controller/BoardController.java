package com.petmillie.board.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.petmillie.board.vo.BoardVO;

public interface BoardController {
public ModelAndView boardList(HttpServletRequest request);
public ModelAndView boardView(HttpServletRequest request, HttpSession session);
public ModelAndView write(@ModelAttribute BoardVO boardVO, @RequestParam("uploadFile") MultipartFile file, HttpServletRequest request) throws Exception;
public ModelAndView update(@ModelAttribute BoardVO boardVO,  @RequestParam("uploadFile") MultipartFile file,@RequestParam("originalFileName") String originalFileName, HttpServletRequest request) throws Exception ;
public ModelAndView delete(HttpServletRequest request);
	
}