package com.mountcarmelschools.ui.houselist

import android.util.Log
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import com.mountcarmelschools.di.networking.RetrofitClient
import com.mountcarmelschools.di.data.classList.ClassListDropDownResponse
import com.mountcarmelschools.di.data.staff.houseList.GetHouseList
import com.mountcarmelschools.di.data.staff.houseList.HouseListPostData
import com.mountcarmelschools.di.data.staff.houseList.HouseListResponse
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class HouseListViewModel : ViewModel() {
    /*
    Get All HouseList`
     */
    var houseListLiveData: MutableLiveData<GetHouseList>? = null


    fun getHouseList(authToken: String): LiveData<GetHouseList> {
            houseListLiveData = MutableLiveData()
        getHouseListResponse(authToken)
        return houseListLiveData!!
    }


    private fun getHouseListResponse(authToken: String) {
        val responseCall: Call<GetHouseList?>? =
            RetrofitClient.apiService.getAllHouseList(authToken)
        responseCall?.enqueue(object : Callback<GetHouseList?> {
            override fun onResponse(
                call: Call<GetHouseList?>,
                response: Response<GetHouseList?>
            ) {
                if (response.isSuccessful) {

                    houseListLiveData?.value = response.body()
                }
            }

            override fun onFailure(
                call: Call<GetHouseList?>,
                t: Throwable
            ) {
            }
        })
    }


    /*
    Get  HouseList Response`
     */
    var houseResponseLiveData: MutableLiveData<HouseListResponse>? = null


    fun getHouseResponseForAPi(
        authToken: String, standard: ArrayList<String>,
        houseLst: ArrayList<String>
    ): LiveData<HouseListResponse> {
            houseResponseLiveData = MutableLiveData()
        getHouseResponse(authToken, standard, houseLst)
        return houseResponseLiveData!!
    }


    private fun getHouseResponse(
        authToken: String,
        standard: ArrayList<String>,
        houseLst: ArrayList<String>
    ) {
        var postData = HouseListPostData(standard , houseLst)
        val responseCall: Call<HouseListResponse?>? =
            RetrofitClient.apiService.updateManyItem(authToken,postData)
        responseCall?.enqueue(object : Callback<HouseListResponse?> {
            override fun onResponse(
                call: Call<HouseListResponse?>,
                response: Response<HouseListResponse?>
            ) {

                    houseResponseLiveData?.value = response.body()
            }

            override fun onFailure(
                call: Call<HouseListResponse?>,
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
