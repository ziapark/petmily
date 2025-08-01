package com.petmillie.order.vo;

import org.springframework.stereotype.Component;

@Component("orderVO")
public class OrderVO {
	private int order_num; 
	private String member_id;
	private int order_id;
	private int goods_num;
	private String goods_name;
	private String goods_sales_price; 
	private int goods_qty;
	private String order_name;
	private String receiver_name;
	private String tel1;
	private String tel2;
	private String tel3;
	private String total_price;
	private String zipcode;
	private String roadAddress;
	private String jibunAddress;
	private String namujiAddress;
	private String delivery_method;
	private String pay_order_tel;
	private String delivery_message;
	private String pay_method;
	private String card_com_name;
	private String card_pay_month;
	private String delivery_state; //기본값 배송준비중
	private int final_total_price;
	private String goods_fileName;
	private String pay_order_time;

	
	public String getTotal_price() {
		return total_price;
	}
	public void setTotal_price(String total_price) {
		this.total_price = total_price;
	}
	public String getTel1() {
		return tel1;
	}
	public void setTel1(String tel1) {
		this.tel1 = tel1;
	}
	public String getTel2() {
		return tel2;
	}
	public void setTel2(String tel2) {
		this.tel2 = tel2;
	}
	public String getTel3() {
		return tel3;
	}
	public void setTel3(String tel3) {
		this.tel3 = tel3;
	}
	public String getZipcode() {
		return zipcode;
	}
	public void setZipcode(String zipcode) {
		this.zipcode = zipcode;
	}
	public String getRoadAddress() {
		return roadAddress;
	}
	public void setRoadAddress(String roadAddress) {
		this.roadAddress = roadAddress;
	}
	public String getJibunAddress() {
		return jibunAddress;
	}
	public void setJibunAddress(String jibunAddress) {
		this.jibunAddress = jibunAddress;
	}
	public String getNamujiAddress() {
		return namujiAddress;
	}
	public void setNamujiAddress(String namujiAddress) {
		this.namujiAddress = namujiAddress;
	}
	public String getDelivery_method() {
		return delivery_method;
	}
	public void setDelivery_method(String delivery_method) {
		this.delivery_method = delivery_method;
	}
	public String getPay_order_tel() {
		return pay_order_tel;
	}
	public void setPay_order_tel(String pay_order_tel) {
		this.pay_order_tel = pay_order_tel;
	}
	public String getPay_order_time() {
		return pay_order_time;
	}
	public void setPay_order_time(String pay_order_time) {
		this.pay_order_time = pay_order_time;
	}
	public int getOrder_num() {
		return order_num;
	}
	public void setOrder_num(int order_num) {
		this.order_num = order_num;
	}
	public String getMember_id() {
		return member_id;
	}
	public void setMember_id(String member_id) {
		this.member_id = member_id;
	}
	public int getOrder_id() {
		return order_id;
	}
	public void setOrder_id(int order_id) {
		this.order_id = order_id;
	}
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
	public String getGoods_sales_price() {
		return goods_sales_price;
	}
	public void setGoods_sales_price(String goods_sales_price) {
		this.goods_sales_price = goods_sales_price;
	}
	public int getGoods_qty() {
		return goods_qty;
	}
	public void setGoods_qty(int goods_qty) {
		this.goods_qty = goods_qty;
	}
	public String getOrder_name() {
		return order_name;
	}
	public void setOrder_name(String order_name) {
		this.order_name = order_name;
	}
	public String getReceiver_name() {
		return receiver_name;
	}
	public void setReceiver_name(String receiver_name) {
		this.receiver_name = receiver_name;
	}
	public String getDelivery_message() {
		return delivery_message;
	}
	public void setDelivery_message(String delivery_message) {
		this.delivery_message = delivery_message;
	}
	public String getPay_method() {
		return pay_method;
	}
	public void setPay_method(String pay_method) {
		this.pay_method = pay_method;
	}
	public String getCard_com_name() {
		return card_com_name;
	}
	public void setCard_com_name(String card_com_name) {
		this.card_com_name = card_com_name;
	}
	public String getCard_pay_month() {
		return card_pay_month;
	}
	public void setCard_pay_month(String card_pay_month) {
		this.card_pay_month = card_pay_month;
	}
	public String getDelivery_state() {
		return delivery_state;
	}
	public void setDelivery_state(String delivery_state) {
		this.delivery_state = delivery_state;
	}
	public int getFinal_total_price() {
		return final_total_price;
	}
	public void setFinal_total_price(int final_total_price) {
		this.final_total_price = final_total_price;
	}
	public String getGoods_fileName() {
		return goods_fileName;
	}
	public void setGoods_fileName(String goods_fileName) {
		this.goods_fileName = goods_fileName;
	}

}
