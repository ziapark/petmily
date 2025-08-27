package com.petmillie.account.vo;

import org.springframework.stereotype.Component;

@Component("accountingVO")
public class AccountVO {
    private String seller_id;
    private String business_name;
    private int netSales;
    private int orderCount;
    private String commission_rate;
    
	public String getSeller_id() {
		return seller_id;
	}
	public void setSeller_id(String seller_id) {
		this.seller_id = seller_id;
	}
	public String getBusiness_name() {
		return business_name;
	}
	public void setBusiness_name(String business_name) {
		this.business_name = business_name;
	}
	public int getNetSales() {
		return netSales;
	}
	public void setNetSales(int netSales) {
		this.netSales = netSales;
	}
	public int getOrderCount() {
		return orderCount;
	}
	public void setOrderCount(int orderCount) {
		this.orderCount = orderCount;
	}
	public String getCommission_rate() {
		return commission_rate;
	}
	public void setCommission_rate(String commission_rate) {
		this.commission_rate = commission_rate;
	}
}
