package com.mountcarmelschools.fcm

import android.content.Intent
import android.text.TextUtils
import android.util.Log
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage
import com.mountcarmelschools.ui.dashboard.DashboardActivity
import com.mountcarmelschools.ui.splash.SplashActivity
import com.mountcarmelschools.utlis.AUTH_TOKEN
import com.mountcarmelschools.utlis.SharedPreferenceUtils

class MyFirebaseMessagingService : FirebaseMessagingService() {
    override fun onNewToken(s: String) {
        super.onNewToken(s)
    }

    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        super.onMessageReceived(remoteMessage)
        //Displaying data in log
        //It is optional
        Log.e(
            TAG,
            "From: " + remoteMessage.from
        )
        // Check if message contains a notification payload.
        if (remoteMessage.notification != null) {
            Log.e(
                TAG,
                "Message Notification Body: " + remoteMessage.notification!!.body
            )
            try {
                val data: Map<String, String> =
                    remoteMessage.getData()
                if (data["notification_type"].equals("DATA", ignoreCase = true)) {
                    handleDataPayload(data, remoteMessage.notification!!.body)
                } else {
                    handleNotificationPayload(remoteMessage.notification!!.body.toString())
                }
            } catch (e: Exception) {
                Log.e(
                    TAG,
                    "Exception: " + e.message
                )
            }
        }
    }

    private fun handleDataPayload(
        data: Map<String, String>,
        message: String?
    ) {
        //creating MyNotificationManager object
        val mNotificationManager =
            MyNotificationManager(getApplicationContext())
        //creating an intent for the notification
        if (MyNotificationManager.isAppIsInBackground(getApplicationContext())) {
            // app is in background, show the notification in notification tray
            val pushNotification: Intent
            if (!TextUtils.isEmpty(
                    SharedPreferenceUtils.getInstance(applicationContext)!!
                        .getStringValue(AUTH_TOKEN, "")
                )
            ) {
                pushNotification = Intent(applicationContext, DashboardActivity::class.java)
                pushNotification.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK)
            } else {
                pushNotification = Intent(applicationContext, SplashActivity::class.java)
                pushNotification.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK)
                pushNotification.putExtra("message", message)
            }
            pushNotification.putExtra("message", message)
            mNotificationManager.showSmallNotification(message, pushNotification)
        } else {
            // app is in foreground, broadcast the push message
        }
    }

    private fun handleNotificationPayload(message: String) {
        //optionally we can display the json into log
        Log.e(
            TAG,
            "Notification Payload $message"
        )
        val imageUrl = ""
        //creating MyNotificationManager object
        val mNotificationManager =
            MyNotificationManager(applicationContext)
        //creating an intent for the notification
        // app is in foreground, broadcast the push message
        val pushNotification: Intent
        if (!TextUtils.isEmpty(
                SharedPreferenceUtils.getInstance(applicationContext)!!
                    .getStringValue(AUTH_TOKEN, "")
            )
        ) {
            pushNotification = Intent(applicationContext, DashboardActivity::class.java)
            pushNotification.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK)
        } else {
            pushNotification = Intent(applicationContext, SplashActivity::class.java)
            pushNotification.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK)
            pushNotification.putExtra("message", message)
        }
        pushNotification.putExtra("message", message)
        mNotificationManager.showSmallNotification(message, pushNotification)
    }

    companion object {
        private const val TAG = "MyFirebaseMsgService"
    }
}