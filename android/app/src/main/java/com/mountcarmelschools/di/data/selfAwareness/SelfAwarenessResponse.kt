package com.mountcarmelschools.di.data.selfAwareness

data class SelfAwarenessResponse(
    val `data`: Data?,
    val golive_data: GoliveData?,
    val message: String?,
    val path: String?,
    val status: Boolean?
) {
    data class Data(
        val __v: Int?,
        val _id: String?,
        val branch_code: Int?,
        val created_at: String?,
        val is_deleted: Boolean?,
        val is_submit: Boolean?,
        val my_goal: String?,
        val my_interest_hobbies: String?,
        val my_strength: String?,
        val responsibilities: String?,
        val standard_section_id: StandardSectionId?,
        val student_id: StudentId?,
        val updated_at: String?,
        val year_session: String?
    ) {
        data class StandardSectionId(
            val _id: String?,
            val id: String?,
            val section: String?,
            val standard: String?
        )

        data class StudentId(
            val _id: String?,
            val admission_no: String?,
            val email: String?,
            val name: String?,
            val profile_pic: String?
        )
    }

    data class GoliveData(
        val __v: Int?,
        val _id: String?,
        val branch_code: Int?,
        val created_at: String?,
        val end_date: String?,
        val end_time: String?,
        val is_deleted: Boolean?,
        val remark: String?,
        val standard_sections: List<String?>?,
        val start_date: String?,
        val start_time: String?,
        val students: List<Any?>?,
        val type: String?,
        val updated_at: String?,
        val year_session: String?
    )
}