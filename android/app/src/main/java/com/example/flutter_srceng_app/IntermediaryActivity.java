package com.example.flutter_srceng_app;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.StrictMode;

import org.libsdl.app.SDLActivity;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.app.AppCompatActivity;
public class IntermediaryActivity extends AppCompatActivity {
    public static String srcengDir = "";

    @Override
protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

  /*  String dir = getIntent().getStringExtra("srcengDir");
    if (dir != null) {
        srcengDir = dir;
    }*/

    runGame();
    finish(); //end 
}

    public void runGame() {
        Intent intent = new Intent(this, SDLActivity.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        startActivity(intent);
    }
}
