package com.mountcarmelschools.di.data.studentprofile


import com.squareup.moshi.Json

data class MedicalPostData(
    @Json(name = "medical")
    val medical: Medical?
) {
    data class Medical(
        @Json(name = "allergies")
        val allergies: String?,
        @Json(name = "bloodgroup")
        val bloodgroup: String?
    )
}