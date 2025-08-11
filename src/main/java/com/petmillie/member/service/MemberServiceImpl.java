package com.petmillie.member.service;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.petmillie.member.dao.MemberDAO;
import com.petmillie.member.vo.MemberVO;

@Service("memberService")
@Transactional(propagation=Propagation.REQUIRED)
public class MemberServiceImpl implements MemberService {
	@Autowired
	private MemberDAO memberDAO;
	
	@Override
	public MemberVO login(Map loginMap) throws Exception{
		return memberDAO.login(loginMap);
	}
	
	@Override
	public void addMember(MemberVO memberVO) throws Exception{
		memberDAO.insertNewMember(memberVO);
	}
	
	@Override
	public int overlapped(String id) throws Exception{
		return memberDAO.selectOverlappedID(id);
	}
	
	@Override
	public String overlappedByEmail(String email1, String email2) throws Exception{
		return memberDAO.overlappedByEmail(email1, email2);
	}
	
	@Override
	public int removeMember(String id) throws Exception {
		return memberDAO.removeMember(id);
	}

	@Override
	public MemberVO findkakaoid(String kakaoid) throws Exception {
		return memberDAO.findkakaoid(kakaoid);
	}
}
