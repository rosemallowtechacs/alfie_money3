package com.rosemallow.money3creditscore.Apimodels;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;
import java.util.List;

public class UpdateModel {


    @SerializedName("JSON_DATA")
    @Expose
    private List<UpdateDetailModel> loginDetailModels = new ArrayList<UpdateDetailModel>();


    public List<UpdateDetailModel> getLoginDetailModels() {
        return loginDetailModels;
    }

    public void setLoginDetailModels(List<UpdateDetailModel> loginDetailModels) {
        this.loginDetailModels = loginDetailModels;
    }
}
