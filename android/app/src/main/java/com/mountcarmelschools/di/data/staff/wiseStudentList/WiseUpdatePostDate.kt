package com.mountcarmelschools.di.data.staff.wiseStudentList


import java.util.*
import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

class WiseUpdatePostDate : ArrayList<WiseUpdatePostDate.WiseUpdatePostDateItem>() {
    @JsonClass(generateAdapter = true)
    data class WiseUpdatePostDateItem(
        @Json(name = "student_id")
        val studentId: String?,
        @Json(name = "wise_date")
        val wiseDate: String?,
        @Json(name = "worthy")
        val worthy: Int?,
        @Json(name = "reason")
        val reason: String?
    )
}