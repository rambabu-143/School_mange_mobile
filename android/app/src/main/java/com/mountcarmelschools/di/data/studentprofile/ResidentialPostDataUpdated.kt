package com.mountcarmelschools.di.data.studentprofile


import com.squareup.moshi.Json

data class ResidentialPostDataUpdated(
    @Json(name = "address")
    val address: List<Addres?>?
) {
    data class Addres(
        @Json(name = "city")
        val city: String?,
        @Json(name = "local_address")
        val localAddress: String?,
        @Json(name = "pincode")
        val pincode: String?,
        @Json(name = "state_id")
        val stateId: String?,
        @Json(name = "country_id")
        val country_id: String?,
        @Json(name = "is_parent")
        val is_parent: Boolean?= null,
        @Json(name = "parent")
        val parent: String?=null,
    )
}