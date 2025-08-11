package com.petmillie.admin.goods.service;

import java.util.List;
import java.util.Map;

import com.petmillie.goods.vo.GoodsVO;
import com.petmillie.goods.vo.ImageFileVO;
import com.petmillie.order.vo.OrderVO;

public interface AdminGoodsService {
	public int addNewGoods(Map newGoodsMap) throws Exception;
	public List<GoodsVO> listNewGoods(Map condMap) throws Exception;
	public Map goodsDetail(int goods_id) throws Exception;
	public List goodsImageFile(int goods_id) throws Exception;
	public void modifyGoodsInfo(Map goodsMap) throws Exception;
	public void modifyGoodsImage(List<ImageFileVO> imageFileList) throws Exception;
	public List<OrderVO> listOrderGoods(Map condMap) throws Exception;
	public void modifyOrderGoods(Map orderMap) throws Exception;
	public void removeGoodsImage(int image_id) throws Exception;
	public void addNewGoodsImage(List imageFileList) throws Exception;
	  public void removeGoods(int goods_num) throws Exception;
	  public void restoreGoods(int goods_num) throws Exception;
	// --- 새로 추가된 메서드 ---

	/**
	 * 특정 상품 번호에 해당하는 모든 이미지 파일 목록을 조회합니다.
	 * 상품 삭제 시 물리적인 이미지 파일들을 삭제하기 위해 사용됩니다.
	 * @param goods_num 상품 번호
	 * @return 해당 상품의 이미지 파일 목록
	 * @throws Exception
	 */
	public List<ImageFileVO> listGoodsImages(int goods_num) throws Exception;

	/**
	 * 특정 상품 번호에 해당하는 상품 정보를 데이터베이스에서 삭제합니다.
	 * 이 메서드는 상품 테이블의 레코드와 관련된 이미지 파일 정보를 삭제합니다.
	 * @param goods_num 삭제할 상품 번호
	 * @throws Exception
	 */
	

}