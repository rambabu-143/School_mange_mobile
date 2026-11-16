package com.mountcarmelschools.ui.gallery

import android.util.Log
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import com.mountcarmelschools.di.networking.RetrofitClient
import com.mountcarmelschools.di.data.gallery.GalleryResponse
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class GalleryViewModel : ViewModel() {


    /*
  Get All Gallery`
   */
    private  val TAG = "GalleryViewModel"
    var galleryListLiveData: MutableLiveData<GalleryResponse>? = null

    fun getGallery(authToken: String,dateOfAdmission: String): LiveData<GalleryResponse> {
            galleryListLiveData = MutableLiveData()
        getGalleryResponse(authToken,dateOfAdmission)
        return galleryListLiveData!!
    }


    private fun getGalleryResponse(authToken: String, dateOfAdmission :String) {
        val responseCall: Call<GalleryResponse?>? =
            RetrofitClient.apiService.getAllGallery(authToken,dateOfAdmission)
        responseCall?.enqueue(object : Callback<GalleryResponse?> {
            override fun onResponse(
                call: Call<GalleryResponse?>,
                response: Response<GalleryResponse?>
            ) {
                if (response.body()!= null && response.isSuccessful) {

                    galleryListLiveData?.value = response.body()
                }else{
                    val respErr = response.errorBody()?.string()
                    Log.d(TAG, "onResponse: $respErr")
                }
            }

            override fun onFailure(
                call: Call<GalleryResponse?>,
                t: Throwable
            ) {
                Log.d(TAG, "onResponse: ${t.localizedMessage}")
            }
        })
    }

}
