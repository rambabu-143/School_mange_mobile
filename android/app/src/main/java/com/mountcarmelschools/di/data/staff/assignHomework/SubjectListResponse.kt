package com.mountcarmelschools.di.data.staff.assignHomework

import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class SubjectListResponse(
    @Json(name = "status")
    val status: Boolean?,
    @Json(name = "message")
    val message: String?,
    @Json(name = "data")
    val data: List<SubjectData>?
) {
    @JsonClass(generateAdapter = true)
    data class SubjectData(
        @Json(name = "is_subject_divide")
        val isSubjectDivide: String?, // "NO" | ...
        @Json(name = "is_taken")
        val isTaken: Boolean?,
        @Json(name = "charges_by")
        val chargesBy: String?, // "QUARTERLY" | ...
        @Json(name = "is_deleted")
        val isDeleted: Boolean?,
        @Json(name = "isMcop")
        val isMcop: Boolean?,
        @Json(name = "_id")
        val id: String?,
        @Json(name = "subject_name")
        val subjectName: String?,
        @Json(name = "short_name")
        val shortName: String?,
        @Json(name = "name_in_ar")
        val nameInAr: String?,
        @Json(name = "subject_type")
        val subjectType: String?, // "MAIN" | ...
        @Json(name = "cbse_code_x")
        val cbseCodeX: String?,
        @Json(name = "cbse_code_xii")
        val cbseCodeXii: String?,
        @Json(name = "order")
        val order: Int?,
        @Json(name = "school")
        val school: String?, // "AN" | ...
        @Json(name = "school_code")
        val schoolCode: String?, // "ANSR" | ...
        @Json(name = "branch_code")
        val branchCode: Int?,
        @Json(name = "year_session")
        val yearSession: String?, // YYYY-YY
        @Json(name = "created_at")
        val createdAt: String?,
        @Json(name = "updated_at")
        val updatedAt: String?
    )
}
