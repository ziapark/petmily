package com.petmillie.leisure.vo;

import org.springframework.stereotype.Component;

@Component("LeisureVO")
public class LeisureVO {
	int leisure_id ;
	String fac_nm;
	String rn_addr;
	String opr_time_info;
	String off_day;
	String rprs_telno;
	String hmpg_url;
	String ctg02; 
	String ctg03;
	String info;
	Double la_vlue;
	Double lo_vlue;
	public int getLeisure_id() {
		return leisure_id;
	}
	public void setLeisure_id(int leisure_id) {
		this.leisure_id = leisure_id;
	}
	public String getFac_nm() {
		return fac_nm;
	}
	public void setFac_nm(String fac_nm) {
		this.fac_nm = fac_nm;
	}
	public String getRn_addr() {
		return rn_addr;
	}
	public void setRn_addr(String rn_addr) {
		this.rn_addr = rn_addr;
	}
	public String getOpr_time_info() {
		return opr_time_info;
	}
	public void setOpr_time_info(String opr_time_info) {
		this.opr_time_info = opr_time_info;
	}
	public String getOff_day() {
		return off_day;
	}
	public void setOff_day(String off_day) {
		this.off_day = off_day;
	}
	public String getRprs_telno() {
		return rprs_telno;
	}
	public void setRprs_telno(String rprs_telno) {
		this.rprs_telno = rprs_telno;
	}
	public String getHmpg_url() {
		return hmpg_url;
	}
	public void setHmpg_url(String hmpg_url) {
		this.hmpg_url = hmpg_url;
	}
	public String getCtg02() {
		return ctg02;
	}
	public void setCtg02(String ctg02) {
		this.ctg02 = ctg02;
	}
	public String getCtg03() {
		return ctg03;
	}
	public void setCtg03(String ctg03) {
		this.ctg03 = ctg03;
	}
	public String getInfo() {
		return info;
	}
	public void setInfo(String info) {
		this.info = info;
	}
	public Double getLa_vlue() {
		return la_vlue;
	}
	public void setLa_vlue(Double la_vlue) {
		this.la_vlue = la_vlue;
	}
	public Double getLo_vlue() {
		return lo_vlue;
	}
	public void setLo_vlue(Double lo_vlue) {
		this.lo_vlue = lo_vlue;
	}

}
