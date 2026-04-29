package com.uiinspector.core

import android.annotation.SuppressLint
import android.content.Context
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.view.MotionEvent
import android.view.View
import android.view.ViewGroup
import kotlin.math.abs

@SuppressLint("ViewConstructor")
internal class FloatingButton(context: Context) : View(context) {

    var onTap: (() -> Unit)? = null

    private val bgPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        color = Color.parseColor("#2196F3")
        style = Paint.Style.FILL
    }
    private val iconPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        color = Color.WHITE
        style = Paint.Style.STROKE
        strokeWidth = 6f
        strokeCap = Paint.Cap.ROUND
    }

    private var isDragging = false
    private var startRawX = 0f
    private var startRawY = 0f
    private var lastRawX = 0f
    private var lastRawY = 0f

    override fun onDraw(canvas: Canvas) {
        val cx = width / 2f
        val cy = height / 2f
        val r = cx - 4f
        canvas.drawCircle(cx, cy, r, bgPaint)

        // シンプルな虫眼鏡アイコン
        val iconR = r * 0.3f
        canvas.drawCircle(cx - r * 0.1f, cy - r * 0.1f, iconR, iconPaint)
        val lineStart = iconR + r * 0.1f
        canvas.drawLine(
            cx - r * 0.1f + lineStart * 0.7f,
            cy - r * 0.1f + lineStart * 0.7f,
            cx + r * 0.55f,
            cy + r * 0.55f,
            iconPaint
        )
    }

    @SuppressLint("ClickableViewAccessibility")
    override fun onTouchEvent(event: MotionEvent): Boolean {
        when (event.action) {
            MotionEvent.ACTION_DOWN -> {
                startRawX = event.rawX
                startRawY = event.rawY
                lastRawX = event.rawX
                lastRawY = event.rawY
                isDragging = false
            }
            MotionEvent.ACTION_MOVE -> {
                val dx = event.rawX - lastRawX
                val dy = event.rawY - lastRawY
                if (abs(event.rawX - startRawX) > 8 || abs(event.rawY - startRawY) > 8) {
                    isDragging = true
                }
                x += dx
                y += dy
                lastRawX = event.rawX
                lastRawY = event.rawY
            }
            MotionEvent.ACTION_UP -> {
                if (!isDragging) onTap?.invoke()
                snapToEdge()
            }
        }
        return true
    }

    private fun snapToEdge() {
        val parent = parent as? ViewGroup ?: return
        val newX = if (x + width / 2 < parent.width / 2) {
            dpToPx(16f)
        } else {
            parent.width - width - dpToPx(16f)
        }
        val minY = dpToPx(80f)
        val maxY = parent.height - height - dpToPx(80f)
        val newY = y.coerceIn(minY, maxY)
        animate().x(newX).y(newY).setDuration(250).start()
    }

    private fun dpToPx(dp: Float) = dp * resources.displayMetrics.density
}
