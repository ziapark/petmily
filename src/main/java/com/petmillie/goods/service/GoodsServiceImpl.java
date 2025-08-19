package com.petmillie.goods.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.petmillie.goods.dao.GoodsDAO;
import com.petmillie.goods.vo.GoodsVO;
import com.petmillie.goods.vo.ImageFileVO;
import com.petmillie.mypage.vo.GoodsReviewVO;

@Service("goodsService")
@Transactional(propagation=Propagation.REQUIRED)
public class GoodsServiceImpl implements GoodsService{
	@Autowired
	private GoodsDAO goodsDAO;
	
    @Override
    public List<GoodsVO> goodsListByCategory(String goods_category) throws Exception {
        return goodsDAO.goodsListByCategory(goods_category);
    }
    
    @Override
	public GoodsVO goodsDetail(int goods_num) throws Exception {
		return goodsDAO.goodsDetail(goods_num);
	}	
    
    @Override
	public List<ImageFileVO> goodsDetailImage(int goods_num) throws Exception {
		return goodsDAO.goodsDetailImage(goods_num);
	}
    
    @Override
    public List<GoodsVO> listAllGoods() throws Exception {
        return goodsDAO.selectAllGoodsList();
    }
    
	public Map<String,List<GoodsVO>> listGoods() throws Exception {
		//bookshop 베스트 스터디 메인에 출력시 필요
		Map<String,List<GoodsVO>> goodsMap=new HashMap<String,List<GoodsVO>>();
		List<GoodsVO> goodsList=goodsDAO.selectGoodsList("bestseller");
		goodsMap.put("bestseller",goodsList);
		goodsList=goodsDAO.selectGoodsList("newbook");
		goodsMap.put("newbook",goodsList);
		
		goodsList=goodsDAO.selectGoodsList("steadyseller");
		goodsMap.put("steadyseller",goodsList);
		return goodsMap;
	}
	
	public List<String> keywordSearch(String keyword) throws Exception {
		List<String> list=goodsDAO.selectKeywordSearch(keyword);
		return list;
	}
	
	@Override
	public List<GoodsVO> searchGoods(String searchWord) throws Exception{
		List goodsList=goodsDAO.selectGoodsBySearchWord(searchWord);
		return goodsList;
	}
	
	@Override
	public List<GoodsReviewVO> goodsReview(int goods_num) throws Exception{
		return goodsDAO.goodsReview(goods_num);
	}
	
}
