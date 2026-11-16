package com.mountcarmelschools.ui.classlist

import com.mountcarmelschools.di.data.classList.ClassListResponse

interface ClassListInterface {

    fun selectedClassList(get: ClassListResponse.Data?)
}