package com.mountcarmelschools.di.data.studentprofile


import com.squareup.moshi.Json

data class GetAllSubCategoryResponse(
    @Json(name = "data")
    val `data`: List<Data>,
    @Json(name = "message")
    val message: String?,
    @Json(name = "status")
    val status: Boolean?
) {
    data class Data(
        @Json(name = "category_Id")
        val categoryId: String?,
        @Json(name = "_id")
        val id: String?,
        @Json(name = "occupation_child_code")
        val occupationChildCode: String?,
        @Json(name = "occupation_child_name")
        val occupationChildName: String?,
        @Json(name = "occupation_id")
        val occupationId: String?
    )
}