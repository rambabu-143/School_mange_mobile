package com.mountcarmelschools.ui.attendance.markattendance

interface DialogInterface {

    fun selectedReason(str:String , id:String)
    fun selectedInfo(str:String , id:String)
    fun enteredOtherReason(str:String , id:String)
}