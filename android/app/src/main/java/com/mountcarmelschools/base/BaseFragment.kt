package com.mountcarmelschools.base

import android.content.Context
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.os.Build
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.databinding.DataBindingUtil
import androidx.databinding.ViewDataBinding
import androidx.fragment.app.Fragment
import androidx.lifecycle.Observer
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import com.mountcarmelschools.R
import com.mountcarmelschools.di.networking.ResponseStatusError

abstract class BaseFragment<DB : ViewDataBinding, VM : ViewModel> : Fragment() {


    protected lateinit var dataBinding: DB
    protected lateinit var viewModel: VM

    abstract fun getLayoutID(): Int
    abstract fun getViewModel(): Class<VM>
//    abstract fun getBaseContext(): Context?


    open val observerError = Observer<ResponseStatusError> {

        when (it) {
            is ResponseStatusError.NoInternetError -> {
                showErrorToast(getString(R.string.check_internet_connection), requireContext())
            }

            is ResponseStatusError.TechnicalError -> {
                showErrorToast(getString(R.string.some_technical_issue_occurred), requireContext())
            }

            is ResponseStatusError.ErrorResponseError -> {}
        }
    }

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {

        dataBinding = DataBindingUtil.inflate(inflater, getLayoutID(), container, false)
        dataBinding.lifecycleOwner = this
        viewModel = ViewModelProvider(this).get(getViewModel())
        return dataBinding.root
    }

    override fun onDestroyView() {
        super.onDestroyView()
    }

    fun showSuccessToast(message: String, context: Context) {


        //Toast.makeText(context, message, Toast.LENGTH_SHORT).show()

        Toast.makeText(context, message, Toast.LENGTH_SHORT).show()

    }

    fun showErrorToast(message: String, context: Context) {

        Toast.makeText(context, message, Toast.LENGTH_SHORT).show()

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