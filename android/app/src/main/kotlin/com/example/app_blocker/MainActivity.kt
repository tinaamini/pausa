

package com.example.app_blocker
import android.content.Context
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.app.usage.UsageStatsManager
import android.app.usage.UsageEvents

class MainActivity : FlutterActivity() {
    private val CHANNEL = "app_blocker_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getInstalledApps" -> result.success(getInstalledAppsList())
                    "getForegroundApp" -> result.success(getForegroundApp())
                    "requestUsagePermission" -> {
                        requestUsagePermission()
                        result.success("opened")
                    }
                    "requestOverlayPermission" -> {
                        requestOverlayPermission()
                        result.success("opened")
                    }
                    "canDrawOverlays" -> {
                        result.success(android.provider.Settings.canDrawOverlays(this))
                    }
                    "showOverlay" -> {
                        // از Service صدا میزنیم نه اینجا
                        startBlockService()
                        result.success("started")
                    }
                    "removeOverlay" -> {
                        stopBlockService()
                        result.success("removed")
                    }

                    "updateBlockedApps" -> {
                        val apps = call.argument<List<String>>("apps") ?: listOf()
                        saveBlockedApps(apps)
                        result.success(true)
                    }

                    else -> result.notImplemented()
                }
            }
    }

    private fun getInstalledAppsList(): List<Map<String, String>> {
        val pm = applicationContext.packageManager
        val packages = pm.getInstalledPackages(0)
        val apps = mutableListOf<Map<String, String>>()

        for (pkg in packages) {
            val appInfo = pkg.applicationInfo ?: continue
            if ((appInfo.flags and android.content.pm.ApplicationInfo.FLAG_SYSTEM) == 0) {
                val label = pm.getApplicationLabel(appInfo).toString()
                val packageName = appInfo.packageName

                try {
                    val drawable = pm.getApplicationIcon(appInfo)
                    val bitmap = android.graphics.Bitmap.createBitmap(
                        drawable.intrinsicWidth.coerceAtLeast(1),
                        drawable.intrinsicHeight.coerceAtLeast(1),
                        android.graphics.Bitmap.Config.ARGB_8888
                    )
                    val canvas = android.graphics.Canvas(bitmap)
                    drawable.setBounds(0, 0, canvas.width, canvas.height)
                    drawable.draw(canvas)

                    val stream = java.io.ByteArrayOutputStream()
                    bitmap.compress(android.graphics.Bitmap.CompressFormat.PNG, 85, stream)
                    bitmap.recycle()  // ← جلوگیری از memory leak

                    val encodedImage = android.util.Base64.encodeToString(
                        stream.toByteArray(),
                        android.util.Base64.NO_WRAP
                    )

                    apps.add(mapOf(
                        "name" to label,
                        "package" to packageName,
                        "icon" to encodedImage
                    ))
                } catch (e: Exception) {
                    // اگه آیکون نداشت بدون آیکون اضافه کن
                    apps.add(mapOf(
                        "name" to label,
                        "package" to packageName,
                        "icon" to ""
                    ))
                }
            }
        }

        return apps
    }

    private fun getForegroundApp(): String {
        val usageStatsManager = getSystemService(USAGE_STATS_SERVICE) as UsageStatsManager
        val endTime = System.currentTimeMillis()
        val beginTime = endTime - 1_000  // ۱ ثانیه کافیه

        val usageEvents = usageStatsManager.queryEvents(beginTime, endTime)
        var lastApp = "unknown"
        val event = UsageEvents.Event()

        while (usageEvents.hasNextEvent()) {
            usageEvents.getNextEvent(event)
            if (event.eventType == UsageEvents.Event.MOVE_TO_FOREGROUND) {
                lastApp = event.packageName
            }
        }
        return lastApp
    }

    private fun requestUsagePermission() {
        val intent = android.content.Intent(android.provider.Settings.ACTION_USAGE_ACCESS_SETTINGS)
        intent.addFlags(android.content.Intent.FLAG_ACTIVITY_NEW_TASK)
        startActivity(intent)
    }

    private fun requestOverlayPermission() {
        if (!android.provider.Settings.canDrawOverlays(this)) {
            val intent = android.content.Intent(
                android.provider.Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                android.net.Uri.parse("package:$packageName")
            )
            intent.addFlags(android.content.Intent.FLAG_ACTIVITY_NEW_TASK)
            startActivity(intent)
        }
    }

    private fun startBlockService() {
        val intent = android.content.Intent(this, BlockService::class.java)
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
            startForegroundService(intent)
        } else {
            startService(intent)
        }
    }

    private fun stopBlockService() {
        val intent = android.content.Intent(this, BlockService::class.java)
        stopService(intent)
    }


    private fun saveBlockedApps(apps: List<String>) {
        val prefs = getSharedPreferences("block_prefs", Context.MODE_PRIVATE)
        prefs.edit().putStringSet("blocked_apps", apps.toSet()).apply()
    }

    // onDestroy فقط نه onPause/onStop
    override fun onDestroy() {
        super.onDestroy()
    }
}