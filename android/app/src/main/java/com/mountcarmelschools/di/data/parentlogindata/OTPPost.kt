package com.mountcarmelschools.di.data.parentlogindata

import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class OTPPost(
        @Json(name = "mobileno") val mobile: String,
        @Json(name = "otp") val otp :String,
        @Json(name = "platform") val platform :String
)