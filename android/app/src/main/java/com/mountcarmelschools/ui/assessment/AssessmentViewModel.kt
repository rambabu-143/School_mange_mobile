package com.mountcarmelschools.ui.assessment

import android.util.Log
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import com.mountcarmelschools.di.data.assesmentRecord.AssesmentRecordResponse
import com.mountcarmelschools.di.data.student.StudentNoticeResponse
import com.mountcarmelschools.di.networking.RetrofitClient
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class AssessmentViewModel : ViewModel() {


    /*
Get Date Sheet`
*/
    var dateSheetListLiveData: MutableLiveData<StudentNoticeResponse>? = null


    fun getDateSheet(authToken: String, id: String): LiveData<StudentNoticeResponse> {
            dateSheetListLiveData = MutableLiveData()
        getDateSheetResponse(authToken,id)
        return dateSheetListLiveData!!
    }


    private fun getDateSheetResponse(authToken: String, id: String) {
        val responseCall: Call<StudentNoticeResponse?>? =
            RetrofitClient.apiService.getDateSheet(authToken,id)
        responseCall?.enqueue(object : Callback<StudentNoticeResponse?> {
            override fun onResponse(
                call: Call<StudentNoticeResponse?>,
                response: Response<StudentNoticeResponse?>
            ) {

                    dateSheetListLiveData?.value = response.body()
            }

            override fun onFailure(
                call: Call<StudentNoticeResponse?>,
                t: Throwable
            ) {
                Log.e("", t.localizedMessage)
            }
        })
    }


    /*
Get assessment
*/


    var studentAssessmentLiveList: MutableLiveData<AssesmentRecordResponse>? = null

    fun getAssessment(authToken: String, sectionId: String): LiveData<AssesmentRecordResponse> {
        if (studentAssessmentLiveList == null) {
            studentAssessmentLiveList = MutableLiveData()
        }

        getAssessmentResponse(authToken, sectionId)
        return studentAssessmentLiveList!!
    }

    private fun getAssessmentResponse(authToken: String, sectionId: String) {

        val responseCall: Call<AssesmentRecordResponse?>? =
            RetrofitClient.apiService.getAssessmentRecord(authToken, sectionId)

        responseCall?.enqueue(object : Callback<AssesmentRecordResponse?> {
            override fun onResponse(
                call: Call<AssesmentRecordResponse?>,
                response: Response<AssesmentRecordResponse?>
            ) {
                if (response.isSuccessful) {

                    studentAssessmentLiveList?.value = response.body()

                }

            }

            override fun onFailure(
                call: Call<AssesmentRecordResponse?>,
                t: Throwable
            ) {
            }
        })
    }

    //--------------- End Student Get assessment  -------------------------//
}