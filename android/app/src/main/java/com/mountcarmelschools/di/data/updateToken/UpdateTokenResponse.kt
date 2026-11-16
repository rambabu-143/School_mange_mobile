package com.mountcarmelschools.di.data.updateToken


import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class UpdateTokenResponse(
    @Json(name = "status")
    val status: Boolean?,
    @Json(name = "message")
    val message: String?
)