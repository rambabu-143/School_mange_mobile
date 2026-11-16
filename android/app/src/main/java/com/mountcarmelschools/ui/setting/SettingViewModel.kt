package com.mountcarmelschools.ui.setting

import android.util.Log
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import com.mountcarmelschools.di.data.setting.SwitchBranchRequest
import com.mountcarmelschools.di.data.setting.SwitchBranchResponse
import com.mountcarmelschools.di.data.student.setting.GetSettingResponse
import com.mountcarmelschools.di.networking.RetrofitClient
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class SettingViewModel : ViewModel() {

    /*
Get  All Setting
*/
    var studentWiseResonseDate: MutableLiveData<GetSettingResponse>? = null

    fun getSetting(
        authToken: String
    ): LiveData<GetSettingResponse> {
        studentWiseResonseDate = MutableLiveData()
        getSettingResponse(authToken)
        return studentWiseResonseDate!!
    }

    private fun getSettingResponse(
        authToken: String
    ) {

        val responseCall: Call<GetSettingResponse?>? =
            RetrofitClient.apiService.getSettingDetail(
                authToken
            )

        responseCall?.enqueue(object : Callback<GetSettingResponse?> {
            override fun onResponse(
                call: Call<GetSettingResponse?>,
                response: Response<GetSettingResponse?>
            ) {
                if (response.isSuccessful) {

                    studentWiseResonseDate?.value = response.body()

                }

            }

            override fun onFailure(
                call: Call<GetSettingResponse?>,
                t: Throwable
            ) {
            }
        })
    }


    /*
update Setting
*/
    var updateSettingResponse: MutableLiveData<GetSettingResponse>? = null

    fun updateSetting(
        authToken: String,
        settingPostData: SettingPostData
    ): LiveData<GetSettingResponse> {
        updateSettingResponse = MutableLiveData()
        updateSettingResponse(authToken, settingPostData)
        return updateSettingResponse!!
    }


    private fun updateSettingResponse(
        authToken: String,
        settingPostData: SettingPostData

    ) {

        val responseCall: Call<GetSettingResponse?>? =
            RetrofitClient.apiService.updateSetting(
                authToken, settingPostData
            )

        responseCall?.enqueue(object : Callback<GetSettingResponse?> {
            override fun onResponse(
                call: Call<GetSettingResponse?>,
                response: Response<GetSettingResponse?>
            ) {
                if (response.isSuccessful) {

                    updateSettingResponse?.value = response.body()

                }

            }

            override fun onFailure(
                call: Call<GetSettingResponse?>,
                t: Throwable
            ) {
            }
        })
    }

    var updateBranch: MutableLiveData<SwitchBranchResponse>? = null

    fun updateBranch(
        authToken: String,
        id: String,
    ): LiveData<SwitchBranchResponse> {
        updateBranch = MutableLiveData()
        updateBranchResponse(authToken, id)
        return updateBranch!!
    }

    private fun updateBranchResponse(
        authToken: String,
        id: String,
    ) {

        val switchBranchRequest = SwitchBranchRequest(id, "android")

        val responseCall: Call<SwitchBranchResponse> =
            RetrofitClient.apiService.switchBranch(
                authToken, switchBranchRequest
            )

        Log.e("tokennn", authToken)
        responseCall.enqueue(object : Callback<SwitchBranchResponse> {
            override fun onResponse(
                call: Call<SwitchBranchResponse>,
                response: Response<SwitchBranchResponse>
            ) {
                Log.e("--------work", "asdasd")

                if (response.isSuccessful) {

                    updateBranch?.value = response.body()


                }

            }

            override fun onFailure(
                call: Call<SwitchBranchResponse>,
                t: Throwable
            ) {

                Log.e("eeerorrrr", "eeerorrrr" + t.localizedMessage);
            }
        })
    }


}
