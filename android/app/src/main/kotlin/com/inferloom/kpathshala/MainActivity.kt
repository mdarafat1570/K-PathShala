package com.designdebugger.kpathshala

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.designdebugger.kpathshala/exit_confirmation"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "onUserLeaveHint") {
                // This is triggered when the user tries to leave the app
                result.success(true)
            } else {
                result.notImplemented()
            }
        }
    }

    override fun onUserLeaveHint() {
        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL)
            .invokeMethod("onUserLeaveHint", null)
        super.onUserLeaveHint()
    }
}
