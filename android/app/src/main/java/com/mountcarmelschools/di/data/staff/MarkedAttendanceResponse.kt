package com.mountcarmelschools.di.data.staff


import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class MarkedAttendanceResponse(
    @Json(name = "status")
    val status: Boolean?,
    @Json(name = "message")
    val message: String?,
) {
    @JsonClass(generateAdapter = true)
    data class Data(
        @Json(name = "standard_id")
        val standardId: String?,
        @Json(name = "standard_section_id")
        val standardSectionId: StandardSectionId?,
        @Json(name = "date")
        val date: String?,
        @Json(name = "students")
        val students: List<Student?>?
    ) {
        @JsonClass(generateAdapter = true)
        data class Student(
            @Json(name = "student_id")
            val studentId: String?,
            @Json(name = "type")
            val type: String?,
            @Json(name = "value")
            val value: Double?,
            @Json(name = "reason")
            val reason: String?,
            @Json(name = "information")
            val information: String?
        )
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
    }
}