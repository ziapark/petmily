package com.petmillie.business.vo;

import org.springframework.stereotype.Component;

@Component("PensionVO")
public class PensionVO {
	private String p_num;
	private String business_id;
	private String p_name;
	private String tel1;
	private String tel2;
	private String tel3;
	private String checkin_time;
	private String checkout_time;
	private String room_count;
	private String facilities;
	private String description;
	private String fileName;
	private String reg_date;
	private String pension_status;
	

	
	private BusinessVO business;
	

	public String getP_num() {
		return p_num;
	}
	public void setP_num(String p_num) {
		this.p_num = p_num;
	}
	public String getBusiness_id() {
		return business_id;
	}
	public void setBusiness_id(String business_id) {
		this.business_id = business_id;
	}
	public String getP_name() {
		return p_name;
	}
	public void setP_name(String p_name) {
		this.p_name = p_name;
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
	public String getCheckin_time() {
		return checkin_time;
	}
	public void setCheckin_time(String checkin_time) {
		this.checkin_time = checkin_time;
	}
	public String getCheckout_time() {
		return checkout_time;
	}
	public void setCheckout_time(String checkout_time) {
		this.checkout_time = checkout_time;
	}
	public String getRoom_count() {
		return room_count;
	}
	public void setRoom_count(String room_count) {
		this.room_count = room_count;
	}
	
	public String getFacilities() {
		return facilities;
	}
	public void setFacilities(String facilities) {
		this.facilities = facilities;
	}
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	public String getPension_status() {
		return pension_status;
	}
	public void setPension_status(String pension_status) {
		this.pension_status = pension_status;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getReg_date() {
		return reg_date;
	}
	public void setReg_date(String reg_date) {
		this.reg_date = reg_date;
	}
	
	
	
	public BusinessVO getBusiness() {
		return business;
	}
	public void setBusiness(BusinessVO business) {
		this.business = business;
	}
	
}