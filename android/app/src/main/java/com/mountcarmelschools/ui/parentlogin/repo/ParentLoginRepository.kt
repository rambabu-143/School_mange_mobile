package com.mountcarmelschools.ui.parentlogin.repo

import com.mountcarmelschools.di.data.parentlogindata.OTPResponse
import com.mountcarmelschools.di.data.parentlogindata.OtpRequestData
import com.mountcarmelschools.di.networking.RetrofitClient
import retrofit2.Response

class ParentLoginRepository {

    suspend fun getParentLoginResponse(postData: OtpRequestData): Response<OTPResponse> {
        return RetrofitClient.apiService.parentLoginUpdated(postData)
    }
}