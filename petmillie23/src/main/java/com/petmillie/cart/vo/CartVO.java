package com.petmillie.cart.vo;

import org.springframework.stereotype.Component;

@Component("cartVO")
public class CartVO {
	private int cart_id;
	private int goods_name;
	private String member_id;
	private int cart_goods_qty;
	private String creDate;
	
	
	public int getCart_id() {
		return cart_id;
	}
	public void setCart_id(int cart_id) {
		this.cart_id = cart_id;
	}
	
	

	public int getGoods_name() {
		return goods_name;
	}
	public void setGoods_name(int goods_name) {
		this.goods_name = goods_name;
	}
	public String getMember_id() {
		return member_id;
	}
	public void setMember_id(String member_id) {
		this.member_id = member_id;
	}
	
	
	public int getCart_goods_qty() {
		return cart_goods_qty;
	}
	public void setCart_goods_qty(int cart_goods_qty) {
		this.cart_goods_qty = cart_goods_qty;
	}
	public String getCreDate() {
		return creDate;
	}
	public void setCreDate(String creDate) {
		this.creDate = creDate;
	}
	
	
	

}
