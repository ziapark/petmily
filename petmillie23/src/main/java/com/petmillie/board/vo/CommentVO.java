package com.petmillie.board.vo;

import java.sql.Date;

import org.springframework.stereotype.Component;

@Component("CommentVO")
public class CommentVO {
	
	private int comment_id;
	private int comu_id;
	public int getComu_id() {
		return comu_id;
	}
	public void setComu_id(int comu_id) {
		this.comu_id = comu_id;
	}
	private String member_id;
	private String comment_content;
	private Date reg_date;
	
	
	public int getComment_id() {
		return comment_id;
	}
	public void setComment_id(int comment_id) {
		this.comment_id = comment_id;
	}
	public String getMember_id() {
		return member_id;
	}
	public void setMember_id(String member_id) {
		this.member_id = member_id;
	}
	public String getComment_content() {
		return comment_content;
	}
	public void setComment_content(String comment_content) {
		this.comment_content = comment_content;
	}
	public Date getReg_date() {
		return reg_date;
	}
	public void setReg_date(Date reg_date) {
		this.reg_date = reg_date;
	}

	
}