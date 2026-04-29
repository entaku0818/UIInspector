package com.uiinspector.demo

import android.graphics.Color
import android.os.Bundle
import android.widget.FrameLayout
import android.widget.GridLayout
import android.widget.LinearLayout
import android.widget.ScrollView
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity

class LayoutDemoActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        title = "Layout Demo"

        val dp = resources.displayMetrics.density
        val scroll = ScrollView(this)
        val root = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            setPadding((16 * dp).toInt(), (16 * dp).toInt(), (16 * dp).toInt(), (16 * dp).toInt())
        }

        root.addView(sectionHeader("Grid Layout", dp))
        root.addView(buildGrid(dp))

        root.addView(sectionHeader("Nested Views", dp))
        root.addView(buildNestedViews(dp))

        root.addView(sectionHeader("Flex Row", dp))
        root.addView(buildFlexRow(dp))

        root.addView(sectionHeader("Z-order Overlap", dp))
        root.addView(buildOverlap(dp))

        scroll.addView(root)
        setContentView(scroll)
    }

    private fun sectionHeader(text: String, dp: Float): TextView = TextView(this).apply {
        this.text = text
        textSize = 16f
        setTypeface(typeface, android.graphics.Typeface.BOLD)
        setTextColor(Color.BLACK)
        layoutParams = LinearLayout.LayoutParams(
            LinearLayout.LayoutParams.MATCH_PARENT,
            LinearLayout.LayoutParams.WRAP_CONTENT
        ).also { it.topMargin = (16 * dp).toInt(); it.bottomMargin = (8 * dp).toInt() }
    }

    private fun buildGrid(dp: Float): GridLayout {
        val colors = listOf(0xFFE3F2FD, 0xFFE8F5E9, 0xFFFFF3E0, 0xFFFCE4EC,
            0xFFEDE7F6, 0xFFE0F2F1)
        val grid = GridLayout(this).apply {
            columnCount = 3
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            ).also { it.bottomMargin = (8 * dp).toInt() }
        }
        colors.forEachIndexed { i, color ->
            val cell = FrameLayout(this).apply {
                setBackgroundColor(color.toInt())
                layoutParams = GridLayout.LayoutParams().apply {
                    width = 0
                    height = (80 * dp).toInt()
                    columnSpec = GridLayout.spec(GridLayout.UNDEFINED, 1f)
                    setMargins((2 * dp).toInt(), (2 * dp).toInt(), (2 * dp).toInt(), (2 * dp).toInt())
                }
            }
            cell.addView(TextView(this).apply {
                text = "${i + 1}"
                textSize = 18f
                setTypeface(typeface, android.graphics.Typeface.BOLD)
                setTextColor(0xFF555555.toInt())
                gravity = android.view.Gravity.CENTER
                layoutParams = FrameLayout.LayoutParams(
                    FrameLayout.LayoutParams.MATCH_PARENT,
                    FrameLayout.LayoutParams.MATCH_PARENT
                )
            })
            grid.addView(cell)
        }
        return grid
    }

    private fun buildNestedViews(dp: Float): LinearLayout {
        fun nested(depth: Int, label: String): LinearLayout {
            val colors = listOf(0xFFBBDEFB, 0xFF90CAF9, 0xFF64B5F6, 0xFF42A5F5)
            val container = LinearLayout(this).apply {
                orientation = LinearLayout.VERTICAL
                setBackgroundColor(colors[depth % colors.size].toInt())
                setPadding((8 * dp).toInt(), (8 * dp).toInt(), (8 * dp).toInt(), (8 * dp).toInt())
                layoutParams = LinearLayout.LayoutParams(
                    LinearLayout.LayoutParams.MATCH_PARENT,
                    LinearLayout.LayoutParams.WRAP_CONTENT
                )
            }
            container.addView(TextView(this).apply {
                text = label
                textSize = 12f
                setTextColor(Color.WHITE)
            })
            if (depth < 3) {
                container.addView(nested(depth + 1, "Child of $label"))
            }
            return container
        }
        return nested(0, "Root")
    }

    private fun buildFlexRow(dp: Float): LinearLayout {
        val row = LinearLayout(this).apply {
            orientation = LinearLayout.HORIZONTAL
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            ).also { it.bottomMargin = (8 * dp).toInt() }
        }
        val weights = listOf(1f, 2f, 1f)
        val colors = listOf(0xFF4CAF50, 0xFF2196F3, 0xFFFF9800)
        weights.forEachIndexed { i, weight ->
            row.addView(FrameLayout(this).apply {
                setBackgroundColor(colors[i].toInt())
                layoutParams = LinearLayout.LayoutParams(0, (60 * dp).toInt(), weight).also {
                    it.leftMargin = if (i > 0) (4 * dp).toInt() else 0
                }
            }.also { frame ->
                frame.addView(TextView(this).apply {
                    text = "${(weight * 100).toInt()}%"
                    textSize = 14f
                    setTextColor(Color.WHITE)
                    setTypeface(typeface, android.graphics.Typeface.BOLD)
                    gravity = android.view.Gravity.CENTER
                    layoutParams = FrameLayout.LayoutParams(
                        FrameLayout.LayoutParams.MATCH_PARENT,
                        FrameLayout.LayoutParams.MATCH_PARENT
                    )
                })
            })
        }
        return row
    }

    private fun buildOverlap(dp: Float): FrameLayout {
        return FrameLayout(this).apply {
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT, (120 * dp).toInt()
            ).also { it.bottomMargin = (8 * dp).toInt() }

            addView(TextView(this@LayoutDemoActivity).apply {
                text = "Back"
                textSize = 14f
                setTextColor(Color.WHITE)
                gravity = android.view.Gravity.CENTER
                setBackgroundColor(0xFF2196F3.toInt())
                layoutParams = FrameLayout.LayoutParams((200 * dp).toInt(), (80 * dp).toInt()).also {
                    it.gravity = android.view.Gravity.TOP or android.view.Gravity.START
                    it.topMargin = (16 * dp).toInt()
                    it.leftMargin = (16 * dp).toInt()
                }
            })

            addView(TextView(this@LayoutDemoActivity).apply {
                text = "Middle"
                textSize = 14f
                setTextColor(Color.WHITE)
                gravity = android.view.Gravity.CENTER
                setBackgroundColor(0xFF4CAF50.toInt())
                layoutParams = FrameLayout.LayoutParams((160 * dp).toInt(), (80 * dp).toInt()).also {
                    it.gravity = android.view.Gravity.TOP or android.view.Gravity.START
                    it.topMargin = (30 * dp).toInt()
                    it.leftMargin = (60 * dp).toInt()
                }
            })

            addView(TextView(this@LayoutDemoActivity).apply {
                text = "Front"
                textSize = 14f
                setTextColor(Color.WHITE)
                gravity = android.view.Gravity.CENTER
                setBackgroundColor(0xFFFF9800.toInt())
                layoutParams = FrameLayout.LayoutParams((120 * dp).toInt(), (80 * dp).toInt()).also {
                    it.gravity = android.view.Gravity.TOP or android.view.Gravity.START
                    it.topMargin = (20 * dp).toInt()
                    it.leftMargin = (120 * dp).toInt()
                }
            })
        }
    }
}
