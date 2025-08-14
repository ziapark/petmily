package com.petmillie.medi.vo;

public class AnimalPharmacyVO {
	private int pharmacy_id;
	private String FRNM_NM ;
	private String RN_ADDR ;
	private String OPR_TIME_INFO ;
	private String RPRS_TELNO ;
	private String HMPG_URL ;
	private Double LA_VLUE ;
	private Double LO_VLUE ;
	public int getPharmacy_id() {
		return pharmacy_id;
	}
	public void setPharmacy_id(int pharmacy_id) {
		this.pharmacy_id = pharmacy_id;
	}
	public String getFRNM_NM() {
		return FRNM_NM;
	}
	public void setFRNM_NM(String fRNM_NM) {
		FRNM_NM = fRNM_NM;
	}
	public String getRN_ADDR() {
		return RN_ADDR;
	}
	public void setRN_ADDR(String rN_ADDR) {
		RN_ADDR = rN_ADDR;
	}
	public String getOPR_TIME_INFO() {
		return OPR_TIME_INFO;
	}
	public void setOPR_TIME_INFO(String oPR_TIME_INFO) {
		OPR_TIME_INFO = oPR_TIME_INFO;
	}
	public String getRPRS_TELNO() {
		return RPRS_TELNO;
	}
	public void setRPRS_TELNO(String rPRS_TELNO) {
		RPRS_TELNO = rPRS_TELNO;
	}
	public String getHMPG_URL() {
		return HMPG_URL;
	}
	public void setHMPG_URL(String hMPG_URL) {
		HMPG_URL = hMPG_URL;
	}
	public Double getLA_VLUE() {
		return LA_VLUE;
	}
	public void setLA_VLUE(Double lA_VLUE) {
		LA_VLUE = lA_VLUE;
	}
	public Double getLO_VLUE() {
		return LO_VLUE;
	}
	public void setLO_VLUE(Double lO_VLUE) {
		LO_VLUE = lO_VLUE;
	}
	
}
