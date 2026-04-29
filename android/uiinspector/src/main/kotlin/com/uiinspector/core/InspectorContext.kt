package com.uiinspector.core

import android.app.Activity
import android.view.View
import androidx.fragment.app.DialogFragment
import androidx.fragment.app.FragmentActivity

interface InspectorContext {
    val activity: FragmentActivity

    fun startViewSelection(onSelect: (View) -> Unit)
    fun stopViewSelection()

    fun highlight(view: View, color: Int, label: String? = null): HighlightToken
    fun removeHighlight(token: HighlightToken)
    fun clearHighlights()

    fun showPanel(fragment: DialogFragment)
    fun dismissPanel()
}

class HighlightToken(internal val overlayView: View)
