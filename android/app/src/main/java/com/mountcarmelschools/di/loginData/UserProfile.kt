package com.mountcarmelschools.di.loginData


import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class UserProfile(
    @Json(name = "mobileNo") val mobileNo: Int,
    @Json(name = "name") val name: String,
    @Json(name = "userId") val userId: String,
    @Json(name = "userTypeId") val userTypeId: Int,
    @Json(name = "usertype") val usertype: String
)

