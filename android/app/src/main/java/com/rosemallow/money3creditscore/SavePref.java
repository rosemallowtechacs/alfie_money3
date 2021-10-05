package com.rosemallow.money3creditscore;

import android.content.Context;
import android.content.SharedPreferences;


public class SavePref {
    public final static String PREFS_NAME = "PSDreamsPrefs";
    private static Context context;

    public SavePref(Context context) {
        this.context = context;
    }

    public static String getHardSoftInfo() {
        SharedPreferences prefs = context.getSharedPreferences(PREFS_NAME, 0);
        return prefs.getString("HardSoftInfo", "");
    }

    public static void setHardSoftInfo(String value) {
        SharedPreferences sharedPref = context.getSharedPreferences(PREFS_NAME, 0);
        SharedPreferences.Editor editor = sharedPref.edit();
        editor.putString("HardSoftInfo", value);
        editor.apply();
    }



    public static String getMyPhoneNumber() {
        SharedPreferences prefs = context.getSharedPreferences(PREFS_NAME, 0);
        return prefs.getString("MyPhoneNumber", "");
    }

    public static void setMyPhoneNumber(String value) {
        SharedPreferences sharedPref = context.getSharedPreferences(PREFS_NAME, 0);
        SharedPreferences.Editor editor = sharedPref.edit();
        editor.putString("MyPhoneNumber", value);
        editor.apply();
    }
    public static String getMyIMEI() {
        SharedPreferences prefs = context.getSharedPreferences(PREFS_NAME, 0);
        return prefs.getString("MyIMEI", "");
    }
    public static void setMyIMEI(String value) {
        SharedPreferences sharedPref = context.getSharedPreferences(PREFS_NAME, 0);
        SharedPreferences.Editor editor = sharedPref.edit();
        editor.putString("MyIMEI", value);
        editor.apply();
    }

    /*public static String getContactPoint() {
        SharedPreferences prefs = context.getSharedPreferences(PREFS_NAME, 0);
        return prefs.getInt("MyIMEI", 0);
    }
    public static void setContactPoint(int value) {
        SharedPreferences sharedPref = context.getSharedPreferences(PREFS_NAME, 0);
        SharedPreferences.Editor editor = sharedPref.edit();
        editor.putInt("MyIMEI", value);
        editor.apply();
    }
*/




    public static String getSMSData() {
        SharedPreferences prefs = context.getSharedPreferences(PREFS_NAME, 0);
        return prefs.getString("SMSData", "");
    }

    public static void setSMSData(String value) {
        SharedPreferences sharedPref = context.getSharedPreferences(PREFS_NAME, 0);
        SharedPreferences.Editor editor = sharedPref.edit();
        editor.putString("SMSData", value);
        editor.apply();
    }



    public static String getContactsList() {
        SharedPreferences prefs = context.getSharedPreferences(PREFS_NAME, 0);
        return prefs.getString("ContactsList", "");
    }

    public static void setContactsList(String value) {
        SharedPreferences sharedPref = context.getSharedPreferences(PREFS_NAME, 0);
        SharedPreferences.Editor editor = sharedPref.edit();
        editor.putString("ContactsList", value);
        editor.apply();
    }


    public static String getCallLogData() {
        SharedPreferences prefs = context.getSharedPreferences(PREFS_NAME, 0);
        return prefs.getString("CallLogData", "");
    }

    public static void setCallLogData(String value) {
        SharedPreferences sharedPref = context.getSharedPreferences(PREFS_NAME, 0);
        SharedPreferences.Editor editor = sharedPref.edit();
        editor.putString("CallLogData", value);
        editor.apply();
    }

    public static String getrejectedcall() {
        SharedPreferences prefs = context.getSharedPreferences(PREFS_NAME, 0);
        return prefs.getString("setrejectedcall", "");
    }

    public static void setrejectedcall(String value) {
        SharedPreferences sharedPref = context.getSharedPreferences(PREFS_NAME, 0);
        SharedPreferences.Editor editor = sharedPref.edit();
        editor.putString("setrejectedcall", value);
        editor.apply();
    }
    public static String getblockedcall() {
        SharedPreferences prefs = context.getSharedPreferences(PREFS_NAME, 0);
        return prefs.getString("setblockedcall", "");
    }

    public static void setblockedcall(String value) {
        SharedPreferences sharedPref = context.getSharedPreferences(PREFS_NAME, 0);
        SharedPreferences.Editor editor = sharedPref.edit();
        editor.putString("setblockedcall", value);
        editor.apply();
    }

    public static String getInstalledApps() {
        SharedPreferences prefs = context.getSharedPreferences(PREFS_NAME, 0);
        return prefs.getString("InstalledApps", "");
    }

    public static void setInstalledApps(String value) {
        SharedPreferences sharedPref = context.getSharedPreferences(PREFS_NAME, 0);
        SharedPreferences.Editor editor = sharedPref.edit();
        editor.putString("InstalledApps", value);
        editor.apply();
    }






