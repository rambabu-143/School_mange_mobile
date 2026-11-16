package com.mountcarmelschools.ui.holidayHomework

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import com.mountcarmelschools.di.networking.RetrofitClient
import com.mountcarmelschools.di.data.holidayHomeWork.HolidayHomeWorkResponse
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class HolidayHomeWorkViewModel : ViewModel() {

    /*
Get Student HomeWork
*/
    var studentNoticeResponse: MutableLiveData<HolidayHomeWorkResponse>? = null

    fun getStudentNoticeDetail(
            authToken: String,
            id: String
    ): LiveData<HolidayHomeWorkResponse> {
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

        val responseCall: Call<HolidayHomeWorkResponse?>? =
                RetrofitClient.apiService.getStudentHomeWork(authToken, standardID)

        responseCall?.enqueue(object : Callback<HolidayHomeWorkResponse?> {
            override fun onResponse(
                    call: Call<HolidayHomeWorkResponse?>,
                    response: Response<HolidayHomeWorkResponse?>
            ) {

                studentNoticeResponse?.value = response.body()

            }

            override fun onFailure(
                    call: Call<HolidayHomeWorkResponse?>,
                    t: Throwable
            ) {
            }
        })
    }

    //---------------   Get Notice -------------------------//
}