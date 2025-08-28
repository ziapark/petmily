package com.petmillie.goods.dao;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

import com.petmillie.goods.vo.GoodsVO;
import com.petmillie.goods.vo.ImageFileVO;
import com.petmillie.mypage.vo.GoodsReviewVO;

@Repository("goodsDAO")
public class GoodsDAOImpl implements GoodsDAO{
	@Autowired
	private SqlSession sqlSession;

    @Override
    public List<GoodsVO> goodsListByCategory(String goods_category) throws DataAccessException {
    	return sqlSession.selectList("mapper.goods.goodsListByCategory", goods_category); 
    }
    
	@Override
	public GoodsVO goodsDetail(int goods_num) throws DataAccessException{
		return sqlSession.selectOne("mapper.goods.goodsDetail", goods_num);
	}

	@Override
	public List<ImageFileVO> goodsDetailImage(int goods_num) throws DataAccessException{
		return sqlSession.selectList("mapper.goods.goodsDetailImage", goods_num);
	}
	
    @Override
    public List<GoodsVO> selectAllGoodsList() throws DataAccessException {
        List<GoodsVO> goodsList = sqlSession.selectList("mapper.goods.selectAllGoodsList");
        return goodsList;
    }
    
	@Override
	public List<GoodsVO> selectGoodsList(String goodsStatus ) throws DataAccessException {
		List<GoodsVO> goodsList=(ArrayList)sqlSession.selectList("mapper.goods.selectGoodsList",goodsStatus);
	   return goodsList;	
     
	}
	@Override
	public List<String> selectKeywordSearch(String keyword) throws DataAccessException {
	   List<String> list=(ArrayList)sqlSession.selectList("mapper.goods.selectKeywordSearch",keyword);
	   return list;
	}
	
	@Override
    public List<GoodsVO> selectGoodsBySearchWord(String searchWord) throws DataAccessException {
        return sqlSession.selectList("mapper.goods.selectGoodsBySearchWord", searchWord);
    }
		
	@Override
	public List<ImageFileVO> selectGoodsDetailImage(int goods_num) throws DataAccessException{
		List<ImageFileVO> imageList=(ArrayList)sqlSession.selectList("mapper.goods.selectGoodsDetailImage",goods_num);
		return imageList;
	}

    @Override
    public List<GoodsVO> selectGoodsByRecommendation(String weatherKeyword) throws DataAccessException{
    	return sqlSession.selectList("mapper.goods.selectGoodsByRecommendation", weatherKeyword);
    }
    
    @Override
    public List<GoodsReviewVO> goodsReview(int goods_num) throws DataAccessException{
    	return sqlSession.selectList("mapper.goods.goodsReview", goods_num);
    }

	@Override
	public List<GoodsVO> getGoodsListByOrder(int order_num) throws DataAccessException {
		System.out.println("주문한 상품리스트 DAO 진입: " + order_num);
		return sqlSession.selectList("mapper.goods.getGoodsListByOrder", order_num);
	}
}
