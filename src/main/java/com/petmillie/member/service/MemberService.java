package com.petmillie.member.service;

import com.petmillie.member.vo.MemberVO;

public interface MemberService {
	public MemberVO login(String member_id, String member_pw) throws Exception;
	public MemberVO findkakaoid(String kakaoid, String nickname) throws Exception;
	public void insertkakao(String kakaoid, String nickname) throws Exception;
	public void addMember(MemberVO memberVO) throws Exception;
	public int overlapped(String id) throws Exception;
	public String overlappedByEmail(String email1, String email2) throws Exception;
	public int removeMember(String id)throws Exception;
	public String findId(MemberVO memberVO) throws Exception;
	public String findPw(MemberVO memberVO) throws Exception;
}
