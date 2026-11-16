package com.mountcarmelschools.receiver

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import com.google.android.gms.auth.api.phone.SmsRetriever
import com.google.android.gms.common.api.CommonStatusCodes
import com.google.android.gms.common.api.Status
import java.util.regex.Pattern

class MySMSBroadcastReceiver() :BroadcastReceiver() {

    private val TAG = "MySMSBroadcastReceiver"

    interface OTPReceiveListener {
        fun onOTPReceived(otp: String?)
        fun onOTPTimeOut()
    }

    private var otpReceiver: OTPReceiveListener? = null

    fun initOTPListener(receiver: OTPReceiveListener?) {
        otpReceiver = receiver
    }

    override fun onReceive(context: Context?, intent: Intent?) {
        if (SmsRetriever.SMS_RETRIEVED_ACTION === intent!!.action) {
            Log.e("---", "" + intent!!.action)
            val extras = intent!!.extras
            Log.e("---", "" + extras)
            try {
                val status = extras!![SmsRetriever.EXTRA_STATUS] as Status?
                Log.e("---", "" + status)
                when (status!!.statusCode) {
                    CommonStatusCodes.SUCCESS -> {
                        var otp = extras!![SmsRetriever.EXTRA_SMS_MESSAGE] as String?

                        // Extract one-time code from the message and complete verification
                        // by sending the code back to your server for SMS authenticity.
                        // But here we are just passing it to MainActivity
                        if (otpReceiver != null) {
                            otp = extractOtpFromMessage(otp)
                            if (otp!!.length == 4) otpReceiver!!.onOTPReceived(otp)
                        }
                    }
                    CommonStatusCodes.TIMEOUT ->                         // Waiting for SMS timed out (5 minutes)
                        // Handle the error ...
                        if (otpReceiver != null) otpReceiver!!.onOTPTimeOut()
                }
            } catch (ex: Throwable) {
                //GlobalFunctionsClass.reportException(TAG,ex);
            }
        }
    }

     fun extractOtpFromMessage(input: String?) : String? {
        val p = Pattern.compile("(\\d{4})")
        val m = p.matcher(input.toString())
            if (m.find()) {
           return m.group(0)
        }
        return ""
    }

}