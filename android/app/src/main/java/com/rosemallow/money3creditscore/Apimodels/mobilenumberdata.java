package com.rosemallow.money3creditscore.Apimodels;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

public class mobilenumberdata {

    // string variables for our name and job
    @SerializedName("_id")
    @Expose
    private String _id;
    @SerializedName("mobileNumber")
    @Expose
    private String mobileNumber;
    @SerializedName("createdAt")
    @Expose
    private String createdAt;
    @SerializedName("updatedAt")
    @Expose
    private String updatedAt;
    @SerializedName("version")
    @Expose
    private String version;

    public mobilenumberdata(String _id, String mobileNumber,String createdAt,String updatedAt,String version) {
        this._id = _id;
        this.mobileNumber = mobileNumber;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.version = version;
    }

    public String getId() {
        return _id;
    }

    public void setId(String _id) {
        this._id = _id;
    }
    public String getMobileNumber() {
        return mobileNumber;
    }

    public void setMobileNumber(String mobileNumber) {
        this.mobileNumber = mobileNumber;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }
    public String getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(String updatedAt) {
        this.updatedAt = updatedAt;
    }
    public String getVersion() {
        return version;
    }

    public void setVersion(String version) {
        this.version = version;
    }
}