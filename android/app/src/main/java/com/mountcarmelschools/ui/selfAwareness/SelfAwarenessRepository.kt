package com.mountcarmelschools.ui.selfAwareness

import com.mountcarmelschools.di.data.CommonResponse
import com.mountcarmelschools.di.data.selfAwareness.SelfAwarenessRequest
import com.mountcarmelschools.di.data.selfAwareness.SelfAwarenessResponse
import com.mountcarmelschools.di.networking.RetrofitClient
import retrofit2.Response

class SelfAwarenessRepository {
    suspend fun getSelfAwarenessData( authToken: String, studentId: String): Response<SelfAwarenessResponse> {
        return RetrofitClient.apiService.getSelfAwarenessUpdated(authToken,studentId)
    }

  suspend fun updateSelfAwarenessData( authToken: String, request: SelfAwarenessRequest): Response<CommonResponse> {
        return RetrofitClient.apiService.updateSelfAwareness(authToken,request)
    }


}