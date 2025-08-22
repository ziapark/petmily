package com.petmillie.business.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.dao.DataAccessException;

import com.petmillie.business.vo.BusinessVO;
import com.petmillie.business.vo.PensionVO;
import com.petmillie.business.vo.RoomVO;
import com.petmillie.goods.vo.GoodsVO;
import com.petmillie.order.vo.OrderVO;
import com.petmillie.reservation.vo.ReservationVO;

public interface BusinessDAO {

	public void addSeller(BusinessVO businessVO) throws DataAccessException;
	public int selectOverlappedID(String id) throws DataAccessException;
	public String isBusinessNumberDuplicate(String business_number) throws DataAccessException;
	public BusinessVO login(String seller_id, String seller_pw) throws DataAccessException;
	public BusinessVO mypension(String business_number) throws DataAccessException;
	
	public BusinessVO businessDetailInfo(String business_number)throws DataAccessException;
	public BusinessVO businessDetailInfo2(String seller_id) throws DataAccessException;
	
	public void modifyInfo(Map businessMap) throws DataAccessException;
	public void addpension(PensionVO pensionVO)throws DataAccessException;
	public void addpension2(RoomVO roomVO)throws DataAccessException;
	public PensionVO pensionList(String business_id)throws DataAccessException;
	public List<RoomVO> roomList(String p_num);
	public void modifyroom(Map roomMap)throws DataAccessException;
	public RoomVO roomDetailInfo(String room_id)throws DataAccessException;
	public int removeroom(int room_id) throws DataAccessException;
	public int updatepension(PensionVO pensionVO) throws DataAccessException;
	public int removepension(int id) throws DataAccessException;
    public List<ReservationVO> reservationList(String business_id) throws DataAccessException;
	public int removeMember(String seller_id) throws DataAccessException;
	public int selectOverlappedGoodsName(String goods_name) throws Exception;
	public List<GoodsVO>selectNewGoodsList(Map condMap) throws DataAccessException;
	public int updateGoodsStatus(Map<String, Object> paramMap) throws Exception;
	public void updateRoomStatus(Map<String, Object> roomMap) throws Exception;
	public int restoreroom(int room_id) throws Exception;
	public void updateApprovalStatus(String sellerId, String approvalStatus) throws DataAccessException;
	public ArrayList<OrderVO>selectNewOrderList(Map condMap) throws DataAccessException; 
}
