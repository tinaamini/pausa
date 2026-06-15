package com.example.app_blocker

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.app.usage.UsageStatsManager
import android.content.Context
import android.content.Intent
import android.graphics.PixelFormat
import android.os.Build
import android.os.IBinder
import android.view.LayoutInflater
import android.view.View
import android.view.WindowManager
import kotlinx.coroutines.*

class BlockService : Service() {

    private lateinit var windowManager: WindowManager
    private var overlayView: View? = null

    private val serviceScope = CoroutineScope(SupervisorJob() + Dispatchers.Main)

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

    override fun onStartCommand(
        intent: Intent?,
        flags: Int,
        startId: Int
    ): Int {
        return START_STICKY
    }

    private fun startMonitoring() {
        serviceScope.launch {
            while (isActive) {
                checkForegroundApp()
                delay(800)
            }
        }
    }

    private suspend fun checkForegroundApp() {

        val foregroundApp = withContext(Dispatchers.Default) {

            val usageStatsManager =
                getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager

            val endTime = System.currentTimeMillis()
            val beginTime = endTime - 10_000

            val usageStats = usageStatsManager.queryUsageStats(
                UsageStatsManager.INTERVAL_DAILY,
                beginTime,
                endTime
            )

            if (usageStats.isNullOrEmpty()) {
                null
            } else {
                usageStats
                    .filter { it.lastTimeUsed > 0 }
                    .maxByOrNull { it.lastTimeUsed }
                    ?.packageName
            }
        }

        android.util.Log.d("BlockService", "foreground: $foregroundApp")
        android.util.Log.d("BlockService", "blocked: ${getBlockedApps()}")

        if (foregroundApp == null) {
            removeOverlay()
            return
        }

        if (foregroundApp == packageName) {
            removeOverlay()
            return
        }

        if (getBlockedApps().contains(foregroundApp)) {
            android.util.Log.d(
                "BlockService",
                "🚫 BLOCKING: $foregroundApp"
            )
            showOverlay()
        } else {
            removeOverlay()
        }
    }

    private fun showOverlay() {

        if (overlayView != null) return

        overlayView = LayoutInflater.from(this)
            .inflate(android.R.layout.simple_list_item_1, null)

        overlayView?.setBackgroundColor(
            0xCC000000.toInt()
        )

        val params = WindowManager.LayoutParams(
            WindowManager.LayoutParams.MATCH_PARENT,
            WindowManager.LayoutParams.MATCH_PARENT,
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
                WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
            else
                WindowManager.LayoutParams.TYPE_PHONE,
            WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN,
            PixelFormat.TRANSLUCENT
        )

        windowManager.addView(
            overlayView,
            params
        )
    }

    private fun removeOverlay() {

        overlayView?.let {

            try {
                windowManager.removeView(it)
            } catch (_: Exception) {
            }

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

            val manager =
                getSystemService(NotificationManager::class.java)

            manager.createNotificationChannel(channel)
        }

        val notification = Notification.Builder(
            this,
            channelId
        )
            .setContentTitle("App Blocker Active")
            .setContentText("Monitoring apps...")
            .setSmallIcon(android.R.drawable.ic_lock_lock)
            .build()

        startForeground(1, notification)
    }

    override fun onDestroy() {
        super.onDestroy()

        serviceScope.cancel()
        removeOverlay()
    }

    override fun onBind(intent: Intent?): IBinder? = null
}