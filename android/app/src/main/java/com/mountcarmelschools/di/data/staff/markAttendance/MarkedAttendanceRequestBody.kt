package com.mountcarmelschools.di.data.staff.markAttendance

import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass


@JsonClass(generateAdapter = true)
data class MarkedAttendanceRequestBody(
        @Json(name = "standard_id")
        val standardId: String?,
        @Json(name = "standard_section_id")
        val standardSectionId: String?,
        @Json(name = "date")
        val date: String?,
        @Json(name = "students")
        val students: List<Student?>?,
        @Json(name = "allstudent")
        val allStudent: List<StudentId>?,
        @Json(name = "no_of_student")
        val noOfStudent: Int?,
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
            @Json(name = "details")
            val details: String?,
            @Json(name = "information")
            val information: String?
    )
    @JsonClass(generateAdapter = true)
    data class StudentId(
            @Json(name = "student_id")
            val studentId: String,
    )
}

