package com.petmillie.reservation.vo;

import org.springframework.stereotype.Component;

@Component("ReservaionVO")
public class ReservaionVO {
	private String reservation_id;
	private String business_id;
	private String reservation_date;
	private String end_date;
	private String reg_date;
	private String status;
	private String member_id;
	
	
	
	public String getMember_id() {
		return member_id;
	}
	public void setMember_id(String member_id) {
		this.member_id = member_id;
	}
	public String getReservaion_id() {
		return reservation_id;
	}
	public void setReservaion_id(String reservaion_id) {
		this.reservation_id = reservaion_id;
	}
	public String getBusiness_id() {
		return business_id;
	}
	public void setBusiness_id(String business_id) {
		this.business_id = business_id;
	}
	public String getReservation_date() {
		return reservation_date;
	}
	public void setReservation_date(String reservation_date) {
		this.reservation_date = reservation_date;
	}
	public String getEnd_date() {
		return end_date;
	}
	public void setEnd_date(String end_date) {
		this.end_date = end_date;
	}
	public String getReg_date() {
		return reg_date;
	}
	public void setReg_date(String reg_date) {
		this.reg_date = reg_date;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}

	
}
