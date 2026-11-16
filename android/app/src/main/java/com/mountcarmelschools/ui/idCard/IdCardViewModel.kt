package com.mountcarmelschools.ui.idCard

import android.util.Log
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import com.mountcarmelschools.di.data.CommonResponse
import com.mountcarmelschools.di.data.assesmentRecord.AssesmentRecordResponse
import com.mountcarmelschools.di.data.student.StudentNoticeResponse
import com.mountcarmelschools.di.data.studentIdCard.StudentIDCardResponse
import com.mountcarmelschools.di.data.studentIdCard.StudentIdCardPostData
import com.mountcarmelschools.di.networking.RetrofitClient
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class IdCardViewModel : ViewModel() {


    /*
Get Student ID Card
*/
    var getIdCardDetail: MutableLiveData<StudentIDCardResponse>? = null


    fun getIDCardDetail(authToken: String, id: String): LiveData<StudentIDCardResponse> {
        getIdCardDetail = MutableLiveData()
        getIdCardResponse(authToken, id)
        return getIdCardDetail!!
    }


    private fun getIdCardResponse(authToken: String, id: String) {
        val responseCall: Call<StudentIDCardResponse> =
            RetrofitClient.apiService.getStudentIDCard(authToken, id)
        responseCall.enqueue(object : Callback<StudentIDCardResponse?> {
            override fun onResponse(
                call: Call<StudentIDCardResponse?>,
                response: Response<StudentIDCardResponse?>
            ) {

                getIdCardDetail?.value = response.body()
            }

            override fun onFailure(
                call: Call<StudentIDCardResponse?>,
                t: Throwable
            ) {
                Log.e("", t.localizedMessage)
            }
        })
    }


    /*
   Post Student ID Card
*/
    var postIdCardDetail: MutableLiveData<CommonResponse>? = null


    fun getPostIDCardDetail(
        authToken: String,
        id: String,
        data: StudentIdCardPostData
    ): LiveData<CommonResponse> {
        postIdCardDetail = MutableLiveData()
        getPostIdCardResponse(authToken, id, data)
        return postIdCardDetail!!
    }


    private fun getPostIdCardResponse(authToken: String, id: String, data: StudentIdCardPostData) {
        val responseCall: Call<CommonResponse> =
            RetrofitClient.apiService.updateStudentIDCard(authToken, id, data)
        responseCall.enqueue(object : Callback<CommonResponse?> {
            override fun onResponse(
                call: Call<CommonResponse?>,
                response: Response<CommonResponse?>
            ) {
                postIdCardDetail?.value = response.body()
            }

            override fun onFailure(
                call: Call<CommonResponse?>,
                t: Throwable
            ) {
                Log.e("", t.localizedMessage)
            }
        })
    }


}