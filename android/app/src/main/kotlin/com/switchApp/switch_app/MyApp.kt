package com.switchApp.switch_app

import android.app.Application
import io.maido.intercom.IntercomFlutterPlugin

class MyApp : Application() {
  override fun onCreate() {
    super.onCreate()

    // Initialize the Intercom SDK here also as Android requires to initialize it in the onCreate of
    // the application.
    IntercomFlutterPlugin.initSdk(this, appId = "spun6s0t", androidApiKey = "android_sdk-52f7088722c877f1154ad199f1a05bdae43e98ff")
  }
}