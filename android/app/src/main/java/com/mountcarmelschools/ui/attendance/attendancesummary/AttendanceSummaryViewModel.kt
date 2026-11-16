package com.mountcarmelschools.ui.attendance.attendancesummary

import android.util.Log
import android.view.View
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import com.mountcarmelschools.di.networking.RetrofitClient
import com.mountcarmelschools.di.data.staff.attendanceSummery.AttendanceSummeryResponse
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class AttendanceSummaryViewModel : ViewModel() {

    fun showDateDialog(view: View) {
        //Utils.showCalendarDialog(view.context)
    }


    /*
 Get attendance summery
  */


    var attendanceSummeryList: MutableLiveData<AttendanceSummeryResponse>? = null

    fun getAttendanceSummery(
        authToken: String,
        date: String
    ): LiveData<AttendanceSummeryResponse> {
            attendanceSummeryList = MutableLiveData()


        getAttendanceSummeryResponse(authToken, date)
        return attendanceSummeryList!!
    }


    private fun getAttendanceSummeryResponse(authToken: String, date: String) {

        val responseCall: Call<AttendanceSummeryResponse?>? =
            RetrofitClient.apiService.getAttendanceSummery(authToken, date)

        responseCall?.enqueue(object : Callback<AttendanceSummeryResponse?> {
            override fun onResponse(
                call: Call<AttendanceSummeryResponse?>,
                response: Response<AttendanceSummeryResponse?>
            ) {

                    attendanceSummeryList?.value = response.body()

            }

            override fun onFailure(
                call: Call<AttendanceSummeryResponse?>,
                t: Throwable
            ) {

                Log.e("error", t.localizedMessage)

            }
        })
    }

    //---------------   Get attendance summery -------------------------//
}
