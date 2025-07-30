package com.petmillie.board.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.ModelAttribute;

import com.petmillie.board.dao.BoardDAO;
import com.petmillie.board.vo.BoardVO;

@Service("boardService")
public class BoardServiceImpl implements BoardService {

    @Autowired
    private BoardDAO boardDAO;

    @Override
    public Map<String, Object> getBoardList(HttpServletRequest request) {
        int page = 1;
        int limit = 10;

        if (request.getParameter("pageNum") != null) {
            page = Integer.parseInt(request.getParameter("pageNum"));
        }

        String items = request.getParameter("items");
        if (items == null) items = "title";

        String text = request.getParameter("text");
        if (text == null) text = "";

        List<BoardVO> boardList = boardDAO.selectBoardList(page, limit, items, text);
        int totalRecord = boardDAO.getTotalCount(items, text);
        int totalPage = (int) Math.ceil((double) totalRecord / limit);

        Map<String, Object> result = new HashMap<>();
        result.put("boardList", boardList);
        result.put("total_record", totalRecord);
        result.put("pageNum", page);
        result.put("total_page", totalPage);
        return result;
    }

    @Override
    public BoardVO getBoardView(int num) {
        boardDAO.updateHit(num);
        return boardDAO.getBoardByNum(num);
    }

    @Override
    public void writeBoard(BoardVO boardVO) {
    	
    	 boardDAO.insertBoard(boardVO);
    }

    @Override
    public void updateBoard(BoardVO boardVO) {
    	BoardVO vo = new BoardVO();
        vo.setComu_id(boardVO.getComu_id());
        vo.setMember_id(boardVO.getMember_id());
        vo.setSubject(boardVO.getSubject());
        vo.setContent(boardVO.getContent());
        
        boardDAO.updateBoard(vo);
    }

    @Override
    public void deleteBoard(int num) {
        boardDAO.deleteBoard(num);
    }
}
