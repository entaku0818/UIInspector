package com.uiinspector.core

import android.content.Context
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.RectF
import android.view.View

internal class HighlightView(context: Context) : View(context) {

    var borderColor: Int = Color.BLUE
    var labelText: String? = null

    private val strokePaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        style = Paint.Style.STROKE
        strokeWidth = 4f
    }
    private val fillPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        style = Paint.Style.FILL
    }
    private val textPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        color = Color.WHITE
        textSize = 28f
    }
    private val textBgPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        style = Paint.Style.FILL
    }

    override fun onDraw(canvas: Canvas) {
        val r = borderColor
        val g = Color.green(borderColor)
        val b = Color.blue(borderColor)

        fillPaint.color = Color.argb(40, Color.red(r), g, b)
        strokePaint.color = borderColor
        textBgPaint.color = borderColor

        val rect = RectF(2f, 2f, width - 2f, height - 2f)
        canvas.drawRect(rect, fillPaint)
        canvas.drawRect(rect, strokePaint)

        labelText?.let { label ->
            val textWidth = textPaint.measureText(label) + 16f
            val textHeight = 36f
            val bgRect = RectF(2f, 2f, 2f + textWidth, 2f + textHeight)
            canvas.drawRect(bgRect, textBgPaint)
            canvas.drawText(label, 8f, 28f, textPaint)
        }
    }
}
