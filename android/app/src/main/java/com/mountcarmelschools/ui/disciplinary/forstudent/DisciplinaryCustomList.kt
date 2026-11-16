package com.mountcarmelschools.ui.disciplinary.forstudent


data class DisciplinaryCustomList(
    val cardName: String,
    val color: Int,
    val color_name: String,
    val count: String,
    val data: List<DisciplinaryCustomListData>
) {
    data class DisciplinaryCustomListData(
        val actionTaken: String,
        val housePoint: String,
        val issueDate: String,
        val reason: String,
        val reasonOther: String,
        val staffName: String,
        val issuedTo: String
    )
}