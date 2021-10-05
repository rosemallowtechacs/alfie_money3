package com.rosemallow.money3creditscore.Retrofitupload;

import com.rosemallow.money3creditscore.Apimodels.UpdateModel;

import okhttp3.MultipartBody;
import okhttp3.RequestBody;
import retrofit2.Call;
import retrofit2.http.Multipart;
import retrofit2.http.POST;
import retrofit2.http.Part;

public interface RetrofitService {

    @Multipart
    @POST("api.php?upload_file_txt")
    Call<UpdateModel> postUpdateCallWithImage(@Part("name") RequestBody name,
                                              @Part MultipartBody.Part csv_file);


}