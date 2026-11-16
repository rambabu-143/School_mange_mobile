package com.mountcarmelschools.ui.parentlogin

import android.content.Context
import android.view.View

interface OtpNavigator {
    fun clickOnContinue()

    fun clickOnResend(view :View)

    fun getContext(): Context?

    fun onError(message: String?)
    fun finishOtpScreen()
}