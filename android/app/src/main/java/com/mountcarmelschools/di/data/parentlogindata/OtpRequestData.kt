package com.mountcarmelschools.di.data.parentlogindata

import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class OtpRequestData(
    @Json(name = "mobileno") val mobile: String
)