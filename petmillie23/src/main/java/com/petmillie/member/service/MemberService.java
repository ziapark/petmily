package com.petmillie.member.service;

import java.util.Map;

import com.petmillie.member.vo.MemberVO;

public interface MemberService {
	public MemberVO login(Map  loginMap) throws Exception;
	public void addMember(MemberVO memberVO) throws Exception;
	public int overlapped(String id) throws Exception;
	public int removeMember(String id)throws Exception;
	public MemberVO findkakaoid(String kakaoid)throws Exception;
}
