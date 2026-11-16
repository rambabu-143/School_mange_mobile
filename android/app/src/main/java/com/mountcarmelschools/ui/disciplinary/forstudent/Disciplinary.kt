package com.mountcarmelschools.ui.disciplinary.forstudent

import com.mountcarmelschools.di.data.disciplinaryCard.DisciplinaryCardResponse

interface Disciplinary {
    fun onClick(value: DisciplinaryCustomList, data: DisciplinaryCardResponse.Data?)
}