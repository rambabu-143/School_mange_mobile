package com.mountcarmelschools.ui.classlist

import android.util.Log
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import com.mountcarmelschools.di.data.classList.ClassListDropDownResponse
import com.mountcarmelschools.di.data.classList.ClassListResponse
import com.mountcarmelschools.di.networking.RetrofitClient
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class ClassListViewModel : ViewModel() {


    var responseLiveData: MutableLiveData<ClassListResponse>? = null

    fun getClassList(authToken: String, sectionId: String): LiveData<ClassListResponse> {
            responseLiveData = MutableLiveData()

        getClassListResponse(authToken, sectionId)
        return responseLiveData!!
    }

    private fun getClassListResponse(authToken: String, sectionId: String) {

        val responseCall: Call<ClassListResponse?> =
            RetrofitClient.apiService.getClassListWithSection(authToken, sectionId)
        responseCall.enqueue(object : Callback<ClassListResponse?> {
            override fun onResponse(
                call: Call<ClassListResponse?>,
                response: Response<ClassListResponse?>
            ) {

                responseLiveData?.value = response.body()

            }

            override fun onFailure(
                    call: Call<ClassListResponse?>,
                    t: Throwable
            ) {

                Log.e("error", t.localizedMessage)
            }
        })
    }


    //------------GET CLASS LIST DROPDOWN RESPONSE

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
