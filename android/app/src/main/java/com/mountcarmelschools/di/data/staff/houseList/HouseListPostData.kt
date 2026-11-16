package com.mountcarmelschools.di.data.staff.houseList


import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class HouseListPostData(
    @Json(name = "standard_sections")
    val standardSections: List<String?>?,
    @Json(name = "houses")
    val houses: List<String?>?
)