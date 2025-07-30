package com.petmillie.board.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.servlet.ModelAndView;

import com.petmillie.board.vo.BoardVO;

public interface BoardController {
	ModelAndView boardList(HttpServletRequest request);
	ModelAndView boardView(HttpServletRequest request);
	ModelAndView write(HttpServletRequest request);
	ModelAndView update(BoardVO boardVO);
	ModelAndView delete(HttpServletRequest request);
}