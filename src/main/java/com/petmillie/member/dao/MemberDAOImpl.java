package com.petmillie.member.dao;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

import com.petmillie.member.vo.MemberVO;

@Repository("memberDAO")
public class MemberDAOImpl  implements MemberDAO{
	@Autowired
	private SqlSession sqlSession;	
	@Autowired
	private MemberVO memberVO;
	
	@Override
	public MemberVO login(String member_id, String member_pw) throws DataAccessException{
		MemberVO memberVO = new MemberVO();
		memberVO.setMember_id(member_id);
		memberVO.setMember_pw(member_pw);
		
		memberVO = (MemberVO)sqlSession.selectOne("mapper.member.login",memberVO);
		return memberVO;
	}
	
	@Override
	public void insertNewMember(MemberVO memberVO) throws DataAccessException{
		sqlSession.insert("mapper.member.insertNewMember",memberVO);
	}

	@Override
	public int selectOverlappedID(String member_id) throws DataAccessException {
		int result =  sqlSession.selectOne("mapper.member.selectOverlappedID",member_id);
		return result;
	}

	@Override
	public String overlappedByEmail(String email1, String email2) throws DataAccessException{
		memberVO.setEmail1(email1);
		memberVO.setEmail2(email2);
		String result = sqlSession.selectOne("mapper.member.selectOverlappedEmail", memberVO);
		return result;
	}
	
	@Override
	public int removeMember(String id) throws DataAccessException {
		return sqlSession.delete("mapper.member.removeMember", id);
	}
	
	@Override
	public MemberVO findkakaoid(String id) throws DataAccessException{
		return sqlSession.selectOne("mapper.member.findkakaoid", id);
	}	
}
