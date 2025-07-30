package com.petmillie.goods.vo;

import java.sql.Date;

import org.springframework.stereotype.Component;

@Component("ImageFileVO")
public class ImageFileVO {
	private int goods_num;
	private int image_id;
	private String fileName;
	private String fileType;
	private String reg_id;
	private Date reg_day;
	



	public Date getReg_day() {
		return reg_day;
	}


	public void setReg_day(Date reg_day) {
		this.reg_day = reg_day;
	}


	public ImageFileVO() {
		super();
	}


	public int getGoods_num() {
		return goods_num;
	}




	public void setGoods_num(int goods_num) {
		this.goods_num = goods_num;
	}




	public int getImage_id() {
		return image_id;
	}




	public void setImage_id(int image_id) {
		this.image_id = image_id;
	}




	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public String getFileType() {
		return fileType;
	}

	public void setFileType(String fileType) {
		this.fileType = fileType;
	}


	public String getReg_id() {
		return reg_id;
	}

	public void setReg_id(String reg_id) {
		this.reg_id = reg_id;
	}


	

}