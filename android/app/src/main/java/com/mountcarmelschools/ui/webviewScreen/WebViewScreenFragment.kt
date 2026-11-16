package com.mountcarmelschools.ui.webviewScreen

import android.content.Context
import android.os.Bundle
import android.util.Log
import android.view.View
import android.webkit.WebResourceError
import android.webkit.WebResourceRequest
import android.webkit.WebView
import android.webkit.WebViewClient
import androidx.fragment.app.Fragment
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseFragment
import com.mountcarmelschools.databinding.FragmentWebViewScreenBinding
import com.mountcarmelschools.ui.dashboard.DashboardActivity

private const val NAVBAR_TITLE = "navbar_title"
private const val URL_TO_OPEN = "url_to_open"

/**
 * A simple [Fragment] subclass.
 * Use the [WebViewScreenFragment.newInstance] factory method to
 * create an instance of this fragment.
 */
class WebViewScreenFragment : BaseFragment<FragmentWebViewScreenBinding, WebViewScreenViewModel>() {
    private var navbarTitle: String? = null
    private var urlToOpen: String? = null

    private lateinit var context: Context

    override fun onAttach(context: Context) {
        super.onAttach(context)
        this.context = context
    }

    override fun onResume() {
        super.onResume()
        (context as DashboardActivity).setHeaderText(navbarTitle)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        arguments?.let {
            navbarTitle = it.getString(NAVBAR_TITLE)
            urlToOpen = it.getString(URL_TO_OPEN)
        }
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        dataBinding.webView.settings.javaScriptEnabled = true

        dataBinding.webView.setInitialScale(1)
        dataBinding.webView.settings.setSupportZoom(false)
        dataBinding.webView.settings.builtInZoomControls = false
        dataBinding.webView.settings.displayZoomControls = false
        dataBinding.webView.settings.useWideViewPort = true
        dataBinding.webView.settings.domStorageEnabled = true
        dataBinding.webView.setLayerType(View.LAYER_TYPE_HARDWARE, null)

        dataBinding.webView.webViewClient = object : WebViewClient() {
            override fun onReceivedError(
                view: WebView?,
                request: WebResourceRequest?,
                error: WebResourceError?
            ) {
                super.onReceivedError(view, request, error)
                val errorString = error?.description.toString()
                Log.d("WebViewScreenFragment", "onReceivedError -> $errorString")
                if (errorString.contains("ERR_BLOCKED_BY_ORB", true)) {
                    return
                }
                showErrorToast(errorString, context)
            }
        }

        urlToOpen.let {
            if (it == null) {
                showErrorToast("URL in invalid", context)
            } else {
                dataBinding.webView.loadUrl(it)
            }
        }
    }

    override fun getLayoutID() = R.layout.fragment_web_view_screen

    override fun getViewModel() = WebViewScreenViewModel::class.java

    companion object {
        /**
         * Use this factory method to create a new instance of
         * this fragment using the provided parameters.
         *
         * @param navbarTitle Title which will be displayed in the Navbar
         * @param urlToOpen URL to open in webview
         * @return A new instance of fragment WebViewScreenFragment.
         */
        @JvmStatic
        fun newInstance(navbarTitle: String, urlToOpen: String) =
            WebViewScreenFragment().apply {
                arguments = Bundle().apply {
                    putString(NAVBAR_TITLE, navbarTitle)
                    putString(URL_TO_OPEN, urlToOpen)
                }
            }
    }
}