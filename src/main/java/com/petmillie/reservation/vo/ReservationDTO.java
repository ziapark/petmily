package com.petmillie.reservation.vo;

import java.sql.Date;
import org.springframework.stereotype.Component;

@Component("reservationDTO")
public class ReservationDTO {
	
	private int reservation_id;
	private String member_id;
	private int p_num; // JSP 등 다른 곳에서 펜션 정보를 넘기기 위해 유지합니다.
	private int room_id;
	private String business_id;
	
	// DB 테이블 컬럼명과 일치시켰습니다.
	private Date checkin_date;
	private Date checkout_date;
	
	private int guests;
	private String reserver_name;
	private String reserver_tel;
	private int total_price;
	private String status;
	
	public ReservationDTO() {
	}

	// --- 모든 필드에 대한 Getter & Setter ---
	
	public int getReservation_id() {
		return reservation_id;
	}

	public void setReservation_id(int reservation_id) {
		this.reservation_id = reservation_id;
	}

	public String getMember_id() {
		return member_id;
	}

	public void setMember_id(String member_id) {
		this.member_id = member_id;
	}

	public int getP_num() {
		return p_num;
	}

	public void setP_num(int p_num) {
		this.p_num = p_num;
	}

	public int getRoom_id() {
		return room_id;
	}

	public void setRoom_id(int room_id) {
		this.room_id = room_id;
	}

	public String getBusiness_id() {
		return business_id;
	}

	public void setBusiness_id(String business_id) {
		this.business_id = business_id;
	}

	public Date getCheckin_date() {
		return checkin_date;
	}

	public void setCheckin_date(Date checkin_date) {
		this.checkin_date = checkin_date;
	}

	public Date getCheckout_date() {
		return checkout_date;
	}

	public void setCheckout_date(Date checkout_date) {
		this.checkout_date = checkout_date;
	}

	public int getGuests() {
		return guests;
	}

	public void setGuests(int guests) {
		this.guests = guests;
	}

	public String getReserver_name() {
		return reserver_name;
	}

	public void setReserver_name(String reserver_name) {
		this.reserver_name = reserver_name;
	}

	public String getReserver_tel() {
		return reserver_tel;
	}

	public void setReserver_tel(String reserver_tel) {
		this.reserver_tel = reserver_tel;
	}

	public int getTotal_price() {
		return total_price;
	}

	public void setTotal_price(int total_price) {
		this.total_price = total_price;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
}