package com.mountcarmelschools.ui.attendance.markattendance

import android.util.Log
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import com.mountcarmelschools.di.data.reason.ReasonResponse
import com.mountcarmelschools.di.data.staff.MarkedAttendanceResponse
import com.mountcarmelschools.di.data.staff.markAttandance.MarkAttendanceResponse
import com.mountcarmelschools.di.data.staff.markAttendance.MarkedAttendanceRequestBody
import com.mountcarmelschools.di.networking.RetrofitClient
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class MarkAttendanceViewModel : ViewModel() {
    /*
Get marked Attendance
*/
    var markedAttendanceResponse: MutableLiveData<MarkedAttendanceResponse>? = null

    fun markAttendance(
        authToken: String,
        json: MarkedAttendanceRequestBody?
    ): LiveData<MarkedAttendanceResponse> {
        markedAttendanceResponse = MutableLiveData()
        getMarkedAttendanceResponse(authToken, json!!)
        return markedAttendanceResponse!!
    }

    private fun getMarkedAttendanceResponse(
        authToken: String, json: MarkedAttendanceRequestBody
    ) {

        val responseCall: Call<MarkedAttendanceResponse?>? =
            RetrofitClient.apiService.markAttendance(authToken, json)

        responseCall?.enqueue(object : Callback<MarkedAttendanceResponse?> {
            override fun onResponse(
                call: Call<MarkedAttendanceResponse?>,
                response: Response<MarkedAttendanceResponse?>
            ) {
                if (response.isSuccessful) {

                    markedAttendanceResponse?.value = response.body()

                }

            }

            override fun onFailure(
                call: Call<MarkedAttendanceResponse?>,
                t: Throwable
            ) {
                Log.e("", t.localizedMessage);
            }
        })
    }

    /*
Get Reason
*/
    var reasonResponse: MutableLiveData<ReasonResponse>? = null

    fun getReason(
        authToken: String
    ): LiveData<ReasonResponse> {
        reasonResponse = MutableLiveData()

        getReasonResponse(authToken)
        return reasonResponse!!
    }

    private fun getReasonResponse(
        authToken: String
    ) {

        val responseCall: Call<ReasonResponse?>? =
            RetrofitClient.apiService.getReason(authToken)

        responseCall?.enqueue(object : Callback<ReasonResponse?> {
            override fun onResponse(
                call: Call<ReasonResponse?>,
                response: Response<ReasonResponse?>
            ) {
                reasonResponse?.value = response.body()


            }

            override fun onFailure(
                call: Call<ReasonResponse?>,
                t: Throwable
            ) {
            }
        })
    }


    /*
Get Attendance Date
*/
    var attendanceStudentLiveList: MutableLiveData<MarkAttendanceResponse>? = null

    fun getStudentMarkedResponseFromDate(
        authToken: String,
        sectionId: String,
        startDate: String,
        endDate: String
    ): LiveData<MarkAttendanceResponse> {

        attendanceStudentLiveList = MutableLiveData()

        getMarkedStudentResponse(authToken, sectionId, startDate, endDate)

        return attendanceStudentLiveList!!

    }

    private fun getMarkedStudentResponse(
        authToken: String,
        sectionId: String,
        startDate: String,
        strEndDate: String
    ) {

        val responseCall: Call<MarkAttendanceResponse?>? =
            RetrofitClient.apiService.getStudentListForMarkAttendance(
                authToken,
                sectionId,
                startDate,
                strEndDate
            )

        responseCall?.enqueue(object : Callback<MarkAttendanceResponse?> {
            override fun onResponse(
                call: Call<MarkAttendanceResponse?>,
                response: Response<MarkAttendanceResponse?>
            ) {

                attendanceStudentLiveList?.value = response.body()


            }

            override fun onFailure(
                call: Call<MarkAttendanceResponse?>,
                t: Throwable
            ) {
                Log.e("", t.localizedMessage)
            }
        })
    }
}

