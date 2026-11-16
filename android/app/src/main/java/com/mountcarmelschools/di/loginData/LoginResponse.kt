package com.mountcarmelschools.di.loginData


import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class LoginResponse(
    @Json(name = "message") val message: String,
    @Json(name = "status") val status: Boolean,
    @Json(name = "result") val userProfile: UserProfile

)