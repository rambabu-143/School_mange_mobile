package com.mountcarmelschools.ui.assignment.assignementUpdated

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import com.mountcarmelschools.di.networking.RetrofitClient
import com.mountcarmelschools.di.data.assignment.AssignmentUpdateResponse
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class AssignmentUpdatedViewModel : ViewModel() {


    /*
  Get Assignment
   */


    var studentAssignmentLiveList: MutableLiveData<AssignmentUpdateResponse>? = null

    fun getAssignmentUpdated(authToken: String, studentId: String, subjectId: String, startDate: String, endDate: String): LiveData<AssignmentUpdateResponse> {
            studentAssignmentLiveList = MutableLiveData()

        getAssignmentUpdatedResponse(authToken, studentId, subjectId, startDate, endDate)
        return studentAssignmentLiveList!!
    }

    private fun getAssignmentUpdatedResponse(authToken: String, studentId: String, subjectId: String, startDate: String, endDate: String) {

        val responseCall: Call<AssignmentUpdateResponse> =
                RetrofitClient.apiService.getAssignmentBySubject(authToken, studentId, subjectId, startDate, endDate)

        responseCall?.enqueue(object : Callback<AssignmentUpdateResponse?> {
            override fun onResponse(
                    call: Call<AssignmentUpdateResponse?>,
                    response: Response<AssignmentUpdateResponse?>
            ) {
                if (response.isSuccessful) {

                    studentAssignmentLiveList?.value = response.body()

                }


            }

            override fun onFailure(
                    call: Call<AssignmentUpdateResponse?>,
                    t: Throwable
            ) {
            }
        })
    }

    //--------------- End Student Get assessment  -------------------------//


}
