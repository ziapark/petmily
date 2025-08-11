package com.petmillie.goods.dao;

import java.util.List;

import org.springframework.dao.DataAccessException;

import com.petmillie.goods.vo.GoodsVO;
import com.petmillie.goods.vo.ImageFileVO;

public interface GoodsDAO {
	public List<GoodsVO> selectGoodsList(String goodsStatus ) throws DataAccessException;
	public List<String> selectKeywordSearch(String keyword) throws DataAccessException;
	public GoodsVO selectGoodsDetail(int goods_num) throws DataAccessException;
	public List<ImageFileVO> selectGoodsDetailImage(int goods_num) throws DataAccessException;
	public List<GoodsVO> selectGoodsBySearchWord(String searchWord) throws DataAccessException;
	// --- 추가해야 할 부분 시작 ---
    // 전체 상품 목록을 가져오는 메서드 추가
    public List<GoodsVO> selectAllGoodsList() throws DataAccessException;
    // --- 추가해야 할 부분 끝 ---
}
