package com.mountcarmelschools.ui.disciplinary.forstudent

import com.mountcarmelschools.di.data.disciplinaryCard.DisciplinaryCardResponse
import com.mountcarmelschools.di.networking.RetrofitClient
import retrofit2.Response

class DisciplinaryCardRepository {
    suspend fun getDisciplinaryData( authToken: String, id: String): Response<DisciplinaryCardResponse> {
        return RetrofitClient.apiService.getDisciplinaryCard(authToken,id)
    }

}