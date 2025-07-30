package com.petmillie.board.dao;

import java.util.List;

import org.springframework.dao.DataAccessException;

import com.petmillie.board.vo.BoardVO;
import com.petmillie.board.vo.CommentVO;
import com.petmillie.board.vo.LikeVO;

public interface BoardDAO {
	List<BoardVO> selectBoardList(int page, int limit, String items, String text);
    int getTotalCount(String items, String text);

    void insertBoard(BoardVO board) throws DataAccessException;
    BoardVO getBoardByNum(int num) throws DataAccessException;
    void updateViews(int num) throws DataAccessException;
    void updateBoard(BoardVO board) throws DataAccessException;
    void deleteBoard(int num) throws DataAccessException;
    void insertComment(CommentVO vo) throws DataAccessException;
    List<CommentVO> selectComment(int comu_id) throws DataAccessException;
    void deleteComment(int comment_id) throws DataAccessException;
    String getWriterId(String session_id) throws DataAccessException;
    void updateComment(CommentVO commentVO) throws DataAccessException;
    CommentVO selectCommentOne(int comment_id) throws DataAccessException;
    LikeVO selectLike(String member_id, int comu_id) throws DataAccessException;
    int insertLike(String member_id, int comu_id) throws DataAccessException;
    int deleteLike(String member_id, int comu_id) throws DataAccessException;
    int countLikes(int comu_id);
}
