package com.mountcarmelschools.ui.attendance.markattendance

interface MarkAttendanceInterface {

    fun selectedValue(type: String , id: String)
    fun firstSelect(id: String , type: Boolean)
    fun secondSelect(id: String , type: Boolean)
}