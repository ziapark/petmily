package com.petmillie.goods.vo;

import java.util.Date; // java.util.Date 대신 java.sql.Date 사용

import org.springframework.stereotype.Component;
@Component("GoodsVO")
public class GoodsVO {
	private int goods_num; // 상품 고유 번호
	private String goods_name; // 상품 이름 (이전 goods_title)
	private String seller_id;
	private String goods_maker; // 제조사/저자 (이전 goods_writer)
	private String goods_category; // 상품 분류 (이전 goods_sort)
	private String goods_sales_price; // 상품 판매 가격
	private String goods_point; // 상품 구매 포인트
	private String goods_stock; // 상품 재고 수량
	private String goods_delivery_price; // 상품 배송비
	private String goods_status; // 상품 종류 (베스트셀러, 스테디셀러 등)
	private String goods_recommend;
	private Date goods_credate; // 상품 등록일 (기존 필드)
	private String del_yn; // 'Y' 또는 'N' 값을 저장할 필드

	private int image_id;
	private String fileName;
	private String fileType;
	private String reg_id;
	private Date reg_day;
	
	public int getGoods_num() {
		return goods_num;
	}
	public void setGoods_num(int goods_num) {
		this.goods_num = goods_num;
	}
	public String getGoods_name() {
		return goods_name;
	}
	public void setGoods_name(String goods_name) {
		this.goods_name = goods_name;
	}
	public String getSeller_id() {
		return seller_id;
	}
	public void setSeller_id(String seller_id) {
		this.seller_id = seller_id;
	}
	public String getGoods_maker() {
		return goods_maker;
	}
	public void setGoods_maker(String goods_maker) {
		this.goods_maker = goods_maker;
	}
	public String getGoods_category() {
		return goods_category;
	}
	public void setGoods_category(String goods_category) {
		this.goods_category = goods_category;
	}
	public String getGoods_sales_price() {
		return goods_sales_price;
	}
	public void setGoods_sales_price(String goods_sales_price) {
		this.goods_sales_price = goods_sales_price;
	}
	public String getGoods_point() {
		return goods_point;
	}
	public void setGoods_point(String goods_point) {
		this.goods_point = goods_point;
	}
	public String getGoods_stock() {
		return goods_stock;
	}
	public void setGoods_stock(String goods_stock) {
		this.goods_stock = goods_stock;
	}
	public String getGoods_delivery_price() {
		return goods_delivery_price;
	}
	public void setGoods_delivery_price(String goods_delivery_price) {
		this.goods_delivery_price = goods_delivery_price;
	}
	public String getGoods_status() {
		return goods_status;
	}
	public void setGoods_status(String goods_status) {
		this.goods_status = goods_status;
	}
	public String getGoods_recommend() {
		return goods_recommend;
	}
	public void setGoods_recommend(String goods_recommend) {
		this.goods_recommend = goods_recommend;
	}
	public Date getGoods_credate() {
		return goods_credate;
	}
	public void setGoods_credate(Date goods_credate) {
		this.goods_credate = goods_credate;
	}
	public String getDel_yn() {
		return del_yn;
	}
	public void setDel_yn(String del_yn) {
		this.del_yn = del_yn;
	}
	
	
	
	public int getImage_id() {
		return image_id;
	}
	public void setImage_id(int image_id) {
		this.image_id = image_id;
	}
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	public String getFileType() {
		return fileType;
	}
	public void setFileType(String fileType) {
		this.fileType = fileType;
	}
	public String getReg_id() {
		return reg_id;
	}
	public void setReg_id(String reg_id) {
		this.reg_id = reg_id;
	}
	public Date getReg_day() {
		return reg_day;
	}
	public void setReg_day(Date reg_day) {
		this.reg_day = reg_day;
	}
}