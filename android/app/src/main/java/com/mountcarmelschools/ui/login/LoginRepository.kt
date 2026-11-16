package com.mountcarmelschools.ui.login

class LoginRepository(private val vm: LoginViewModel) {

 /*   fun getLoginCall(loginRequest: LoginRequest) {
        val responseCases: retrofit2.Call<LoginResponse> =
            RetrofitClient.apiService.getLoginResponse(loginRequest)
        responseCases.enqueue(object : Callback<LoginResponse> {
            override fun onResponse(
                call: Call<LoginResponse>,
                response: Response<LoginResponse>
            ) {
                if (response.isSuccessful) {
                    vm.responseLiveData?.value = response.body()
                }
            }

            override fun onFailure(call: Call<LoginResponse>, t: Throwable) {
//                vm.responseLiveData?.value?.message = t.message.toString()

            }
        })
    }
*/
}