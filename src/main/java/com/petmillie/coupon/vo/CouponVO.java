package com.petmillie.coupon.vo;

import java.sql.Date;

public class CouponVO {
    private int coupon_id;
    private String coupon_name;
    private String coupon_code;
    private String discount_type;
    private int discount_value;
    private int min_order_amount;
    private int max_discount_amount;
    private Date expire_date;
    private String description;
    private Date reg_date;
    private String issued_by;
	public int getCoupon_id() {
		return coupon_id;
	}
	public void setCoupon_id(int coupon_id) {
		this.coupon_id = coupon_id;
	}
	public String getCoupon_name() {
		return coupon_name;
	}
	public void setCoupon_name(String coupon_name) {
		this.coupon_name = coupon_name;
	}
	public String getCoupon_code() {
		return coupon_code;
	}
	public void setCoupon_code(String coupon_code) {
		this.coupon_code = coupon_code;
	}
	public String getDiscount_type() {
		return discount_type;
	}
	public void setDiscount_type(String discount_type) {
		this.discount_type = discount_type;
	}
	public int getDiscount_value() {
		return discount_value;
	}
	public void setDiscount_value(int discount_value) {
		this.discount_value = discount_value;
	}
	public int getMin_order_amount() {
		return min_order_amount;
	}
	public void setMin_order_amount(int min_order_amount) {
		this.min_order_amount = min_order_amount;
	}
	public int getMax_discount_amount() {
		return max_discount_amount;
	}
	public void setMax_discount_amount(int max_discount_amount) {
		this.max_discount_amount = max_discount_amount;
	}
	public Date getExpire_date() {
		return expire_date;
	}
	public void setExpire_date(Date expire_date) {
		this.expire_date = expire_date;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public Date getReg_date() {
		return reg_date;
	}
	public void setReg_date(Date reg_date) {
		this.reg_date = reg_date;
	}
	public String getIssued_by() {
		return issued_by;
	}
	public void setIssued_by(String issued_by) {
		this.issued_by = issued_by;
	}
    
}
