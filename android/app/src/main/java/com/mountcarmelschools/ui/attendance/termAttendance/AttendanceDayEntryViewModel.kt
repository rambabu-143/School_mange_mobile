package com.mountcarmelschools.ui.attendance.termAttendance

import android.util.Log
import android.view.View
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import com.mountcarmelschools.di.networking.RetrofitClient
import com.mountcarmelschools.di.data.classList.ClassListDropDownResponse
import com.mountcarmelschools.di.data.staff.termAttandance.TermAttandanceResponse
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class AttendanceDayEntryViewModel : ViewModel() {

    fun showDateDialog(view: View) {
        //Utils.showCalendarDialog(view.context )
    }
    /*
 Get term attendance summery
  */


    var attendanceSummeryList: MutableLiveData<TermAttandanceResponse>? = null

    fun getTermAttendanceSummery(
        authToken: String,
        standardID: String,
        sectionId: String,
        term: String
    ): LiveData<TermAttandanceResponse> {
            attendanceSummeryList = MutableLiveData()

        getTermSummeryResponse(authToken, standardID, sectionId, term)
        return attendanceSummeryList!!
    }

    private fun getTermSummeryResponse(
        authToken: String,
        standardID: String,
        sectionId: String,
        term: String
    ) {

        val responseCall: Call<TermAttandanceResponse?>? =
            RetrofitClient.apiService.getTermAttendance(authToken, standardID, sectionId, term)

        responseCall?.enqueue(object : Callback<TermAttandanceResponse?> {
            override fun onResponse(
                call: Call<TermAttandanceResponse?>,
                response: Response<TermAttandanceResponse?>
            ) {

                    attendanceSummeryList?.value = response.body()


            }

            override fun onFailure(
                call: Call<TermAttandanceResponse?>,
                t: Throwable
            ) {
                Log.e("",t.localizedMessage)
            }
        })
    }

    //------------------------GET CLASS LIST DROPDOWN RESPONSE--------------------//

    var responseClassListLiveData: MutableLiveData<ClassListDropDownResponse>? = null

    fun getClassListForDropDown(authToken: String): LiveData<ClassListDropDownResponse> {
        responseClassListLiveData = MutableLiveData()

        getClassListForDropDownResponse(authToken)
        return responseClassListLiveData!!
    }

    private fun getClassListForDropDownResponse(authToken: String) {

        val responseCall: Call<ClassListDropDownResponse?>? =
                RetrofitClient.apiService.getClassListDropDown(authToken)

        responseCall?.enqueue(object : Callback<ClassListDropDownResponse?> {
            override fun onResponse(
                    call: Call<ClassListDropDownResponse?>,
                    response: Response<ClassListDropDownResponse?>
            ) {

                responseClassListLiveData?.value = response.body()

            }

            override fun onFailure(
                    call: Call<ClassListDropDownResponse?>,
                    t: Throwable
            ) {

                Log.e("error", t.localizedMessage)
            }
        })
    }
}
