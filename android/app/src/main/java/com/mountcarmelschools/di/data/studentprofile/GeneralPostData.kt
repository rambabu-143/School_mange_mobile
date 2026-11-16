package com.mountcarmelschools.di.data.studentprofile

import com.squareup.moshi.Json

data class GeneralPostData (
        @Json(name = "aadhar_card")
        val aadhar_card: String?,
        @Json(name = "mother_tongue_id")
        val mother_tongue_id: String?
    )
