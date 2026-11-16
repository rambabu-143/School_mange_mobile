package com.mountcarmelschools.di.loginData


import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class SocialLoginRequest(
    @Json(name = "email") val email: String,
    @Json(name = "token") val password: String,
    @Json(name = "platform") val platform: String
)
