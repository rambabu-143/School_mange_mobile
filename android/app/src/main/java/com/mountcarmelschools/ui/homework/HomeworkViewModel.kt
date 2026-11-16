package com.mountcarmelschools.ui.homework

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import com.mountcarmelschools.di.data.homework.HomeworkResponse
import com.mountcarmelschools.di.networking.RetrofitClient
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class HomeworkViewModel : ViewModel() {
    var homeworksMutableLiveData: MutableLiveData<HomeworkResponse>? = null

    fun getHomework(
        authToken: String,
        studentId: String,
        subjectId: String,
        startDate: String,
        endDate: String
    ): LiveData<HomeworkResponse> {
        val data: MutableLiveData<HomeworkResponse> = MutableLiveData()
        homeworksMutableLiveData = data

        getHomeworkResponse(authToken, studentId, subjectId, startDate, endDate)
        return data
    }

    private fun getHomeworkResponse(
        authToken: String,
        studentId: String,
        subjectId: String,
        startDate: String,
        endDate: String
    ) {
        val responseCall: Call<HomeworkResponse> =
            RetrofitClient.apiService.getHomeworkBySubject(authToken, studentId, subjectId, startDate, endDate)

        responseCall.enqueue(object : Callback<HomeworkResponse?> {
            override fun onResponse(
                call: Call<HomeworkResponse?>,
                response: Response<HomeworkResponse?>
            ) {
                if (response.isSuccessful) {
                    homeworksMutableLiveData?.value = response.body()
                }
            }

            override fun onFailure(
                call: Call<HomeworkResponse?>,
                t: Throwable
            ) {}
        })
    }
}