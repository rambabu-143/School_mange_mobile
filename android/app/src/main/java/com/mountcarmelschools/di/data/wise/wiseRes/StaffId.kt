package com.mountcarmelschools.di.data.wise.wiseRes


import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class StaffId(
    @Json(name = "_id")
    val id: String?,
    @Json(name = "name")
    val name: String?
)