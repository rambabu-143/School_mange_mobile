package com.mountcarmelschools.di.data

import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class NotificationCountModel(
    @Json(name = "message")
    val message: String,
    @Json(name = "notification_count")
    val notification_count: Int,
    @Json(name = "sms_count")
    val sms_count: Int,
    @Json(name = "status")
    val status: Boolean
)