package com.petmillie.admin.goods.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

import com.petmillie.goods.vo.GoodsVO;
import com.petmillie.goods.vo.ImageFileVO;
import com.petmillie.order.vo.OrderVO;

@Repository("adminGoodsDAO")
public class AdminGoodsDAOImpl  implements AdminGoodsDAO{
@Autowired
private SqlSession sqlSession;

@Override
public int insertNewGoods(Map newGoodsMap) throws DataAccessException {
sqlSession.insert("mapper.admin.goods.insertNewGoods", newGoodsMap);

Object goodsIdObj = newGoodsMap.get("goods_num");
if (goodsIdObj != null && !goodsIdObj.toString().isBlank()) {
return Integer.parseInt(goodsIdObj.toString());
} else {
throw new RuntimeException("goods_num가 null이거나 빈 문자열입니다. insertNewGoods 실패");
}
}

@Override
public void insertGoodsImageFile(List fileList)  throws DataAccessException {
for(int i=0; i<fileList.size();i++){
ImageFileVO imageFileVO=(ImageFileVO)fileList.get(i);
sqlSession.insert("mapper.admin.goods.insertGoodsImageFile",imageFileVO);
}
}

@Override
public List<GoodsVO>selectNewGoodsList(Map condMap) throws DataAccessException {
		List<GoodsVO>  goodsList=sqlSession.selectList("mapper.admin.goods.selectNewGoodsList",condMap);
return goodsList;
}

@Override
public GoodsVO selectGoodsDetail(int goods_id) throws DataAccessException{
GoodsVO goodsBean = new GoodsVO();
goodsBean=(GoodsVO)sqlSession.selectOne("mapper.admin.goods.selectGoodsDetail",goods_id);
return goodsBean;
}

@Override
public List selectGoodsImageFileList(int goods_id) throws DataAccessException {
List imageList=new ArrayList();
imageList=(List)sqlSession.selectList("mapper.admin.goods.selectGoodsImageFileList",goods_id);
return imageList;
}

@Override
public void updateGoodsInfo(Map goodsMap) throws DataAccessException{
sqlSession.update("mapper.admin.goods.updateGoodsInfo",goodsMap);
}

@Override
public void deleteGoodsImage(int image_id) throws DataAccessException{
sqlSession.delete("mapper.admin.goods.deleteGoodsImage",image_id);
}

@Override
public void deleteGoodsImage(List fileList) throws DataAccessException{
int image_id;
for(int i=0; i<fileList.size();i++){
ImageFileVO bean=(ImageFileVO) fileList.get(i);
image_id=bean.getImage_id();
sqlSession.delete("mapper.admin.goods.deleteGoodsImage",image_id);	
}
}

@Override
public List<OrderVO> selectOrderGoodsList(Map condMap) throws DataAccessException{
List<OrderVO>  orderGoodsList=(ArrayList)sqlSession.selectList("mapper.admin.selectOrderGoodsList",condMap);
return orderGoodsList;
}	

@Override
public void updateOrderGoods(Map orderMap) throws DataAccessException{
sqlSession.update("mapper.admin.goods.updateOrderGoods",orderMap);

}

@Override
public void updateGoodsImage(List<ImageFileVO> imageFileList) throws DataAccessException {

for(int i=0; i<imageFileList.size();i++){
ImageFileVO imageFileVO = imageFileList.get(i);
sqlSession.update("mapper.admin.goods.updateGoodsImage",imageFileVO);	
}

}

@Override
public void modifyMemberInfo(Map MemberMap) throws DataAccessException{
sqlSession.update("mapper.admin.goods.modifyMemberInfo", MemberMap);
}


//@Override
//public void removeGoods(int goods_num) throws Exception {
//    // "mapper.admin.goods.adminGoods.removeGoods"는 MyBatis XML 매퍼 파일에 정의된
//    // <delete id="removeGoods"> 태그의 namespace와 id를 합친 것입니다.
//    sqlSession.delete("mapper.admin.goods.removeGoods", goods_num);
//}

//................


@Override
public void updateGoodsDelYn(Map<String, Object> goodsMap) throws Exception {
    // "mapper.admin.goods.adminGoods.updateGoodsDelYn"는 MyBatis XML 매퍼 파일에 정의될 ID입니다.
    sqlSession.update("mapper.admin.goods.updateGoodsDelYn", goodsMap);
}

}
