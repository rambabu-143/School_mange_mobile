package com.mountcarmelschools.di.data.wise.wiseRes


import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class StandardSectionId(
    @Json(name = "_id")
    val _id: String?,
    @Json(name = "standard")
    val standard: String?,
    @Json(name = "section")
    val section: String?,
    @Json(name = "id")
    val id: String?
)