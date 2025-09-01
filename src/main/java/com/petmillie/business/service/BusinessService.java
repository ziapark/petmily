package com.petmillie.business.service;

import java.util.List;
import java.util.Map;

import com.petmillie.business.vo.BusinessVO;
import com.petmillie.business.vo.PensionVO;
import com.petmillie.business.vo.RoomVO;
import com.petmillie.business.vo.Room_image;
import com.petmillie.goods.vo.GoodsVO;
import com.petmillie.order.vo.OrderVO;

public interface BusinessService {

	public void addSeller(BusinessVO businessVO) throws Exception;
	public int overlapped(String id) throws Exception;
	public String isBusinessNumberDuplicate(String business_number) throws Exception;
	public BusinessVO login(String seller_id, String seller_pw) throws Exception;
	public BusinessVO mypension(String business_number) throws Exception;
	public BusinessVO businessDetailInfo(String business_number) throws Exception;
	public BusinessVO businessDetailInfo2(String seller_id) throws Exception;
	public BusinessVO modifyInfo(Map businessMap) throws Exception;
	public void addpension(PensionVO pensionVO) throws Exception;
	public void addpension2(RoomVO roomVO) throws Exception;
	public PensionVO pension(String business_id)throws Exception;
	public List roomList(String p_num);
	public RoomVO modifyroom(Map roomMap)throws Exception;
	public RoomVO roomDetailInfo(int room_id) throws Exception;
	public int removeroom(int id) throws Exception;
	public int updatepension(PensionVO pensionVO) throws Exception;
	public int removepension(int id) throws Exception;
	public List reservationList(String business_id) throws Exception;
	public int removeMember(String seller_id)throws Exception;
	public int addNewGoods(Map newGoodsMap) throws Exception;
	public List<GoodsVO> listNewGoods(Map condMap) throws Exception;
	public int checkOverlappedGoodsName(String goods_name) throws Exception;
	public int updateGoodsStatus(Map<String, Object> paramMap) throws Exception;
	public int restoreroom(int room_id) throws Exception;
	public void updateApprovalStatus(String sellerId, String approvalStatus) throws Exception;
	public List<OrderVO> listNewOrder(Map condMap) throws Exception;
	public List<BusinessVO> getAllBusinesses() throws Exception;
	// [추가] 관리자가 모든 펜션 정보를 조회
	public List<PensionVO> getAllPensionsWithBusinessInfo() throws Exception;

	// [추가] 관리자가 펜션의 승인 상태를 변경
	public void updatePensionStatus(Map<String, Object> pensionMap) throws Exception;
	public void modifyRoomImage(Map<String, Object> imageFileMap) throws Exception;
	public int getGoodsCount(Map<String, Object> condMap) throws Exception;
	public int getNewOrderCount(Map<String, Object> condMap) throws Exception;
    public int addNewRoomAndGetId(RoomVO roomVO) throws Exception;
    public void addRoomImages(List<Room_image> imageFileList) throws Exception;

}
