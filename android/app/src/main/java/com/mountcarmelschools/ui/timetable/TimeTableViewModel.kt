package com.mountcarmelschools.ui.timetable

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import com.mountcarmelschools.di.networking.RetrofitClient
import com.mountcarmelschools.di.data.timeTable.TimeTableResponse
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class TimeTableViewModel : ViewModel() {


    /*
  Get Student Time Table Detail
   */


    var studentTimeTableLiveList: MutableLiveData<TimeTableResponse>? = null

    fun getTimeTable(authToken: String, sectionId: String): LiveData<TimeTableResponse> {
        if (studentTimeTableLiveList == null) {
            studentTimeTableLiveList = MutableLiveData()
        }

        getTimeTableResponse(authToken, sectionId)
        return studentTimeTableLiveList!!
    }

    private fun getTimeTableResponse(authToken: String, sectionId: String) {

        val responseCall: Call<TimeTableResponse?>? =
            RetrofitClient.apiService.getTimeTable(authToken, sectionId)

        responseCall?.enqueue(object : Callback<TimeTableResponse?> {
            override fun onResponse(
                call: Call<TimeTableResponse?>,
                response: Response<TimeTableResponse?>
            ) {
                if (response.isSuccessful) {

                    studentTimeTableLiveList?.value = response.body()

                }


            }

            override fun onFailure(
                call: Call<TimeTableResponse?>,
                t: Throwable
            ) {
            }
        })
    }

    //--------------- End Student Time table Detail -------------------------//


    /*
  Get Standard  Time Table Detail
   */


    var staffStandardTimeTableLiveList: MutableLiveData<TimeTableResponse>? = null

    fun getStaffTimeTable(authToken: String, standardId: String): LiveData<TimeTableResponse> {
        if (staffStandardTimeTableLiveList == null) {
            staffStandardTimeTableLiveList = MutableLiveData()
        }

        getStaffTimeTableResponse(authToken, standardId)
        return staffStandardTimeTableLiveList!!
    }

    private fun getStaffTimeTableResponse(authToken: String, standardId: String) {

        val responseCall: Call<TimeTableResponse?>? =
            RetrofitClient.apiService.getStaffTimeTable(authToken, standardId)

        responseCall?.enqueue(object : Callback<TimeTableResponse?> {
            override fun onResponse(
                call: Call<TimeTableResponse?>,
                response: Response<TimeTableResponse?>
            ) {
                if (response.isSuccessful) {

                    staffStandardTimeTableLiveList?.value = response.body()

                }


            }

            override fun onFailure(
                call: Call<TimeTableResponse?>,
                t: Throwable
            ) {
            }
        })
    }

    //---------------   Get End  Standard  Time Table Detail -------------------------//

}
