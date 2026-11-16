package com.mountcarmelschools.ui.profile.health

import com.mountcarmelschools.di.data.CommonResponse
import com.mountcarmelschools.di.data.motherTongue.MotherTongueResponse
import com.mountcarmelschools.di.data.selfAwareness.SelfAwarenessResponse
import com.mountcarmelschools.di.data.studentprofile.*
import com.mountcarmelschools.di.networking.RetrofitClient
import retrofit2.Response

class HealthRepository {


    suspend fun updateMedical(
        authToken: String,
        id: String,
        params: MedicalPostData
    ): Response<CommonResponse> {
        return RetrofitClient.apiService.updateUserMedicalData(authToken, id, params)
    }


}