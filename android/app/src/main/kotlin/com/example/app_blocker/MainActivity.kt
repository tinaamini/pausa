package com.example.app_blocker

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.app.usage.UsageStatsManager
import android.app.usage.UsageEvents
import android.graphics.PixelFormat
import android.view.Gravity
import android.view.WindowManager
import android.widget.LinearLayout
import android.widget.TextView

class MainActivity : FlutterActivity() {
    private val CHANNEL = "app_blocker_channel"
    private var overlayView: LinearLayout? = null
    private var wm: WindowManager? = null
    private var isOverlayVisible = false


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
                    "showOverlay" -> {
                        showBlockOverlay()
                        result.success("shown")
                    }
                    "canDrawOverlays" -> {
                        val canDraw = android.provider.Settings.canDrawOverlays(this)
                        result.success(canDraw)
                    }
                    "removeOverlay" -> {
                        removeOverlay()
                        result.success("removed")
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
            val appInfo = pkg.applicationInfo ?: continue // 👈 اگر null بود، برو بعدی
            // فقط اپ‌های کاربر (نه اپ‌های سیستمی)
            if ((appInfo.flags and android.content.pm.ApplicationInfo.FLAG_SYSTEM) == 0) {
                val label = pm.getApplicationLabel(appInfo).toString()
                val packageName = appInfo.packageName

                try {
                    val drawable = pm.getApplicationIcon(appInfo)
                    val bitmap = android.graphics.Bitmap.createBitmap(
                        drawable.intrinsicWidth,
                        drawable.intrinsicHeight,
                        android.graphics.Bitmap.Config.ARGB_8888
                    )
                    val canvas = android.graphics.Canvas(bitmap)
                    drawable.setBounds(0, 0, canvas.width, canvas.height)
                    drawable.draw(canvas)

                    val stream = java.io.ByteArrayOutputStream()
                    bitmap.compress(android.graphics.Bitmap.CompressFormat.PNG, 100, stream)
                    val encodedImage = android.util.Base64.encodeToString(stream.toByteArray(), android.util.Base64.NO_WRAP)

                    apps.add(
                        mapOf(
                            "name" to label,
                            "package" to packageName,
                            "icon" to encodedImage
                        )
                    )
                } catch (e: Exception) {
                    e.printStackTrace()
                }
            }
        }

        return apps
    }

    private fun getForegroundApp(): String {
        val usageStatsManager = getSystemService(USAGE_STATS_SERVICE) as UsageStatsManager
        val endTime = System.currentTimeMillis()
        val beginTime = endTime - 10_000 // بررسی ۱۰ ثانیه اخیر

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

    private fun showBlockOverlay() {
        if (!android.provider.Settings.canDrawOverlays(this)) {
            android.widget.Toast.makeText(this, "Overlay permission not granted", android.widget.Toast.LENGTH_SHORT).show()
            requestOverlayPermission()
            return
        }

        if (isOverlayVisible) return

        wm = getSystemService(WINDOW_SERVICE) as WindowManager

        val params = WindowManager.LayoutParams(
            WindowManager.LayoutParams.MATCH_PARENT,
            WindowManager.LayoutParams.MATCH_PARENT,
            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O)
                WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
            else
                WindowManager.LayoutParams.TYPE_PHONE,
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE
                    or WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL
                    or WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN,
            PixelFormat.TRANSLUCENT
        )

        overlayView = LinearLayout(this).apply {
            setBackgroundColor(android.graphics.Color.argb(180, 255, 0, 0))

            val textView = TextView(this@MainActivity).apply {
                text = "🚫 This app is blocked!"
                textSize = 22f
                setTextColor(android.graphics.Color.WHITE)
                gravity = Gravity.CENTER
                setPadding(60, 200, 60, 60)
            }

            addView(textView)
        }

        try {
            wm?.addView(overlayView, params)
            isOverlayVisible = true
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    private fun removeOverlay() {
        try {
            if (isOverlayVisible && wm != null && overlayView != null) {
                wm?.removeView(overlayView)
                isOverlayVisible = false
                overlayView = null
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    override fun onPause() {
        super.onPause()
        removeOverlay()
    }

    override fun onStop() {
        super.onStop()
        removeOverlay()
    }

    override fun onDestroy() {
        super.onDestroy()
        removeOverlay()
    }
}
