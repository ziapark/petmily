package com.petmillie.medi.vo;

import org.springframework.stereotype.Component;

@Component("MediVO")

public class MediVO {
    private int id;
    private String name;
    private String addr;
    private String oprTime;
    private String tel;
    private String homepage;
    private double lat;
    private double lng;
    private String type; // HOSPITAL or PHARMACY

    // getter / setter
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getAddr() { return addr; }
    public void setAddr(String addr) { this.addr = addr; }

    public String getOprTime() { return oprTime; }
    public void setOprTime(String oprTime) { this.oprTime = oprTime; }

    public String getTel() { return tel; }
    public void setTel(String tel) { this.tel = tel; }

    public String getHomepage() { return homepage; }
    public void setHomepage(String homepage) { this.homepage = homepage; }

    public double getLat() { return lat; }
    public void setLat(double lat) { this.lat = lat; }

    public double getLng() { return lng; }
    public void setLng(double lng) { this.lng = lng; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
}