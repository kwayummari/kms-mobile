package com.example.kms

import io.flutter.embedding.android.FlutterActivity
import androidx.multidex.MultiDex
import android.os.Bundle

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        MultiDex.install(this)
    }
}
