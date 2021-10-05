package com.rosemallow.money3creditscore.Apimodels;


import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

public class Locationdata {

    // string variables for our name and job
    @SerializedName("_id")
    @Expose
    private String _id;
    @SerializedName("Address")
    @Expose
    private String Address;
    @SerializedName("PostalCode")
    @Expose
    private String PostalCode;
    @SerializedName("createdAt")
    @Expose
    private String createdAt;
    @SerializedName("updatedAt")
    @Expose
    private String updatedAt;


    public Locationdata(String _id, String Address, String createdAt, String updatedAt, String PostalCode) {
        this._id = _id;
        this.Address = Address;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.PostalCode = PostalCode;
    }

    public String getId() {
        return _id;
    }

    public void setId(String _id) {
        this._id = _id;
    }
    public String getAddress() {
        return Address;
    }

    public void setAddress(String Address) {
        this.Address = Address;
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
    public String getPostalCode() {
        return PostalCode;
    }

    public void setPostalCode(String PostalCode) {
        this.PostalCode = PostalCode;
    }
}