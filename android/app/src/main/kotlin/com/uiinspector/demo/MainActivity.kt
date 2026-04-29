package com.uiinspector.demo

import android.content.Intent
import android.os.Bundle
import android.widget.LinearLayout
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity

class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val dp = resources.displayMetrics.density
        val root = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            setPadding((24 * dp).toInt(), (24 * dp).toInt(), (24 * dp).toInt(), (24 * dp).toInt())
        }

        val title = TextView(this).apply {
            text = "UIInspector Demo"
            textSize = 24f
            setTypeface(typeface, android.graphics.Typeface.BOLD)
            setPadding(0, 0, 0, (24 * dp).toInt())
        }
        root.addView(title)

        val subtitle = TextView(this).apply {
            text = "Shake the device or tap the floating button to open the inspector."
            textSize = 14f
            setTextColor(0xFF666666.toInt())
            setPadding(0, 0, 0, (32 * dp).toInt())
        }
        root.addView(subtitle)

        val screens = listOf(
            "Form Demo" to FormDemoActivity::class.java,
            "List Demo" to ListDemoActivity::class.java,
            "Layout Demo" to LayoutDemoActivity::class.java
        )

        screens.forEach { (label, target) ->
            val btn = com.google.android.material.button.MaterialButton(this).apply {
                text = label
                textSize = 16f
                setOnClickListener { startActivity(Intent(this@MainActivity, target)) }
                layoutParams = LinearLayout.LayoutParams(
                    LinearLayout.LayoutParams.MATCH_PARENT,
                    LinearLayout.LayoutParams.WRAP_CONTENT
                ).also { it.bottomMargin = (12 * dp).toInt() }
            }
            root.addView(btn)
        }

        setContentView(root)
    }
}
