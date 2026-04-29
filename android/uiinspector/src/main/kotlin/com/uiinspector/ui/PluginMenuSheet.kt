package com.uiinspector.ui

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.LinearLayout
import android.widget.TextView
import androidx.core.content.ContextCompat
import com.google.android.material.bottomsheet.BottomSheetDialogFragment
import com.uiinspector.core.InspectorPlugin

internal class PluginMenuSheet : BottomSheetDialogFragment() {

    private var plugins: List<InspectorPlugin> = emptyList()
    private var onSelect: ((InspectorPlugin) -> Unit)? = null

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

        // タイトル
        val title = TextView(ctx).apply {
            text = "UIInspector"
            textSize = 18f
            setTypeface(typeface, android.graphics.Typeface.BOLD)
            setPadding((24 * dp).toInt(), (16 * dp).toInt(), (24 * dp).toInt(), (16 * dp).toInt())
        }
        root.addView(title)

        // 区切り線
        root.addView(View(ctx).apply {
            setBackgroundColor(0x1A000000)
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT, (1 * dp).toInt()
            )
        })

        // プラグイン一覧
        plugins.forEach { plugin ->
            val row = LinearLayout(ctx).apply {
                orientation = LinearLayout.HORIZONTAL
                setPadding((24 * dp).toInt(), (16 * dp).toInt(), (24 * dp).toInt(), (16 * dp).toInt())
                isClickable = true
                isFocusable = true
                setOnClickListener {
                    dismissAllowingStateLoss()
                    onSelect?.invoke(plugin)
                }
                with(android.util.TypedValue()) {
                    ctx.theme.resolveAttribute(android.R.attr.selectableItemBackground, this, true)
                    setBackgroundResource(resourceId)
                }
            }

            val textContainer = LinearLayout(ctx).apply {
                orientation = LinearLayout.VERTICAL
                layoutParams = LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f)
            }
            textContainer.addView(TextView(ctx).apply {
                text = plugin.name
                textSize = 16f
                setTypeface(typeface, android.graphics.Typeface.BOLD)
            })
            textContainer.addView(TextView(ctx).apply {
                text = plugin.description
                textSize = 13f
                setTextColor(0xFF888888.toInt())
            })

            row.addView(textContainer)
            root.addView(row)
        }

        return root
    }

    companion object {
        fun newInstance(
            plugins: List<InspectorPlugin>,
            onSelect: (InspectorPlugin) -> Unit
        ) = PluginMenuSheet().also {
            it.plugins = plugins
            it.onSelect = onSelect
        }
    }
}
