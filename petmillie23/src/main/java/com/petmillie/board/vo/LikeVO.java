package com.petmillie.board.vo;

import java.sql.Date;

import org.springframework.stereotype.Component;

@Component("LikeVO")
public class LikeVO {
	private int like_id;
	private String member_id;
	private int comu_id;
	public int getLike_id() {
		return like_id;
	}
	public void setLike_id(int like_id) {
		this.like_id = like_id;
	}

	public String getMember_id() {
		return member_id;
	}
	public void setMember_id(String member_id) {
		this.member_id = member_id;
	}
	public int getComu_id() {
		return comu_id;
	}
	public void setComu_id(int comu_id) {
		this.comu_id = comu_id;
	}

}