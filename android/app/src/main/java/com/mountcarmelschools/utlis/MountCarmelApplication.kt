package com.mountcarmelschools.utlis

import android.app.Application

class MountCarmelApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        instance = this
    }

    companion object {
        lateinit var instance: MountCarmelApplication private set
    }
}