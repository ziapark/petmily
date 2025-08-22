package com.petmillie.order.dao;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

import com.petmillie.member.vo.MemberVO;
import com.petmillie.order.vo.PayVO;

@Repository("payDAO")
public class PayDAOImpl implements PayDAO {
	@Autowired
	private SqlSession sqlSession;

	@Override
	public void insertPay(PayVO payVO) throws DataAccessException {
		sqlSession.insert("mapper.payment.insertNewPayment", payVO);
	}
	
	@Override
	public void deductionPoint(MemberVO memberVO) throws DataAccessException {
		sqlSession.update("mapper.payment.deductionPoint", memberVO);
	}
}
