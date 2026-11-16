package com.mountcarmelschools.ui.dashboard

import android.content.Context
import android.view.View

interface DashboardNavigator {

    fun itemClick(position: Int, string: String)
    fun logoutDialog(view:View)
    fun getContext(): Context?
    fun onError(message: String)


}