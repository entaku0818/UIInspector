package com.uiinspector.plugins

import android.graphics.Color
import android.view.View
import android.view.ViewGroup
import com.uiinspector.core.HighlightToken
import com.uiinspector.core.InspectorContext
import com.uiinspector.core.InspectorPlugin
import com.uiinspector.ui.ViewHierarchySheet

class ViewHierarchyPlugin : InspectorPlugin {
    override val id = "com.uiinspector.viewhierarchy"
    override val name = "View Hierarchy"
    override val iconRes = 0
    override val description = "ビュー階層をツリー表示して選択・ハイライト"

    private var context: InspectorContext? = null
    private var selectedToken: HighlightToken? = null

    override fun activate(context: InspectorContext) {
        this.context = context
        val root = context.activity.window.decorView
        val rootNode = buildHierarchy(root)
        val sheet = ViewHierarchySheet.newInstance(rootNode) { node ->
            selectedToken?.let { context.removeHighlight(it) }
            selectedToken = context.highlight(node.view, Color.parseColor("#2196F3"), node.className)
        }
        context.showPanel(sheet)
    }

    override fun deactivate() {
        selectedToken?.let { context?.removeHighlight(it) }
        selectedToken = null
        context = null
    }

    internal fun buildHierarchy(view: View, depth: Int = 0): ViewNode {
        val children = if (view is ViewGroup) {
            (0 until view.childCount).map { buildHierarchy(view.getChildAt(it), depth + 1) }
        } else emptyList()
        return ViewNode(view, depth, children)
    }
}

data class ViewNode(
    val view: View,
    val depth: Int,
    val children: List<ViewNode>
) {
    val className: String get() = view.javaClass.simpleName.ifEmpty { view.javaClass.name }
    val frameDescription: String get() {
        val loc = IntArray(2)
        view.getLocationOnScreen(loc)
        return "(${loc[0]},${loc[1]}) ${view.width}×${view.height}"
    }
    val isLeaf: Boolean get() = children.isEmpty()
}
