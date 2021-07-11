package antmoira.med_reminder

import android.content.ContentResolver;
import android.content.Context;
import android.media.RingtoneManager;
import android.os.Bundle;

import java.util.TimeZone;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;


class MainActivity: FlutterActivity() {
    private fun resourceToUriString(context: Context, resId: Int): String? {
        return (ContentResolver.SCHEME_ANDROID_RESOURCE
                .toString() + "://"
                + context.getResources().getResourcePackageName(resId)
                + "/"
                + context.getResources().getResourceTypeName(resId)
                + "/"
                + context.getResources().getResourceEntryName(resId))
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        MethodChannel(flutterEngine.getDartExecutor(), "antmoira/med_reminder_notifications").setMethodCallHandler(
                { call, result ->
                    if ("drawableToUri" == call.method) {
                        val resourceId: Int = this@MainActivity.getResources().getIdentifier(call.arguments as String, "drawable", this@MainActivity.getPackageName())
                        result.success(resourceToUriString(this@MainActivity.getApplicationContext(), resourceId))
                    }
                    if ("getAlarmUri" == call.method) {
                        result.success(RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM).toString())
                    }
                    if ("getTimeZoneName" == call.method) {
                        result.success(TimeZone.getDefault().id)
                    }
                })
    }
}
