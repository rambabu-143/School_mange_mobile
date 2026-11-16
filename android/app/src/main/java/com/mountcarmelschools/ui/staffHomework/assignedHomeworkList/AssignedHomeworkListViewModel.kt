package com.mountcarmelschools.ui.staffHomework.assignedHomeworkList

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import com.mountcarmelschools.di.data.CheckCurrentTermResponse
import com.mountcarmelschools.di.data.staffhomework.StaffHomeworkResponse
import com.mountcarmelschools.di.networking.RetrofitClient
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class AssignedHomeworkListViewModel : ViewModel() {
    /**
     * Homework Data
     */
    var homeworksMutableLiveData: MutableLiveData<StaffHomeworkResponse>? = null

    fun getAssignedHomeworkList(
        authToken: String,
        startDate: String,
        endDate: String
    ): LiveData<StaffHomeworkResponse> {
        val data: MutableLiveData<StaffHomeworkResponse> = MutableLiveData()
        homeworksMutableLiveData = data

        getStaffHomeworkResponse(authToken, startDate, endDate)
        return data
    }

    private fun getStaffHomeworkResponse(
        authToken: String,
        startDate: String,
        endDate: String
    ) {
        val responseCall: Call<StaffHomeworkResponse> =
            RetrofitClient.apiService.getAssignedHomeworkListInDateRange(authToken, startDate, endDate)

        responseCall.enqueue(object : Callback<StaffHomeworkResponse?> {
            override fun onResponse(
                call: Call<StaffHomeworkResponse?>,
                response: Response<StaffHomeworkResponse?>
            ) {
                if (response.isSuccessful) {
                    homeworksMutableLiveData?.value = response.body()
                }
            }

            override fun onFailure(
                call: Call<StaffHomeworkResponse?>,
                t: Throwable
            ) {}
        })
    }

    /**
     * Delete Homework
     */
    fun deleteAssignedHomework(
        authToken: String,
        homeworkId: String,
        startDate: String,
        endDate: String
    ): LiveData<StaffHomeworkResponse> {
        deleteAssignedHomeworkResponse(authToken, homeworkId, startDate, endDate)
        return homeworksMutableLiveData!!
    }

    private fun deleteAssignedHomeworkResponse(
        authToken: String,
        homeworkId: String,
        startDate: String,
        endDate: String
    ) {
        val responseCall: Call<StaffHomeworkResponse> =
            RetrofitClient.apiService.deleteAssignedHomework(authToken, homeworkId, startDate, endDate)

        responseCall.enqueue(object : Callback<StaffHomeworkResponse?> {
            override fun onResponse(
                call: Call<StaffHomeworkResponse?>,
                response: Response<StaffHomeworkResponse?>
            ) {
                if (response.isSuccessful) {
                    homeworksMutableLiveData?.value = response.body()
                }
            }

            override fun onFailure(
                call: Call<StaffHomeworkResponse?>,
                t: Throwable
            ) {}
        })
    }

    /**
     * Term Data
     */
    var currentTermMutableLiveData: MutableLiveData<CheckCurrentTermResponse>? = null

    fun getCurrentTermResponse(
        authToken: String,
        term: String
    ): LiveData<CheckCurrentTermResponse> {
        val data: MutableLiveData<CheckCurrentTermResponse> = MutableLiveData()
        currentTermMutableLiveData = data

        currentTermResponse(authToken, term)
        return data
    }

    private fun currentTermResponse(authToken: String, term: String) {
        val responseCall: Call<CheckCurrentTermResponse> =
            RetrofitClient.apiService.checkCurrentTerm(authToken, term)

        responseCall.enqueue(object : Callback<CheckCurrentTermResponse> {
            override fun onResponse(
                call: Call<CheckCurrentTermResponse>,
                response: Response<CheckCurrentTermResponse>
            ) {
                if (response.isSuccessful) {
                    currentTermMutableLiveData?.value = response.body()
                }
            }

            override fun onFailure(
                call: Call<CheckCurrentTermResponse>,
                t: Throwable
            ) {}
        })
    }
}