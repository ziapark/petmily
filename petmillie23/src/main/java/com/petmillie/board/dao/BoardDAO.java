package com.petmillie.board.dao;

import java.util.List;

import com.petmillie.board.vo.BoardVO;

public interface BoardDAO {
	List<BoardVO> selectBoardList(int page, int limit, String items, String text);
    int getTotalCount(String items, String text);

    void insertBoard(BoardVO board);
    BoardVO getBoardByNum(int num);
    void updateHit(int num);
    void updateBoard(BoardVO board);
    void deleteBoard(int num);
}
