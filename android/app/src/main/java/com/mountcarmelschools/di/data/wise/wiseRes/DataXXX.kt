package com.mountcarmelschools.di.data.wise.wiseRes


import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class DataXXX(
    @Json(name = "worthy")
    val worthy: Int?,
    @Json(name = "intellect")
    val intellect: Int?,
    @Json(name = "stature")
    val stature: Int?,
    @Json(name = "emotion")
    val emotion: Int?,
    @Json(name = "is_deleted")
    val isDeleted: Boolean?,
    @Json(name = "_id")
    val _id: String?,
    @Json(name = "id")
    val id: Int?,
    @Json(name = "adm_no")
    val admNo: Int?,
    @Json(name = "staff_id")
    val staffId: StaffId?,
    @Json(name = "staff_branch")
    val staffBranch: String?,
    @Json(name = "remarks")
    val remarks: String?,
    @Json(name = "card_type")
    val cardType: String?,
    @Json(name = "timestamp")
    val timestamp: String?,
    @Json(name = "approved")
    val approved: String?,
    @Json(name = "approvedby")
    val approvedby: String?,
    @Json(name = "approval_timestamp")
    val approvalTimestamp: String?,
    @Json(name = "card_entry_by")
    val cardEntryBy: String?,
    @Json(name = "parent_id")
    val parentId: String?,
    @Json(name = "chaap")
    val chaap: String?,
    @Json(name = "parent_card_id")
    val parentCardId: Int?,
    @Json(name = "status")
    val status: Int?,
    @Json(name = "admission_no")
    val admissionNo: String?,
    @Json(name = "school_code")
    val schoolCode: String?,
    @Json(name = "wise_date")
    val wiseDate: String?,
    @Json(name = "reason")
    val reason: String?,
    @Json(name = "wise_updated")
    val wiseUpdated: String?,
    @Json(name = "created_at")
    val createdAt: String?,
    @Json(name = "updated_at")
    val updatedAt: String?
)