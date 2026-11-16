package com.mountcarmelschools.ui.calendar

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import com.mountcarmelschools.di.networking.RetrofitClient
import com.mountcarmelschools.di.data.student.SchoolCalendarResponse
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class SchoolCalendarViewModel : ViewModel() {
    /*
  Get Student calendar
  */
    var studentWiseResonseDate: MutableLiveData<SchoolCalendarResponse>? = null

    fun getSchoolCalendar(
        authToken: String,
        id: String
    ): LiveData<SchoolCalendarResponse> {
            studentWiseResonseDate = MutableLiveData()
        getSchoolCalendarDateResponse(authToken, id)
        return studentWiseResonseDate!!
    }

    private fun getSchoolCalendarDateResponse(
        authToken: String,
        standardID: String
    ) {

        val responseCall: Call<SchoolCalendarResponse?>? =
            RetrofitClient.apiService.getSchoolCalendarData(
                authToken,
                standardID
            )

        responseCall?.enqueue(object : Callback<SchoolCalendarResponse?> {
            override fun onResponse(
                call: Call<SchoolCalendarResponse?>,
                response: Response<SchoolCalendarResponse?>
            ) {
                if (response.isSuccessful) {

                        studentWiseResonseDate?.value = response.body()


                }

            }

            override fun onFailure(
                call: Call<SchoolCalendarResponse?>,
                t: Throwable
            ) {
            }
        })
    }
}
