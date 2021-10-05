package com.rosemallow.money3creditscore;
import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.plugins.util.GeneratedPluginRegister;
import io.flutter.plugin.common.MethodChannel;

import android.app.PendingIntent;
import android.content.Intent;
import android.content.IntentSender;
import android.os.Bundle;
import android.widget.Toast;

import com.google.android.gms.auth.api.credentials.Credential;
import com.google.android.gms.auth.api.credentials.CredentialPickerConfig;
import com.google.android.gms.auth.api.credentials.Credentials;
import com.google.android.gms.auth.api.credentials.CredentialsApi;
import com.google.android.gms.auth.api.credentials.HintRequest;


public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "heartbeat.fritz.ai/native";
    private static final int CREDENTIAL_PICKER_REQUEST = 1;
    String phoneNumber1="1234567890";
    MethodChannel.Result mResult;
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        //GeneratedPluginRegistrant.registerWith(flutterEngine);
        GeneratedPluginRegister.registerGeneratedPlugins(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    if (call.method.equals("mobileNumber")) {

                        mResult = result;
                        requestHint();

                    }
                    if (call.method.equals("ActivityStart")) {
                        String mobilenumber = call.argument("mobilenumber");

                        new SavePref(MainActivity.this).setMyPhoneNumber(mobilenumber);

                        Toast.makeText(MainActivity.this, mobilenumber, Toast.LENGTH_LONG).show();
                        Intent i = new Intent(getApplicationContext(), TermsandConditionsActivity.class);
                        startActivity(i);

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
            mResult.success(phoneNumber1);
        }
        else if (requestCode == CREDENTIAL_PICKER_REQUEST && resultCode == CredentialsApi.ACTIVITY_RESULT_NO_HINTS_AVAILABLE)
        {
            Toast.makeText(MainActivity.this, "No phone numbers found", Toast.LENGTH_LONG).show();
        }
    }
}