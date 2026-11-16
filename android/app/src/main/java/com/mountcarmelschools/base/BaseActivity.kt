package com.mountcarmelschools.base

import android.annotation.SuppressLint
import android.content.Context
import android.content.pm.ActivityInfo
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.os.Build
import android.os.Bundle
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.databinding.DataBindingUtil
import androidx.databinding.ViewDataBinding
import androidx.lifecycle.Observer
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import com.mountcarmelschools.R
import com.mountcarmelschools.di.networking.ResponseStatusError

abstract class BaseActivity<DB : ViewDataBinding, VM : ViewModel> : AppCompatActivity() {

    protected lateinit var dataBinding: DB
    protected lateinit var viewModel: VM

    abstract fun getLayoutId(): Int
    abstract fun getViewModel(): Class<VM>




    override fun onStart() {
        super.onStart()

        /*  if (SharedPreferenceUtils.getInstance(this)
                  ?.getBoolanValue(IS_LOGGED_IN, false)!!
          ) {

              val intent = Intent(this, WelcomeActivity::class.java)
              intent.flags =
                  Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
              SharedPreferenceUtils.getInstance(this)?.clear()
              startActivity(intent)
              finish()
          }*/
    }

    open val observerError = Observer<ResponseStatusError> {

        when (it) {
            is ResponseStatusError.NoInternetError -> {
                showErrorToast(getString(R.string.check_internet_connection))
            }

            is ResponseStatusError.TechnicalError -> {
                showErrorToast(getString(R.string.some_technical_issue_occurred))
            }

            is ResponseStatusError.ErrorResponseError -> {}
        }
    }

    @SuppressLint("SourceLockedOrientationActivity")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        dataBinding = DataBindingUtil.setContentView(this, getLayoutId())
        dataBinding.lifecycleOwner = this
        requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_PORTRAIT
        viewModel = ViewModelProvider(this).get(getViewModel())
    }

    fun showSuccessToast(message: String) {

        val toast = Toast.makeText(this, message, Toast.LENGTH_SHORT);
        toast.show()


    }

    fun showErrorToast(message: String) {

        val toast = Toast.makeText(this, message, Toast.LENGTH_SHORT);
        toast.show()
    }

    fun isNetworkAvailable(context: Context?): Boolean {
        if (context == null) return false
        val connectivityManager =
            context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val capabilities =
                connectivityManager.getNetworkCapabilities(connectivityManager.activeNetwork)
            if (capabilities != null) {
                when {
                    capabilities.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR) -> {
                        return true
                    }
                    capabilities.hasTransport(NetworkCapabilities.TRANSPORT_WIFI) -> {
                        return true
                    }
                    capabilities.hasTransport(NetworkCapabilities.TRANSPORT_ETHERNET) -> {
                        return true
                    }
                }
            }
        } else {
            val activeNetworkInfo = connectivityManager.activeNetworkInfo
            if (activeNetworkInfo != null && activeNetworkInfo.isConnected) {
                return true
            }
        }
        return false
    }

}