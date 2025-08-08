package com.petmillie.board.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.petmillie.board.vo.BoardVO;
import com.petmillie.board.vo.CommentVO;

public interface BoardService {

	Map<String, Object> getBoardList(HttpServletRequest request);
    void writeBoard(BoardVO boardVO);
    void updateBoard(BoardVO boardVO);
    void deleteBoard(int num);
    BoardVO getBoardView(int comu_id);
	void addComment(String comment_content, String member_id,int comu_id);
	List<CommentVO> selectComment(int comu_id);
	void deleteComment (int comment_id);
	String getWriterId(String session_id);
	void updateComment(CommentVO commentVO);
	CommentVO selectCommentOne(int comment_id);
	public boolean toggleLike(String memberId, int comu_id);
	public boolean isLiked(String member_id, int comu_id) ;
	int countLikes(int comu_id); 
}
