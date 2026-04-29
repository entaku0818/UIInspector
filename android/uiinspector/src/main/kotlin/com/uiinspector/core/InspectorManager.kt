package com.uiinspector.core

import android.app.Activity
import android.app.Application
import android.graphics.Color
import android.os.Bundle
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import androidx.fragment.app.DialogFragment
import androidx.fragment.app.FragmentActivity
import com.uiinspector.ui.PluginMenuSheet

internal class InspectorManager(
    private val plugins: List<InspectorPlugin>
) : Application.ActivityLifecycleCallbacks, InspectorContext {

    override lateinit var activity: FragmentActivity
        private set

    private var overlayRoot: FrameLayout? = null
    private var floatingButton: FloatingButton? = null
    private var selectionOverlay: SelectionOverlayView? = null
    private val highlights = mutableListOf<View>()
    private var activePlugin: InspectorPlugin? = null
    private var currentPanel: DialogFragment? = null

    // MARK: - ActivityLifecycleCallbacks

    override fun onActivityCreated(a: Activity, b: Bundle?) {}
    override fun onActivityStarted(a: Activity) {}
    override fun onActivityStopped(a: Activity) {}
    override fun onActivitySaveInstanceState(a: Activity, b: Bundle) {}
    override fun onActivityDestroyed(a: Activity) {
        if (a === activity) teardown()
    }

    override fun onActivityResumed(a: Activity) {
        if (a is FragmentActivity) {
            activity = a
            setup(a)
        }
    }

    override fun onActivityPaused(a: Activity) {
        if (a === activity) teardown()
    }

    private fun setup(a: FragmentActivity) {
        val decor = a.window.decorView as? ViewGroup ?: return
        val overlay = FrameLayout(a)
        decor.addView(overlay, ViewGroup.LayoutParams(
            ViewGroup.LayoutParams.MATCH_PARENT,
            ViewGroup.LayoutParams.MATCH_PARENT
        ))
        overlayRoot = overlay

        val btn = FloatingButton(a)
        val size = (56 * a.resources.displayMetrics.density).toInt()
        val margin = (16 * a.resources.displayMetrics.density).toInt()
        val params = FrameLayout.LayoutParams(size, size).apply {
            rightMargin = margin
            bottomMargin = margin + (80 * a.resources.displayMetrics.density).toInt()
        }
        overlay.addView(btn, params)
        btn.x = (a.resources.displayMetrics.widthPixels - size - margin).toFloat()
        btn.y = (a.resources.displayMetrics.heightPixels - size - margin * 6).toFloat()
        btn.onTap = { showPluginMenu() }
        floatingButton = btn
    }

    private fun teardown() {
        activePlugin?.deactivate()
        activePlugin = null
        val decor = activity.window.decorView as? ViewGroup
        overlayRoot?.let { decor?.removeView(it) }
        overlayRoot = null
        floatingButton = null
        selectionOverlay = null
        highlights.clear()
        currentPanel = null
    }

    fun showPluginMenu() {
        val sheet = PluginMenuSheet.newInstance(plugins) { plugin ->
            activatePlugin(plugin)
        }
        sheet.show(activity.supportFragmentManager, "plugin_menu")
    }

    private fun activatePlugin(plugin: InspectorPlugin) {
        activePlugin?.deactivate()
        clearHighlights()
        stopViewSelection()
        dismissPanel()
        activePlugin = plugin
        plugin.activate(this)
    }

    // MARK: - InspectorContext

    override fun startViewSelection(onSelect: (View) -> Unit) {
        val root = overlayRoot ?: return
        stopViewSelection()
        dismissPanel()

        val overlay = SelectionOverlayView(activity)
        overlay.excludedViews = listOfNotNull(floatingButton)
        overlay.onViewSelected = { view ->
            stopViewSelection()
            onSelect(view)
        }
        root.addView(overlay, ViewGroup.LayoutParams(
            ViewGroup.LayoutParams.MATCH_PARENT,
            ViewGroup.LayoutParams.MATCH_PARENT
        ))
        selectionOverlay = overlay
        floatingButton?.alpha = 0.4f
    }

    override fun stopViewSelection() {
        overlayRoot?.removeView(selectionOverlay)
        selectionOverlay = null
        floatingButton?.alpha = 1f
    }

    override fun highlight(view: View, color: Int, label: String?): HighlightToken {
        val root = overlayRoot ?: return HighlightToken(View(activity))
        val rect = android.graphics.Rect()
        view.getGlobalVisibleRect(rect)

        val decorRect = android.graphics.Rect()
        activity.window.decorView.getGlobalVisibleRect(decorRect)

        val hlView = HighlightView(activity)
        hlView.borderColor = color
        hlView.labelText = label
        val params = FrameLayout.LayoutParams(rect.width(), rect.height()).apply {
            leftMargin = rect.left - decorRect.left
            topMargin = rect.top - decorRect.top
        }
        root.addView(hlView, params)
        highlights.add(hlView)
        return HighlightToken(hlView)
    }

    override fun removeHighlight(token: HighlightToken) {
        overlayRoot?.removeView(token.overlayView)
        highlights.remove(token.overlayView)
    }

    override fun clearHighlights() {
        highlights.forEach { overlayRoot?.removeView(it) }
        highlights.clear()
    }

    override fun showPanel(fragment: DialogFragment) {
        dismissPanel()
        fragment.show(activity.supportFragmentManager, "inspector_panel")
        currentPanel = fragment
    }

    override fun dismissPanel() {
        currentPanel?.dismissAllowingStateLoss()
        currentPanel = null
    }
}
