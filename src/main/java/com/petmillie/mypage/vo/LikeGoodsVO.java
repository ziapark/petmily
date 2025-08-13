package com.petmillie.mypage.vo;

public class LikeGoodsVO {
	private int like_goods_id;
	private String member_id;
	private int goods_num;
	private String goods_name;
	private String goods_sales_price;
	private String goods_fileName;
	
	public int getLike_goods_id() {
		return like_goods_id;
	}
	public void setLike_goods_id(int like_goods_id) {
		this.like_goods_id = like_goods_id;
	}
	public String getMember_id() {
		return member_id;
	}
	public void setMember_id(String member_id) {
		this.member_id = member_id;
	}
	public int getGoods_num() {
		return goods_num;
	}
	public void setGoods_num(int goods_num) {
		this.goods_num = goods_num;
	}
	public String getGoods_sales_price() {
		return goods_sales_price;
	}
	public void setGoods_sales_price(String goods_sales_price) {
		this.goods_sales_price = goods_sales_price;
	}
	public String getGoods_name() {
		return goods_name;
	}
	public void setGoods_name(String goods_name) {
		this.goods_name = goods_name;
	}
	public String getGoods_fileName() {
		return goods_fileName;
	}
	public void setGoods_fileName(String goods_fileName) {
		this.goods_fileName = goods_fileName;
	}

}
