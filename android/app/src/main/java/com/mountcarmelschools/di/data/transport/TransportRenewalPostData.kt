package com.mountcarmelschools.di.data.transport


import com.squareup.moshi.Json

data class TransportRenewalPostData(
    @Json(name = "admission_no")
    val admissionNo: String?,
    @Json(name = "sibling_details")
    val siblingDetails: List<SiblingDetail?>?,
    @Json(name = "student_id")
    val studentId: String?,
    @Json(name = "transport_type")
    val transportType: String?
) {
    data class SiblingDetail(
        @Json(name = "admission_no")
        val admissionNo: String?,
        @Json(name = "class")
        val classX: String?,
        @Json(name = "name")
        val name: String?,
        @Json(name = "school_code")
        val schoolCode: String?,
        @Json(name = "section")
        val section: String?,
        @Json(name = "sibling_id")
        val siblingId: String?,
        @Json(name = "standard_section_id")
        val standardSectionId: String?
    )
}