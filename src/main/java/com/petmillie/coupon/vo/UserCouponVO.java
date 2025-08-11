package com.petmillie.coupon.vo;

import java.sql.Date;

public class UserCouponVO {
    private int user_coupon_id;
    private int coupon_id;
    private String member_id;
    private Date issued_date;
    private String used_yn;
    private Date used_date;
    private String available_yn;
	public int getUser_coupon_id() {
		return user_coupon_id;
	}
	public void setUser_coupon_id(int user_coupon_id) {
		this.user_coupon_id = user_coupon_id;
	}
	public int getCoupon_id() {
		return coupon_id;
	}
	public void setCoupon_id(int coupon_id) {
		this.coupon_id = coupon_id;
	}
	public String getMember_id() {
		return member_id;
	}
	public void setMember_id(String member_id) {
		this.member_id = member_id;
	}
	public Date getIssued_date() {
		return issued_date;
	}
	public void setIssued_date(Date issued_date) {
		this.issued_date = issued_date;
	}
	public String getUsed_yn() {
		return used_yn;
	}
	public void setUsed_yn(String used_yn) {
		this.used_yn = used_yn;
	}
	public Date getUsed_date() {
		return used_date;
	}
	public void setUsed_date(Date used_date) {
		this.used_date = used_date;
	}
	public String getAvailable_yn() {
		return available_yn;
	}
	public void setAvailable_yn(String available_yn) {
		this.available_yn = available_yn;
	}
    
}
