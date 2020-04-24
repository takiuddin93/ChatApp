package com.example.chatapp;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.WindowManager;

import com.example.chatapp.services.MyFirebaseMessagingService;

import java.util.Objects;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "TokenChannel";
    private static final String TAG = "MainActivity";
    private Intent startService;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_SECURE, WindowManager.LayoutParams.FLAG_SECURE);

        new MethodChannel(Objects.requireNonNull(getFlutterEngine()).getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler(
                (call, result) -> {
                    String token = call.method;
                    startService =new Intent(MainActivity.this, MyFirebaseMessagingService.class);
                    startService.putExtra("Token", token);
                    startService(startService);
                    Log.d(TAG, "onCreate: " + token);
                }
        );
    }
}
