package com.mountcarmelschools.ui.splash

import android.annotation.SuppressLint
import android.content.Intent
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.view.View
import androidx.appcompat.app.AppCompatActivity
import com.mountcarmelschools.R
import com.mountcarmelschools.di.data.GetStatusList
import com.mountcarmelschools.di.networking.RetrofitClient
import com.mountcarmelschools.ui.dashboard.DashboardActivity
import com.mountcarmelschools.ui.welcome.WelcomeActivity
import com.mountcarmelschools.utlis.IS_LOGGED_IN
import com.mountcarmelschools.utlis.SharedPreferenceUtils
import com.mountcarmelschools.utlis.Utils
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response


@SuppressLint("CustomSplashScreen")
class SplashActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_splash)

        onComplete()
    }

    private fun onComplete() {
        Handler(Looper.myLooper()!!).postDelayed({
            if (SharedPreferenceUtils.getInstance(this@SplashActivity)
                    ?.getBoolanValue(IS_LOGGED_IN, false)!!
            ) {
                startActivity(Intent(this@SplashActivity, DashboardActivity::class.java))
                finish()

            } else {
                startActivity(Intent(this@SplashActivity, WelcomeActivity::class.java))
                finish()
            }

        }, 3000)
    }

}
