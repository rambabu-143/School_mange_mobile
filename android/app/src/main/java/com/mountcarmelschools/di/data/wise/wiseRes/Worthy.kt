package com.mountcarmelschools.di.data.wise.wiseRes


import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class Worthy(
    @Json(name = "count")
    val count: Int?,
    @Json(name = "data")
    val `data`: List<DataX>?
)