package com.petmillie.mypage.vo;

import java.sql.Date;

public class PetVO {
	private int pet_id;
	private String member_id;
	private String pet_name;
	private Date pet_birth_date;
	private String pet_species;
	private String pet_breed;
	private String pet_gender;
	private String pet_favorite_toy;
	private String pet_favorite_snack;
	private String fileName;
	private Date reg_date;
	
	public int getPet_id() {
		return pet_id;
	}

	public void setPet_id(int pet_id) {
		this.pet_id = pet_id;
	}

	public String getMember_id() {
		return member_id;
	}

	public void setMember_id(String member_id) {
		this.member_id = member_id;
	}

	public String getPet_name() {
		return pet_name;
	}

	public void setPet_name(String pet_name) {
		this.pet_name = pet_name;
	}

	public Date getPet_birth_date() {
		return pet_birth_date;
	}

	public void setPet_birth_date(Date pet_birth_date) {
		this.pet_birth_date = pet_birth_date;
	}

	public String getPet_species() {
		return pet_species;
	}

	public void setPet_species(String pet_species) {
		this.pet_species = pet_species;
	}

	public String getPet_breed() {
		return pet_breed;
	}

	public void setPet_breed(String pet_breed) {
		this.pet_breed = pet_breed;
	}

	public String getPet_gender() {
		return pet_gender;
	}

	public void setPet_gender(String pet_gender) {
		this.pet_gender = pet_gender;
	}

	public String getPet_favorite_toy() {
		return pet_favorite_toy;
	}

	public void setPet_favorite_toy(String pet_favorite_toy) {
		this.pet_favorite_toy = pet_favorite_toy;
	}

	public String getPet_favorite_snack() {
		return pet_favorite_snack;
	}

	public void setPet_favorite_snack(String pet_favorite_snack) {
		this.pet_favorite_snack = pet_favorite_snack;
	}

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public Date getReg_date() {
		return reg_date;
	}

	public void setReg_date(Date reg_date) {
		this.reg_date = reg_date;
	}
}
