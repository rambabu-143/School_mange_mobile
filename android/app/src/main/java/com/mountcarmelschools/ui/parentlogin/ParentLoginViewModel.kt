package com.mountcarmelschools.ui.parentlogin

import android.content.Context
import android.text.TextUtils
import android.util.Log
import android.view.View
import android.widget.Toast
import androidx.databinding.ObservableField
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.viewModelScope
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseViewModel
import com.mountcarmelschools.base.McopBaseViewModel
import com.mountcarmelschools.di.data.parentlogindata.OTPResponse
import com.mountcarmelschools.di.data.parentlogindata.OtpRequestData
import com.mountcarmelschools.di.data.selfAwareness.SelfAwarenessResponse
import com.mountcarmelschools.di.networking.NoConnectivityException
import com.mountcarmelschools.di.networking.ResponseStatus
import com.mountcarmelschools.di.networking.RetrofitClient
import com.mountcarmelschools.ui.parentlogin.repo.ParentLoginRepository
import com.mountcarmelschools.ui.selfAwareness.SelfAwarenessRepository
import com.mountcarmelschools.utlis.PARENT_MOBILE_NO
import com.mountcarmelschools.utlis.SharedPreferenceUtils
import com.mountcarmelschools.utlis.Utils
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response


class ParentLoginViewModel() : BaseViewModel<ParentNavigator>() {
    val TAG = "ParentLoginViewModel"
    var progressBar = ObservableField<Boolean>(false)

    var mobile = ObservableField<String>("")


    /*

  Parent Login API
   */

    val liveDataParentLoginApi = MutableLiveData<ResponseStatus<OTPResponse>>()

    fun getParentLogin(context: Context, data: OtpRequestData) {

        progressBar.set(true)
        viewModelScope.launch(Dispatchers.IO + coroutineExceptionHandler) {
            try {
                val response = ParentLoginRepository().getParentLoginResponse(
                    data
                )
                withContext(Dispatchers.Main) {
                    onGetParentLoginResponse(context, response)
                }
            } catch (e: Exception) {
                Log.e("-------", e.toString())
                progressBar.set(false)

                throw NoConnectivityException()
            }
        }
    }

    private fun onGetParentLoginResponse(
        context: Context, response: Response<OTPResponse>
    ) {
        progressBar.set(false)


        if (response.isSuccessful && response.body() != null) {
            val loginResponseBody = response.body()
            loginResponseBody?.let { it ->
                if (it.status == true) {
                    SharedPreferenceUtils.getInstance(context)?.setStringValue(
                        PARENT_MOBILE_NO, response.body()!!.data?.mobile
                    )

                    liveDataParentLoginApi.postValue(ResponseStatus.Success(it))
                } else {
                    liveDataParentLoginApi.postValue(
                        ResponseStatus.Error(
                            responseMessage = it.message
                                ?: context.getString(R.string.unable_to_fetch_information)
                        )
                    )
                }

            } ?: liveDataParentLoginApi.postValue(
                ResponseStatus.Error(
                    responseMessage = context.getString(
                        R.string.unable_to_fetch_information
                    )
                )
            )

        } else {
            liveDataParentLoginApi.postValue(
                ResponseStatus.TechnicalError(
                    responseMessage = context.getString(
                        R.string.some_technical_issue_occurred
                    )
                )
            )
        }
    }


    public fun checkValidation(view: View): Boolean {

        if (TextUtils.isEmpty(mobile.get())) {


            Toast.makeText(
                view.context,
                view.context.resources.getString(R.string.please_enter_your_mobile_number),
                Toast.LENGTH_SHORT
            ).show()
            return false
        } else if (!Utils.isMobileZero(mobile.get())) {


            Toast.makeText(
                view.context,
                view.context.resources.getString(R.string.please_enter_valid_mobile),
                Toast.LENGTH_SHORT
            ).show()

            return false
        } else if (mobile.get()?.length!! < 10) {

            Toast.makeText(
                view.context,
                view.context.resources.getString(R.string.please_enter_valid_mobile),
                Toast.LENGTH_SHORT
            ).show()
            return false
        }

        return true

    }


}