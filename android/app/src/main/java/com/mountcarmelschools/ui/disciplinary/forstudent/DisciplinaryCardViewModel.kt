package com.mountcarmelschools.ui.disciplinary.forstudent


import android.content.Context
import android.util.Log
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.viewModelScope
import com.mountcarmelschools.R
import com.mountcarmelschools.base.McopBaseViewModel
import com.mountcarmelschools.di.data.disciplinaryCard.DisciplinaryCardResponse
import com.mountcarmelschools.di.networking.NoConnectivityException
import com.mountcarmelschools.di.networking.ResponseStatus
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import retrofit2.Response

class DisciplinaryCardViewModel : McopBaseViewModel() {

    /*
    GET Disciplinary Card
     */

    val liveDataDisciplinaryCard = MutableLiveData<ResponseStatus<DisciplinaryCardResponse>>()

    fun callDisciplinaryCard(context: Context, authToken: String, studentId: String) {
        viewModelScope.launch(Dispatchers.IO + coroutineExceptionHandler) {
            try {
                val response = DisciplinaryCardRepository().getDisciplinaryData(
                    authToken = authToken, id = studentId
                )
                withContext(Dispatchers.Main) {
                    onGetDisciplinaryCardResponse(context, response)
                }
            } catch (e: Exception) {
                Log.e("-------", e.toString())
                throw NoConnectivityException()
            }
        }
    }

    private fun onGetDisciplinaryCardResponse(
        context: Context,
        response: Response<DisciplinaryCardResponse>
    ) {

        if (response.isSuccessful && response.body() != null) {
            val loginResponseBody = response.body()
            loginResponseBody?.let { it ->
                if (it.status == true)
                    liveDataDisciplinaryCard.postValue(ResponseStatus.Success(it))
                else
                    liveDataDisciplinaryCard.postValue(
                        ResponseStatus.Error(
                            responseMessage = it.message
                                ?: context.getString(R.string.unable_to_fetch_information)
                        )
                    )

            } ?: liveDataDisciplinaryCard.postValue(
                ResponseStatus.Error(
                    responseMessage = context.getString(
                        R.string.unable_to_fetch_information
                    )
                )
            )

        } else {
            liveDataDisciplinaryCard.postValue(
                ResponseStatus.TechnicalError(
                    responseMessage = context.getString(
                        R.string.some_technical_issue_occurred
                    )
                )
            )
        }
    }



}