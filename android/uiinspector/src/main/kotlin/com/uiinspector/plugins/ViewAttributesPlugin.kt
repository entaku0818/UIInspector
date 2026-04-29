package com.uiinspector.plugins

import android.graphics.Color
import android.graphics.drawable.ColorDrawable
import android.view.View
import android.widget.ImageView
import android.widget.ScrollView
import android.widget.TextView
import com.uiinspector.core.InspectorContext
import com.uiinspector.core.InspectorPlugin
import com.uiinspector.ui.AttributesSheet

class ViewAttributesPlugin : InspectorPlugin {
    override val id = "com.uiinspector.viewattributes"
    override val name = "View Attributes"
    override val iconRes = 0
    override val description = "ビューのプロパティを詳細表示"

    private var context: InspectorContext? = null

    override fun activate(context: InspectorContext) {
        this.context = context
        startSelection()
    }

    override fun deactivate() {
        context?.stopViewSelection()
        context?.clearHighlights()
        context = null
    }

    private fun startSelection() {
        context?.startViewSelection { view ->
            context?.clearHighlights()
            context?.highlight(view, Color.parseColor("#4CAF50"))
            showAttributes(view)
        }
    }

    private fun showAttributes(view: View) {
        val attrs = extractAttributes(view)
        val sheet = AttributesSheet.newInstance(attrs) { startSelection() }
        context?.showPanel(sheet)
    }

    private fun extractAttributes(view: View): ViewAttributeData {
        val loc = IntArray(2)
        view.getLocationOnScreen(loc)

        val bgColor = (view.background as? ColorDrawable)?.color

        val extra = mutableListOf<AttributeRow>()
        if (view is TextView) {
            extra += AttributeRow("text", view.text?.toString() ?: "null")
            extra += AttributeRow("textSize", "${view.textSize.toInt()}px")
            extra += AttributeRow("textColor", "#%06X".format(0xFFFFFF and view.currentTextColor))
            extra += AttributeRow("lines", view.lineCount.toString())
        }
        if (view is ImageView) {
            extra += AttributeRow("hasImage", (view.drawable != null).toString())
            extra += AttributeRow("scaleType", view.scaleType.name)
        }
        if (view is ScrollView) {
            extra += AttributeRow("scrollY", view.scrollY.toString())
        }

        return ViewAttributeData(
            className = view.javaClass.simpleName.ifEmpty { view.javaClass.name },
            x = loc[0],
            y = loc[1],
            width = view.width,
            height = view.height,
            alpha = view.alpha,
            visibility = visibilityName(view.visibility),
            isEnabled = view.isEnabled,
            isClickable = view.isClickable,
            tag = view.tag?.toString(),
            contentDescription = view.contentDescription?.toString(),
            bgColor = bgColor,
            extra = extra
        )
    }

    private fun visibilityName(v: Int) = when (v) {
        View.VISIBLE -> "VISIBLE"
        View.INVISIBLE -> "INVISIBLE"
        View.GONE -> "GONE"
        else -> "UNKNOWN"
    }
}

data class ViewAttributeData(
    val className: String,
    val x: Int, val y: Int,
    val width: Int, val height: Int,
    val alpha: Float,
    val visibility: String,
    val isEnabled: Boolean,
    val isClickable: Boolean,
    val tag: String?,
    val contentDescription: String?,
    val bgColor: Int?,
    val extra: List<AttributeRow>
)

data class AttributeRow(val key: String, val value: String)
