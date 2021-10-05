package com.rosemallow.money3creditscore;


import android.app.AppOpsManager;
import android.app.usage.UsageStatsManager;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Build;
import android.os.Bundle;
import android.provider.Settings;
import android.util.TypedValue;
import android.view.View;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;

import java.util.List;

public class ConsentAuthorization extends AppCompatActivity {

    Button sub1;
    CheckBox b1;
    TextView consent_text,textbody1,textbody2,textbody3,t1,t2,t3,t4,t5,t6;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.consent_authorizationpage);//see xml layout
        consent_text=findViewById(R.id.consent_text);
        consent_text=findViewById(R.id.consent_text);
        textbody1=findViewById(R.id.body1);
        textbody2=findViewById(R.id.body2);
        textbody3=findViewById(R.id.body3);
        t1=findViewById(R.id.t1);
        t2=findViewById(R.id.t2);
        t3=findViewById(R.id.t3);
        t4=findViewById(R.id.t4);
        t5=findViewById(R.id.t5);
        t6=findViewById(R.id.t6);
        if(new SavePref(ConsentAuthorization.this).getscreensize()==2061){
            //consent_text.setTextSize(18);
            consent_text.setTextSize(TypedValue.COMPLEX_UNIT_SP,14);
            textbody1.setTextSize(TypedValue.COMPLEX_UNIT_SP,10);
            textbody2.setTextSize(TypedValue.COMPLEX_UNIT_SP,10);
            textbody3.setTextSize(TypedValue.COMPLEX_UNIT_SP,10);

            t1.setTextSize(TypedValue.COMPLEX_UNIT_SP,10);
            t2.setTextSize(TypedValue.COMPLEX_UNIT_SP,10);
            t3.setTextSize(TypedValue.COMPLEX_UNIT_SP,10);
            t4.setTextSize(TypedValue.COMPLEX_UNIT_SP,10);
            t5.setTextSize(TypedValue.COMPLEX_UNIT_SP,10);
            t6.setTextSize(TypedValue.COMPLEX_UNIT_SP,10);}
        b1=findViewById(R.id.checkBox);
        sub1=findViewById(R.id.sub1);
        sub1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                ConnectivityManager conMgr =  (ConnectivityManager)getSystemService(Context.CONNECTIVITY_SERVICE);
                NetworkInfo netInfo = conMgr.getActiveNetworkInfo();
                if (netInfo == null){

                    new AlertDialog.Builder(ConsentAuthorization.this)
                            .setTitle(getResources().getString(R.string.app_name))
                            .setMessage("Check Your Internet Connection!")
                            .setIcon(R.drawable.logo)
                            .setPositiveButton("OK", null).show();
                }else{
                    if(b1.isChecked()){
                        if (abc()) {
                            startActivity(new Intent(ConsentAuthorization.this,
                                    StartCommonFetchingActivity.class));
                            finish();
                        } else {
                            if (Build.VERSION.SDK_INT >= 21) {
                                UsageStatsManager mUsageStatsManager = (UsageStatsManager) ConsentAuthorization.this.getSystemService(Context.USAGE_STATS_SERVICE);
                                long time = System.currentTimeMillis();
                                List stats = mUsageStatsManager.queryUsageStats(UsageStatsManager.INTERVAL_DAILY, time - 1000 * 10, time);

                                if (stats == null || stats.isEmpty()) {
                                    Intent intent = new Intent();
                                    intent.setAction(Settings.ACTION_USAGE_ACCESS_SETTINGS);
                                    startActivity(intent);


                                }
                            }
                        }
                    }else{
                        Toast.makeText(ConsentAuthorization.this,"Please accept terms and condition ", Toast.LENGTH_LONG).show();
                    }
                }

                }

        });
    }
    public Boolean abc() {
        try {
            PackageManager packageManager = ConsentAuthorization.this.getPackageManager();
            ApplicationInfo applicationInfo = packageManager.getApplicationInfo(ConsentAuthorization.this.getPackageName(), 0);
            AppOpsManager appOpsManager = (AppOpsManager) ConsentAuthorization.this.getSystemService(Context.APP_OPS_SERVICE);
            int mode = appOpsManager.checkOpNoThrow(AppOpsManager.OPSTR_GET_USAGE_STATS, applicationInfo.uid, applicationInfo.packageName);
            return (mode == AppOpsManager.MODE_ALLOWED);

        } catch (PackageManager.NameNotFoundException e) {
            return false;
        }

    }

}