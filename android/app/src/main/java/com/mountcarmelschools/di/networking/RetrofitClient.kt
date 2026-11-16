package com.mountcarmelschools.di.networking

import com.squareup.moshi.Moshi
import com.squareup.moshi.kotlin.reflect.KotlinJsonAdapterFactory
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Retrofit
import retrofit2.converter.moshi.MoshiConverterFactory
import java.util.concurrent.TimeUnit


object RetrofitClient {

    private const val baseUrl = "https://mountcarmelschool.com:4201/" /*Test URL*/

    private var retrofit: Retrofit? = null

    /**
     * Get Retrofit Instance
     */

    private val retrofitInstance: Retrofit?
        get() {

            val moshi = Moshi.Builder()
                .add(KotlinJsonAdapterFactory())
                .build()

            if (retrofit == null) {
                val logging = HttpLoggingInterceptor()
                logging.level = HttpLoggingInterceptor.Level.BODY

                val httpClient = OkHttpClient.Builder()
                httpClient.addInterceptor(logging)
                httpClient.addInterceptor(CustomHttpLoggingInterceptor())
                httpClient.addInterceptor(NetworkConnectionInterceptor())
                    .connectTimeout(5, TimeUnit.MINUTES)
                    .readTimeout(1, TimeUnit.MINUTES)
                    .writeTimeout(1, TimeUnit.MINUTES)
                    .retryOnConnectionFailure(true)

                retrofit = Retrofit.Builder()
                    .client(httpClient.build())
                    .baseUrl(baseUrl)
                    .addConverterFactory(MoshiConverterFactory.create(moshi))
                    .build()
            }
            return retrofit
        }


    /**
     * Get API Service
     *
     * @return API Service
     */
    val apiService: ApiService
        get() = retrofitInstance!!.create(ApiService::class.java)


}

