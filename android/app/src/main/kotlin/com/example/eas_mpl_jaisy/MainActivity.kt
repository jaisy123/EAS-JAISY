package com.example.eas_mpl_jaisy

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    // Menentukan nama jembatan penghubung antara Kotlin dan Flutter
    private val CHANNEL = "com.jaisy.eas/npm"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "reverseNpmNative") {
                val originalNpm = call.argument<String>("npm")
                if (originalNpm != null) {
                    // LOGIKA NATIVE KOTLIN: Membalikkan string NPM secara fisik di Android
                    val reversedNpm = originalNpm.reversed()
                    result.success(reversedNpm)
                } else {
                    result.error("INVALID_NPM", "NPM tidak boleh kosong", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}