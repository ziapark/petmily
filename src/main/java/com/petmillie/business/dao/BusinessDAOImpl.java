package com.petmillie.business.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

import com.petmillie.business.vo.BusinessVO;
import com.petmillie.business.vo.PensionVO;
import com.petmillie.business.vo.RoomVO;
import com.petmillie.goods.vo.GoodsVO;
import com.petmillie.order.vo.OrderVO;
import com.petmillie.reservation.vo.ReservationVO;

@Repository("businessDAO")
public class BusinessDAOImpl implements BusinessDAO {
	@Autowired
	private SqlSession sqlSession;

	@Override
	public void addSeller(BusinessVO businessVO) throws DataAccessException {
		sqlSession.insert("mapper.business.insertNewBusinesspartner",businessVO);		
	}
	
	@Override
	public int selectOverlappedID(String id) throws DataAccessException {
		int result = sqlSession.selectOne("mapper.business.selectOverlappedID",id);
		return result;
	}

	@Override
	public String isBusinessNumberDuplicate(String business_number) throws DataAccessException{
		return sqlSession.selectOne("mapper.business.isBusinessNumberDuplicate", business_number);
	}
	
	@Override
	public BusinessVO login(String seller_id, String seller_pw) throws DataAccessException {
		BusinessVO businessVO = new BusinessVO(); 
		
		businessVO.setSeller_id(seller_id);
		businessVO.setSeller_pw(seller_pw);
		
		businessVO = (BusinessVO)sqlSession.selectOne("mapper.business.busilogin", businessVO);
		return businessVO;
	}

	@Override
	public BusinessVO mypension(String business_number) throws DataAccessException {
		BusinessVO mypension = (BusinessVO)sqlSession.selectOne("mapper.business.mypension", business_number);
		return mypension;
	}

	@Override
	public BusinessVO businessDetailInfo(String business_number) throws DataAccessException {	
		BusinessVO DetailInfo = (BusinessVO)sqlSession.selectOne("mapper.business.businessDetailInfo", business_number);
		return DetailInfo;
	}

	@Override
	public BusinessVO businessDetailInfo2(String seller_id) throws DataAccessException {
		System.out.println("DAO진입. seller_id:" + seller_id);
		BusinessVO DetailInfo = (BusinessVO)sqlSession.selectOne("mapper.business.businessDetailInfo2", seller_id);
		return DetailInfo;
	}
	@Override
	public void modifyInfo(Map businessMap) throws DataAccessException {
		sqlSession.update("mapper.business.updateMyInfo", businessMap);
		
	}

	@Override
	public void addpension(PensionVO pensionVO) throws DataAccessException {
		 sqlSession.insert("mapper.business.insertpension", pensionVO);
	}

	@Override
	public void addpension2(RoomVO roomVO) throws DataAccessException {
		 sqlSession.insert("mapper.business.insertroom", roomVO);
		
	}

	@Override
	public PensionVO pensionList(String business_id) throws DataAccessException {
		PensionVO pension = (PensionVO)sqlSession.selectOne("mapper.business.pension", business_id);
		return pension;
	}

	@Override
	public List<RoomVO> roomList(String p_num) {
		List<RoomVO> list = (List)sqlSession.selectList("mapper.business.selectroomList", p_num);
		return list;
	}

	@Override
	public void modifyroom(Map roomMap) throws DataAccessException {	
		sqlSession.update("mapper.business.updateMyroom", roomMap);
	}

	@Override
	public RoomVO roomDetailInfo(String room_id) throws DataAccessException {
		RoomVO DetailInfo = (RoomVO)sqlSession.selectOne("mapper.business.roomDetailInfo", room_id);
		return DetailInfo;
	}

	@Override
	public int removeroom(int room_id) throws DataAccessException {
		return sqlSession.delete("mapper.business.removeroom", room_id);
	}

	@Override
	public int updatepension(PensionVO pensionVO) throws DataAccessException {
		return sqlSession.update("mapper.business.updatepension", pensionVO);
	}

	@Override
	public int removepension(int id) throws DataAccessException {
		return sqlSession.update("mapper.business.removepension", id);
	}

    @Override
    public List<ReservationVO> reservationList(String business_id) throws DataAccessException {
        return sqlSession.selectList("mapper.adminReser.reservationList", business_id);
    }

	@Override
	public int removeMember(String seller_id) throws DataAccessException {
		int re = sqlSession.update("mapper.business.removebusiness", seller_id);
		return re ;
	}
	
	@Override
	public int selectOverlappedGoodsName(String goods_name) throws Exception {
	    return sqlSession.selectOne("mapper.business.selectOverlappedGoodsName", goods_name);
	}
	
	@Override
	public List<GoodsVO>selectNewGoodsList(Map condMap) throws DataAccessException {
		List<GoodsVO>  goodsList=sqlSession.selectList("mapper.business.selectNewGoodsList",condMap);
		return goodsList;
	}
	
    @Override
    public int updateGoodsStatus(Map<String, Object> paramMap) throws Exception {
        return sqlSession.update("mapper.business.updateGoodsStatus", paramMap);
    }
    
    @Override
    public void updateRoomStatus(Map<String, Object> roomMap) throws Exception {
        sqlSession.update("mapper.business.updateRoomStatus", roomMap);
    }
    @Override
    public int restoreroom(int room_id) throws Exception {
        return sqlSession.update("mapper.business.restoreroom", room_id);
    }

	@Override
	public void updateApprovalStatus(String sellerId, String approvalStatus) throws DataAccessException {
		sqlSession.update("mapper.business.updateApprovalStatus", Map.of(
		        "seller_id", sellerId,
		        "approval_status", approvalStatus
		    ));
		System.out.println("dao approvalStatus: "+approvalStatus);
	}
	
	public ArrayList<OrderVO>selectNewOrderList(Map condMap) throws DataAccessException{
		ArrayList<OrderVO> orderList=(ArrayList)sqlSession.selectList("mapper.business.selectNewOrderList",condMap);
		return orderList;
	}
	// [추가] 관리자가 모든 사업자 목록을 조회
	@Override
	public List<BusinessVO> selectAllBusinesses() throws Exception {
	    return sqlSession.selectList("mapper.business.selectAllBusinesses");
	}
	// [추가] 관리자가 모든 펜션 정보를 조회
	@Override
	public List<PensionVO> selectAllPensionsWithBusinessInfo() throws Exception {
	    return sqlSession.selectList("mapper.business.selectAllPensionsWithBusinessInfo");
	}

	// [추가] 관리자가 펜션의 승인 상태를 변경
	@Override
	public void updatePensionStatus(Map<String, Object> pensionMap) throws Exception {
	    sqlSession.update("mapper.business.updatePensionStatus", pensionMap);
	}

}