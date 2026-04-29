package com.uiinspector.ui

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.LinearLayout
import android.widget.ScrollView
import android.widget.TextView
import com.google.android.material.bottomsheet.BottomSheetDialogFragment
import com.uiinspector.plugins.ViewAttributeData

internal class AttributesSheet : BottomSheetDialogFragment() {

    private var data: ViewAttributeData? = null
    private var onDismissed: (() -> Unit)? = null

    override fun onDismiss(dialog: android.content.DialogInterface) {
        super.onDismiss(dialog)
        onDismissed?.invoke()
    }

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
            text = "View Attributes"
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

        val scrollView = ScrollView(ctx).apply {
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT, (500 * dp).toInt()
            )
        }

        val content = LinearLayout(ctx).apply {
            orientation = LinearLayout.VERTICAL
            setPadding((16 * dp).toInt(), (8 * dp).toInt(), (16 * dp).toInt(), (8 * dp).toInt())
        }

        data?.let { attrs ->
            addSection(content, "Identity", dp, listOf(
                "class" to attrs.className,
                "tag" to (attrs.tag ?: "null"),
                "contentDescription" to (attrs.contentDescription ?: "null")
            ))
            addSection(content, "Layout", dp, listOf(
                "x" to "${attrs.x}px",
                "y" to "${attrs.y}px",
                "width" to "${attrs.width}px",
                "height" to "${attrs.height}px"
            ))
            addSection(content, "Appearance", dp, buildList {
                add("alpha" to "%.2f".format(attrs.alpha))
                add("visibility" to attrs.visibility)
                add("isEnabled" to attrs.isEnabled.toString())
                add("isClickable" to attrs.isClickable.toString())
                attrs.bgColor?.let { add("bgColor" to "#%06X".format(0xFFFFFF and it)) }
            })
            if (attrs.extra.isNotEmpty()) {
                addSection(content, "Type Specific", dp,
                    attrs.extra.map { it.key to it.value })
            }
        }

        scrollView.addView(content)
        root.addView(scrollView)
        return root
    }

    private fun addSection(
        container: LinearLayout,
        sectionTitle: String,
        dp: Float,
        rows: List<Pair<String, String>>
    ) {
        val ctx = requireContext()

        val header = TextView(ctx).apply {
            text = sectionTitle.uppercase()
            textSize = 11f
            setTextColor(0xFF888888.toInt())
            setPadding(0, (16 * dp).toInt(), 0, (4 * dp).toInt())
            setTypeface(typeface, android.graphics.Typeface.BOLD)
        }
        container.addView(header)

        val card = LinearLayout(ctx).apply {
            orientation = LinearLayout.VERTICAL
            setBackgroundColor(0x0A000000)
            setPadding((12 * dp).toInt(), (4 * dp).toInt(), (12 * dp).toInt(), (4 * dp).toInt())
        }

        rows.forEach { (key, value) ->
            val row = LinearLayout(ctx).apply {
                orientation = LinearLayout.HORIZONTAL
                setPadding(0, (8 * dp).toInt(), 0, (8 * dp).toInt())
            }
            val keyView = TextView(ctx).apply {
                text = key
                textSize = 13f
                layoutParams = LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f)
            }
            val valueView = TextView(ctx).apply {
                text = value
                textSize = 13f
                setTextColor(0xFF444444.toInt())
                setTypeface(typeface, android.graphics.Typeface.BOLD)
            }
            row.addView(keyView)
            row.addView(valueView)
            card.addView(row)
        }

        container.addView(card)
    }

    companion object {
        fun newInstance(data: ViewAttributeData, onDismissed: () -> Unit) =
            AttributesSheet().also {
                it.data = data
                it.onDismissed = onDismissed
            }
    }
}
