package com.mountcarmelschools.di.data.staff


import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class StaffTimeTable(
    @Json(name = "status")
    val status: Boolean?,
    @Json(name = "message")
    val message: String?,
    @Json(name = "data")
    val `data`: Data?
) {
    @JsonClass(generateAdapter = true)
    data class Data(
        @Json(name = "status")
        val status: Int?,
        @Json(name = "resource")
        val resource: List<Resource?>?
    ) {
        @JsonClass(generateAdapter = true)
        data class Resource(
            @Json(name = "class")
            val classX: String?,
            @Json(name = "section")
            val section: String?,
            @Json(name = "Monday")
            val monday: List<Monday?>?,
            @Json(name = "Tuesday")
            val tuesday: List<Tuesday?>?,
            @Json(name = "Wednesday")
            val wednesday: List<Wednesday?>?,
            @Json(name = "Thursday")
            val thursday: List<Thursday?>?,
            @Json(name = "Friday")
            val friday: List<Friday?>?,
            @Json(name = "Saturday")
            val saturday: List<Any?>?,
            @Json(name = "Sunday")
            val sunday: List<Any?>?
        ) {
            @JsonClass(generateAdapter = true)
            data class Monday(
                @Json(name = "class")
                val classX: String?,
                @Json(name = "section")
                val section: String?,
                @Json(name = "day")
                val day: String?,
                @Json(name = "subject")
                val subject: String?,
                @Json(name = "start_time")
                val startTime: String?,
                @Json(name = "start_at")
                val startAt: Any?,
                @Json(name = "end_time")
                val endTime: String?,
                @Json(name = "end_at")
                val endAt: Any?
            )

            @JsonClass(generateAdapter = true)
            data class Tuesday(
                @Json(name = "class")
                val classX: String?,
                @Json(name = "section")
                val section: String?,
                @Json(name = "day")
                val day: String?,
                @Json(name = "subject")
                val subject: String?,
                @Json(name = "start_time")
                val startTime: String?,
                @Json(name = "start_at")
                val startAt: Any?,
                @Json(name = "end_time")
                val endTime: String?,
                @Json(name = "end_at")
                val endAt: Any?
            )

            @JsonClass(generateAdapter = true)
            data class Wednesday(
                @Json(name = "class")
                val classX: String?,
                @Json(name = "section")
                val section: String?,
                @Json(name = "day")
                val day: String?,
                @Json(name = "subject")
                val subject: String?,
                @Json(name = "start_time")
                val startTime: String?,
                @Json(name = "start_at")
                val startAt: Any?,
                @Json(name = "end_time")
                val endTime: String?,
                @Json(name = "end_at")
                val endAt: Any?
            )

            @JsonClass(generateAdapter = true)
            data class Thursday(
                @Json(name = "class")
                val classX: String?,
                @Json(name = "section")
                val section: String?,
                @Json(name = "day")
                val day: String?,
                @Json(name = "subject")
                val subject: String?,
                @Json(name = "start_time")
                val startTime: String?,
                @Json(name = "start_at")
                val startAt: Any?,
                @Json(name = "end_time")
                val endTime: String?,
                @Json(name = "end_at")
                val endAt: Any?
            )

            @JsonClass(generateAdapter = true)
            data class Friday(
                @Json(name = "class")
                val classX: String?,
                @Json(name = "section")
                val section: String?,
                @Json(name = "day")
                val day: String?,
                @Json(name = "subject")
                val subject: String?,
                @Json(name = "start_time")
                val startTime: String?,
                @Json(name = "start_at")
                val startAt: Any?,
                @Json(name = "end_time")
                val endTime: String?,
                @Json(name = "end_at")
                val endAt: Any?
            )
        }
    }
}