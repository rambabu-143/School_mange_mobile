package com.mountcarmelschools.di.data.updateToken


import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class TokenPostData(
    @Json(name = "token")
    val token: String?
)