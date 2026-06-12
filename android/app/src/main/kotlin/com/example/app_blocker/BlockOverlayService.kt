package com.example.app_blocker

import android.app.*
import android.content.Context
import android.content.Intent
import android.graphics.PixelFormat
import android.os.Build
import android.os.IBinder
import android.view.LayoutInflater
import android.view.View
import android.view.WindowManager
import android.app.usage.UsageStatsManager
import android.app.usage.UsageEvents
import kotlinx.coroutines.*

class BlockService  : Service() {

    private lateinit var windowManager: WindowManager
    private var overlayView: View? = null

    private val scope = CoroutineScope(Dispatchers.Default + Job())

    private fun getBlockedApps(): Set<String> {
        val prefs = getSharedPreferences("block_prefs", Context.MODE_PRIVATE)
        return prefs.getStringSet("blocked_apps", setOf()) ?: setOf()
    }

    override fun onCreate() {
        super.onCreate()
        windowManager = getSystemService(WINDOW_SERVICE) as WindowManager
        startForegroundServiceNotification()
        startMonitoring()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        return START_STICKY
    }

    private fun startMonitoring() {
        scope.launch {
            while (true) {
                checkForegroundApp()
                delay(800) // بدون لگ (هر 0.8 ثانیه)
            }
        }
    }

    private fun checkForegroundApp() {
        val usageStatsManager =
            getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager

        val endTime = System.currentTimeMillis()
        val beginTime = endTime - 2000

        val events = usageStatsManager.queryEvents(beginTime, endTime)
        val event = UsageEvents.Event()

        var foregroundApp: String? = null

        while (events.hasNextEvent()) {
            events.getNextEvent(event)
            if (event.eventType == UsageEvents.Event.MOVE_TO_FOREGROUND) {
                foregroundApp = event.packageName
            }
        }

        foregroundApp?.let {
            if (getBlockedApps().contains(it)) {
                showOverlay()
            } else {
                removeOverlay()
            }
        }
    }

    private fun showOverlay() {
        if (overlayView != null) return

        overlayView = LayoutInflater.from(this)
            .inflate(android.R.layout.simple_list_item_1, null)

        val params = WindowManager.LayoutParams(
            WindowManager.LayoutParams.MATCH_PARENT,
            WindowManager.LayoutParams.MATCH_PARENT,
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
                WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
            else
                WindowManager.LayoutParams.TYPE_PHONE,
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or
                    WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN,
            PixelFormat.TRANSLUCENT
        )

        overlayView?.setBackgroundColor(0xCC000000.toInt()) // نیمه مشکی

        windowManager.addView(overlayView, params)
    }

    private fun removeOverlay() {
        overlayView?.let {
            windowManager.removeView(it)
            overlayView = null
        }
    }

    private fun startForegroundServiceNotification() {
        val channelId = "block_service_channel"

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                channelId,
                "Block Service",
                NotificationManager.IMPORTANCE_LOW
            )

            val manager = getSystemService(NotificationManager::class.java)
            manager.createNotificationChannel(channel)
        }

        val notification = Notification.Builder(this, channelId)
            .setContentTitle("App Blocker Active")
            .setContentText("Monitoring apps...")
            .setSmallIcon(android.R.drawable.ic_lock_lock)
            .build()

        startForeground(1, notification)
    }

    override fun onDestroy() {
        super.onDestroy()
        scope.cancel()
        removeOverlay()
    }

    override fun onBind(intent: Intent?): IBinder? = null
}