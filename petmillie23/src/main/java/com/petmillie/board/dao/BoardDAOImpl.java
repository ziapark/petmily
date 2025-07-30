package com.petmillie.board.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.petmillie.board.vo.BoardVO;

@Repository("BoardDAO")
public class BoardDAOImpl implements BoardDAO {
    @Autowired
    private SqlSession sqlSession;

    @Autowired
    private BoardVO baordVO;

    
    private static final String NAMESPACE = "mapper.board";

    @Override
    public List<BoardVO> selectBoardList(int page, int limit, String items, String text) {
        int start = (page - 1) * limit;

        Map<String, Object> params = new HashMap<>();
        params.put("start", start);
        params.put("limit", limit);
        params.put("items", items);
        params.put("text", "%" + text + "%");

        return sqlSession.selectList(NAMESPACE + ".selectBoardList", params);
    }

    @Override
    public int getTotalCount(String items, String text) {
        Map<String, Object> params = new HashMap<>();
        params.put("items", items);
        params.put("text", "%" + text + "%");

        return sqlSession.selectOne(NAMESPACE + ".getTotalCount", params);
    }

    
    public void insertBoard(BoardVO board) {
       
        sqlSession.insert("mapper.board.insertBoard", board); 
    }
    
    public BoardVO getBoardByNum(int num) {
    	 return sqlSession.selectOne("mapper.board.getBoardByNum", num);
    
    };
    public void updateHit(int num) {
    	
    };
    public void updateBoard(BoardVO board) {
    	sqlSession.update("mapper.board.updateBoard", board); 
    	
    	
    };
    public void deleteBoard(int num) {
    	sqlSession.delete("mapper.board.deleteBoard", num); 
    };
    
    
}