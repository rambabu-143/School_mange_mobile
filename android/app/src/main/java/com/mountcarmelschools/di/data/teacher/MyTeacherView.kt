package com.mountcarmelschools.di.data.teacher


import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class MyTeacherView(
        val teacher: List<Teacher?>?
) {
    @JsonClass(generateAdapter = true)
    data class Teacher(
            val id: String?,
            val name: String?,
            val title: String?,
            val profilePic: String?
    )
}