package com.petmillie.business.service;

import java.util.List;
import java.util.Map;

import com.petmillie.business.vo.BusinessVO;
import com.petmillie.business.vo.PensionVO;
import com.petmillie.business.vo.RoomVO;

public interface BusinessService {

	public void addSeller(BusinessVO businessVO) throws Exception;
	public int overlapped(String id) throws Exception;
	public BusinessVO login(Map loginMap) throws Exception;
	public BusinessVO mypension(String business_number) throws Exception;
	public BusinessVO businessDetailInfo(String business_number) throws Exception;
	public BusinessVO modifyInfo(Map businessMap) throws Exception;
	public void addpension(PensionVO pensionVO) throws Exception;
	public void addpension2(RoomVO roomVO) throws Exception;
	public PensionVO pension(String business_id)throws Exception;
	public List roomList(String p_num);
	public RoomVO modifyroom(Map roomMap)throws Exception;
	public RoomVO roomDetailInfo(String room_id) throws Exception;
	public int removeroom(int id) throws Exception;
	public int updatepension(PensionVO pensionVO) throws Exception;
	public int removepension(int id) throws Exception;
}
