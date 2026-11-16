package com.mountcarmelschools.ui.selfAwareness


import android.content.Context
import android.util.Log
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.viewModelScope
import com.mountcarmelschools.R
import com.mountcarmelschools.base.McopBaseViewModel
import com.mountcarmelschools.di.data.CommonResponse
import com.mountcarmelschools.di.data.selfAwareness.SelfAwarenessRequest
import com.mountcarmelschools.di.data.selfAwareness.SelfAwarenessResponse
import com.mountcarmelschools.di.networking.NoConnectivityException
import com.mountcarmelschools.di.networking.ResponseStatus
import com.mountcarmelschools.di.networking.RetrofitClient
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import kotlin.math.log

class SelfAwarenessViewModel : McopBaseViewModel() {

    /*

    GET SELFAWARENESS DATA
     */

    val liveDataSelfAwareness = MutableLiveData<ResponseStatus<SelfAwarenessResponse>>()

    fun callGetSelfAwareness(context: Context, authToken: String, studentId: String) {
        viewModelScope.launch(Dispatchers.IO + coroutineExceptionHandler) {
            try {
                val response = SelfAwarenessRepository().getSelfAwarenessData(
                    authToken = authToken, studentId = studentId
                )
                withContext(Dispatchers.Main) {
                    onGetSelfAwarenessResponse(context, response)
                }
            } catch (e: Exception) {
                Log.e("-------", e.toString())
                throw NoConnectivityException()
            }
        }
    }

    private fun onGetSelfAwarenessResponse(
        context: Context,
        response: Response<SelfAwarenessResponse>
    ) {

        if (response.isSuccessful && response.body() != null) {
            val loginResponseBody = response.body()
            loginResponseBody?.let { it ->
                if (it.status == true)
                    liveDataSelfAwareness.postValue(ResponseStatus.Success(it))
                else
                    liveDataSelfAwareness.postValue(
                        ResponseStatus.Error(
                            responseMessage = it.message
                                ?: context.getString(R.string.unable_to_fetch_information)
                        )
                    )

            } ?: liveDataSelfAwareness.postValue(
                ResponseStatus.Error(
                    responseMessage = context.getString(
                        R.string.unable_to_fetch_information
                    )
                )
            )

        } else {
            liveDataSelfAwareness.postValue(
                ResponseStatus.TechnicalError(
                    responseMessage = context.getString(
                        R.string.some_technical_issue_occurred
                    )
                )
            )
        }
    }


    /*

   UPDATE SELFAWARENESS DATA
    */


    val liveSubmitSelfAwareness = MutableLiveData<ResponseStatus<CommonResponse>>()

    fun callSubmitSelfAwareness(
        context: Context, authToken: String,
        data: SelfAwarenessRequest
    ) {
        viewModelScope.launch(Dispatchers.IO + coroutineExceptionHandler) {
            try {
                val response = SelfAwarenessRepository().updateSelfAwarenessData(
                    authToken = authToken, request = data
                )
                withContext(Dispatchers.Main) {
                    onSubmitSelfAwarenessResponse(context, response)
                }
            } catch (e: Exception) {
                Log.e("-------", e.toString())
                throw NoConnectivityException()
            }
        }
    }

    private fun onSubmitSelfAwarenessResponse(
        context: Context,
        response: Response<CommonResponse>
    ) {

        if (response.isSuccessful && response.body() != null) {
            val loginResponseBody = response.body()
            loginResponseBody?.let { it ->
                if (it.status == true)
                    liveSubmitSelfAwareness.postValue(ResponseStatus.Success(it))
                else
                    liveSubmitSelfAwareness.postValue(
                        ResponseStatus.Error(
                            responseMessage = it.message
                                ?: context.getString(R.string.unable_to_fetch_information)
                        )
                    )

            } ?: liveSubmitSelfAwareness.postValue(
                ResponseStatus.Error(
                    responseMessage = context.getString(
                        R.string.unable_to_fetch_information
                    )
                )
            )

        } else {
            liveSubmitSelfAwareness.postValue(
                ResponseStatus.TechnicalError(
                    responseMessage = context.getString(
                        R.string.some_technical_issue_occurred
                    )
                )
            )
        }
    }


}