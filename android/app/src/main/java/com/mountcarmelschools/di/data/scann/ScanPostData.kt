package com.mountcarmelschools.di.data.scann


import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class ScanPostData(
    @Json(name = "admission_no")
    val admissionNo: String?,
    @Json(name = "search_type")
    val searchType: String?
)