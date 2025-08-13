package com.petmillie.board.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.petmillie.board.dao.BoardDAO;
import com.petmillie.board.vo.BoardVO;
import com.petmillie.board.vo.CommentVO;
import com.petmillie.board.vo.LikeVO;
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
        int start = (page - 1) * limit; 
        String items = request.getParameter("items");
        if (items == null) items = "subject";

        String text = request.getParameter("text");
        if (text == null) text = "";

        String boardType = request.getParameter("board_type");
        if (boardType == null || boardType.equals("")) {
            boardType = "notice";
        }

        //  DAO에 넘길 파라미터들을 Map에 담음
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("page", page);
        paramMap.put("limit", limit);
        paramMap.put("items", items);
        paramMap.put("text", text);
        paramMap.put("board_type", boardType);
        paramMap.put("start", start);

        //  DAO 호출
        List<BoardVO> boardList = boardDAO.selectBoardList(paramMap);
        int totalRecord = boardDAO.getTotalCount(paramMap);
        int totalPage = (int) Math.ceil((double) totalRecord / limit);

        //  결과 담기
        Map<String, Object> result = new HashMap<>();
        result.put("boardList", boardList);
        result.put("total_record", totalRecord);
        result.put("pageNum", page);
        result.put("total_page", totalPage);

        return result;
    }

    @Override
    public BoardVO getBoardView(int comu_id) {
       // boardDAO.updateViews(comu_id);
        return boardDAO.getBoardByNum(comu_id);
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
        vo.setFile_name(boardVO.getFile_name());
        vo.setBoard_type(boardVO.getBoard_type());
        boardDAO.updateBoard(vo);
    }

    @Override
    public void deleteBoard(int num) {
        boardDAO.deleteBoard(num);
    }
    
    
    @Override
    public void addComment(String comment_content, String member_id, int comu_id) {
    	
    	CommentVO vo = new CommentVO();
    	vo.setMember_id(member_id);
    	vo.setComment_content(comment_content);
    	vo.setComu_id(comu_id);
		/* System.out.println(""); */
    	boardDAO.insertComment(vo);
    	
    }

	
	public List<CommentVO> selectComment(int comu_id) {
		
		List<CommentVO> vo = boardDAO.selectComment(comu_id);
		return vo;
	}

	@Override
	public void deleteComment(int comment_id) {
		
		boardDAO.deleteComment(comment_id);
	}

	@Override
	public String getWriterId(String session_id) {

		String writer_id = boardDAO.getWriterId(session_id);
		return writer_id;
	}

	@Override
	public void updateComment(CommentVO commentVO) {
		boardDAO.updateComment(commentVO);
		
	}

	@Override
	public CommentVO selectCommentOne(int comment_id) {
		CommentVO vo = boardDAO.selectCommentOne(comment_id);
		return vo;
	}

	@Override
	public boolean toggleLike(String member_id, int comu_id) {
	    LikeVO like = boardDAO.selectLike(member_id, comu_id);
	    int result = 0;
	    boolean likedNow = false;

	    if (like == null) {
	        
	        result = boardDAO.insertLike(member_id, comu_id);
	        likedNow = (result > 0); 
	    } else {
	        
	        result = boardDAO.deleteLike(member_id, comu_id);
	        likedNow = false; 
	    }

	    return likedNow;
	}
	@Override
	public boolean isLiked(String member_id, int comu_id) {
		
	    LikeVO like = boardDAO.selectLike(member_id, comu_id);
	    return like != null;
		
	}

	@Override
	public int countLikes(int comu_id) {
		  return boardDAO.countLikes(comu_id);
	}
    
}
