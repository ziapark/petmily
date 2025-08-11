package com.petmillie.member.dao;

import java.util.Map;

import org.springframework.dao.DataAccessException;

import com.petmillie.member.vo.MemberVO;

public interface MemberDAO {
	public MemberVO login(Map loginMap) throws DataAccessException;
	public void insertNewMember(MemberVO memberVO) throws DataAccessException;
	public int selectOverlappedID(String id) throws DataAccessException;
	public String overlappedByEmail(String email1, String email2) throws DataAccessException;
	public int removeMember(String id) throws DataAccessException;
	public MemberVO findkakaoid(String id) throws DataAccessException;
}
