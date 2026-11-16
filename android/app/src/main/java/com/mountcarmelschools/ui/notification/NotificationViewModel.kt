package com.mountcarmelschools.ui.notification

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import com.mountcarmelschools.di.networking.RetrofitClient
import com.mountcarmelschools.di.data.notificationHistory.NotificationPostData
import com.mountcarmelschools.di.data.notificationHistory.StaffNotificationHistoryResponse
import com.mountcarmelschools.di.data.updateToken.UpdateTokenResponse
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class NotificationViewModel : ViewModel() {

    /*
 Get staff notification
  */

    var staffList: MutableLiveData<StaffNotificationHistoryResponse>? = null

    fun getNotificationListForStaff(
            authToken: String,
            id: String
    ): LiveData<StaffNotificationHistoryResponse> {
        if (staffList == null) {
            staffList = MutableLiveData()
        }

        getNotificationListForStaffResponse(authToken, id)
        return staffList!!
    }

    private fun getNotificationListForStaffResponse(
            authToken: String,
            id: String
    ) {

        val responseCall: Call<StaffNotificationHistoryResponse?>? =
                RetrofitClient.apiService.getStaffNotificationHistory(authToken, id)

        responseCall?.enqueue(object : Callback<StaffNotificationHistoryResponse?> {
            override fun onResponse(
                    call: Call<StaffNotificationHistoryResponse?>,
                    response: Response<StaffNotificationHistoryResponse?>
            ) {
                if (response.isSuccessful) {

                    staffList?.value = response.body()

                }

            }

            override fun onFailure(
                    call: Call<StaffNotificationHistoryResponse?>,
                    t: Throwable
            ) {
            }
        })
    }

    //---------------   Get Staff notification -------------------------//


    /*
Get Student  notification
*/

    var studentList: MutableLiveData<StaffNotificationHistoryResponse>? = null

    fun getStudentListNotification(
            authToken: String,
            id: String
    ): LiveData<StaffNotificationHistoryResponse> {
        if (studentList == null) {
            studentList = MutableLiveData()
        }

        getStudentListResponse(authToken, id)
        return studentList!!
    }

    private fun getStudentListResponse(
            authToken: String,
            id: String
    ) {

        val responseCall: Call<StaffNotificationHistoryResponse?>? =
                RetrofitClient.apiService.getStudentNotificationHistory(authToken, id)

        responseCall?.enqueue(object : Callback<StaffNotificationHistoryResponse?> {
            override fun onResponse(
                    call: Call<StaffNotificationHistoryResponse?>,
                    response: Response<StaffNotificationHistoryResponse?>
            ) {
                if (response.isSuccessful) {

                    studentList?.value = response.body()

                }

            }

            override fun onFailure(
                    call: Call<StaffNotificationHistoryResponse?>,
                    t: Throwable
            ) {
            }
        })
    }

    //---------------   Get Student  -------------------------//


    /*
           update Student status
*/

    var studentNotificationStatus: MutableLiveData<UpdateTokenResponse>? = null

    fun updateStudentNotification(
            authToken: String,
            id: String,
            studentId: String,
            notificationPostData: NotificationPostData
    ): LiveData<UpdateTokenResponse> {
        if (studentNotificationStatus == null) {
            studentNotificationStatus = MutableLiveData()
        }

        updateStudentNotificationResponse(authToken, id, studentId, notificationPostData)
        return studentNotificationStatus!!
    }

    private fun updateStudentNotificationResponse(
            authToken: String,
            id: String,
            studentId: String,
            notificationPostData: NotificationPostData
    ) {

        val responseCall: Call<UpdateTokenResponse?>? =
                RetrofitClient.apiService.updateStudentReadNotification(authToken, id, studentId, notificationPostData)

        responseCall?.enqueue(object : Callback<UpdateTokenResponse?> {
            override fun onResponse(
                    call: Call<UpdateTokenResponse?>,
                    response: Response<UpdateTokenResponse?>
            ) {
                if (response.isSuccessful) {

                    studentNotificationStatus?.value = response.body()

                }

            }

            override fun onFailure(
                    call: Call<UpdateTokenResponse?>,
                    t: Throwable
            ) {
            }
        })
    }

    //---------------   Get Student  -------------------------//


    /*
           update Staff status
*/

    var staffNotificationStatus: MutableLiveData<UpdateTokenResponse>? = null

    fun updateStaffNotification(
            authToken: String,
            id: String,
            studentId: String,
            notificationPostData: NotificationPostData
    ): LiveData<UpdateTokenResponse> {
        if (staffNotificationStatus == null) {
            staffNotificationStatus = MutableLiveData()
        }

        updateStaffNotificationResponse(authToken, id, studentId, notificationPostData)
        return staffNotificationStatus!!
    }

    private fun updateStaffNotificationResponse(
            authToken: String,
            id: String,
            studentId: String,
            notificationPostData: NotificationPostData
    ) {

        val responseCall: Call<UpdateTokenResponse?>? =
                RetrofitClient.apiService.updateStaffReadNotification(authToken, id, studentId, notificationPostData)

        responseCall?.enqueue(object : Callback<UpdateTokenResponse?> {
            override fun onResponse(
                    call: Call<UpdateTokenResponse?>,
                    response: Response<UpdateTokenResponse?>
            ) {
                if (response.isSuccessful) {

                    staffNotificationStatus?.value = response.body()

                }

            }

            override fun onFailure(
                    call: Call<UpdateTokenResponse?>,
                    t: Throwable
            ) {
            }
        })
    }



}
