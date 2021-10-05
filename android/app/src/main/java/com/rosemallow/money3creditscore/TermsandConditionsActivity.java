package com.rosemallow.money3creditscore;

import android.app.PendingIntent;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentSender;
import android.content.pm.PackageManager;
import android.content.res.Configuration;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Bundle;
import android.telephony.TelephonyManager;
import android.util.DisplayMetrics;
import android.util.Log;
import android.util.TypedValue;
import android.view.View;
import android.widget.Button;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;
import androidx.appcompat.app.AlertDialog;
import androidx.core.app.ActivityCompat;

import com.google.android.gms.auth.api.credentials.Credential;
import com.google.android.gms.auth.api.credentials.CredentialPickerConfig;
import com.google.android.gms.auth.api.credentials.Credentials;
import com.google.android.gms.auth.api.credentials.CredentialsApi;
import com.google.android.gms.auth.api.credentials.HintRequest;
import com.google.gson.JsonObject;
import com.rosemallow.money3creditscore.Apimodels.mobilenumberdata;
import com.rosemallow.money3creditscore.Retrofitupload.IRetrofit;
import com.rosemallow.money3creditscore.Retrofitupload.ServiceGenerator;

import org.jetbrains.annotations.NotNull;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class TermsandConditionsActivity extends BaseActivity {

    Button proceedbtn;
    String phoneNumber1 = " ";
    IRetrofit retrofitService;
    private static final int CREDENTIAL_PICKER_REQUEST = 1;
    String currentVersion;
    DisplayMetrics metrics;
    ProgressBar progressBar;
    int width = 0, height = 0;
    TextView txthome;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_termsand_conditions);
        proceedbtn = findViewById(R.id.proceedbtn);
        progressBar = findViewById(R.id.progressBar);
        ConnectivityManager conMgr = (ConnectivityManager) getSystemService(Context.CONNECTIVITY_SERVICE);
      /*  NetworkInfo netInfo = conMgr.getActiveNetworkInfo();
        if (netInfo == null) {
            new AlertDialog.Builder(TermsandConditionsActivity.this)
                    .setTitle(getResources().getString(R.string.app_name))
                    .setMessage("Check Your Internet Connection!")
                    .setIcon(R.drawable.logo)
                    .setPositiveButton("OK", null).show();
        }*/

        proceedbtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                
                if (new SavePref(TermsandConditionsActivity.this).getMyPhoneNumber().isEmpty()) {

                    requestHint();
                } else {

                    ConnectivityManager conMgr = (ConnectivityManager) getSystemService(Context.CONNECTIVITY_SERVICE);
                    NetworkInfo netInfo = conMgr.getActiveNetworkInfo();
                    if (netInfo == null) {
                        new AlertDialog.Builder(TermsandConditionsActivity.this)
                                .setTitle(getResources().getString(R.string.app_name))
                                .setMessage("Check Your Internet Connection!")
                                .setIcon(R.drawable.logo)
                                .setPositiveButton("OK", null).show();
                    } else {
                        uploadFile();
                    }

                    //uploadFile();
                }


            }
        });
        metrics = new DisplayMetrics();
        getWindowManager().getDefaultDisplay().getMetrics(metrics);
        height = Math.min(metrics.widthPixels, metrics.heightPixels); //height
        width = Math.max(metrics.widthPixels, metrics.heightPixels);
        txthome = findViewById(R.id.txthome);
        new SavePref(TermsandConditionsActivity.this).setscreensize(width);

        retrofitService = ServiceGenerator.getClient().create(IRetrofit.class);

        try {
            currentVersion = getPackageManager().getPackageInfo(getPackageName(), 0).versionName;
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }
if(new SavePref(TermsandConditionsActivity.this).getMyPhoneNumber().equalsIgnoreCase(" ")){
    TelephonyManager tMgr = (TelephonyManager) getSystemService(TELEPHONY_SERVICE);

    if (ActivityCompat.checkSelfPermission(TermsandConditionsActivity.this,
            android.Manifest.permission.READ_SMS) != PackageManager.PERMISSION_GRANTED &&
            ActivityCompat.checkSelfPermission(TermsandConditionsActivity.this,
                    android.Manifest.permission.READ_PHONE_NUMBERS) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(TermsandConditionsActivity.this, android.Manifest.permission.READ_PHONE_STATE) != PackageManager.PERMISSION_GRANTED) {

        return;
    }
    mPhoneNumber = tMgr.getLine1Number();
    new SavePref(TermsandConditionsActivity.this).setMyPhoneNumber(mPhoneNumber);
}


        if (new SavePref(TermsandConditionsActivity.this).getMyPhoneNumber().equalsIgnoreCase(" ")) {
            requestHint();
        }

    }


    private void uploadFile() {
        progressBar.setVisibility(View.VISIBLE);
        JsonObject jsonObject = new JsonObject();
        jsonObject.addProperty("MobileNumber", new SavePref(TermsandConditionsActivity.this).getMyPhoneNumber());

        Call<mobilenumberdata> call = retrofitService.postRawJSON(jsonObject);
        call.enqueue(new Callback<mobilenumberdata>() {
            @Override
            public void onResponse(Call<mobilenumberdata> call, Response<mobilenumberdata> response) {
                try {

                    if (response.isSuccessful()) {
                        progressBar.setVisibility(View.GONE);
                        new SavePref(TermsandConditionsActivity.this).setmobilenumberdata(response.body().getMobileNumber());
                        new SavePref(TermsandConditionsActivity.this).setuserid(response.body().getId());
                        new SavePref(TermsandConditionsActivity.this).setcreatedat(response.body().getCreatedAt());
                        new SavePref(TermsandConditionsActivity.this).setupdatedat(response.body().getUpdatedAt());
                        startActivity(new Intent(TermsandConditionsActivity.this, ConsentAuthorization.class));
                        finish();
                    } else {
                        Toast.makeText(TermsandConditionsActivity.this, response.errorBody().string(), Toast.LENGTH_SHORT).show();
                    }
                } catch (Exception e) {
                    switch (response.code()) {
                        case 404:

                            new AlertDialog.Builder(TermsandConditionsActivity.this)
                                    .setTitle(getResources().getString(R.string.app_name))
                                    .setMessage("Server not found !")
                                    .setIcon(R.drawable.logo)
                                    .setPositiveButton("Try again", new DialogInterface.OnClickListener() {
                                        public void onClick(DialogInterface dialog, int id) {
                                            startActivity(new Intent(TermsandConditionsActivity.this, TermsandConditionsActivity.class));
                                        }
                                    }).show();
                            break;
                        case 500:
                            new AlertDialog.Builder(TermsandConditionsActivity.this)
                                    .setTitle(getResources().getString(R.string.app_name))
                                    .setMessage("server broken!")
                                    .setIcon(R.drawable.logo)
                                    .setPositiveButton("Try again", new DialogInterface.OnClickListener() {
                                        public void onClick(DialogInterface dialog, int id) {
                                            startActivity(new Intent(TermsandConditionsActivity.this, TermsandConditionsActivity.class));
                                        }
                                    }).show();

                            break;
                        default:

                            new AlertDialog.Builder(TermsandConditionsActivity.this)
                                    .setTitle(getResources().getString(R.string.app_name))
                                    .setMessage("unknown error")
                                    .setIcon(R.drawable.logo)
                                    .setPositiveButton("Try again", new DialogInterface.OnClickListener() {
                                        public void onClick(DialogInterface dialog, int id) {
                                            startActivity(new Intent(TermsandConditionsActivity.this, TermsandConditionsActivity.class));
                                        }
                                    }).show();
                            break;
                    }

                    Toast.makeText(TermsandConditionsActivity.this, e.getMessage(), Toast.LENGTH_SHORT).show();
                    e.printStackTrace();
                }
            }

            @Override
            public void onFailure(Call<mobilenumberdata> call, Throwable t) {
                Log.e("response-failure", call.toString());
                startActivity(new Intent(TermsandConditionsActivity.this, ConsentAuthorization.class));
                finish();
               /* new AlertDialog.Builder(TermsandConditionsActivity.this)
                        .setTitle(getResources().getString(R.string.app_name))
                        .setMessage("Check Your Internet Connection!")
                        .setIcon(R.drawable.logo)
                        .setPositiveButton("Try again", new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialog, int id) {
                                startActivity(new Intent(TermsandConditionsActivity.this, TermsandConditionsActivity.class));
                            }
                        }).show();*/
            }
        });
    }


    private void requestHint() {
        CredentialPickerConfig conf  = new CredentialPickerConfig.Builder()
                .setShowAddAccountButton(false)
                .build();
        HintRequest hintRequest = new HintRequest.Builder()
                .setPhoneNumberIdentifierSupported(true)
                .setHintPickerConfig(conf)
                .build();
        PendingIntent intent = Credentials.getClient(this).getHintPickerIntent(hintRequest);
        try {
            startIntentSenderForResult(intent.getIntentSender(), CREDENTIAL_PICKER_REQUEST, null, 0, 0, 0, new Bundle());
        } catch (IntentSender.SendIntentException e) {
            e.printStackTrace();
        }
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {

        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == CREDENTIAL_PICKER_REQUEST && resultCode == RESULT_OK)
        {

            Credential credentials = data.getParcelableExtra(Credential.EXTRA_KEY);

            phoneNumber1=credentials.getId();

            new SavePref(TermsandConditionsActivity.this).setMyPhoneNumber(phoneNumber1);

        }
        else if (requestCode == CREDENTIAL_PICKER_REQUEST && resultCode == CredentialsApi.ACTIVITY_RESULT_NO_HINTS_AVAILABLE)
        {
            // *** No phone numbers available ***
            Toast.makeText(TermsandConditionsActivity.this, "No phone numbers found", Toast.LENGTH_LONG).show();
        }


    }
    @Override
    public void onConfigurationChanged(@NotNull Configuration newConfig) {
        super.onConfigurationChanged(newConfig);

        if (newConfig.orientation == Configuration.ORIENTATION_LANDSCAPE) {
            Toast.makeText(this, "landscape", Toast.LENGTH_SHORT).show();
            txthome.setTextSize(TypedValue.COMPLEX_UNIT_SP,10);
        } else if (newConfig.orientation == Configuration.ORIENTATION_PORTRAIT){
            txthome.setTextSize(TypedValue.COMPLEX_UNIT_SP,18);
            Toast.makeText(this, "portrait", Toast.LENGTH_SHORT).show();
        }
    }

}