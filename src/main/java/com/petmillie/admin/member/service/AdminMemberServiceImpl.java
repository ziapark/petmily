package com.petmillie.admin.member.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.petmillie.admin.member.dao.AdminMemberDAO;
import com.petmillie.business.dao.BusinessDAO;
import com.petmillie.business.vo.BusinessVO;
import com.petmillie.member.vo.MemberVO;


@Service("adminMemberService")
@Transactional(propagation=Propagation.REQUIRED)
public class AdminMemberServiceImpl implements AdminMemberService {
	@Autowired
	private AdminMemberDAO adminMemberDAO;
	@Autowired
	private BusinessDAO businessDAO;
	
	public ArrayList<MemberVO> listMember(HashMap condMap) throws Exception{
		return adminMemberDAO.listMember(condMap);
	}
	
	// 모든 회원을 조회하기 위해 새로 추가한 메서드
	@Override
	public ArrayList<MemberVO> listAllMembers(HashMap condMap) throws Exception {
		return adminMemberDAO.listAllMembers(condMap);
	}

	public ArrayList<BusinessVO> listSellerMember(HashMap condMap) throws Exception{
		return adminMemberDAO.listSellerMember(condMap);
	}
	
	public MemberVO memberDetail(String member_id) throws Exception{
		 return adminMemberDAO.memberDetail(member_id);
	}
	
	public void modifyMemberInfo(HashMap memberMap) throws Exception{
		 String member_id=(String)memberMap.get("member_id");
		 adminMemberDAO.modifyMemberInfo(memberMap);
	}
}