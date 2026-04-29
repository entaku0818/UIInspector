package com.uiinspector.core

import android.annotation.SuppressLint
import android.content.Context
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.Rect
import android.view.MotionEvent
import android.view.View
import android.view.ViewGroup

@SuppressLint("ViewConstructor")
internal class SelectionOverlayView(context: Context) : View(context) {

    var onViewSelected: ((View) -> Unit)? = null
    var excludedViews: List<View> = emptyList()

    private val bgPaint = Paint().apply {
        color = Color.argb(20, 33, 150, 243)
        style = Paint.Style.FILL
    }
    private val textPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        color = Color.WHITE
        textSize = 36f
        textAlign = Paint.Align.CENTER
    }
    private val hintBgPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        color = Color.argb(210, 33, 150, 243)
        style = Paint.Style.FILL
    }

    override fun onDraw(canvas: Canvas) {
        canvas.drawRect(0f, 0f, width.toFloat(), height.toFloat(), bgPaint)
        val hint = "ビューをタップして選択"
        val textWidth = textPaint.measureText(hint) + 48f
        val cx = width / 2f
        val top = 120f
        val bottom = top + 60f
        canvas.drawRoundRect(cx - textWidth / 2, top, cx + textWidth / 2, bottom, 16f, 16f, hintBgPaint)
        canvas.drawText(hint, cx, bottom - 16f, textPaint)
    }

    @SuppressLint("ClickableViewAccessibility")
    override fun onTouchEvent(event: MotionEvent): Boolean {
        if (event.action == MotionEvent.ACTION_UP) {
            val x = event.rawX.toInt()
            val y = event.rawY.toInt()
            val root = rootView as? ViewGroup ?: return true
            val found = findDeepestView(x, y, root)
            found?.let { onViewSelected?.invoke(it) }
        }
        return true
    }

    private fun findDeepestView(x: Int, y: Int, view: View): View? {
        if (view.visibility != VISIBLE) return null
        if (view in excludedViews) return null

        val rect = Rect()
        view.getGlobalVisibleRect(rect)
        if (!rect.contains(x, y)) return null

        if (view is ViewGroup) {
            for (i in view.childCount - 1 downTo 0) {
                val found = findDeepestView(x, y, view.getChildAt(i))
                if (found != null) return found
            }
        }

        return if (view is ViewGroup && view.childCount > 0) null else view
    }
}
