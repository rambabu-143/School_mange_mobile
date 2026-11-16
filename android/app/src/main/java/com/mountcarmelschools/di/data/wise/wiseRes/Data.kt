package com.mountcarmelschools.di.data.wise.wiseRes


import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class Data(
    @Json(name = "worthy")
    val worthy: Worthy?,
    @Json(name = "intellect")
    val intellect: Intellect?,
    @Json(name = "stature")
    val stature: Stature?,
    @Json(name = "emotion")
    val emotion: Emotion?
)