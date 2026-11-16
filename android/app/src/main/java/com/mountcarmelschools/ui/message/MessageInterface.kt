package com.mountcarmelschools.ui.message

import com.mountcarmelschools.di.data.staff.sms.SmsResponse

interface MessageInterface {

    fun showDialog(data: SmsResponse.Data?)
}