package com.petmillie.goods.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.petmillie.goods.vo.GoodsVO;

public interface GoodsService {
	
	public Map<String,List<GoodsVO>> listGoods() throws Exception;
	public Map goodsDetail(int goods_num) throws Exception;
	
	public List<String> keywordSearch(String keyword) throws Exception;
	public List<GoodsVO> searchGoods(String searchWord) throws Exception;
	public List<GoodsVO> listAllGoods() throws Exception; 
	
}
