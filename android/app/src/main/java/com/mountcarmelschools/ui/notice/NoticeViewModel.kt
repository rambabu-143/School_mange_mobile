package com.mountcarmelschools.ui.notice

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import com.mountcarmelschools.di.networking.RetrofitClient
import com.mountcarmelschools.di.data.staff.notice.NoticeResponse
import com.mountcarmelschools.di.data.student.StudentNoticeResponse
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class NoticeViewModel : ViewModel() {

    /*
Get Notice
*/
    var noticeResponse: MutableLiveData<NoticeResponse>? = null

    fun getNoticeDetail(
        authToken: String,
        id: String
    ): LiveData<NoticeResponse> {
        if (noticeResponse == null) {
            noticeResponse = MutableLiveData()
        }

        getNoticeDetailResponse(authToken, id)
        return noticeResponse!!
    }

    private fun getNoticeDetailResponse(
        authToken: String,
        standardID: String
    ) {

        val responseCall: Call<NoticeResponse?>? =
            RetrofitClient.apiService.getNotice(authToken, standardID)

        responseCall?.enqueue(object : Callback<NoticeResponse?> {
            override fun onResponse(
                call: Call<NoticeResponse?>,
                response: Response<NoticeResponse?>
            ) {
                if (response.isSuccessful) {

                    noticeResponse?.value = response.body()

                }


            }

            override fun onFailure(
                call: Call<NoticeResponse?>,
                t: Throwable
            ) {
            }
        })
    }

    //---------------   Get Notice -------------------------//


    /*
Get Student Notice
*/
    var studentNoticeResponse: MutableLiveData<StudentNoticeResponse>? = null

    fun getStudentNoticeDetail(
        authToken: String,
        id: String
    ): LiveData<StudentNoticeResponse> {
        if (studentNoticeResponse == null) {
            studentNoticeResponse = MutableLiveData()
        }

        getStudentNoticeDetailResponse(authToken, id)
        return studentNoticeResponse!!
    }

    private fun getStudentNoticeDetailResponse(
        authToken: String,
        standardID: String
    ) {

        val responseCall: Call<StudentNoticeResponse?>? =
            RetrofitClient.apiService.getStudentNotice(authToken, standardID)

        responseCall?.enqueue(object : Callback<StudentNoticeResponse?> {
            override fun onResponse(
                call: Call<StudentNoticeResponse?>,
                response: Response<StudentNoticeResponse?>
            ) {

                studentNoticeResponse?.value = response.body()

            }

            override fun onFailure(
                call: Call<StudentNoticeResponse?>,
                t: Throwable
            ) {
            }
        })
    }

    //---------------   Get Notice -------------------------//
}