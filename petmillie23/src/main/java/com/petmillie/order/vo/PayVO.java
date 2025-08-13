package com.petmillie.order.vo;

import org.springframework.stereotype.Component;

@Component("payVO")
public class PayVO {
	private String payment_id;
	private String pay_method;
	private String card_com_name;
	private String card_pay_month;
	private int final_total_price;
	private String pay_order_time;
	private int order_num;
	private String payment_amount;
	private String payment_status;
	private String pg_tid;
	private String payment_time;
	private String pay_order_tel;
	public String getPayment_id() {
		return payment_id;
	}
	public void setPayment_id(String payment_id) {
		this.payment_id = payment_id;
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
	public int getFinal_total_price() {
		return final_total_price;
	}
	public void setFinal_total_price(int final_total_price) {
		this.final_total_price = final_total_price;
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
	public String getPayment_amount() {
		return payment_amount;
	}
	public void setPayment_amount(String payment_amount) {
		this.payment_amount = payment_amount;
	}
	public String getPayment_status() {
		return payment_status;
	}
	public void setPayment_status(String payment_status) {
		this.payment_status = payment_status;
	}
	public String getPg_tid() {
		return pg_tid;
	}
	public void setPg_tid(String pg_tid) {
		this.pg_tid = pg_tid;
	}
	public String getPayment_time() {
		return payment_time;
	}
	public void setPayment_time(String payment_time) {
		this.payment_time = payment_time;
	}
	public String getPay_order_tel() {
		return pay_order_tel;
	}
	public void setPay_order_tel(String pay_order_tel) {
		this.pay_order_tel = pay_order_tel;
	}
	
	
	
}
