package com.petmillie.business.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

import com.petmillie.business.vo.BusinessVO;
import com.petmillie.business.vo.PensionVO;
import com.petmillie.business.vo.RoomVO;
import com.petmillie.reservation.vo.ReservaionVO;

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
    public List<ReservaionVO> reservationList(String business_id) throws DataAccessException {
        // XML 파일의 네임스페이스와 일치하도록 "mapper.reser"를 "mapper.adminReser"로 수정
        return sqlSession.selectList("mapper.adminReser.reservationList", business_id);
    }

	@Override
	public int removeMember(String business_number) throws DataAccessException {
		int re = sqlSession.update("mapper.business.removebusiness", business_number);
		return re ;
	}
}