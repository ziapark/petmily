package com.petmillie.admin.goods.service;

import java.util.List;
import java.util.Map;

import com.petmillie.goods.vo.GoodsVO;
import com.petmillie.goods.vo.ImageFileVO;
import com.petmillie.order.vo.OrderVO;

public interface AdminGoodsService {
	public int addNewGoods(Map newGoodsMap) throws Exception;
	public List<GoodsVO> listNewGoods(Map condMap) throws Exception;
	public GoodsVO goodsDetail(int goods_id) throws Exception;
	public List goodsDetailImage(int goods_num) throws Exception;
	public void modifyGoods(Map goodsMap) throws Exception;
	public void modifyGoodsImage(List<ImageFileVO> imageFileList) throws Exception;
	public List<OrderVO> listOrderGoods(Map condMap) throws Exception;
	public void modifyOrderGoods(Map orderMap) throws Exception;
	public void removeGoodsImage(int image_id) throws Exception;
	public void addNewGoodsImage(List imageFileList) throws Exception;
    public int removeGoods(int goods_num) throws Exception;
    public void restoreGoods(int goods_num) throws Exception;
    public int updateGoodsStatus(GoodsVO goodsVO) throws Exception;
	public List<ImageFileVO> listGoodsImages(int goods_num) throws Exception;

	
	    
	    // 조건에 맞는 전체 상품 개수를 가져오는 메소드
	    public int countNewGoods(Map<String,Object> condMap) throws Exception;


}