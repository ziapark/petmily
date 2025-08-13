package com.petmillie.admin.goods.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.petmillie.admin.goods.dao.AdminGoodsDAO;
import com.petmillie.goods.vo.GoodsVO;
import com.petmillie.goods.vo.ImageFileVO;
import com.petmillie.order.vo.OrderVO;


@Service("adminGoodsService")
@Transactional(propagation=Propagation.REQUIRED)
public class AdminGoodsServiceImpl implements AdminGoodsService {
	@Autowired
	private AdminGoodsDAO adminGoodsDAO;
	
	@Override
	public int addNewGoods(Map newGoodsMap) throws Exception{
		int goods_num = adminGoodsDAO.insertNewGoods(newGoodsMap);
		ArrayList<ImageFileVO> imageFileList = (ArrayList)newGoodsMap.get("imageFileList");
		for(ImageFileVO imageFileVO : imageFileList) {
			imageFileVO.setGoods_num(goods_num);
		}
		adminGoodsDAO.insertGoodsImageFile(imageFileList);
		return goods_num;
	}
	
	@Override
	public List<GoodsVO> listNewGoods(Map condMap) throws Exception{
		return adminGoodsDAO.selectNewGoodsList(condMap);
	}
	@Override
	public Map goodsDetail(int goods_num) throws Exception {
		Map goodsMap = new HashMap();
		GoodsVO goodsVO=adminGoodsDAO.selectGoodsDetail(goods_num);
		List imageFileList =adminGoodsDAO.selectGoodsImageFileList(goods_num);
		goodsMap.put("goods", goodsVO);
		goodsMap.put("imageFileList", imageFileList);
		return goodsMap;
	}
	@Override
	public List goodsImageFile(int goods_num) throws Exception{
		List imageList =adminGoodsDAO.selectGoodsImageFileList(goods_num);
		return imageList;
	}
	
	@Override
	public void modifyGoods(Map goodsMap) throws Exception{
		adminGoodsDAO.modifyGoods(goodsMap);
		
	}	
	@Override
	public void modifyGoodsImage(List<ImageFileVO> imageFileList) throws Exception{
		adminGoodsDAO.updateGoodsImage(imageFileList); 
	}
	
	@Override
	public List<OrderVO> listOrderGoods(Map condMap) throws Exception{
		return adminGoodsDAO.selectOrderGoodsList(condMap);
	}
	@Override
	public void modifyOrderGoods(Map orderMap) throws Exception{
		adminGoodsDAO.updateOrderGoods(orderMap);
	}
	
	@Override
	public void removeGoodsImage(int image_id) throws Exception{
		adminGoodsDAO.deleteGoodsImage(image_id);
	}
	
	@Override
	public void addNewGoodsImage(List imageFileList) throws Exception{
		adminGoodsDAO.insertGoodsImageFile(imageFileList);
	}

	@Override
	public List<ImageFileVO> listGoodsImages(int goods_num) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	public int updateGoodsStatus(GoodsVO goodsVO) throws Exception{
		return adminGoodsDAO.updateGoodsStatus(goodsVO);
	}

	 
	@Override
	public int removeGoods(int goods_num) throws Exception {     
        Map<String, Object> goodsMap = new HashMap<>();
        goodsMap.put("goods_num", goods_num);
        goodsMap.put("del_yn", "Y"); // del_yn을 'Y'로 설정
        goodsMap.put("goods_status", "삭제");
        return adminGoodsDAO.updateGoodsDelYn(goodsMap); // DAO에 새로 추가될 메서드 호출
	}
	 
	@Override
    public void restoreGoods(int goods_num) throws Exception {
        // GOODS 테이블의 del_yn 컬럼 값을 'N'으로 업데이트 (복원)
        Map<String, Object> goodsMap = new HashMap<>();
        goodsMap.put("goods_num", goods_num);
        goodsMap.put("del_yn", "N"); // 'N'으로 설정하여 복원
        goodsMap.put("goods_status", "판매중");
        adminGoodsDAO.updateGoodsDelYn(goodsMap); // 기존 updateGoodsDelYn DAO 메서드 재활용
    }
	 
}