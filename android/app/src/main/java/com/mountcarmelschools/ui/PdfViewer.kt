package com.mountcarmelschools.ui

import android.Manifest.permission
import android.app.DownloadManager
import android.content.*
import android.content.pm.PackageManager
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.Environment
import android.text.TextUtils
import android.util.Log
import android.view.View
import android.view.View.GONE
import android.widget.ProgressBar
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ActivityCompat
import androidx.core.app.NotificationManagerCompat
import androidx.core.content.ContextCompat
import androidx.core.content.FileProvider
import com.google.android.material.imageview.ShapeableImageView
import com.google.android.material.textview.MaterialTextView
import com.mountcarmelschools.R
import com.rajat.pdfviewer.PdfEngine
import com.rajat.pdfviewer.PdfQuality
import com.rajat.pdfviewer.PdfRendererView
import okhttp3.ResponseBody
import java.io.*


class PdfViewer : AppCompatActivity() {

    private var permissionGranted: Boolean? = false
    private var fileUrl: String? = null

    lateinit var file: File

    private lateinit var pdfView: PdfRendererView

    companion object {
        const val FILE_URL = "pdf_file_url"
        const val FILE_DIRECTORY = "pdf_file_directory"
        const val FILE_TITLE = "pdf_file_title"
        const val ENABLE_FILE_DOWNLOAD = "enable_download"
        const val FROM_ASSETS = "from_assests"
        var engine = PdfEngine.INTERNAL
        var enableDownload = true
        var isPDFFromPath = false
        var isFromAssets = false
        var PERMISSION_CODE = 4040


        fun launchPdfFromUrl(
            context: Context?,
            pdfUrl: String?,
            pdfTitle: String?,
            directoryName: String?,
            enableDownload: Boolean = true
        ): Intent {
            val intent = Intent(context, PdfViewer::class.java)
            intent.putExtra(FILE_URL, pdfUrl)
            intent.putExtra(FILE_TITLE, pdfTitle)
            intent.putExtra(FILE_DIRECTORY, directoryName)
            intent.putExtra(ENABLE_FILE_DOWNLOAD, enableDownload)
            intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
            isPDFFromPath = false
            return intent
        }

        fun launchPdfFromPath(
            context: Context?,
            path: String?,
            pdfTitle: String?,
            directoryName: String?,
            enableDownload: Boolean = true,
            fromAssets: Boolean = false
        ): Intent {
            val intent = Intent(context, PdfViewer::class.java)
            intent.putExtra(FILE_URL, path)
            intent.putExtra(FILE_TITLE, pdfTitle)
            intent.putExtra(FILE_DIRECTORY, directoryName)
            intent.putExtra(ENABLE_FILE_DOWNLOAD, enableDownload)
            intent.putExtra(FROM_ASSETS, fromAssets)
            isPDFFromPath = true
            return intent
        }

    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_pdfview)

        setUpToolbar(
            intent.extras!!.getString(
                FILE_TITLE,
                "PDF"
            )
        )

        enableDownload = intent.extras!!.getBoolean(
            ENABLE_FILE_DOWNLOAD,
            true
        )

        isFromAssets = intent.extras!!.getBoolean(
            FROM_ASSETS,
            false
        )

        engine = PdfEngine.INTERNAL

        init()

