package com.mountcarmelschools.ui.disciplinary.forstaff

import com.mountcarmelschools.di.data.staff.wiseStudentList.WiseListFromClassResponse
import com.mountcarmelschools.di.data.wise.wiseRes.WisePostData

interface DisciplinaryInterface {

    fun showDetailDialog(card:String ,data: WiseListFromClassResponse.Data?)
    fun removeData(id: String)

}