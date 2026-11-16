package com.mountcarmelschools.ui.payment

import android.content.Context
import android.content.DialogInterface
import android.content.Intent
import android.graphics.Bitmap
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.view.KeyEvent
import android.view.View
import android.webkit.ClientCertRequest
import android.webkit.WebSettings
import android.webkit.WebView
import android.webkit.WebViewClient
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseActivity
import com.mountcarmelschools.databinding.ActivityFeeBinding
import com.mountcarmelschools.ui.dashboard.DashboardActivity
import com.mountcarmelschools.utlis.Utils


class FeePayment : BaseActivity<ActivityFeeBinding, FeeViewModel>() {
    override fun getLayoutId() = R.layout.activity_fee

    override fun getViewModel() = FeeViewModel::class.java
    private var url = ""
    private lateinit var webView: WebView
    private var doubleBackToExitPressedOnce = false

    lateinit var context: Context

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        context = this

        var bundle: Bundle? = intent.extras

        var from = bundle!!.getString("from")

        if (Utils.isParent(this)) {
            if (from.equals("transport")) {
                url = "https://www.mountcarmelschool.com/parent/payment/transport-bill-app/${Utils.getUserId(this)}"

                dataBinding.tvHeader.text = "Transport";
            } else if (from.equals("fee")) {
                dataBinding.tvHeader.text = "Fee";

                url = "https://www.mountcarmelschool.com/parent/payment/fee-bill-app/${Utils.getUserId(this)}"
            }
            else if (from.equals("hostel"))
            {
                dataBinding.tvHeader.text = "Hostel";

                url = "https://www.mountcarmelschool.com/parent/payment/hostel-bill-app/${Utils.getUserId(this)}"

            }
        } else {
            dataBinding.tvHeader.text = "Transport";

            url = "https://www.mountcarmelschool.com/parent/payment/staff-transport-bill-app/${
                Utils.getUserId(this)
            }"

        }

        dataBinding.backIcon.setOnClickListener {
            showAlert()
        }

        dataBinding.ivNotification.setOnClickListener {
            showAlert()
        }
        //  disableSSLCertificateChecking()
        webView = findViewById(R.id.webView)

        // Get the web view settings instance
        val settings = webView.settings

        // Enable java script in web view
        settings.javaScriptEnabled = true

        // Enable and setup web view cache
      //  settings.setAppCacheEnabled(true)
        settings.cacheMode = WebSettings.LOAD_DEFAULT
        //settings.setAppCachePath(cacheDir.path)


        webView.setInitialScale(1);
        webView.getSettings().setLoadWithOverviewMode(true);
        webView.getSettings().setUseWideViewPort(true);

        webView.getSettings().setJavaScriptEnabled(true);

        webView.getSettings().setAllowFileAccess(true);
        webView.getSettings().setAllowContentAccess(true);
        webView.setScrollbarFadingEnabled(false);


        // Enable zooming in web view
        settings.setSupportZoom(false)
        settings.builtInZoomControls = false
        settings.displayZoomControls = false

        // Zoom web view text
        settings.textZoom = 100

        // Enable disable images in web view
        settings.blockNetworkImage = false
        // Whether the WebView should load image resources
        settings.loadsImagesAutomatically = true


        // More web view settings
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            settings.safeBrowsingEnabled = true  // api 26
        }
        //settings.pluginState = WebSettings.PluginState.ON
        settings.useWideViewPort = true
        settings.loadWithOverviewMode = true
        settings.javaScriptCanOpenWindowsAutomatically = true
        settings.mediaPlaybackRequiresUserGesture = false


        // More optional settings, you can enable it by yourself
        settings.domStorageEnabled = true
        settings.setSupportMultipleWindows(true)
        settings.loadWithOverviewMode = true
        settings.allowContentAccess = true
        settings.setGeolocationEnabled(true)
        settings.allowUniversalAccessFromFileURLs = true
        settings.allowFileAccess = true

        // WebView settings
        webView.fitsSystemWindows = true


        /*
            if SDK version is greater of 19 then activate hardware acceleration
            otherwise activate software acceleration
        */
        webView.setLayerType(View.LAYER_TYPE_HARDWARE, null)


        // Set web view client
        webView.webViewClient = object : WebViewClient() {
            override fun shouldOverrideUrlLoading(view: WebView?, url: String?): Boolean {
                Log.e("shouldoverride", url!!)

                view?.loadUrl(url)

                return true
            }
            override fun onReceivedClientCertRequest(view: WebView?, request: ClientCertRequest?) {
                super.onReceivedClientCertRequest(view, request)
            }

            override fun onPageStarted(view: WebView?, url: String?, favicon: Bitmap?) {
                super.onPageStarted(view, url, favicon)

            }

            override fun onPageFinished(view: WebView?, url: String?) {

                Log.e("onPageFinished", url!!)

                super.onPageFinished(view, url)

                try {
                    /*  if (url!!.contains("/onSuccessfullFeePayment")) {
                          showSuccessToast("Your payment successful")
                          startActivity(Intent(context, DashboardActivity::class.java))
                          finishAffinity()

                      } else if (url!!.contains("/onSuccessfullTransportPayment")) {
                          showSuccessToast("Your payment successful")
                          startActivity(Intent(context, DashboardActivity::class.java))
                          finishAffinity()

                      } else if (url!!.contains("/onSuccessfullStaffTransportPayment")) {
                          showSuccessToast("Your payment successful")
                          startActivity(Intent(context, DashboardActivity::class.java))
                          finishAffinity()

                      }
  */
                    if (url!!.contains("dashboard")) {
                        showSuccessToast("Your payment successful")
                        startActivity(Intent(context, DashboardActivity::class.java))
                        finishAffinity()

                    } else if (url!!.contains("fee-bill") && url!!.contains("login")) {
                        showSuccessToast("Oops! The payment has been declined by the bank.")
                        startActivity(Intent(context, DashboardActivity::class.java))
                        finishAffinity()
                    } else if (url!!.contains("transport-bill") && url!!.contains("login")) {
                        showSuccessToast("Oops! The payment has been declined by the bank.")
                        startActivity(Intent(context, DashboardActivity::class.java))
                        finishAffinity()
                    }  else if (url!!.contains("hostel-bill") && url!!.contains("login")) {
                        showSuccessToast("Oops! The payment has been declined by the bank.")
                        startActivity(Intent(context, DashboardActivity::class.java))
                        finishAffinity()
                    } else if (url!!.contains("staff-transport-bill") && url!!.contains("login")) {
                        showSuccessToast("Oops! The payment has been declined by the bank.")
                        startActivity(Intent(context, DashboardActivity::class.java))
                        finishAffinity()
                    }

                } catch (exception: Exception) {
                    exception.printStackTrace()
                }
            }


        }
        webView.loadUrl(url);

    }


    override fun onKeyDown(keyCode: Int, event: KeyEvent): Boolean {
        if (event.action == KeyEvent.ACTION_DOWN) {
            if (keyCode == KeyEvent.KEYCODE_BACK) {
                if (webView.canGoBack()) {
                    webView.goBack()
                } else {
                    showToastToExit()
                }
                return true
            }
        }
        return super.onKeyDown(keyCode, event)
    }

    private fun showToastToExit() {
        when {
            doubleBackToExitPressedOnce -> {
                onBackPressed()
            }
            else -> {
                doubleBackToExitPressedOnce = true
                showErrorToast("Back again to exit!")
                Handler(Looper.myLooper()!!).postDelayed({ doubleBackToExitPressedOnce = false }, 2000)
            }
        }
    }

    fun showAlert() {
        val alertDialogBuilder: MaterialAlertDialogBuilder = MaterialAlertDialogBuilder(
            this,
            R.style.ThemeOverlay_MaterialComponents_MaterialAlertDialog_Centered
        )
            .setTitle("Alert")
            .setMessage("Do you want to exit?")
                .setNegativeButton(
                        "No",
                        DialogInterface.OnClickListener { dialog, which ->


                            dialog.dismiss()

                        })
                .setPositiveButton("Yes",  /* listener = */
                        DialogInterface.OnClickListener {

                            dialog, which ->
                            dialog.dismiss()
                            onBackPressed()

                        })


        alertDialogBuilder.show()
    }

}
