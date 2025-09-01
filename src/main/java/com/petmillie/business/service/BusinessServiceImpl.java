package com.petmillie.business.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.petmillie.admin.goods.dao.AdminGoodsDAO;
import com.petmillie.business.dao.BusinessDAO;
import com.petmillie.business.vo.BusinessVO;
import com.petmillie.business.vo.PensionVO;
import com.petmillie.business.vo.RoomVO;
import com.petmillie.business.vo.Room_image;
import com.petmillie.goods.vo.GoodsVO;
import com.petmillie.goods.vo.ImageFileVO;
import com.petmillie.order.vo.OrderVO;
import com.petmillie.reservation.dao.ReservaionDAO;
import com.petmillie.reservation.vo.ReservationVO;

@Service("businessService")
public class BusinessServiceImpl implements BusinessService {
	@Autowired
	private BusinessDAO businessDAO;
	@Autowired
	private ReservaionDAO reservaionDAO;
	@Autowired
	private AdminGoodsDAO adminGoodsDAO;
	
	@Override
	public void addSeller(BusinessVO businessVO) throws Exception {
		 businessDAO.addSeller(businessVO);
	}
	
	@Override
	public int overlapped(String id) throws Exception{
		return businessDAO.selectOverlappedID(id);
	}

	@Override
	public String isBusinessNumberDuplicate(String business_number) throws Exception{
		return businessDAO.isBusinessNumberDuplicate(business_number);
	}
	
	@Override
	public BusinessVO login(String seller_id, String seller_pw) throws Exception {
		return businessDAO.login(seller_id, seller_pw);
	}

	@Override
	public BusinessVO mypension(String business_id) throws Exception {
		return businessDAO.mypension(business_id);
	}

	@Override
	public BusinessVO businessDetailInfo(String business_number) throws Exception {
		return businessDAO.businessDetailInfo(business_number);
	}
	@Override
	public BusinessVO businessDetailInfo2(String seller_id) throws Exception {
		System.out.println("서비스진입. seller_id:" + seller_id);
		return businessDAO.businessDetailInfo2(seller_id);
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
	public List roomList(int p_num) {
		List<RoomVO> list = businessDAO.roomList(p_num);
		return list;
	}

	@Override
	public RoomVO modifyroom(Map roomMap) throws Exception {
		int room_id = (int) roomMap.get("room_id");
		businessDAO.modifyroom(roomMap);
		return businessDAO.roomDetailInfo(room_id);
	}

    @Override
    public void modifyRoomImage(Map<String, Object> imageFileMap) throws Exception {
        businessDAO.updateRoomImage(imageFileMap);
    }
    
	@Override
	public RoomVO roomDetailInfo(int room_id) throws Exception {
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

	@Override
	public List<ReservationVO> reservationList(String business_id) throws Exception {
		List<ReservationVO> list = businessDAO.reservationList(business_id);
		return list;
	}

	@Override
	public int removeMember(String seller_id) throws Exception {
		return businessDAO.removeMember(seller_id);
	}
	
	@Override
	public int addNewGoods(Map newGoodsMap) throws Exception{
		int goods_num = adminGoodsDAO.insertNewGoods(newGoodsMap);	//admin꺼 사용
		ArrayList<ImageFileVO> imageFileList = (ArrayList)newGoodsMap.get("imageFileList");
		for(ImageFileVO imageFileVO : imageFileList) {
			imageFileVO.setGoods_num(goods_num);
		}
		adminGoodsDAO.insertGoodsImageFile(imageFileList);
		return goods_num;
	}
	
	@Override
	public List<GoodsVO> listNewGoods(Map condMap) throws Exception{
		return businessDAO.selectNewGoodsList(condMap);
	}
	
	@Override
	public int checkOverlappedGoodsName(String goods_name) throws Exception {
	    return businessDAO.selectOverlappedGoodsName(goods_name);
	}
	
    @Override
    public int updateGoodsStatus(Map<String, Object> paramMap) throws Exception {
        return businessDAO.updateGoodsStatus(paramMap);
    }
    @Override
    public int restoreroom(int room_id) throws Exception {
        return businessDAO.restoreroom(room_id);
    }

	@Override
	public void updateApprovalStatus(String sellerId, String approvalStatus) throws Exception {
		businessDAO.updateApprovalStatus(sellerId, approvalStatus);
		System.out.println("service approvalStatus: "+approvalStatus);
		
	}
	
	public List<OrderVO> listNewOrder(Map condMap) throws Exception{
		return businessDAO.selectNewOrderList(condMap);
		
	}
	
	// [추가] 관리자가 모든 사업자 목록을 조회
	@Override
	public List<BusinessVO> getAllBusinesses() throws Exception {
	    return businessDAO.selectAllBusinesses();
	}
	@Override
	public List<PensionVO> getAllPensionsWithBusinessInfo() throws Exception {
	    return businessDAO.selectAllPensionsWithBusinessInfo();
	}

	// [추가] 관리자가 펜션의 승인 상태를 변경
	@Override
	public void updatePensionStatus(Map<String, Object> pensionMap) throws Exception {
	    businessDAO.updatePensionStatus(pensionMap);
	}

	@Override
	public int getGoodsCount(Map<String, Object> condMap) throws Exception {
	    return businessDAO.selectGoodsCount(condMap);
	}

	@Override
	public int getNewOrderCount(Map<String, Object> condMap) throws Exception {
	    return businessDAO.selectNewOrderCount(condMap);
	}
	
    @Override
    public int addNewRoomAndGetId(RoomVO roomVO) throws Exception {
        businessDAO.insertNewRoomAndGetId(roomVO);
        return roomVO.getRoom_id(); // Mapper에서 keyProperty로 설정한 필드에 ID가 담겨있습니다.
    }

    @Override
    public void addRoomImages(List<Room_image> imageFileList) throws Exception {
        businessDAO.insertRoomImages(imageFileList);
    }
}
