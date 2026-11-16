package com.mountcarmelschools.fcm

import android.annotation.SuppressLint
import android.app.*
import android.app.ActivityManager.RunningAppProcessInfo
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.media.RingtoneManager
import android.os.Build
import android.util.Log
import androidx.core.app.NotificationCompat
import com.mountcarmelschools.R
import java.net.HttpURLConnection
import java.net.URL
import java.util.*


class MyNotificationManager(private val mCtx: Context) {
    var defaultSoundUri =
        RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION)
    var time = Calendar.getInstance().timeInMillis

    //the method will show a small notification
    //parameters are title for message title, message for message text and an intent that will open
    //when you will tap on the notification
    @SuppressLint("UnspecifiedImmutableFlag")
    fun showSmallNotification(message: String?, intent: Intent?) {


        var resultPendingIntent: PendingIntent? = null
        resultPendingIntent = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            PendingIntent.getActivity(
                mCtx,
                ID_SMALL_NOTIFICATION,
                intent,
                PendingIntent.FLAG_MUTABLE
            )
        } else {
            PendingIntent.getActivity(
                mCtx,
                ID_SMALL_NOTIFICATION,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT
            )
        }


        Log.e("time", time.toString())
        val mBuilder =
            NotificationCompat.Builder(
                mCtx,
                mCtx.getString(R.string.default_notification_channel_id)
            )
        val notification: Notification =
            mBuilder.setSmallIcon(R.mipmap.ic_launcher).setTicker(message).setWhen(0)
            .setAutoCancel(true)
            .setContentIntent(resultPendingIntent)
            .setContentTitle(mCtx.getString(R.string.app_name))
            .setSmallIcon(R.mipmap.ic_launcher)
            .setLargeIcon(BitmapFactory.decodeResource(mCtx.resources, R.mipmap.ic_launcher))
            .setSound(defaultSoundUri)
            .setContentText(message)
            .setWhen(time)
            .setStyle(NotificationCompat.BigTextStyle().bigText(message))
            .build()
        notification.flags = notification.flags or Notification.FLAG_AUTO_CANCEL
        val notificationManager =
            mCtx.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        // Since android Oreo notification channel is needed.
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channelId = mCtx.getString(R.string.default_notification_channel_id)
            val channel = NotificationChannel(
                channelId,
                mCtx.getString(R.string.app_name),
                NotificationManager.IMPORTANCE_DEFAULT
            )
            channel.description = message
            notificationManager.createNotificationChannel(channel)
            mBuilder.setChannelId(channelId)
        }
        notificationManager.notify(
            ID_BIG_NOTIFICATION,
            notification
        )
    }



    /*
     *To get a Bitmap image from the URL received
     * */
    fun getBitmapfromUrl(imageUrl: String?): Bitmap? {
        return try {
            Log.e("inside getbitmap", imageUrl!!)
            val url = URL(imageUrl)
            val connection =
                url.openConnection() as HttpURLConnection
            connection.doInput = true
            connection.connect()
            val input = connection.inputStream
            BitmapFactory.decodeStream(input)
        } catch (e: Exception) {
            // TODO Auto-generated catch block
            e.printStackTrace()
            null
        }
    }

    companion object {
        const val ID_BIG_NOTIFICATION = 234
        const val ID_SMALL_NOTIFICATION = 235

        fun isAppIsInBackground(context: Context): Boolean {
            var isInBackground = true
            val am =
                context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
            if (Build.VERSION.SDK_INT > Build.VERSION_CODES.KITKAT_WATCH) {
                val runningProcesses =
                    am.runningAppProcesses
                for (processInfo in runningProcesses) {
                    if (processInfo.importance == RunningAppProcessInfo.IMPORTANCE_FOREGROUND) {
                        for (activeProcess in processInfo.pkgList) {
                            if (activeProcess == context.packageName) {
                                isInBackground = false
                            }
                        }
                    }
                }
            } else {
                val taskInfo = am.getRunningTasks(1)
                val componentInfo = taskInfo[0].topActivity
                if (componentInfo!!.packageName == context.packageName) {
                    isInBackground = false
                }
            }
            return isInBackground
        }

    }

}