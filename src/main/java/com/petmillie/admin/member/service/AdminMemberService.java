package com.petmillie.admin.member.service;

import java.util.ArrayList;
import java.util.HashMap;

import com.petmillie.business.vo.BusinessVO;
import com.petmillie.member.vo.MemberVO;

public interface AdminMemberService {
	public ArrayList<MemberVO> listMember(HashMap condMap) throws Exception;
	
	// 모든 회원을 조회하기 위한 메서드 선언을 추가합니다.
	public ArrayList<MemberVO> listAllMembers(HashMap condMap) throws Exception;
	
	public MemberVO memberDetail(String member_id) throws Exception;
	public void modifyMemberInfo(HashMap memberMap) throws Exception;
	public ArrayList<BusinessVO> listSellerMember(HashMap condMap) throws Exception;
}