package com.mountcarmelschools.ui.notification

import com.mountcarmelschools.di.data.notificationHistory.StaffNotificationHistoryResponse

interface NotificationInterface {

    fun showDialog(data: StaffNotificationHistoryResponse.Data?)
}