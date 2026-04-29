package com.uiinspector

import android.app.Application
import com.uiinspector.core.InspectorManager
import com.uiinspector.core.InspectorPlugin
import com.uiinspector.plugins.MeasurePlugin
import com.uiinspector.plugins.ViewAttributesPlugin
import com.uiinspector.plugins.ViewHierarchyPlugin

object UIInspector {

    private var manager: InspectorManager? = null

    fun install(app: Application, additionalPlugins: List<InspectorPlugin> = emptyList()) {
        if (manager != null) return
        val defaultPlugins = listOf(
            ViewHierarchyPlugin(),
            ViewAttributesPlugin(),
            MeasurePlugin()
        )
        val m = InspectorManager(defaultPlugins + additionalPlugins)
        app.registerActivityLifecycleCallbacks(m)
        manager = m
    }

    fun show() {
        manager?.showPluginMenu()
    }
}
