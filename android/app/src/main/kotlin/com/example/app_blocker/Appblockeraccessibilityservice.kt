package com.example.app_blocker

import android.accessibilityservice.AccessibilityService
import android.accessibilityservice.AccessibilityServiceInfo
import android.content.Context
import android.graphics.PixelFormat
import android.os.Build
import android.view.LayoutInflater
import android.view.View
import android.view.WindowManager
import android.view.accessibility.AccessibilityEvent

class AppBlockerAccessibilityService : AccessibilityService() {

    private var windowManager: WindowManager? = null
    private var overlayView: View? = null
    private var overlayShownAt: Long = 0
    private val OVERLAY_COOLDOWN_MS = 3000L

    override fun onServiceConnected() {
        windowManager = getSystemService(WINDOW_SERVICE) as WindowManager

        val info = AccessibilityServiceInfo()
        info.eventTypes = AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED
        info.feedbackType = AccessibilityServiceInfo.FEEDBACK_GENERIC
        info.flags = AccessibilityServiceInfo.FLAG_INCLUDE_NOT_IMPORTANT_VIEWS
        info.notificationTimeout = 100
        serviceInfo = info
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent) {
        if (event.eventType != AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) return

        val packageName = event.packageName?.toString() ?: return

        // خود app رو بلاک نکن
        if (packageName == this.packageName) {
            removeOverlay()
            return
        }

        val blockedApps = getBlockedApps()

        if (blockedApps.contains(packageName)) {
            android.util.Log.d("AccessibilityBlocker", "🚫 BLOCKING: $packageName")
            showOverlay()
        } else {
            removeOverlay()
        }
    }

    private fun getBlockedApps(): Set<String> {
        val prefs = getSharedPreferences("block_prefs", Context.MODE_PRIVATE)
        return prefs.getStringSet("blocked_apps", setOf()) ?: setOf()
    }

    private fun showOverlay() {
        if (overlayView != null) return

        overlayShownAt = System.currentTimeMillis()

        overlayView = LayoutInflater.from(this)
            .inflate(android.R.layout.simple_list_item_1, null)

        overlayView?.setBackgroundColor(0xCC000000.toInt())

        val params = WindowManager.LayoutParams(
            WindowManager.LayoutParams.MATCH_PARENT,
            WindowManager.LayoutParams.MATCH_PARENT,
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
                WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
            else
                WindowManager.LayoutParams.TYPE_PHONE,
            WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN or
                    WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL,
            PixelFormat.TRANSLUCENT
        )

        windowManager?.addView(overlayView, params)
    }

    private fun removeOverlay() {
        if (overlayView != null) {
            val elapsed = System.currentTimeMillis() - overlayShownAt
            if (elapsed < OVERLAY_COOLDOWN_MS) return
        }

        overlayView?.let {
            try {
                windowManager?.removeView(it)
            } catch (_: Exception) {}
            overlayView = null
        }
    }

    override fun onInterrupt() {
        removeOverlay()
    }

    override fun onDestroy() {
        super.onDestroy()
        removeOverlay()
    }
}