package com.mountcarmelschools.ui.myTeacher

import android.util.Log
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import com.mountcarmelschools.di.data.teacher.MyTeacherResponse
import com.mountcarmelschools.di.networking.RetrofitClient
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class MyTeacherFragmentViewModel : ViewModel() {

    /*
Get Teacher Response
*/
    var mResponse: MutableLiveData<MyTeacherResponse>? = null

    fun getTeacher(
        authToken: String,
        id: String
    ): LiveData<MyTeacherResponse> {
        if (mResponse == null) {
            mResponse = MutableLiveData()
        }

        getMyTeacherResponse(authToken, id)
        return mResponse!!
    }

    private fun getMyTeacherResponse(
        authToken: String,
        standardID: String
    ) {

        val responseCall: Call<MyTeacherResponse> =
            RetrofitClient.apiService.getTeacherResponse(authToken, standardID)

        responseCall.enqueue(object : Callback<MyTeacherResponse?> {
            override fun onResponse(
                call: Call<MyTeacherResponse?>,
                response: Response<MyTeacherResponse?>
            ) {
                if (response.body() != null) {

                    mResponse?.value = response.body()

                }


            }

            override fun onFailure(
                call: Call<MyTeacherResponse?>,
                t: Throwable
            ) {
                val teacherResponse = MyTeacherResponse(false,"",null,null,null,null)
                mResponse!!.value = teacherResponse

                Log.e("", "")
            }
        })
    }


}