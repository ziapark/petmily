package com.petmillie.board.service;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.servlet.ModelAndView;

import com.petmillie.board.vo.BoardVO;

public interface BoardService {

	Map<String, Object> getBoardList(HttpServletRequest request);
    void writeBoard(BoardVO boardVO);
    void updateBoard(BoardVO boardVO);
    void deleteBoard(int num);
    BoardVO getBoardView(int num);
    
}