        val backImage = findViewById<ShapeableImageView>(R.id.backImage)
        val download = findViewById<ShapeableImageView>(R.id.download)
        pdfView = findViewById(R.id.pdfView)
        backImage.setOnClickListener {
            finish()
        }
        download.setOnClickListener {
            checkPermission(PERMISSION_CODE)
            /*       val intent2 = Intent()
                   intent2.action = Intent.ACTION_SEND
                   intent2.type = "text/plain"
                   intent2.putExtra(Intent.EXTRA_TEXT, intent.getStringExtra(FILE_URL))
                   startActivity(Intent.createChooser(intent2, "Share via"))
             */
        }
    }

    private fun init() {
        if (intent.extras!!.containsKey(FILE_URL)) {
            fileUrl = intent.extras!!.getString(FILE_URL)
            if (isPDFFromPath) {
                initPdfViewerWithPath(this.fileUrl)
            } else {
                if (checkInternetConnection(this)) {
                    loadFileFromNetwork(this.fileUrl)
                } else {
                    Toast.makeText(
                        this,
                        "No Internet Connection. Please Check your internet connection.",
                        Toast.LENGTH_SHORT
                    ).show()
                }
            }
        }
    }

    private fun checkInternetConnection(context: Context): Boolean {
        var result = 0 // Returns connection type. 0: none; 1: mobile data; 2: wifi
        val cm = context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager?
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            cm?.run {
                cm.getNetworkCapabilities(cm.activeNetwork)?.run {
                    when {
                        hasTransport(NetworkCapabilities.TRANSPORT_WIFI) -> {
                            result = 2
                        }
                        hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR) -> {
                            result = 1
                        }
                        hasTransport(NetworkCapabilities.TRANSPORT_VPN) -> {
                            result = 3
                        }
                    }
                }
            }
        } else {
            cm?.run {
                cm.activeNetworkInfo?.run {
                    when (type) {
                        ConnectivityManager.TYPE_WIFI -> {
                            result = 2
                        }
                        ConnectivityManager.TYPE_MOBILE -> {
                            result = 1
                        }
                        ConnectivityManager.TYPE_VPN -> {
                            result = 3
                        }
                    }
                }
            }
        }
        return result != 0
    }

    private fun setUpToolbar(toolbarTitle: String) {
        val tv_header = findViewById<MaterialTextView>(R.id.tv_header)

        if (tv_header != null) {
            tv_header.text = toolbarTitle
        } else {
            title = toolbarTitle
        }

    }

    private fun loadFileFromNetwork(fileUrl: String?) {
        initPdfViewer(
            fileUrl,
            engine
        )
    }

    private fun initPdfViewer(fileUrl: String?, engine: PdfEngine) {
        if (TextUtils.isEmpty(fileUrl)) onPdfError()

        //Initiating PDf Viewer with URL
        try {
            pdfView.initWithUrl(
                fileUrl!!,
                PdfQuality.NORMAL,
                engine
            )
        } catch (e: Exception) {
            onPdfError()
        }

        enableDownload()

    }

    private fun initPdfViewerWithPath(filePath: String?) {
        if (TextUtils.isEmpty(filePath)) onPdfError()

        //Initiating PDf Viewer with URL
        try {

            val file = if (isFromAssets)
                com.rajat.pdfviewer.util.FileUtils.fileFromAsset(this, filePath!!)
            else File(filePath!!)

            pdfView.initWithFile(
                file,
                PdfQuality.NORMAL
            )

        } catch (e: Exception) {
            onPdfError()
        }

        enableDownload()
    }

    private fun enableDownload() {

        checkPermissionOnInit()

        if(this::pdfView.isInitialized) {
            pdfView.statusListener = object : PdfRendererView.StatusCallBack {
                override fun onDownloadStart() {
                    true.showProgressBar()
                }

                override fun onDownloadProgress(
                    progress: Int,
                    downloadedBytes: Long,
                    totalBytes: Long?
                ) {
                    //Download is in progress
                }

                override fun onDownloadSuccess() {
                    false.showProgressBar()
                }

                override fun onError(error: Throwable) {
                    onPdfError()
                }

                override fun onPageChanged(currentPage: Int, totalPage: Int) {
                    //Page change. Not require
                }

            }
        }
    }

    private fun checkPermissionOnInit() {
        if (ContextCompat.checkSelfPermission(
                this,
                permission.WRITE_EXTERNAL_STORAGE
            ) == PackageManager.PERMISSION_GRANTED

            &&
            ContextCompat.checkSelfPermission(
                this,
                permission.READ_EXTERNAL_STORAGE
            ) == PackageManager.PERMISSION_GRANTED
        ) {
            permissionGranted = true
        }
    }

    private fun onPdfError() {
        /*true.showProgressBar()
        finish()*/
        val uri = Uri.parse(fileUrl)
        // Chrome is probably not installed
        // OR not selected as default browser OR if no Browser is selected as default browser
        val i = Intent(Intent.ACTION_VIEW, uri)
        i.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        startActivity(i)
        finish()
    }

    private fun Boolean.showProgressBar() {
        val progressBar = findViewById<ProgressBar>(R.id.progressBar)
        progressBar.visibility = if (this) View.VISIBLE else GONE
    }

    private var onComplete: BroadcastReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {

            openFile()

            NotificationManagerCompat.from(this@PdfViewer).cancelAll()

            context?.unregisterReceiver(this)
        }
    }

    private fun downloadPdf() {
        try {
            if (permissionGranted!!) {
                val directoryName = intent.getStringExtra(FILE_DIRECTORY)
                val fileName = intent.getStringExtra(FILE_TITLE) + System.currentTimeMillis()
                val fileUrl = intent.getStringExtra(FILE_URL)
                val filePath =
                    if (TextUtils.isEmpty(directoryName)) "/$fileName.pdf" else "/$directoryName/$fileName.pdf"

                file = File("/mountcarmel/$fileName.pdf")
                try {
                    file.createNewFile()

                } catch (e: Exception) {

                }
                Log.e("file path", file.toString());



                try {
                    if (isPDFFromPath) {
                        downloadFile(
                            this,
                            fileUrl!!,
                            directoryName!!,
                            fileName
                        )
                    } else {


                        Log.e("file to download", fileUrl.toString());

                        val uri = Uri.parse(fileUrl.toString())
                        val downloadManager = getSystemService(DOWNLOAD_SERVICE) as DownloadManager
                        val request = DownloadManager.Request(uri)
                        request.setAllowedNetworkTypes(
                            DownloadManager.Request.NETWORK_WIFI or
                                    DownloadManager.Request.NETWORK_MOBILE
                        )


                        request.setTitle(fileName)

                        request.setNotificationVisibility(DownloadManager.Request.VISIBILITY_VISIBLE_NOTIFY_COMPLETED)

                        request.setDestinationInExternalPublicDir(
                            Environment.DIRECTORY_DOWNLOADS,
                            file.path

                        );
                        /*   //set the local destination for download file to a path within the application's external files directory
                           request.setDestinationInExternalFilesDir(
                               this,
                               directoryName,
                               file.path
                           )*/
                        registerReceiver(
                            onComplete,
                            IntentFilter(DownloadManager.ACTION_DOWNLOAD_COMPLETE)
                        );

                        try {
                            downloadManager.enqueue(request)

                        } catch (e: Exception) {
                            Log.e("", "eearae")
                        }

                        /*     val responseCall: Call<ResponseBody> =
                                 RetrofitClient.apiService.downloadFile(fileUrl.toString())
                             responseCall.enqueue(object : Callback<ResponseBody?> {
                                 override fun onResponse(
                                     call: Call<ResponseBody?>?,
                                     response: Response<ResponseBody?>
                                 ) {
                                     if (response.isSuccessful) {
                                         if (writeResponseBodyToDisk(response.body()!!)) {
                                             Log.e("", "loaded")
                                             val pdfUri: Uri = FileProvider.getUriForFile(
                                                 this@PdfViewer,
                                                 "com.mountcarmelschool.fileprovider",
                                                 file
                                             )
                                             val share = Intent()
                                             share.action = Intent.ACTION_SEND
                                             share.type = "application/pdf"
                                             share.putExtra(Intent.EXTRA_STREAM, pdfUri)
                                             startActivity(Intent.createChooser(share, "Share file"))
                                         }
                                         // Files.asByteSink(file).write(response.body()!!.bytes());


                                     } else {
                                         Log.e("", "failed")
                                     }
                                 }

                                 override fun onFailure(call: Call<ResponseBody?>?, t: Throwable) {
                                     t.printStackTrace()
                                     Log.e("", "failed" + t.printStackTrace())

                                 }
                             })
     */

                    }
                } catch (e: Exception) {
                    Toast.makeText(
                        this,
                        "Unable to download file",
                        Toast.LENGTH_SHORT
                    ).show()
                }
            } else {
                checkPermissionOnInit()
            }

        } catch (e: Exception) {
            Log.e("Error", e.toString())
        }
    }

    fun openFile() {
        val file = File(
            Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS),
            file.path
        ) // Set Your File Name

        if (file.exists()) {
            try {
                val uri =
                    FileProvider.getUriForFile(this, "com.mountcarmelschools.fileprovider", file)
                //FileProvider authorities from Manifest
                val sharingIntent = Intent(Intent.ACTION_SEND)
                sharingIntent.type = "*/*"

                sharingIntent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                sharingIntent.putExtra(Intent.EXTRA_STREAM, uri)
                startActivity(sharingIntent)
            } catch (e: ActivityNotFoundException) {
            }
        }

    }


    private fun checkPermission(requestCode: Int) {
        if (ContextCompat.checkSelfPermission(this, permission.WRITE_EXTERNAL_STORAGE)
            == PackageManager.PERMISSION_DENIED
        ) {
            ActivityCompat.requestPermissions(
                this, arrayOf(permission.WRITE_EXTERNAL_STORAGE, permission.READ_EXTERNAL_STORAGE),
                requestCode
            )
        } else {
            permissionGranted = true
            downloadPdf()
        }
    }


    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == PERMISSION_CODE &&
            grantResults.isNotEmpty() &&
            grantResults[0] == PackageManager.PERMISSION_GRANTED
        ) {
            permissionGranted = true
            downloadPdf()
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        pdfView.closePdfRender()
    }

    @Throws(IOException::class)
    fun copy(inputStream: InputStream?, output: File?) {
        var outputStream: OutputStream? = null
        try {
            outputStream = FileOutputStream(output)
            var read = 0
            val bytes = ByteArray(1024)
            while (inputStream!!.read(bytes).also { read = it } != -1) {
                outputStream.write(bytes, 0, read)
            }
        } finally {
            try {
                inputStream?.close()
            } finally {
                outputStream?.close()
            }
        }
    }

    @Throws(IOException::class)
    fun downloadFile(context: Context, assetName: String, filePath: String, fileName: String?) {

        val dirPath = "${Environment.getExternalStorageDirectory()}/${filePath}"
        val outFile = File(dirPath)
        //Create New File if not present
        if (!outFile.exists()) {
            outFile.mkdirs()
        }
        val outFile1 = File(dirPath, "/$fileName.pdf")
        copy(context.assets.open(assetName), outFile1)
    }

    private fun writeResponseBodyToDisk(body: ResponseBody): Boolean {
        return try {
            var inputStream: InputStream? = null
            var outputStream: OutputStream? = null
            try {
                val fileReader = ByteArray(4096)
                val fileSize = body.contentLength()
                var fileSizeDownloaded: Long = 0
                inputStream = body.byteStream()
                outputStream = FileOutputStream(file)
                while (true) {
                    val read = inputStream.read(fileReader)
                    if (read == -1) {
                        break
                    }
                    outputStream!!.write(fileReader, 0, read)
                    fileSizeDownloaded += read.toLong()
                    Log.d("", "file download: $fileSizeDownloaded of $fileSize")
                }
                outputStream!!.flush()
                true
            } catch (e: IOException) {
                e.printStackTrace()
                false
            } finally {
                inputStream?.close()
                outputStream?.close()
            }
        } catch (e: IOException) {
            e.printStackTrace()
            false
        }
    }

}