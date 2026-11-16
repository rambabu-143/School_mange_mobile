package com.mountcarmelschools.ui.streamSelection

import com.google.android.gms.common.internal.service.Common
import com.mountcarmelschools.di.data.CommonResponse
import com.mountcarmelschools.di.data.selfAwareness.SelfAwarenessResponse
import com.mountcarmelschools.di.data.streamSelection.StreamSelectionPostData
import com.mountcarmelschools.di.data.streamSelection.StreamSelectionResponse
import com.mountcarmelschools.di.networking.RetrofitClient
import retrofit2.Response

class StreamSelectionRepository {

    suspend fun getStreamSelectionData( authToken: String, branch_code: String, year_session:String): Response<StreamSelectionResponse> {
        return RetrofitClient.apiService.getStreamSelection(authToken,branch_code,year_session)
    }

    suspend fun updateStreamSelectionData(authToken: String, data: StreamSelectionPostData): Response<CommonResponse> {
        return RetrofitClient.apiService.updateStreamSelection(authToken,data)
    }
}