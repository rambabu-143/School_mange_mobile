package com.mountcarmelschools.di.data.streamSelection


import com.squareup.moshi.Json

data class StreamSelectionResponse(
    @Json(name = "data")
    val `data`: List<Data?>?,
    @Json(name = "eligibility_criteria")
    val eligibilityCriteria: String?,
    @Json(name = "message")
    val message: String?,
    @Json(name = "status")
    val status: Boolean?
) {
    data class Data(
        @Json(name = "branch_code")
        val branchCode: Int?,
        @Json(name = "combination_name")
        val combinationName: String?,
        @Json(name = "created_at")
        val createdAt: String?,
        @Json(name = "created_by")
        val createdBy: CreatedBy?,
        @Json(name = "_id")
        val id: String?,
        @Json(name = "is_additional_subject")
        val isAdditionalSubject: Boolean?,
        @Json(name = "is_deleted")
        val isDeleted: Boolean?,
        @Json(name = "order")
        val order: Int?,
        @Json(name = "subject1")
        val subject1: List<Subject1?>?,
        @Json(name = "subject2")
        val subject2: List<Subject2?>?,
        @Json(name = "subject3")
        val subject3: List<Subject3?>?,
        @Json(name = "subject4")
        val subject4: List<Subject4?>?,
        @Json(name = "subject5")
        val subject5: List<Subject5?>?,
        @Json(name = "subject6")
        val subject6: List<Subject6?>?,
        @Json(name = "updated_at")
        val updatedAt: String?,
        @Json(name = "__v")
        val v: Int?,
        @Json(name = "year_session")
        val yearSession: String?
    ) {
        data class CreatedBy(
            @Json(name = "_id")
            val id: String?,
            @Json(name = "name")
            val name: String?
        )

        data class Subject1(
            @Json(name = "_id")
            val id: String?,
            @Json(name = "subject_name")
            val subjectName: String?
        )

        data class Subject2(
            @Json(name = "_id")
            val id: String?,
            @Json(name = "subject_name")
            val subjectName: String?
        )

        data class Subject3(
            @Json(name = "_id")
            val id: String?,
            @Json(name = "subject_name")
            val subjectName: String?
        )

        data class Subject4(
            @Json(name = "_id")
            val id: String?,
            @Json(name = "subject_name")
            val subjectName: String?
        )

        data class Subject5(
            @Json(name = "_id")
            val id: String?,
            @Json(name = "subject_name")
            val subjectName: String?
        )

        data class Subject6(
            @Json(name = "_id")
            val id: String?,
            @Json(name = "subject_name")
            val subjectName: String?
        )
    }
}