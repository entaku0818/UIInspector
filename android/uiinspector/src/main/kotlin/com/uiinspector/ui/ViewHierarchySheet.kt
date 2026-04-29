package com.uiinspector.ui

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.LinearLayout
import android.widget.ScrollView
import android.widget.TextView
import com.google.android.material.bottomsheet.BottomSheetDialogFragment
import com.uiinspector.plugins.ViewNode

internal class ViewHierarchySheet : BottomSheetDialogFragment() {

    private var rootNode: ViewNode? = null
    private var onSelect: ((ViewNode) -> Unit)? = null

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
            text = "View Hierarchy"
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
                LinearLayout.LayoutParams.MATCH_PARENT, (400 * dp).toInt()
            )
        }

        val treeContainer = LinearLayout(ctx).apply {
            orientation = LinearLayout.VERTICAL
            setPadding(0, (8 * dp).toInt(), 0, (8 * dp).toInt())
        }

        rootNode?.let { addNodeRows(it, treeContainer, dp) }
        scrollView.addView(treeContainer)
        root.addView(scrollView)

        return root
    }

    private fun addNodeRows(node: ViewNode, container: LinearLayout, dp: Float) {
        val ctx = requireContext()
        val indent = (node.depth * 16 * dp).toInt()
        val row = LinearLayout(ctx).apply {
            orientation = LinearLayout.HORIZONTAL
            setPadding(
                (16 * dp).toInt() + indent,
                (10 * dp).toInt(),
                (16 * dp).toInt(),
                (10 * dp).toInt()
            )
            isClickable = true
            isFocusable = true
            setOnClickListener {
                onSelect?.invoke(node)
            }
            with(android.util.TypedValue()) {
                ctx.theme.resolveAttribute(android.R.attr.selectableItemBackground, this, true)
                setBackgroundResource(resourceId)
            }
        }

        val nameView = TextView(ctx).apply {
            text = node.className
            textSize = 14f
            setTypeface(typeface, android.graphics.Typeface.BOLD)
            layoutParams = LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f)
        }

        val frameView = TextView(ctx).apply {
            text = node.frameDescription
            textSize = 12f
            setTextColor(0xFF888888.toInt())
        }

        row.addView(nameView)
        row.addView(frameView)
        container.addView(row)

        node.children.forEach { addNodeRows(it, container, dp) }
    }

    companion object {
        fun newInstance(rootNode: ViewNode, onSelect: (ViewNode) -> Unit) =
            ViewHierarchySheet().also {
                it.rootNode = rootNode
                it.onSelect = onSelect
            }
    }
}
