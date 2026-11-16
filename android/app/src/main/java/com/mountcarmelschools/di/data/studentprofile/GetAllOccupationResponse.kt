package com.mountcarmelschools.di.data.studentprofile


import com.squareup.moshi.Json

data class GetAllOccupationResponse(
    @Json(name = "data")
    val `data`: List<Data>,
    @Json(name = "message")
    val message: String?,
    @Json(name = "status")
    val status: Boolean?
) {
    data class Data(
        @Json(name = "_id")
        val id: String?,
        @Json(name = "occupation_code")
        val occupationCode: String?,
        @Json(name = "occupation_name")
        val occupationName: String?,
        @Json(name = "order")
        val order: Int?
    )
}