package com.uiinspector.demo

import android.app.Application
import com.uiinspector.UIInspector

class DemoApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        UIInspector.install(this)
    }
}
