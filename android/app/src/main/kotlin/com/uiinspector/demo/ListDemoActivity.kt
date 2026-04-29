package com.uiinspector.demo

import android.graphics.Color
import android.os.Bundle
import android.widget.FrameLayout
import android.widget.LinearLayout
import android.widget.ScrollView
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity

class ListDemoActivity : AppCompatActivity() {

    private val items = List(20) { index ->
        "Item ${index + 1}" to "Description for item ${index + 1}"
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        title = "List Demo"

        val dp = resources.displayMetrics.density
        val scroll = ScrollView(this)
        val root = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            setPadding(0, (8 * dp).toInt(), 0, (8 * dp).toInt())
        }

        items.forEachIndexed { index, (title, description) ->
            val card = LinearLayout(this).apply {
                orientation = LinearLayout.HORIZONTAL
                setPadding((16 * dp).toInt(), (12 * dp).toInt(), (16 * dp).toInt(), (12 * dp).toInt())
                layoutParams = LinearLayout.LayoutParams(
                    LinearLayout.LayoutParams.MATCH_PARENT,
                    LinearLayout.LayoutParams.WRAP_CONTENT
                ).also { it.bottomMargin = (1 * dp).toInt() }
                setBackgroundColor(Color.WHITE)
                isClickable = true
                isFocusable = true
                with(android.util.TypedValue()) {
                    theme.resolveAttribute(android.R.attr.selectableItemBackground, this, true)
                    setBackgroundResource(resourceId)
                }
            }

            val avatar = FrameLayout(this).apply {
                layoutParams = LinearLayout.LayoutParams(
                    (48 * dp).toInt(), (48 * dp).toInt()
                ).also { it.rightMargin = (16 * dp).toInt() }
                background = android.graphics.drawable.GradientDrawable().apply {
                    shape = android.graphics.drawable.GradientDrawable.OVAL
                    val colors = listOf(0xFF2196F3, 0xFF4CAF50, 0xFFFF9800, 0xFFE91E63, 0xFF9C27B0)
                    setColor(colors[index % colors.size].toInt())
                }
            }

            val avatarLabel = TextView(this).apply {
                text = (index + 1).toString()
                textSize = 16f
                setTextColor(Color.WHITE)
                setTypeface(typeface, android.graphics.Typeface.BOLD)
                gravity = android.view.Gravity.CENTER
                layoutParams = FrameLayout.LayoutParams(
                    FrameLayout.LayoutParams.MATCH_PARENT,
                    FrameLayout.LayoutParams.MATCH_PARENT
                )
            }
            avatar.addView(avatarLabel)

            val textContainer = LinearLayout(this).apply {
                orientation = LinearLayout.VERTICAL
                layoutParams = LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f)
            }
            textContainer.addView(TextView(this).apply {
                text = title
                textSize = 16f
                setTypeface(typeface, android.graphics.Typeface.BOLD)
                setTextColor(Color.BLACK)
            })
            textContainer.addView(TextView(this).apply {
                text = description
                textSize = 13f
                setTextColor(0xFF888888.toInt())
            })

            card.addView(avatar)
            card.addView(textContainer)
            root.addView(card)
        }

        scroll.addView(root)
        setContentView(scroll)
    }
}
