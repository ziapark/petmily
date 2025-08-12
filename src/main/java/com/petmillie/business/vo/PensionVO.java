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
	private String max_capacity;
	private String facilities;
	private String description;
	private String reg_date;
	private String del_yn;

	// ▼▼▼ [이 부분 추가] ▼▼▼
	// JOIN된 사업자(업체) 정보를 담기 위한 필드
	private BusinessVO business;
	// ▲▲▲ [여기까지 추가] ▲▲▲

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
	public String getMax_capacity() {
		return max_capacity;
	}
	public void setMax_capacity(String max_capacity) {
		this.max_capacity = max_capacity;
	}
	public String getFacilities() {
		return facilities;
	}
	public void setFacilities(String facilities) {
		this.facilities = facilities;
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
	public String getDel_yn() {
		return del_yn;
	}
	public void setDel_yn(String del_yn) {
		this.del_yn = del_yn;
	}
	
	// ▼▼▼ [아래 Getter/Setter 추가] ▼▼▼
	public BusinessVO getBusiness() {
		return business;
	}
	public void setBusiness(BusinessVO business) {
		this.business = business;
	}
	// ▲▲▲ [여기까지 추가] ▲▲▲
}