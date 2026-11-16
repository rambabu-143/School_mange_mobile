package com.mountcarmelschools.di.data.timeTable


import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class TimeTableResponse(
    @Json(name = "data")
    val `data`: Data?,
    @Json(name = "message")
    val message: String?,
    @Json(name = "status")
    val status: Boolean?
) {
    @JsonClass(generateAdapter = true)
    data class Data(
        @Json(name = "resource")
        val resource: List<Resource?>?,
        @Json(name = "status")
        val status: Int?
    ) {
        @JsonClass(generateAdapter = true)
        data class Resource(
            @Json(name = "class")
            val classX: String?,
            @Json(name = "Friday")
            val friday: List<Friday?>?,
            @Json(name = "Monday")
            val monday: List<Monday?>?,
            @Json(name = "Saturday")
            val saturday: List<Any?>?,
            @Json(name = "section")
            val section: String?,
            @Json(name = "Sunday")
            val sunday: List<Any?>?,
            @Json(name = "Thursday")
            val thursday: List<Thursday?>?,
            @Json(name = "Tuesday")
            val tuesday: List<Tuesday?>?,
            @Json(name = "Wednesday")
            val wednesday: List<Wednesday?>?
        ) {
            @JsonClass(generateAdapter = true)
            data class Friday(
                @Json(name = "class")
                val classX: String?,
                @Json(name = "day")
                val day: String?,
                @Json(name = "end_at")
                val endAt: Any?,
                @Json(name = "end_time")
                val endTime: String?,
                @Json(name = "section")
                val section: String?,
                @Json(name = "start_at")
                val startAt: Any?,
                @Json(name = "start_time")
                val startTime: String?,
                @Json(name = "subject")
                val subject: String?
            )

            @JsonClass(generateAdapter = true)
            data class Monday(
                @Json(name = "class")
                val classX: String?,
                @Json(name = "day")
                val day: String?,
                @Json(name = "end_at")
                val endAt: Any?,
                @Json(name = "end_time")
                val endTime: String?,
                @Json(name = "section")
                val section: String?,
                @Json(name = "start_at")
                val startAt: Any?,
                @Json(name = "start_time")
                val startTime: String?,
                @Json(name = "subject")
                val subject: String?
            )

            @JsonClass(generateAdapter = true)
            data class Thursday(
                @Json(name = "class")
                val classX: String?,
                @Json(name = "day")
                val day: String?,
                @Json(name = "end_at")
                val endAt: Any?,
                @Json(name = "end_time")
                val endTime: String?,
                @Json(name = "section")
                val section: String?,
                @Json(name = "start_at")
                val startAt: Any?,
                @Json(name = "start_time")
                val startTime: String?,
                @Json(name = "subject")
                val subject: String?
            )

            @JsonClass(generateAdapter = true)
            data class Tuesday(
                @Json(name = "class")
                val classX: String?,
                @Json(name = "day")
                val day: String?,
                @Json(name = "end_at")
                val endAt: Any?,
                @Json(name = "end_time")
                val endTime: String?,
                @Json(name = "section")
                val section: String?,
                @Json(name = "start_at")
                val startAt: Any?,
                @Json(name = "start_time")
                val startTime: String?,
                @Json(name = "subject")
                val subject: String?
            )

            @JsonClass(generateAdapter = true)
            data class Wednesday(
                @Json(name = "class")
                val classX: String?,
                @Json(name = "day")
                val day: String?,
                @Json(name = "end_at")
                val endAt: Any?,
                @Json(name = "end_time")
                val endTime: String?,
                @Json(name = "section")
                val section: String?,
                @Json(name = "start_at")
                val startAt: Any?,
                @Json(name = "start_time")
                val startTime: String?,
                @Json(name = "subject")
                val subject: String?
            )
        }
    }
}