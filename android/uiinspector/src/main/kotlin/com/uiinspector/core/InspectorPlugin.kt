package com.uiinspector.core

interface InspectorPlugin {
    val id: String
    val name: String
    val iconRes: Int
    val description: String

    fun activate(context: InspectorContext)
    fun deactivate()
}
