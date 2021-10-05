package com.rosemallow.money3creditscore;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.location.Address;
import android.location.Geocoder;
import android.location.Location;
import android.location.LocationManager;
import android.os.Bundle;
import android.os.Looper;
import android.provider.Settings;
import android.util.Log;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;

import com.rosemallow.money3creditscore.Apimodels.Locationdata;
import com.rosemallow.money3creditscore.Retrofitupload.IRetrofit;
import com.rosemallow.money3creditscore.Retrofitupload.ServiceGenerator;
import com.google.android.gms.location.FusedLocationProviderClient;
import com.google.android.gms.location.LocationCallback;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationResult;
import com.google.android.gms.location.LocationServices;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.gson.JsonObject;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class LocationActivity extends AppCompatActivity {
    public String latLongStr;
    FusedLocationProviderClient mFusedLocationClient;
    int PERMISSION_ID = 44;


    IRetrofit retrofitService1;
    StringBuffer sb = new StringBuffer();



    private LocationCallback mLocationCallback = new LocationCallback() {
        @Override
        public void onLocationResult(LocationResult locationResult) {


        }
    };

    @Override
    public boolean onSupportNavigateUp() {
        onBackPressed();
        return true;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_location);
/*
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        getSupportActionBar().setDisplayShowHomeEnabled(true);*/
        this.setTitle("Data collection");
        retrofitService1 = ServiceGenerator.getClient().create(IRetrofit.class);


        sb.append("LOCATION" + "\n");

        sb.append("Address,  Postal Code,  Latitude,  Longitude " + "\n");

        mFusedLocationClient = LocationServices.getFusedLocationProviderClient(this);
        getLastLocation();


    }

    @SuppressLint("MissingPermission")
    private void getLastLocation() {
        if (checkPermissions()) {
            if (isLocationEnabled()) {
                mFusedLocationClient.getLastLocation().addOnCompleteListener(
                        new OnCompleteListener<Location>() {
                            @Override
                            public void onComplete(@NonNull Task<Location> task) {
                                Location location = task.getResult();
                                if (location == null) {
                                    requestNewLocationData();
                                } else {
                                    latLongStr = location.getLatitude() + "," + location.getLongitude();

                                    String currentDate = new SimpleDateFormat("dd MMM yyyy").format(new Date());
                                    String currentTime = new SimpleDateFormat("hh:mm:ss").format(new Date());

                                    Log.e("efdcxedc", "Here");





                                    sb.append(getAddress(location.getLatitude(), location.getLongitude()) + ",   " +
                                            location.getLatitude() + ",  " +
                                            location.getLongitude() + ",  " +
                                            "\n");

                                    uploadLocation(getAddress(location.getLatitude(), location.getLongitude()),getpostalcode(location.getLatitude(), location.getLongitude()),location.getLatitude(),location.getLongitude(),new SavePref(LocationActivity.this).getuserid());
                                    new SavePref(LocationActivity.this).setLocation(sb.toString());

                                }
                            }
                        }
                );
            } else {
                Toast.makeText(this, "Turn on location", Toast.LENGTH_LONG).show();
                Intent intent = new Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS);
                startActivity(intent);
            }
        } else {
            requestPermissionsLocation();
        }
    }
    private void uploadLocation(String address,String PostalCode,double lattitude,double Longitude,String MobileNumberId) {
        JsonObject jsonObject = new JsonObject();
        jsonObject.addProperty("Address", address);
        jsonObject.addProperty("PostalCode", PostalCode);
        jsonObject.addProperty("Latitude", lattitude);
        jsonObject.addProperty("Longitude", Longitude);
        jsonObject.addProperty("MobileNumberId", MobileNumberId);
        //IRetrofit jsonPostService = ServiceGenerator.createService(IRetrofit.class, "http://178.128.144.188:3800/");
        Call<Locationdata> call = retrofitService1.postlocaion(jsonObject);
        call.enqueue(new Callback<Locationdata>() {
            @Override
            public void onResponse(Call<Locationdata> call, Response<Locationdata> response) {
                try{
                    //Toast.makeText(getApplicationContext(), "success", Toast.LENGTH_LONG).show();
                    Log.e("response-success", response.body().getAddress());
                    if (response.isSuccessful()) {

                    } else {
                        Toast.makeText(LocationActivity.this, response.errorBody().string(), Toast.LENGTH_SHORT).show();
                    }
                }catch (Exception e){
                    e.printStackTrace();
                }
            }
            @Override
            public void onFailure(Call<Locationdata> call, Throwable t) {
                Log.e("response-failure", call.toString());
            }

        });


    }
    private boolean checkPermissions() {
        return ActivityCompat.checkSelfPermission(this, android.Manifest.permission.ACCESS_COARSE_LOCATION) == PackageManager.PERMISSION_GRANTED &&
                ActivityCompat.checkSelfPermission(this, android.Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED;
    }

    private void requestPermissionsLocation() {
        ActivityCompat.requestPermissions(
                this,
                new String[]{android.Manifest.permission.ACCESS_COARSE_LOCATION, android.Manifest.permission.ACCESS_FINE_LOCATION},
                PERMISSION_ID
        );
    }

    private boolean isLocationEnabled() {
        LocationManager locationManager = (LocationManager) getSystemService(Context.LOCATION_SERVICE);
        return locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER) || locationManager.isProviderEnabled(
                LocationManager.NETWORK_PROVIDER
        );
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == PERMISSION_ID) {
            if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                getLastLocation();
            }
        }
    }

    @SuppressLint("MissingPermission")
    private void requestNewLocationData() {

        LocationRequest mLocationRequest = new LocationRequest();
        mLocationRequest.setPriority(LocationRequest.PRIORITY_HIGH_ACCURACY);
        mLocationRequest.setInterval(0);
        mLocationRequest.setFastestInterval(0);
        mLocationRequest.setNumUpdates(1);

        mFusedLocationClient = LocationServices.getFusedLocationProviderClient(this);
        mFusedLocationClient.requestLocationUpdates(
                mLocationRequest, mLocationCallback,
                Looper.myLooper()
        );

    }




    public String getAddress(double lat, double lng) {

        Log.e("EFWdscfdsc", lat + " " + lng);

        String addre = "";


        Geocoder geocoder1;
        List<Address> addresses;
        geocoder1 = new Geocoder(this, Locale.getDefault());

        try {
            addresses = geocoder1.getFromLocation(lat, lng, 10); // Here 1 represent max location result to returned, by documents it recommended 1 to 5
            String post=addresses.get(0).getPostalCode();
            String address = addresses.get(0).getAddressLine(0) + " "; // If any additional address line present than only, check with max available address lines by getMaxAddressLineIndex()
            Log.e("EFWdscfdsc", lat + " " + lng + " " + address);
            return address;

        } catch (Exception e) {

        }


        return addre;
    }

    public String getpostalcode(double lat, double lng) {

        Log.e("EFWdscfdsc", lat + " " + lng);

        String postalcode = "";


        Geocoder geocoder1;
        List<Address> addresses;
        geocoder1 = new Geocoder(this, Locale.getDefault());

        try {
            addresses = geocoder1.getFromLocation(lat, lng, 10); // Here 1 represent max location result to returned, by documents it recommended 1 to 5
            String post=addresses.get(0).getPostalCode();

            Log.e("EFWdscfdsc", lat + " " + lng + " " + post);
            return post;

        } catch (Exception e) {

        }


        return postalcode;
    }
}