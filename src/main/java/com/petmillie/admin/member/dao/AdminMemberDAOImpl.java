package com.petmillie.admin.member.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

import com.petmillie.business.vo.BusinessVO;
import com.petmillie.member.vo.MemberVO;

@Repository("adminMemberDao")
public class AdminMemberDAOImpl implements AdminMemberDAO {
	@Autowired
	private SqlSession sqlSession;
	
	
	// 기존 페이지네이션용 메서드 (그대로 둡니다)
	public ArrayList<MemberVO> listMember(HashMap condMap) throws DataAccessException {
		ArrayList<MemberVO> memberList = (ArrayList)sqlSession.selectList("mapper.admin.member.listMember", condMap);
		return memberList;
	}

	// 모든 회원을 조회하기 위해 새로 추가한 메서드
	public ArrayList<MemberVO> listAllMembers(HashMap condMap) throws DataAccessException {
		// 새로운 Mapper ID를 호출합니다.
		ArrayList<MemberVO> memberList = (ArrayList)sqlSession.selectList("mapper.admin.member.listAllMembers", condMap);
		return memberList;
	}
	
	@Override
	public ArrayList<BusinessVO> listSellerMember(HashMap condMap) throws DataAccessException {
		ArrayList<BusinessVO> sellerMemberList = (ArrayList)sqlSession.selectList("mapper.admin.member.listSellerMember", condMap);
		return sellerMemberList;
	}
	
	public MemberVO memberDetail(String member_id) throws DataAccessException {
		MemberVO memberBean = (MemberVO)sqlSession.selectOne("mapper.admin.member.memberDetail", member_id);
		return memberBean;
	}
	
	public void modifyMemberInfo(HashMap memberMap) throws DataAccessException {
		sqlSession.update("mapper.admin.member.modifyMemberInfo", memberMap);
	}
}