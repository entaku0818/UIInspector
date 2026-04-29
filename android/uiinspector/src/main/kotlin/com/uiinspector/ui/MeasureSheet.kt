package com.uiinspector.ui

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.LinearLayout
import android.widget.TextView
import com.google.android.material.bottomsheet.BottomSheetDialogFragment
import com.uiinspector.plugins.ViewMeasurementData

internal class MeasureSheet : BottomSheetDialogFragment() {

    private var data: ViewMeasurementData? = null
    private var onRemeasure: (() -> Unit)? = null

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        val ctx = requireContext()
        val dp = ctx.resources.displayMetrics.density

        val root = LinearLayout(ctx).apply {
            orientation = LinearLayout.VERTICAL
            setPadding(0, (16 * dp).toInt(), 0, (32 * dp).toInt())
        }

        val title = TextView(ctx).apply {
            text = "Measure"
            textSize = 18f
            setTypeface(typeface, android.graphics.Typeface.BOLD)
            setPadding((24 * dp).toInt(), (16 * dp).toInt(), (24 * dp).toInt(), (16 * dp).toInt())
        }
        root.addView(title)

        root.addView(View(ctx).apply {
            setBackgroundColor(0x1A000000)
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT, (1 * dp).toInt()
            )
        })

        val content = LinearLayout(ctx).apply {
            orientation = LinearLayout.VERTICAL
            setPadding((24 * dp).toInt(), (16 * dp).toInt(), (24 * dp).toInt(), (16 * dp).toInt())
        }

        data?.let { d ->
            addViewLabel(content, "A", d.classA, dp)
            addViewLabel(content, "B", d.classB, dp)

            content.addView(View(ctx).apply {
                setBackgroundColor(0x1A000000)
                layoutParams = LinearLayout.LayoutParams(
                    LinearLayout.LayoutParams.MATCH_PARENT, (1 * dp).toInt()
                ).also { it.topMargin = (12 * dp).toInt(); it.bottomMargin = (12 * dp).toInt() }
            })

            if (d.isOverlapping) {
                addResultRow(content, "Status", "Overlapping", 0xFFE91E63.toInt(), dp)
            } else {
                d.horizontalGap?.let { addResultRow(content, "Horizontal Gap", "${it}px", 0xFF2196F3.toInt(), dp) }
                d.verticalGap?.let { addResultRow(content, "Vertical Gap", "${it}px", 0xFF4CAF50.toInt(), dp) }
                if (d.horizontalGap == null && d.verticalGap == null) {
                    addResultRow(content, "Status", "Aligned", 0xFF9E9E9E.toInt(), dp)
                }
            }
            addResultRow(content, "Center Distance", "%.1fpx".format(d.centerDistance), 0xFF9C27B0.toInt(), dp)
        }

        val remeasureBtn = Button(ctx).apply {
            text = "Remeasure"
            setOnClickListener {
                dismissAllowingStateLoss()
                onRemeasure?.invoke()
            }
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            ).also {
                it.leftMargin = (24 * dp).toInt()
                it.rightMargin = (24 * dp).toInt()
                it.topMargin = (8 * dp).toInt()
            }
        }

        root.addView(content)
        root.addView(remeasureBtn)
        return root
    }

    private fun addViewLabel(container: LinearLayout, label: String, className: String, dp: Float) {
        val ctx = requireContext()
        val row = LinearLayout(ctx).apply {
            orientation = LinearLayout.HORIZONTAL
            setPadding(0, (6 * dp).toInt(), 0, (6 * dp).toInt())
        }
        val badge = TextView(ctx).apply {
            text = label
            textSize = 12f
            setTextColor(android.graphics.Color.WHITE)
            setTypeface(typeface, android.graphics.Typeface.BOLD)
            val color = if (label == "A") 0xFFFF9800.toInt() else 0xFF9C27B0.toInt()
            background = android.graphics.drawable.GradientDrawable().apply {
                shape = android.graphics.drawable.GradientDrawable.OVAL
                setColor(color)
                setSize((24 * dp).toInt(), (24 * dp).toInt())
            }
            gravity = android.view.Gravity.CENTER
            layoutParams = LinearLayout.LayoutParams((24 * dp).toInt(), (24 * dp).toInt())
        }
        val nameView = TextView(ctx).apply {
            text = className
            textSize = 14f
            setPadding((8 * dp).toInt(), 0, 0, 0)
        }
        row.addView(badge)
        row.addView(nameView)
        container.addView(row)
    }

    private fun addResultRow(container: LinearLayout, key: String, value: String, valueColor: Int, dp: Float) {
        val ctx = requireContext()
        val row = LinearLayout(ctx).apply {
            orientation = LinearLayout.HORIZONTAL
            setPadding(0, (8 * dp).toInt(), 0, (8 * dp).toInt())
        }
        val keyView = TextView(ctx).apply {
            text = key
            textSize = 14f
            layoutParams = LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f)
        }
        val valueView = TextView(ctx).apply {
            text = value
            textSize = 14f
            setTextColor(valueColor)
            setTypeface(typeface, android.graphics.Typeface.BOLD)
        }
        row.addView(keyView)
        row.addView(valueView)
        container.addView(row)
    }

    companion object {
        fun newInstance(data: ViewMeasurementData, onRemeasure: () -> Unit) =
            MeasureSheet().also {
                it.data = data
                it.onRemeasure = onRemeasure
            }
    }
}
