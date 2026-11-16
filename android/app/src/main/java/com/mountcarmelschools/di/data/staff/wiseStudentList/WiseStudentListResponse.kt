package com.mountcarmelschools.di.data.staff.wiseStudentList


import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class WiseStudentListResponse(
    @Json(name = "status")
    val status: Boolean?,
    @Json(name = "message")
    val message: String?,
    @Json(name = "data")
    val `data`: List<Data?>?
) {
    @JsonClass(generateAdapter = true)
    data class Data(
        @Json(name = "_id")
        val id: String?,
        @Json(name = "worthy")
        val worthy: Int?,
        @Json(name = "intellect")
        val intellect: Int?,
        @Json(name = "stature")
        val stature: Int?,
        @Json(name = "emotion")
        val emotion: Int?,
        @Json(name = "wise_date")
        val wiseDate: String?,
        @Json(name = "reason")
        val reason: String?,
        @Json(name = "created_at")
        val createdAt: String?,
        @Json(name = "students")
        val students: Students?,
        @Json(name = "staffs")
        val staffs: Staffs?
    ) {
        @JsonClass(generateAdapter = true)
        data class Students(
            @Json(name = "_id")
            val id: String?,
            @Json(name = "admission_no")
            val admissionNo: String?,
            @Json(name = "name")
            val name: String?
        )

        @JsonClass(generateAdapter = true)
        data class Staffs(
            @Json(name = "name")
            val name: String?
        )
    }
}