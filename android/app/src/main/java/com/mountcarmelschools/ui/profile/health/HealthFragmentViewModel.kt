package com.mountcarmelschools.ui.profile.health

import android.content.Context
import android.util.Log
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.viewModelScope
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseViewModel
import com.mountcarmelschools.di.data.CommonResponse
import com.mountcarmelschools.di.data.studentprofile.MedicalPostData
import com.mountcarmelschools.di.data.studentprofile.ResidentialPostDataUpdated
import com.mountcarmelschools.di.networking.NoConnectivityException
import com.mountcarmelschools.di.networking.ResponseStatus
import com.mountcarmelschools.ui.parentlogin.ParentNavigator
import com.mountcarmelschools.ui.profile.general.GeneralRepository
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import retrofit2.Response

class HealthFragmentViewModel : BaseViewModel<ParentNavigator>() {


    /*

Update Medical  DATA
 */

    val liveDataHealth = MutableLiveData<ResponseStatus<CommonResponse>>()

    fun updateMedical(context: Context, authToken: String, id:String, params: MedicalPostData) {
        viewModelScope.launch(Dispatchers.IO + coroutineExceptionHandler) {
            try {
                val response = HealthRepository().updateMedical(
                    authToken = authToken, id = id ,params =params
                )
                withContext(Dispatchers.Main) {
                    callMedical(context, response)
                }
            } catch (e: Exception) {
                Log.e("-------", e.toString())
                throw NoConnectivityException()
            }
        }
    }

    private fun callMedical(
        context: Context,
        response: Response<CommonResponse>
    ) {

        if (response.isSuccessful && response.body() != null) {
            val loginResponseBody = response.body()
            loginResponseBody?.let { it ->
                if (it.status == true)
                    liveDataHealth.postValue(ResponseStatus.Success(it))
                else
                    liveDataHealth.postValue(
                        ResponseStatus.Error(
                            responseMessage = it.message
                                ?: context.getString(R.string.unable_to_fetch_information)
                        )
                    )

            } ?: liveDataHealth.postValue(
                ResponseStatus.Error(
                    responseMessage = context.getString(
                        R.string.unable_to_fetch_information
                    )
                )
            )

        } else {
            liveDataHealth.postValue(
                ResponseStatus.TechnicalError(
                    responseMessage = context.getString(
                        R.string.some_technical_issue_occurred
                    )
                )
            )
        }
    }
}