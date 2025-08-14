package com.petmillie.business.vo;

import org.springframework.stereotype.Component;

@Component("room_image")
public class Room_image {
	private int image_id;
	private int room_id;
	private String fileName;
	private String reg_id;
	private String reg_day;
	
	public int getImage_id() {
		return image_id;
	}
	public void setImage_id(int image_id) {
		this.image_id = image_id;
	}
	public int getRoom_id() {
		return room_id;
	}
	public void setRoom_id(int room_id) {
		this.room_id = room_id;
	}
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	public String getReg_id() {
		return reg_id;
	}
	public void setReg_id(String reg_id) {
		this.reg_id = reg_id;
	}
	public String getReg_day() {
		return reg_day;
	}
	public void setReg_day(String reg_day) {
		this.reg_day = reg_day;
	}
}
