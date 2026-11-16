package com.mountcarmelschools.ui.setting


import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class SettingPostData(
    @Json(name = "name")
    val name: String?,
    @Json(name = "status")
    val status: String?
)