package com.mountcarmelschools.ui.assignment

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import com.mountcarmelschools.di.networking.RetrofitClient
import com.mountcarmelschools.di.data.assignment.AssignmentsResponse
import com.mountcarmelschools.di.data.syllabus.SyllabusResponse
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class AssignmentViewModel : ViewModel() {


    /*
  Get Syllabus
   */


    var studentSyllabusLiveList: MutableLiveData<SyllabusResponse>? = null

    fun getSyllabus(authToken: String, sectionId: String): LiveData<SyllabusResponse> {
        if (studentSyllabusLiveList == null) {
            studentSyllabusLiveList = MutableLiveData()
        }

        getSyllabusResponse(authToken, sectionId)
        return studentSyllabusLiveList!!
    }

    private fun getSyllabusResponse(authToken: String, sectionId: String) {

        val responseCall: Call<SyllabusResponse?>? =
            RetrofitClient.apiService.getSyllabus(authToken, sectionId)

        responseCall?.enqueue(object : Callback<SyllabusResponse?> {
            override fun onResponse(
                call: Call<SyllabusResponse?>,
                response: Response<SyllabusResponse?>
            ) {
                if (response.isSuccessful) {

                    studentSyllabusLiveList?.value = response.body()

                }


            }

            override fun onFailure(
                call: Call<SyllabusResponse?>,
                t: Throwable
            ) {
            }
        })
    }

    //--------------- End Student Get assessment  -------------------------//


    /*
  Get assignments
   */


    var studentAssignmentLiveList: MutableLiveData<AssignmentsResponse>? = null

    fun getAssignment(authToken: String, sectionId: String): LiveData<AssignmentsResponse> {
        if (studentAssignmentLiveList == null) {
            studentAssignmentLiveList = MutableLiveData()
        }

        getAssignmentResponse(authToken, sectionId)

        return studentAssignmentLiveList!!
    }

    private fun getAssignmentResponse(authToken: String, sectionId: String) {

        val responseCall: Call<AssignmentsResponse?>? =
            RetrofitClient.apiService.getAssignment(authToken, sectionId)


        responseCall?.enqueue(object : Callback<AssignmentsResponse?> {
            override fun onResponse(
                call: Call<AssignmentsResponse?>,
                response: Response<AssignmentsResponse?>
            ) {
                if (response.isSuccessful) {
                    studentAssignmentLiveList?.value = response.body()
                }
            }

            override fun onFailure(
                call: Call<AssignmentsResponse?>,
                t: Throwable
            ) {
            }
        })
    }

    //--------------- End Student Get assessment  -------------------------//


}
