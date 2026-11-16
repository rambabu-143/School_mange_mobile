package com.mountcarmelschools.di.data.config

import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class ServerTimeResponse(
    @Json(name = "status")
    val status: Boolean?,
    @Json(name = "message")
    val message: String?,
    @Json(name = "data")
    val data: String?,
    @Json(name = "current_time")
    val currentTime: String?,
    @Json(name = "today_date")
    val todayDate: String?, // YYYY-MM-DD
)
