package com.petmillie.order.vo;

public class OrderItemDto {
	private int goods_num;
	private int goods_qty;
	private String fileName;
	
	public int getGoods_num() {
		return goods_num;
	}
	public void setGoods_num(int goods_num) {
		this.goods_num = goods_num;
	}
	public int getGoods_qty() {
		return goods_qty;
	}
	public void setGoods_qty(int goods_qty) {
		this.goods_qty = goods_qty;
	}
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	
}
