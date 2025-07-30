package com.petmillie.board.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.petmillie.board.service.BoardService;
import com.petmillie.board.vo.BoardVO;

@Controller("boardController")
@RequestMapping(value="/board")
public class BoardControllerImpl implements BoardController{
	
	@Autowired
    private BoardService boardService;

	@RequestMapping("/boardList.do")
	public ModelAndView boardList(HttpServletRequest request) {
	    String viewName = (String) request.getAttribute("viewName");
	    ModelAndView mav = new ModelAndView("/common/layout");

	    Map<String, Object> result = boardService.getBoardList(request);
	    
	    mav.addObject("body", "/WEB-INF/views" + viewName + ".jsp");
	    mav.addObject("boardList", result.get("boardList"));
	    mav.addObject("total_record", result.get("total_record"));
	    mav.addObject("pageNum", result.get("pageNum"));
	    mav.addObject("total_page", result.get("total_page"));

	    return mav;
	}

	@RequestMapping("/view.do")
	public ModelAndView boardView(HttpServletRequest request) {
	    String viewName = (String) request.getAttribute("viewName");
	    int num = Integer.parseInt(request.getParameter("num"));

	    BoardVO vo = boardService.getBoardView(num);
	    System.out.println("vo: " + vo);
	    ModelAndView mav = new ModelAndView("/common/layout");
	    mav.addObject("body", "/WEB-INF/views" + viewName + ".jsp");
	    mav.addObject("vo", vo);
	    mav.addObject("page", request.getParameter("page"));

	    return mav;
	}

	@RequestMapping("/writeForm.do")
	public ModelAndView writeForm(HttpServletRequest request) {
		String viewName = (String) request.getAttribute("viewName");
		ModelAndView mav = new ModelAndView("/common/layout");
		mav.addObject("body", "/WEB-INF/views" + viewName + ".jsp");
	    return mav;
	}

	
	@RequestMapping("/write.do")
	public ModelAndView write(HttpServletRequest request) {
		
	    String memberId = request.getParameter("id");
	    
	    String subject = request.getParameter("subject");
	    String content = request.getParameter("content");
	    
	    // 예외처리 (로그인 안 한 사용자일 경우)
	    if (memberId == null) {
	        return new ModelAndView("redirect:/member/loginForm.do");
	    }
	    
	    BoardVO board = new BoardVO();
	    board.setMember_id(memberId);
	    board.setSubject(subject);
	    board.setContent(content);

	    boardService.writeBoard(board);
	    return new ModelAndView("redirect:/board/boardList.do");
	}
	@RequestMapping("/updateForm.do")
	public ModelAndView updateForm(HttpServletRequest request) {
		
		int comu_id = Integer.parseInt(request.getParameter("num"));

	    BoardVO board = boardService.getBoardView(comu_id); // ← 이 메소드 네가 DAO에서 정의해놔야 해

	    String viewName = (String) request.getAttribute("viewName");
	    ModelAndView mav = new ModelAndView("/common/layout");

	    mav.addObject("vo", board); // 수정할 글 정보
	    mav.addObject("body", "/WEB-INF/views" + viewName + ".jsp");
	    return mav;
	}
	@RequestMapping("/update.do")
	public ModelAndView update(@ModelAttribute BoardVO boardVO) {
	    boardService.updateBoard(boardVO);
	    return new ModelAndView("redirect:/board/boardList.do");
	}

	@RequestMapping("/delete.do")
	public ModelAndView delete(HttpServletRequest request) {
		int num = Integer.parseInt(request.getParameter("num"));
	    boardService.deleteBoard(num);
	    return new ModelAndView("redirect:/board/boardList.do");
	}

	
}
