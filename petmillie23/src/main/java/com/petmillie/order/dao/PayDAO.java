package com.petmillie.order.dao;

import org.springframework.dao.DataAccessException;

import com.petmillie.order.vo.PayVO;

public interface PayDAO {
	public void insertPay(PayVO payVO) throws DataAccessException;


}
