package com.mountcarmelschools.di.data

import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class CommonResponse(
    @Json(name = "status")
    val status: Boolean?,
    @Json(name = "message")
    val message: String?
)
