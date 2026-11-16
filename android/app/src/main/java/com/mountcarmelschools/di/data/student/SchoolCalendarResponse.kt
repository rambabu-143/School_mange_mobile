package com.mountcarmelschools.di.data.student


import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class SchoolCalendarResponse(
    @Json(name = "status")
    val status: Boolean?,
    @Json(name = "message")
    val message: String?,
    @Json(name = "events")
    val events: List<Event?>?,
    @Json(name = "holidays")
    val holidays: List<Holiday?>?
) {
    @JsonClass(generateAdapter = true)
    data class Event(
        @Json(name = "is_deleted")
        val isDeleted: Boolean?,
        @Json(name = "_id")
        val id: String?,
        @Json(name = "title")
        val title: String?,
        @Json(name = "event_for")
        val eventFor: String?,
        @Json(name = "start_date")
        val startDate: String?,
        @Json(name = "end_date")
        val endDate: String?,
        @Json(name = "primary_color")
        val primaryColor: String?,
        @Json(name = "secondary_color")
        val secondaryColor: String?,
        @Json(name = "location")
        val location: String?,
        @Json(name = "remark")
        val remark: String?,
        @Json(name = "branch_code")
        val branchCode: String?,
        @Json(name = "created_at")
        val createdAt: String?,
        @Json(name = "updated_at")
        val updatedAt: String?,
        @Json(name = "__v")
        val v: Int?
    )

    @JsonClass(generateAdapter = true)
    data class Holiday(
        @Json(name = "is_deleted")
        val isDeleted: Boolean?,
        @Json(name = "_id")
        val id: String?,
        @Json(name = "date")
        val date: String?,
        @Json(name = "day")
        val day: String?,
        @Json(name = "standard_id")
        val standardId: String?,
        @Json(name = "status")
        val status: String?,
        @Json(name = "remark")
        val remark: String?,
        @Json(name = "term")
        val term: Int?,
        @Json(name = "school_code")
        val schoolCode: String?,
        @Json(name = "branch_code")
        val branchCode: String?,
        @Json(name = "year_session")
        val yearSession: String?,
        @Json(name = "created_at")
        val createdAt: String?,
        @Json(name = "updated_at")
        val updatedAt: String?,
        @Json(name = "updated_by")
        val updatedBy: Any?
    )
}