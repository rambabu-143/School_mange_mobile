package com.mountcarmelschools.ui.wise

import com.mountcarmelschools.di.data.wise.wiseRes.WisePostData

interface wiseInterface {

    fun addData(wisePostData: WisePostData)
    fun removeData(id: String)

}