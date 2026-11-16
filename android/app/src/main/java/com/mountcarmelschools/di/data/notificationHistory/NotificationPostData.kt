package com.mountcarmelschools.di.data.notificationHistory


import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class NotificationPostData(
    @Json(name = "read_flag")
    val readFlag: Boolean?
)