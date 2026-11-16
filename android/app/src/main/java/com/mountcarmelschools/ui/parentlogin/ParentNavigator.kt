package com.mountcarmelschools.ui.parentlogin

import android.content.Context

interface ParentNavigator {

    fun getContext(): Context?

    fun onError(message: String?)
}