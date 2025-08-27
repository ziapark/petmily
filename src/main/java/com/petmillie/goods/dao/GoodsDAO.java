package com.petmillie.goods.dao;

import java.util.List;

import org.springframework.dao.DataAccessException;

import com.petmillie.goods.vo.GoodsVO;
import com.petmillie.goods.vo.ImageFileVO;
import com.petmillie.mypage.vo.GoodsReviewVO;

public interface GoodsDAO {
	public List<GoodsVO> goodsListByCategory(String goods_category) throws DataAccessException;
	public GoodsVO goodsDetail(int goods_num) throws DataAccessException;
	public List<ImageFileVO> goodsDetailImage(int goods_num) throws DataAccessException;
	
	public List<GoodsVO> selectAllGoodsList() throws DataAccessException;
	public List<GoodsVO> selectGoodsList(String goodsStatus ) throws DataAccessException;
	public List<String> selectKeywordSearch(String keyword) throws DataAccessException;	
	public List<ImageFileVO> selectGoodsDetailImage(int goods_num) throws DataAccessException;
	public List<GoodsVO> selectGoodsBySearchWord(String searchWord) throws DataAccessException;   
    public List<GoodsVO> selectGoodsByRecommendation(String weatherKeyword) throws DataAccessException;
    public List<GoodsReviewVO> goodsReview(int goods_num) throws DataAccessException;
    
    public List<GoodsVO> getGoodsListByOrder(int order_num) throws DataAccessException;
}
