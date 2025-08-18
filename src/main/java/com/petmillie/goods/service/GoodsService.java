package com.petmillie.goods.service;

import java.util.List;
import java.util.Map;

import com.petmillie.goods.vo.GoodsVO;
import com.petmillie.goods.vo.ImageFileVO;

public interface GoodsService {
	public List<GoodsVO> goodsListByCategory(String goods_category) throws Exception;
	public GoodsVO goodsDetail(int goods_num) throws Exception;
	public List<ImageFileVO> goodsDetailImage(int goods_num) throws Exception;
	
	public List<GoodsVO> listAllGoods() throws Exception; 
	public Map<String,List<GoodsVO>> listGoods() throws Exception;	
	public List<String> keywordSearch(String keyword) throws Exception;
	public List<GoodsVO> searchGoods(String searchWord) throws Exception;
}
