package com.mountcarmelschools.ui.message

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import com.mountcarmelschools.di.networking.RetrofitClient
import com.mountcarmelschools.di.data.notificationHistory.NotificationPostData
import com.mountcarmelschools.di.data.staff.sms.SmsResponse
import com.mountcarmelschools.di.data.updateToken.UpdateTokenResponse
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class MessageFragmentViewModel : ViewModel() {

    /*
Get Message
*/
    var messageResponse: MutableLiveData<SmsResponse>? = null

    fun getMessageDetail(
        authToken: String,
        id: String
    ): LiveData<SmsResponse> {
        if (messageResponse == null) {
            messageResponse = MutableLiveData()
        }

        getMessageDetailResponse(authToken, id)
        return messageResponse!!
    }

    private fun getMessageDetailResponse(
        authToken: String,
        standardID: String
    ) {

        val responseCall: Call<SmsResponse?>? =
            RetrofitClient.apiService.getStaffMessage(authToken, standardID)

        responseCall?.enqueue(object : Callback<SmsResponse?> {
            override fun onResponse(
                call: Call<SmsResponse?>,
                response: Response<SmsResponse?>
            ) {
                if (response.isSuccessful) {

                    messageResponse?.value = response.body()

                }


            }

            override fun onFailure(
                call: Call<SmsResponse?>,
                t: Throwable
            ) {
            }
        })
    }

    //---------------   Get message -------------------------//
    //
    //
    /*
Get Message
*/
    var messageResponseForStudent: MutableLiveData<SmsResponse>? = null

    fun getMessageDetailForStudent(
        authToken: String,
        id: String,
        studentSectionId: String
    ): LiveData<SmsResponse> {
        if (messageResponseForStudent == null) {
            messageResponseForStudent = MutableLiveData()
        }

        getMessageDetailResponseForStudent(authToken, id, studentSectionId)
        return messageResponseForStudent!!
    }

    private fun getMessageDetailResponseForStudent(
        authToken: String,
        standardID: String,
        studentSectionId: String
    ) {

        val responseCall: Call<SmsResponse?>? =
            RetrofitClient.apiService.getMessageForStudent(authToken, standardID)

        responseCall?.enqueue(object : Callback<SmsResponse?> {
            override fun onResponse(
                call: Call<SmsResponse?>,
                response: Response<SmsResponse?>
            ) {
                if (response.code() == 200) {
                    messageResponseForStudent?.value = response.body()
                } else {
                    var value = SmsResponse(false, "Something went wrong", null);

                    messageResponseForStudent?.value = value
                }

            }

            override fun onFailure(
                call: Call<SmsResponse?>,
                t: Throwable
            ) {
                var value = SmsResponse(false, "Something went wrong", null);

                messageResponseForStudent?.value = value
            }
        })
    }

    //---------------   Get message -------------------------//


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
                RetrofitClient.apiService.updateStudentReadMessages(authToken, id, studentId, notificationPostData)

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
                RetrofitClient.apiService.updateStaffReadMessages(authToken, id, studentId, notificationPostData)

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

    //---------------   Get Student  -------------------------//


}