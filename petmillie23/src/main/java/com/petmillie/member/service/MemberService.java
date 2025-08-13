package com.petmillie.member.service;

import com.petmillie.member.vo.MemberVO;
// 다른 import문이 있다면 그대로 두세요.

public interface MemberService {
	
	// 기존에 있던 다른 메서드들...
	public MemberVO login(String member_id, String member_pw) throws Exception;
	public void addMember(MemberVO memberVO) throws Exception;
	public int overlapped(String id) throws Exception;
	public String overlappedByEmail(String email1, String email2) throws Exception;
	public MemberVO findkakaoid(String kakao_id) throws Exception;
	public void removeMember(String member_id) throws Exception;
	
	// ▼▼▼▼▼ 이 부분이 반드시 추가되어야 합니다! ▼▼▼▼▼
	public String findId(MemberVO memberVO) throws Exception;
	// ▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲
	
}