package com.mountcarmelschools.di.data.studentprofile


import com.squareup.moshi.Json

data class ParentPostData(
    @Json(name = "relation")
    val relation: List<Relation>
) {
    data class Relation(
        @Json(name = "designation")
        var designation: String?,
        @Json(name = "email")
        var email: String?,
        @Json(name = "mobile")
        var mobile: String?,
        @Json(name = "name")
        var name: String?,
        @Json(name = "occupation_child_id")
        var occupationChildId: String?,
        @Json(name = "occupation_id")
        var occupationId: String?,
        @Json(name = "office_address")
        var officeAddress: String?,
        @Json(name = "office_phone")
        var officePhone: String?,
        @Json(name = "organization")
        var organization: String?,
        @Json(name = "pancard")
        var pancard: String?,
        @Json(name = "qualification_id")
        var qualificationId: String?,
        @Json(name = "relation")
        var relation: String?
    )
}