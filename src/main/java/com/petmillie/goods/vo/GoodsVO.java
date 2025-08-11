package com.petmillie.goods.vo;

import java.sql.Date; // java.util.Date 대신 java.sql.Date 사용

import org.springframework.stereotype.Component;
@Component("GoodsVO")
public class GoodsVO {
	private int goods_num; // 상품 고유 번호
	private String goods_name; // 상품 이름 (이전 goods_title)
	private String goods_maker; // 제조사/저자 (이전 goods_writer)
	private String goods_publisher; // 출판사 (새로 추가, 만약 DB에 없다면 필요에 따라 추가 또는 제거)

	private String goods_category; // 상품 분류 (이전 goods_sort)
	private String goods_sales_price; // 상품 판매 가격
	private String goods_point; // 상품 구매 포인트
	private String goods_stock; // 상품 재고 수량
	private String goods_delivery_price; // 상품 배송비
	private Date goods_delivery_date; // 상품 도착 예정일
	private String goods_fileName; // 메인 이미지 파일명
	private String goods_status; // 상품 종류 (베스트셀러, 스테디셀러 등)

	// 새로 추가되거나 이름이 변경된 필드들
	private String goods_goods_writer_intro; // 저자/제조사 소개 (이전 goods_writer_intro)
	private String goods_contents_order; // 상품 목차
	private Date goods_credate; // 상품 등록일 (기존 필드)
	private String goods_intro; // 상품 소개 (새로 추가)

	private String del_yn; // 'Y' 또는 'N' 값을 저장할 필드

    public String getDel_yn() {
        return del_yn;
    }

    public void setDel_yn(String del_yn) {
        this.del_yn = del_yn;
    }
    // --- 새로 추가할 부분 끝 ---

	public GoodsVO() {
	}

	// Getter와 Setter 메소드
	// IDE의 자동 생성 기능을 활용하여 누락 없이 추가하는 것을 권장합니다.

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

	public String getGoods_maker() {
		return goods_maker;
	}
	public void setGoods_maker(String goods_maker) {
		this.goods_maker = goods_maker;
	}

	// 새로 추가된 goods_publisher
	public String getGoods_publisher() {
		return goods_publisher;
	}
	public void setGoods_publisher(String goods_publisher) {
		this.goods_publisher = goods_publisher;
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

	public Date getGoods_delivery_date() {
		return goods_delivery_date;
	}
	public void setGoods_delivery_date(Date goods_delivery_date) {
		this.goods_delivery_date = goods_delivery_date;
	}

	public String getGoods_fileName() {
		return goods_fileName;
	}
	public void setGoods_fileName(String goods_fileName) {
		this.goods_fileName = goods_fileName;
	}

	public String getGoods_status() {
		return goods_status;
	}
	public void setGoods_status(String goods_status) {
		this.goods_status = goods_status;
	}

	public String getGoods_goods_writer_intro() {
		return goods_goods_writer_intro;
	}
	public void setGoods_goods_writer_intro(String goods_goods_writer_intro) {
		this.goods_goods_writer_intro = goods_goods_writer_intro;
	}

	public String getGoods_contents_order() {
		return goods_contents_order;
	}
	public void setGoods_contents_order(String goods_contents_order) {
		this.goods_contents_order = goods_contents_order;
	}

	public Date getGoods_credate() {
		return goods_credate;
	}
	public void setGoods_credate(Date goods_credate) {
		this.goods_credate = goods_credate;
	}

	// 새로 추가된 필드들
//	public Date getGoods_published_date() {
//		return goods_published_date;
//	}
//	public void setGoods_published_date(Date goods_published_date) {
//		this.goods_published_date = goods_published_date;
//	}
//
//	public String getGoods_total_page() {
//		return goods_total_page;
//	}
//	public void setGoods_total_page(String goods_total_page) {
//		this.goods_total_page = goods_total_page;
//	}

	

	public String getGoods_intro() {
		return goods_intro;
	}
	public void setGoods_intro(String goods_intro) {
		this.goods_intro = goods_intro;
	}

	
}