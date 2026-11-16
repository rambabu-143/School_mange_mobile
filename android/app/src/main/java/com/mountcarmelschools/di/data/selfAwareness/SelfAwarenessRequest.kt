package com.mountcarmelschools.di.data.selfAwareness


import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass


@JsonClass(generateAdapter = true)
class SelfAwarenessRequest (
    @Json(name = "my_goal") val my_goal: String,
    @Json(name = "my_strength") val my_strength: String,
    @Json(name = "my_interest_hobbies") val my_interest_hobbies: String,
    @Json(name = "responsibilities") val responsibilities: String,
    @Json(name = "is_submit") val is_submit: String,
    @Json(name = "student_id") val student_id: String,
    @Json(name = "standard_section_id") val standard_section_id: String,
)