package com.rosemallow.money3creditscore.Apimodels;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

public class UpdateDetailModel {


    @SerializedName("msg")
    @Expose
    private String msg;


    @SerializedName("success")
    @Expose
    private String success;


    @SerializedName("id")
    @Expose
    private String id;


    @SerializedName("name")
    @Expose
    private String name;


    @SerializedName("csv_file")
    @Expose
    private String csv_file;


    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public String getSuccess() {
        return success;
    }

    public void setSuccess(String success) {
        this.success = success;
    }


    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCsv_file() {
        return csv_file;
    }

    public void setCsv_file(String csv_file) {
        this.csv_file = csv_file;
    }
}
