package com.petmillie.business.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.petmillie.business.dao.BusinessDAO;
import com.petmillie.business.vo.BusinessVO;
import com.petmillie.business.vo.PensionVO;
import com.petmillie.business.vo.RoomVO;

@Service("businessService")
public class BusinessServiceImpl implements BusinessService {
	@Autowired
	private BusinessDAO businessDAO;

	@Override
	public void addSeller(BusinessVO businessVO) throws Exception {
		 businessDAO.addSeller(businessVO);
	}
	
	@Override
	public int overlapped(String id) throws Exception{
		return businessDAO.selectOverlappedID(id);
	}

	@Override
	public BusinessVO login(Map loginMap) throws Exception {
		return businessDAO.login(loginMap);
	}

	@Override
	public BusinessVO mypension(String business_number) throws Exception {
		return businessDAO.mypension(business_number);
	}

	@Override
	public BusinessVO businessDetailInfo(String business_number) throws Exception {
		return businessDAO.businessDetailInfo(business_number);
	}

	@Override
	public BusinessVO modifyInfo(Map businessMap) throws Exception {
		 String business_number=(String)businessMap.get("business_number");
		 businessDAO.modifyInfo(businessMap);
		return businessDAO.businessDetailInfo(business_number);
	}

	@Override
	public void addpension(PensionVO pensionVO) throws Exception {
		businessDAO.addpension(pensionVO);
	}

	@Override
	public void addpension2(RoomVO roomVO) throws Exception {
		businessDAO.addpension2(roomVO);		
	}

	@Override
	public PensionVO pension(String business_id) throws Exception {
		return 	businessDAO.pensionList(business_id);

	}

	@Override
	public List roomList(String p_num) {
		List<RoomVO> list = businessDAO.roomList(p_num);
		return list;
	}

	@Override
	public RoomVO modifyroom(Map roomMap) throws Exception {
		String room_id = (String) roomMap.get("room_id");
		businessDAO.modifyroom(roomMap);
		return businessDAO.roomDetailInfo(room_id);
	}

	@Override
	public RoomVO roomDetailInfo(String room_id) throws Exception {
		return businessDAO.roomDetailInfo(room_id);
	}

	@Override
	public int removeroom(int room_id) throws Exception {
		return businessDAO.removeroom(room_id);
		
	}

	@Override
	public int updatepension(PensionVO pensionVO) throws Exception {
		return businessDAO.updatepension(pensionVO);
	}

	@Override
	public int removepension(int id) throws Exception {
		return businessDAO.removepension(id);
	}
}
