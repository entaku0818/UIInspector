package com.uiinspector.demo

import android.os.Bundle
import android.widget.Button
import android.widget.CheckBox
import android.widget.EditText
import android.widget.LinearLayout
import android.widget.ScrollView
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity

class FormDemoActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        title = "Form Demo"

        val dp = resources.displayMetrics.density
        val scroll = ScrollView(this)
        val root = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            setPadding((24 * dp).toInt(), (24 * dp).toInt(), (24 * dp).toInt(), (24 * dp).toInt())
        }

        root.addView(sectionLabel("Personal Info", dp))
        root.addView(labeledField("First Name", "Enter first name", dp))
        root.addView(labeledField("Last Name", "Enter last name", dp))
        root.addView(labeledField("Email", "Enter email address", dp))
        root.addView(labeledField("Phone", "Enter phone number", dp))

        root.addView(sectionLabel("Account", dp))
        root.addView(labeledField("Username", "Choose a username", dp))
        root.addView(labeledField("Password", "Create a password", dp))

        val agreeCheck = CheckBox(this).apply {
            text = "I agree to the terms and conditions"
            textSize = 14f
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            ).also { it.bottomMargin = (16 * dp).toInt() }
        }
        root.addView(agreeCheck)

        val submitBtn = Button(this).apply {
            text = "Submit"
            textSize = 16f
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                (48 * dp).toInt()
            )
        }
        root.addView(submitBtn)

        scroll.addView(root)
        setContentView(scroll)
    }

    private fun sectionLabel(text: String, dp: Float): TextView = TextView(this).apply {
        this.text = text
        textSize = 18f
        setTypeface(typeface, android.graphics.Typeface.BOLD)
        setTextColor(0xFF333333.toInt())
        layoutParams = LinearLayout.LayoutParams(
            LinearLayout.LayoutParams.MATCH_PARENT,
            LinearLayout.LayoutParams.WRAP_CONTENT
        ).also { it.topMargin = (16 * dp).toInt(); it.bottomMargin = (8 * dp).toInt() }
    }

    private fun labeledField(label: String, hint: String, dp: Float): LinearLayout {
        val container = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            ).also { it.bottomMargin = (12 * dp).toInt() }
        }
        container.addView(TextView(this).apply {
            text = label
            textSize = 13f
            setTextColor(0xFF666666.toInt())
        })
        container.addView(EditText(this).apply {
            this.hint = hint
            textSize = 14f
            setPadding((8 * dp).toInt(), (8 * dp).toInt(), (8 * dp).toInt(), (8 * dp).toInt())
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            )
        })
        return container
    }
}
