package com.mountcarmelschools.base

import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import com.mountcarmelschools.R
import com.mountcarmelschools.di.networking.ErrorResponse
import com.mountcarmelschools.di.networking.NoConnectivityException
import com.mountcarmelschools.di.networking.ResponseStatusError
import kotlinx.coroutines.CoroutineExceptionHandler


abstract class McopBaseViewModel: ViewModel() {
     val liveDataNetworkError        = MutableLiveData<ResponseStatusError>()
     val liveDataErrorResponseError  = MutableLiveData<ResponseStatusError>() // Kept for Error Response Interceptor for future implementation

    val coroutineExceptionHandler: CoroutineExceptionHandler = CoroutineExceptionHandler { _, throwable ->
        when (throwable) {
            is NoConnectivityException -> liveDataNetworkError.postValue(ResponseStatusError.NoInternetError(R.string.internet_connection))
            is ErrorResponse -> liveDataErrorResponseError.postValue(ResponseStatusError.ErrorResponseError(throwable.localizedMessage))
        }
    }
}