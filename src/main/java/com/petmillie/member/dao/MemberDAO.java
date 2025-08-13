package com.petmillie.member.dao;

import org.springframework.dao.DataAccessException;

import com.petmillie.member.vo.MemberVO;

public interface MemberDAO {
	public MemberVO login(String member_id, String member_pw) throws DataAccessException;
	public void insertNewMember(MemberVO memberVO) throws DataAccessException;
	public int selectOverlappedID(String id) throws DataAccessException;
	public String overlappedByEmail(String email1, String email2) throws DataAccessException;
	public int removeMember(String id) throws DataAccessException;
	public MemberVO findkakaoid(String id) throws DataAccessException;
	public String findId(MemberVO memberVO) throws Exception;
	public String findPw(MemberVO memberVO) throws Exception;
}
