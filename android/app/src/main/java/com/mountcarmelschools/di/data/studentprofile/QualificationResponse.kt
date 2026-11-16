package com.mountcarmelschools.di.data.studentprofile


import com.squareup.moshi.Json

data class QualificationResponse(
    @Json(name = "data")
    val data: List<Data>,
    @Json(name = "message")
    val message: String?,
    @Json(name = "status")
    val status: Boolean?
) {
    data class Data(
        @Json(name = "code")
        val code: String?,
        @Json(name = "_id")
        val id: String?,
        @Json(name = "order")
        val order: Int?,
        @Json(name = "qualification")
        val qualification: String?
    )
}