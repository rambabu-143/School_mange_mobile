package com.mountcarmelschools.di.data.setting


import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class SwitchBranchRequest(
    @Json(name = "branch_code") val branch_code: String,
    @Json(name = "platform") val platform: String
)
