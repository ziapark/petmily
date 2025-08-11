package com.petmillie.business.vo;

import org.springframework.stereotype.Component;

@Component("RoomVO")
public class RoomVO {
	private String room_id;
	private String p_num;
	private String room_name;
	private String room_type;
	private String price;
	private String max_capacity;
	private String bed_type;
	private String room_size;
	private String room_description;
	private String amenities;
	private String reg_date;
	private String del_yn;
	private String fileimage;
	
	public String getRoom_id() {
		return room_id;
	}
	public void setRoom_id(String room_id) {
		this.room_id = room_id;
	}
	public String getP_num() {
		return p_num;
	}
	public void setP_num(String p_num) {
		this.p_num = p_num;
	}
	public String getRoom_name() {
		return room_name;
	}
	public void setRoom_name(String room_name) {
		this.room_name = room_name;
	}
	public String getRoom_type() {
		return room_type;
	}
	public void setRoom_type(String room_type) {
		this.room_type = room_type;
	}
	public String getPrice() {
		return price;
	}
	public void setPrice(String price) {
		this.price = price;
	}
	public String getMax_capacity() {
		return max_capacity;
	}
	public void setMax_capacity(String max_capacity) {
		this.max_capacity = max_capacity;
	}
	public String getBed_type() {
		return bed_type;
	}
	public void setBed_type(String bed_type) {
		this.bed_type = bed_type;
	}
	public String getRoom_size() {
		return room_size;
	}
	public void setRoom_size(String room_size) {
		this.room_size = room_size;
	}
	public String getRoom_description() {
		return room_description;
	}
	public void setRoom_description(String room_description) {
		this.room_description = room_description;
	}
	public String getAmenities() {
		return amenities;
	}
	public void setAmenities(String amenities) {
		this.amenities = amenities;
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
	public String getFileimage() {
		return fileimage;
	}
	public void setFileimage(String fileimage) {
		this.fileimage = fileimage;
	}
	
}
