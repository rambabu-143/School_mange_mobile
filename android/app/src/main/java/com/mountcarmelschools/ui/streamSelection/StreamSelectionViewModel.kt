package com.mountcarmelschools.ui.streamSelection

import android.content.Context
import android.util.Log
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.viewModelScope
import com.mountcarmelschools.R
import com.mountcarmelschools.base.McopBaseViewModel
import com.mountcarmelschools.di.data.CommonResponse
import com.mountcarmelschools.di.data.selfAwareness.SelfAwarenessResponse
import com.mountcarmelschools.di.data.streamSelection.StreamSelectionPostData
import com.mountcarmelschools.di.data.streamSelection.StreamSelectionResponse
import com.mountcarmelschools.di.networking.NoConnectivityException
import com.mountcarmelschools.di.networking.ResponseStatus
import com.mountcarmelschools.ui.selfAwareness.SelfAwarenessRepository
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import retrofit2.Response

class StreamSelectionViewModel : McopBaseViewModel() {

    /*

 GET Stream Selection DATA
  */

    val liveDataStreamSelection = MutableLiveData<ResponseStatus<StreamSelectionResponse>>()

    fun callGetStreamSelection(
        context: Context, authToken: String, branch_code: String, year_session: String
    ) {
        viewModelScope.launch(Dispatchers.IO + coroutineExceptionHandler) {
            try {
                val response = StreamSelectionRepository().getStreamSelectionData(
                    authToken = authToken, branch_code = branch_code, year_session = year_session
                )
                withContext(Dispatchers.Main) {
                    onGetStreamSelectionResponse(context, response)
                }
            } catch (e: Exception) {
                Log.e("-------", e.toString())
                throw NoConnectivityException()
            }
        }
    }


    private fun onGetStreamSelectionResponse(
        context: Context, response: Response<StreamSelectionResponse>
    ) {

        if (response.isSuccessful && response.body() != null) {
            val loginResponseBody = response.body()
            loginResponseBody?.let { it ->
                if (it.status == true) liveDataStreamSelection.postValue(ResponseStatus.Success(it))
                else liveDataStreamSelection.postValue(
                    ResponseStatus.Error(
                        responseMessage = it.message
                            ?: context.getString(R.string.unable_to_fetch_information)
                    )
                )

            } ?: liveDataStreamSelection.postValue(
                ResponseStatus.Error(
                    responseMessage = context.getString(
                        R.string.unable_to_fetch_information
                    )
                )
            )

        } else {
            liveDataStreamSelection.postValue(
                ResponseStatus.TechnicalError(
                    responseMessage = context.getString(
                        R.string.some_technical_issue_occurred
                    )
                )
            )
        }
    }


    /*

--------------------------------------------- Update Stream Selection DATA-------------------------------------------------------------
  */

    val liveDataUpdateStreamSelection = MutableLiveData<ResponseStatus<CommonResponse>>()


    fun callUpdateStreamSelection(
        context: Context, authToken: String, data: StreamSelectionPostData
    ) {
        viewModelScope.launch(Dispatchers.IO + coroutineExceptionHandler) {
            try {
                val response = StreamSelectionRepository().updateStreamSelectionData(
                    authToken = authToken, data = data
                )
                withContext(Dispatchers.Main) {
                    onUpdateStreamSelectionResponse(context, response)
                }
            } catch (e: Exception) {
                Log.e("-------", e.toString())
                throw NoConnectivityException()
            }
        }
    }

    private fun onUpdateStreamSelectionResponse(
        context: Context, response: Response<CommonResponse>
    ) {

        if (response.isSuccessful && response.body() != null) {
            val loginResponseBody = response.body()
            loginResponseBody?.let { it ->
                if (it.status == true) liveDataUpdateStreamSelection.postValue(
                    ResponseStatus.Success(
                        it
                    )
                )
                else liveDataUpdateStreamSelection.postValue(
                    ResponseStatus.Error(
                        responseMessage = it.message
                            ?: context.getString(R.string.unable_to_fetch_information)
                    )
                )

            } ?: liveDataUpdateStreamSelection.postValue(
                ResponseStatus.Error(
                    responseMessage = context.getString(
                        R.string.unable_to_fetch_information
                    )
                )
            )

        } else {
            liveDataUpdateStreamSelection.postValue(
                ResponseStatus.TechnicalError(
                    responseMessage = context.getString(
                        R.string.some_technical_issue_occurred
                    )
                )
            )
        }
    }


}