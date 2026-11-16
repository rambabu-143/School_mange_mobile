package com.mountcarmelschools.ui.scanner

import android.annotation.SuppressLint
import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.view.ViewGroup
import com.google.zxing.Result
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseActivity
import com.mountcarmelschools.databinding.ScannerActivityBinding
import me.dm7.barcodescanner.zxing.ZXingScannerView


class ScannerActivity : BaseActivity<ScannerActivityBinding, ScannerViewModel>(), ZXingScannerView.ResultHandler {


    private var mScannerView: ZXingScannerView? = null

    @SuppressLint("ClickableViewAccessibility")
    override fun onCreate(savedInstanceState: Bundle?) {


        super.onCreate(savedInstanceState)


        val contentFrame = findViewById<ViewGroup>(R.id.content_frame)
        mScannerView = ZXingScannerView(this);   // Programmatically initialize the scanner view
        contentFrame.addView(mScannerView)

    }

    override fun getLayoutId() = R.layout.scanner_activity

    override fun getViewModel() = ScannerViewModel::class.java


    override fun handleResult(rawResult: Result?) {

        // Note:
        // * Wait 2 seconds to resume the preview.
        // * On older devices continuously stopping and resuming camera preview can result in freezing the app.
        // * I don't know why this is the case but I don't have the time to figure out.

        // Note:
        // * Wait 2 seconds to resume the preview.
        // * On older devices continuously stopping and resuming camera preview can result in freezing the app.
        // * I don't know why this is the case but I don't have the time to figure out.
        /*   val handler = Handler()
           handler.postDelayed({
               mScannerView!!.resumeCameraPreview(this)


           }, 2000)*/

        val returnIntent = Intent()
        returnIntent.putExtra("id", rawResult!!.text)
        setResult(Activity.RESULT_OK, returnIntent)
        finish()
    }


    override fun onResume() {
        super.onResume()
        mScannerView!!.setResultHandler(this) // Register ourselves as a handler for scan results.
        mScannerView!!.startCamera() // Start camera on resume
    }

    override fun onPause() {
        super.onPause()
        mScannerView!!.stopCamera() // Stop camera on pause
    }


}