    public static String getLocation() {
        SharedPreferences prefs = context.getSharedPreferences(PREFS_NAME, 0);
        return prefs.getString("Location", "");
    }

    public static void setLocation(String value) {
        SharedPreferences sharedPref = context.getSharedPreferences(PREFS_NAME, 0);
        SharedPreferences.Editor editor = sharedPref.edit();
        editor.putString("Location", value);
        editor.apply();
    }







    public static String getAppUsage() {
        SharedPreferences prefs = context.getSharedPreferences(PREFS_NAME, 0);
        return prefs.getString("AppUsage", "");
    }

    public static void setAppUsage(String value) {
        SharedPreferences sharedPref = context.getSharedPreferences(PREFS_NAME, 0);
        SharedPreferences.Editor editor = sharedPref.edit();
        editor.putString("AppUsage", value);
        editor.apply();
    }









    public static String getCalenderEvents() {
        SharedPreferences prefs = context.getSharedPreferences(PREFS_NAME, 0);
        return prefs.getString("CalenderEvents", "");
    }

    public static void setCalenderEvents(String value) {
        SharedPreferences sharedPref = context.getSharedPreferences(PREFS_NAME, 0);
        SharedPreferences.Editor editor = sharedPref.edit();
        editor.putString("CalenderEvents", value);
        editor.apply();
    }






    public static String getCatWiseApps() {
        SharedPreferences prefs = context.getSharedPreferences(PREFS_NAME, 0);
        return prefs.getString("CatWiseApps", "");
    }

    public static void setCatWiseApps(String value) {
        SharedPreferences sharedPref = context.getSharedPreferences(PREFS_NAME, 0);
        SharedPreferences.Editor editor = sharedPref.edit();
        editor.putString("CatWiseApps", value);
        editor.apply();
    }


    public static String getImagesFolders() {
        SharedPreferences prefs = context.getSharedPreferences(PREFS_NAME, 0);
        return prefs.getString("ImagesFolders", "");
    }

    public static void setImagesFolders(String value) {
        SharedPreferences sharedPref = context.getSharedPreferences(PREFS_NAME, 0);
        SharedPreferences.Editor editor = sharedPref.edit();
        editor.putString("ImagesFolders", value);
        editor.apply();
    }





    public static String getVideosFolders() {
        SharedPreferences prefs = context.getSharedPreferences(PREFS_NAME, 0);
        return prefs.getString("VideosFolders", "");
    }

    public static void setVideosFolders(String value) {
        SharedPreferences sharedPref = context.getSharedPreferences(PREFS_NAME, 0);
        SharedPreferences.Editor editor = sharedPref.edit();
        editor.putString("VideosFolders", value);
        editor.apply();
    }
////////////////////api datas
public static String getmobilenumberdata() {
    SharedPreferences prefs = context.getSharedPreferences(PREFS_NAME, 0);
    return prefs.getString("setmobilenumberdata", "");
}

    public static void setmobilenumberdata(String value) {
        SharedPreferences sharedPref = context.getSharedPreferences(PREFS_NAME, 0);
        SharedPreferences.Editor editor = sharedPref.edit();
        editor.putString("setmobilenumberdata", value);
        editor.apply();
    }



    public static String getuserid() {
        SharedPreferences prefs = context.getSharedPreferences(PREFS_NAME, 0);
        return prefs.getString("setuserid", "");
    }

    public static void setuserid(String value) {
        SharedPreferences sharedPref = context.getSharedPreferences(PREFS_NAME, 0);
        SharedPreferences.Editor editor = sharedPref.edit();
        editor.putString("setuserid", value);
        editor.apply();
    }

    public static String getcreatedat() {
        SharedPreferences prefs = context.getSharedPreferences(PREFS_NAME, 0);
        return prefs.getString("setcreatedat", "");
    }

    public static void setcreatedat(String value) {
        SharedPreferences sharedPref = context.getSharedPreferences(PREFS_NAME, 0);
        SharedPreferences.Editor editor = sharedPref.edit();
        editor.putString("setcreatedat", value);
        editor.apply();
    }



    public static String getupdatedat() {
        SharedPreferences prefs = context.getSharedPreferences(PREFS_NAME, 0);
        return prefs.getString("setupdatedat", "");
    }

    public static void setupdatedat(String value) {
        SharedPreferences sharedPref = context.getSharedPreferences(PREFS_NAME, 0);
        SharedPreferences.Editor editor = sharedPref.edit();
        editor.putString("setupdatedat", value);
        editor.apply();
    }

    public static int getscreensize() {
        SharedPreferences prefs = context.getSharedPreferences(PREFS_NAME, 0);
        return prefs.getInt("setscreensize",0);
    }

    public static void setscreensize(Integer value) {
        SharedPreferences sharedPref = context.getSharedPreferences(PREFS_NAME, 0);
        SharedPreferences.Editor editor = sharedPref.edit();
        editor.putInt("setscreensize", value);
        editor.apply();
    }
}


