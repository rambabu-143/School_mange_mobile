package com.mountcarmelschools.ui.attendance.studentattendance

import android.util.Log
import android.view.View
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import com.mountcarmelschools.R
import com.mountcarmelschools.di.data.staff.markAttandance.MarkAttendanceDropDownResponse
import com.mountcarmelschools.di.data.staff.markAttandance.MarkAttendanceResponse
import com.mountcarmelschools.di.data.student.attendanceResponse.UpdatedStudentAttendanceResponse
import com.mountcarmelschools.di.networking.RetrofitClient
import com.mountcarmelschools.ui.attendance.markattendance.MarkAttendanceFragment
import com.mountcarmelschools.utlis.Utils
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class AttendanceViewModel : ViewModel() {


    fun showDateDialog(view: View) {
        // Utils.showCalendarDialog(view.context)
    }

    fun onMarkAttendance(view: View) {
        Utils.replaceFragment(
            view.context,
            R.id.fl_dashboardContainer,
            MarkAttendanceFragment(),
            "AttendanceViewModel"
        )
    }


    /*
Get Attendance Date
*/
    var attendanceLiveList: MutableLiveData<UpdatedStudentAttendanceResponse>? = null


    fun getAttendance(
        authToken: String,
        sectionId: String,
        startDate: String,
        endDate: String
    ): LiveData<UpdatedStudentAttendanceResponse> {
        attendanceLiveList = MutableLiveData()

        getAttendanceResponse(authToken, sectionId, startDate, endDate)

        return attendanceLiveList!!
    }

    private fun getAttendanceResponse(
        authToken: String,
        sectionId: String,
        startDate: String,
        strEndDate: String
    ) {

        val responseCall: Call<UpdatedStudentAttendanceResponse?>? =
            RetrofitClient.apiService.getAttendance(authToken, sectionId, startDate, strEndDate)

        responseCall?.enqueue(object : Callback<UpdatedStudentAttendanceResponse?> {
            override fun onResponse(
                call: Call<UpdatedStudentAttendanceResponse?>,
                response: Response<UpdatedStudentAttendanceResponse?>
            ) {

                attendanceLiveList?.value = response.body()


            }

            override fun onFailure(
                call: Call<UpdatedStudentAttendanceResponse?>,
                t: Throwable
            ) {
                Log.e("tag", t.localizedMessage)
            }
        })
    }

    //--------------- End Attendance  -------------------------//
    /*
Get Attendance Date
*/
    var attendanceStudentLiveList: MutableLiveData<MarkAttendanceResponse>? = null

    fun getMarkedAttendanceResponse(
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

    //--------------- End Attendance  -------------------------//


    //------------GET ATTENDANCE LIST DROPDOWN RESPONSE

    var responseClassListLiveData: MutableLiveData<MarkAttendanceDropDownResponse>? = null

    fun getClassListForDropDown(authToken: String): LiveData<MarkAttendanceDropDownResponse> {
        responseClassListLiveData = MutableLiveData()

        getClassListForDropDownResponse(authToken)
        return responseClassListLiveData!!
    }

    private fun getClassListForDropDownResponse(authToken: String) {

        val responseCall: Call<MarkAttendanceDropDownResponse?>? =
                RetrofitClient.apiService.getMarkAttendanceDropDown(authToken)

        responseCall?.enqueue(object : Callback<MarkAttendanceDropDownResponse?> {
            override fun onResponse(
                    call: Call<MarkAttendanceDropDownResponse?>,
                    response: Response<MarkAttendanceDropDownResponse?>
            ) {

                responseClassListLiveData?.value = response.body()

            }

            override fun onFailure(
                    call: Call<MarkAttendanceDropDownResponse?>,
                    t: Throwable
            ) {

                Log.e("error", t.localizedMessage)
            }
        })
    }
}
