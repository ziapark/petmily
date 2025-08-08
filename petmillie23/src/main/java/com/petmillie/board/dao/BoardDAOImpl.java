package com.petmillie.board.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

import com.petmillie.board.vo.BoardVO;
import com.petmillie.board.vo.CommentVO;
import com.petmillie.board.vo.LikeVO;

@Repository("BoardDAO")
public class BoardDAOImpl implements BoardDAO {
    @Autowired
    private SqlSession sqlSession;

    @Autowired
    private BoardVO baordVO;

    
    private static final String NAMESPACE = "mapper.board";
    
    
	
    @Override 
    public List<BoardVO> selectBoardList(Map<String, Object> paramMap){ 
		System.out.println("selectBoardList 호출 - " + paramMap); 
		return sqlSession.selectList("mapper.board.selectBoardList", paramMap); 
	}
  
	@Override 
	public int getTotalCount(Map<String, Object> paramMap) { 	  
		return sqlSession.selectOne("mapper.board.getTotalCount", paramMap); 
	}
 
   
    
    public void insertBoard(BoardVO board) {
       
        sqlSession.insert("mapper.board.insertBoard", board); 
    }
    
    public BoardVO getBoardByNum(int num) {
    	 return sqlSession.selectOne("mapper.board.getBoardByNum", num);
    
    };
    public void updateViews(int comu_id) {
    	sqlSession.update("mapper.board.updateViews", comu_id);
    };
    public void updateBoard(BoardVO board) {
    	sqlSession.update("mapper.board.updateBoard", board); 
    	
    	
    };
    public void deleteBoard(int num) {
    	sqlSession.delete("mapper.board.deleteBoard", num); 
    };
    
    public void insertComment(CommentVO vo) {
    	sqlSession.insert("mapper.board.insertComment",vo);
    };
    
    public List<CommentVO> selectComment(int comu_id) {
    	
    	List<CommentVO> vo1 = sqlSession.selectList("mapper.board.selectComment",comu_id);
    	
    	return vo1;
    }

	@Override
	public void deleteComment(int comment_id) throws DataAccessException {
		System.out.println("dao 진입 , comment_id :" +comment_id);
		sqlSession.delete("mapper.board.deleteComment", comment_id);
		
	}

	@Override
	public String getWriterId(String session_id) {
		String writer_id = sqlSession.selectOne("mapper.board.getWriterId", session_id); 
		return writer_id;
	}

	@Override
	public void updateComment(CommentVO commentVO) throws DataAccessException {
		sqlSession.update("mapper.board.updateComment", commentVO);
		
	}

	@Override
	public CommentVO selectCommentOne(int comment_id) throws DataAccessException {
		CommentVO vo = sqlSession.selectOne("mapper.board.selectCommentOne", comment_id);
		return vo;
	}


	@Override
	public LikeVO selectLike(String member_id, int comu_id) throws DataAccessException {
		LikeVO like = new LikeVO();
	    like.setMember_id(member_id);
	    like.setComu_id(comu_id);
		
	    LikeVO result= sqlSession.selectOne("mapper.board.selectLike", like);
	    return result;
	}


	@Override
	public int insertLike(String member_id, int comu_id) throws DataAccessException {

		LikeVO like = new LikeVO();
	    like.setMember_id(member_id);
	    like.setComu_id(comu_id);
	    
	    return sqlSession.insert("mapper.board.insertLike", like);
	
	}


	@Override
	public int deleteLike(String member_id, int comu_id) throws DataAccessException {
		LikeVO like = new LikeVO();
	    like.setMember_id(member_id);
	    like.setComu_id(comu_id);
	    
		return sqlSession.delete("mapper.board.deleteLike", like);
	}


	@Override
	public int countLikes(int comu_id) {
	    return sqlSession.selectOne("mapper.board.countLikes", comu_id);
	}

}