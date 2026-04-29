package com.uiinspector.plugins

import android.graphics.Color
import android.graphics.Rect
import android.view.View
import com.uiinspector.core.HighlightToken
import com.uiinspector.core.InspectorContext
import com.uiinspector.core.InspectorPlugin
import com.uiinspector.ui.MeasureSheet
import kotlin.math.sqrt

class MeasurePlugin : InspectorPlugin {
    override val id = "com.uiinspector.measure"
    override val name = "Measure"
    override val iconRes = 0
    override val description = "2つのビュー間の距離を計測"

    private var context: InspectorContext? = null
    private var viewA: View? = null
    private var tokenA: HighlightToken? = null
    private var tokenB: HighlightToken? = null

    override fun activate(context: InspectorContext) {
        this.context = context
        selectViewA()
    }

    override fun deactivate() {
        context?.stopViewSelection()
        context?.clearHighlights()
        viewA = null
        tokenA = null
        tokenB = null
        context = null
    }

    private fun selectViewA() {
        context?.startViewSelection { view ->
            viewA = view
            tokenA = context?.highlight(view, Color.parseColor("#FF9800"), "A")
            selectViewB()
        }
    }

    private fun selectViewB() {
        context?.startViewSelection { view ->
            tokenB = context?.highlight(view, Color.parseColor("#9C27B0"), "B")
            showResult(viewA ?: return@startViewSelection, view)
        }
    }

    private fun showResult(a: View, b: View) {
        val rectA = Rect().also { a.getGlobalVisibleRect(it) }
        val rectB = Rect().also { b.getGlobalVisibleRect(it) }
        val measurement = ViewMeasurementData(
            classA = a.javaClass.simpleName,
            rectA = rectA,
            classB = b.javaClass.simpleName,
            rectB = rectB
        )
        val sheet = MeasureSheet.newInstance(measurement) {
            tokenA?.let { context?.removeHighlight(it) }
            tokenB?.let { context?.removeHighlight(it) }
            viewA = null; tokenA = null; tokenB = null
            selectViewA()
        }
        context?.showPanel(sheet)
    }
}

data class ViewMeasurementData(
    val classA: String, val rectA: Rect,
    val classB: String, val rectB: Rect
) {
    val horizontalGap: Int? get() = when {
        rectA.right <= rectB.left -> rectB.left - rectA.right
        rectB.right <= rectA.left -> rectA.left - rectB.right
        else -> null
    }
    val verticalGap: Int? get() = when {
        rectA.bottom <= rectB.top -> rectB.top - rectA.bottom
        rectB.bottom <= rectA.top -> rectA.top - rectB.bottom
        else -> null
    }
    val centerDistance: Float get() {
        val dx = (rectB.centerX() - rectA.centerX()).toFloat()
        val dy = (rectB.centerY() - rectA.centerY()).toFloat()
        return sqrt(dx * dx + dy * dy)
    }
    val isOverlapping: Boolean get() = Rect.intersects(rectA, rectB)
}
