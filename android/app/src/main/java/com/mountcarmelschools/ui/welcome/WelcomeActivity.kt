package com.mountcarmelschools.ui.welcome

import android.app.AlertDialog
import android.content.ActivityNotFoundException
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.util.Log
import com.mountcarmelschools.BuildConfig
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseActivity
import com.mountcarmelschools.databinding.ActivityWelcomeBinding
import com.mountcarmelschools.di.data.versionControl.GetVersionResponse
import com.mountcarmelschools.di.networking.RetrofitClient
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response


class WelcomeActivity : BaseActivity<ActivityWelcomeBinding, WelcomeViewModel>(), WelcomeNavigator {


    override fun onResume() {
        super.onResume()
        val versionCode: Int = BuildConfig.VERSION_CODE

        val responseCall: Call<GetVersionResponse> = RetrofitClient.apiService.getVersion()

        responseCall.enqueue(object : Callback<GetVersionResponse?> {
            override fun onResponse(
                call: Call<GetVersionResponse?>,
                response: Response<GetVersionResponse?>
            ) {
                if (response.body() != null && response.body()?.status!!) {

                    if (versionCode < Integer.valueOf(response.body()!!.data!!.version!!)) {
                        val builder: AlertDialog.Builder? =
                            AlertDialog.Builder(this@WelcomeActivity)

                                .setCancelable(false)
                                .setTitle("Update Available")
                                .setMessage("A new version of Mount Carmel School App is available. Please update to new version")

                                .setPositiveButton(
                                    "Update"
                                )
                                { dialog, _ ->


                                    try {
                                        startActivity(
                                            Intent(
                                                Intent.ACTION_VIEW,
                                                Uri.parse("market://details?id=$packageName")
                                            )
                                        )
                                    } catch (e: ActivityNotFoundException) {
                                        startActivity(
                                            Intent(
                                                Intent.ACTION_VIEW,
                                                Uri.parse("https://play.google.com/store/apps/details?id=$packageName")
                                            )
                                        )
                                    }

                                    dialog.dismiss()

                                }


                        builder!!.show()

                    }


                }
            }

            override fun onFailure(
                call: Call<GetVersionResponse?>,
                t: Throwable
            ) {
                Log.d("", t.localizedMessage!!)
            }
        })

    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        dataBinding.modelView = viewModel
        viewModel.setNavigator(this)
    }


    override fun getLayoutId() = R.layout.activity_welcome

    override fun getViewModel() = WelcomeViewModel::class.java
    override fun finishWelcome() {
        finish()
    }


}
