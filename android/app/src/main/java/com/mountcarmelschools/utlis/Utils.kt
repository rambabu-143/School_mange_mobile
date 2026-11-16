package com.mountcarmelschools.utlis

import android.annotation.SuppressLint
import android.app.Activity
import android.app.Dialog
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.Environment
import android.text.Editable
import android.text.Selection
import android.text.TextWatcher
import android.util.Log
import android.util.Patterns
import android.view.View
import android.view.Window
import android.view.inputmethod.InputMethodManager
import android.widget.EditText
import android.widget.Toast
import androidx.appcompat.content.res.AppCompatResources
import androidx.appcompat.widget.AppCompatEditText
import androidx.core.text.HtmlCompat
import androidx.core.widget.addTextChangedListener
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentActivity
import androidx.fragment.app.FragmentTransaction
import com.applandeo.materialcalendarview.CalendarView
import com.applandeo.materialcalendarview.EventDay
import com.applandeo.materialcalendarview.listeners.OnDayClickListener
import com.mountcarmelschools.R
import com.mountcarmelschools.ui.PdfViewer
import com.mountcarmelschools.ui.commonAdapter.CommonInterface
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.MultipartBody
import okhttp3.RequestBody
import java.io.*
import java.text.SimpleDateFormat
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter
import java.util.*


private const val tag = "FileUtils"


class Utils {
    companion object {


        fun isEmailValid(email: String?): Boolean {
            return Patterns.EMAIL_ADDRESS.matcher(email!!).matches()
        }

        /**
         * this method is to check mobile number all 0
         *
         * @param number mobile number enterd by the user
         * @return false if zero else true
         */
        fun isMobileZero(number: String?): Boolean {
            var zip: Long = 0
            try {
                zip = number!!.toLong()
                Log.i("DEBUG", zip.toString() + "code value")
            } catch (e: NumberFormatException) {
                return true
            }
            return zip != 0L
        }


        fun replaceFragment(
            context: Context,
            id: Int,
            fragment: Fragment,
            tag: String
        ) {
            val fragmentTransaction: FragmentTransaction =
                (context as FragmentActivity).supportFragmentManager.beginTransaction()
            fragmentTransaction.replace(id, fragment)
            fragmentTransaction.addToBackStack(tag)
            fragmentTransaction.commit()
        }

        fun replaceFragmentWithBundle(
            context: Context,
            id: Int,
            fragment: Fragment,
            bundle: Bundle
        ) {
            val fragmentTransaction: FragmentTransaction =
                (context as FragmentActivity).supportFragmentManager.beginTransaction()
            fragmentTransaction.replace(id, fragment)
            fragment.arguments = bundle
            fragmentTransaction.commit()
        }

        fun addFragment(
            context: Context,
            id: Int,
            fragment: Fragment,
            tag: String
        ) {
            val fragmentTransaction: FragmentTransaction =
                (context as FragmentActivity).supportFragmentManager.beginTransaction()
            fragmentTransaction.add(id, fragment)
            fragmentTransaction.commit()
        }

        fun shareLink(context: Context, link: String?) {
            val thread: Thread = object : Thread() {
                override fun run() {
                    val emailIntent = Intent()
                    emailIntent.action = Intent.ACTION_SEND
                    emailIntent.putExtra(Intent.EXTRA_TEXT, link)
                    emailIntent.type = "text/plain"
                    context.startActivity(Intent.createChooser(emailIntent, "Share Via"))
                }
            }
            thread.start()
        }

        fun multipart(path: String, key: String): MultipartBody.Part {
            val file = File(path)
            val images = MultipartBody.Part.createFormData(
                key,
                file.name,
                RequestBody.create("image/*".toMediaTypeOrNull(), file)
            )

            return images
        }


        fun getCurrentDate(): String {
            var answer: String
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val current = LocalDateTime.now()
                val formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy")
                answer = current.format(formatter)
            } else {
                var date = Date()
                val formatter = SimpleDateFormat("dd/MM/yyyy")
                answer = formatter.format(date)
            }
            return answer
        }

        fun getUserType(mContext: Context): String {
            return SharedPreferenceUtils.getInstance(mContext)?.getStringValue(USER_TYPE, "")!!

        }

        fun getAccessToken(mContext: Context): String {
            Log.d("TTAG", "getAccessToken: "+SharedPreferenceUtils.getInstance(mContext)?.getStringValue(AUTH_TOKEN, "")!!)
            return SharedPreferenceUtils.getInstance(mContext)?.getStringValue(AUTH_TOKEN, "")!!

        }

        fun getUserId(mContext: Context): String {
            return SharedPreferenceUtils.getInstance(mContext)?.getStringValue(USER_ID, "")!!

        }
        fun getStaffUserId(mContext: Context): String {
            return SharedPreferenceUtils.getInstance(mContext)?.getStringValue(STAFF_USER_ID, "")!!

        }
      fun getStudentID(mContext: Context): String {
            return SharedPreferenceUtils.getInstance(mContext)?.getStringValue(STUDENT_ID, "")!!

        }

        fun getStudentRollNo(mContext: Context): String {
            return SharedPreferenceUtils.getInstance(mContext)
                ?.getStringValue(STUDENT_ROLL_NO, "")!!

        }

        fun getSectionId(mContext: Context): String {
            return SharedPreferenceUtils.getInstance(mContext)?.getStringValue(SECTION_ID, "")!!

        }

        fun getStandardId(mContext: Context): String {
            return SharedPreferenceUtils.getInstance(mContext)?.getStringValue(STANDARD_ID, "")!!

        }

        fun getStandardSectionId(mContext: Context): String? {
            return SharedPreferenceUtils.getInstance(mContext)?.getStringValue(STANDARD_SECTION_ID, null)
        }

        fun getStandardName(mContext: Context): String {
            return SharedPreferenceUtils.getInstance(mContext)?.getStringValue(STANDARD_NAME, "")!!

        }

        fun getAllStudentDetail(mContext: Context): String {
            return SharedPreferenceUtils.getInstance(mContext)
                ?.getStringValue(STUDENT_DATA_FOR_PARENT, "")!!

        }

        fun getAllBranchList(mContext: Context): String {
            return SharedPreferenceUtils.getInstance(mContext)
                ?.getStringValue(BRANCH_DATA_FOR_STAFF, "")!!

        }

        fun getSelectedBranch(mContext: Context): String {
            return SharedPreferenceUtils.getInstance(mContext)
                ?.getStringValue(CURRENT_BRANCH, "")!!

        }

        fun isParent(mContext: Context): Boolean {
            return SharedPreferenceUtils.getInstance(mContext)
                ?.getBoolanValue(IS_PARENT, false)!!

        }

        fun isStaff(mContext: Context): Boolean {
            return SharedPreferenceUtils.getInstance(mContext)
                ?.getBoolanValue(IS_STAFF, false)!!

        }

        fun getUserName(mContext: Context): String {
            return SharedPreferenceUtils.getInstance(mContext)
                ?.getStringValue(USER_NAME, "")!!

        }

        fun getStaffEmail(mContext: Context): String {
            return SharedPreferenceUtils.getInstance(mContext)
                ?.getStringValue(TEACHER_EMAIL_ID, "")!!

        }

        fun getParentEmail(mContext: Context): String {
            return SharedPreferenceUtils.getInstance(mContext)
                ?.getStringValue(PARENT_EMAIL_ID, "")!!

        }

        fun getMobileNumber(mContext: Context): String {
            return SharedPreferenceUtils.getInstance(mContext)
                ?.getStringValue(MOBILE_NUMBER, "")!!

        }

        fun getParentProfilePath(mContext: Context): String {
            return SharedPreferenceUtils.getInstance(mContext)
                ?.getStringValue(PARENT_URL, "")!!

        }

        fun getYearSession(mContext: Context): String {
            return SharedPreferenceUtils.getInstance(mContext)
                ?.getStringValue(YEAR_SESSION, "")!!

        }

        fun getParentImagePath(mContext: Context): String {
            return SharedPreferenceUtils.getInstance(mContext)
                ?.getStringValue(PARENT_IMAGE_PATH, "")!!

        }

        fun getBackGroundColor(userType: String): Int {
            if (userType.equals("1")) {

                return R.color.blue_background
            } else if (userType.equals("2")) {

                return R.color.fourth_background
            } else
                return R.color.parent_background

        }


        /**
         * This method is to show the Calendar dialog box.
         */
        fun showCalendarDialog(context: Context , commonInterface:CommonInterface) {

            var cal = Calendar.getInstance();

            val customProgressDialog = Dialog(context)
            customProgressDialog.requestWindowFeature(Window.FEATURE_NO_TITLE)
            customProgressDialog.setContentView(R.layout.dialog_calendar)
            val datePicker = customProgressDialog.findViewById(R.id.calendarView) as CalendarView
            datePicker.showCurrentMonthPage()
            datePicker.setHeaderColor(R.color.white)
            datePicker.setHeaderLabelColor(R.color.black)
            datePicker.setForwardButtonImage(
                AppCompatResources.getDrawable(
                    context,
                    R.drawable.ic_right_arrow_black
                )!!
            )
            datePicker.setPreviousButtonImage(
                AppCompatResources.getDrawable(
                    context,
                    R.drawable.ic_left_arrow_black
                )!!
            )
            datePicker.setOnDayClickListener(object : OnDayClickListener{
                override fun onDayClick(eventDay: EventDay) {

                    val df = SimpleDateFormat("dd-MM-yyyy")
                    val startDate = df.format(eventDay.calendar.time)
                    commonInterface.selectedDate(startDate)
                    customProgressDialog.dismiss()
                    customProgressDialog.cancel()
                }

            })
            datePicker.setDate(Date())
            datePicker.setMaximumDate(cal)
            customProgressDialog.show()
        }


        /**
         * This method is to show the Calendar dialog box.
         */
        fun showCalendarDialogWithFixDates(
            context: Context,
            commonInterface: CommonInterface,
            startDate: Calendar
        ) {

            val cal = Calendar.getInstance();

            val customProgressDialog = Dialog(context)
            customProgressDialog.requestWindowFeature(Window.FEATURE_NO_TITLE)
            customProgressDialog.setContentView(R.layout.dialog_calendar)
            val datePicker = customProgressDialog.findViewById(R.id.calendarView) as CalendarView
            datePicker.showCurrentMonthPage()
            datePicker.setHeaderColor(R.color.white)
            datePicker.setHeaderLabelColor(R.color.black)
            datePicker.setForwardButtonImage(
                AppCompatResources.getDrawable(
                    context,
                    R.drawable.ic_right_arrow_black
                )!!
            )
            datePicker.setPreviousButtonImage(
                AppCompatResources.getDrawable(
                    context,
                    R.drawable.ic_left_arrow_black
                )!!
            )


            datePicker.setOnDayClickListener(object : OnDayClickListener {
                override fun onDayClick(eventDay: EventDay) {

                    if(!eventDay.calendar.before(startDate) //should not back date
                                    && !eventDay.calendar.after(cal)//should after max date
                    )
                    {
                        val df = SimpleDateFormat("dd-MM-yyyy")
                        val startDate = df.format(eventDay.calendar.time)
                        commonInterface.selectedDate(startDate)
                        customProgressDialog.dismiss()
                        customProgressDialog.cancel()
                    }


                }

            })
            datePicker.setDate(Date())
            datePicker.setMaximumDate(cal)
            datePicker.setMinimumDate(startDate)
            customProgressDialog.show()
        }


        public fun formattedDateFromString(
            inputFormat: String,
            outputFormat: String,
            inputDate: String?
        ): String? {
            var inputFormat = inputFormat
            var outputFormat = outputFormat

            if (inputFormat == "") { // if inputFormat = "", set a default input format.
                inputFormat = "yyyy-MM-dd'T'hh:mm:ss.SSS'Z'"
            }
            if (outputFormat == "") {
                outputFormat =
                    "dd MMM yyyy hh:mm a" // if inputFormat = "", set a default output format.
            }
            var parsed: Date? = null
            var outputDate = ""
            val df_input =
                SimpleDateFormat(inputFormat)
            df_input.setTimeZone(TimeZone.getTimeZone("UTC"));

            val df_output =
                SimpleDateFormat(outputFormat)

            df_output.setTimeZone(TimeZone.getDefault());


            // You can set a different Locale, This example set a locale of Country Mexico.
            //SimpleDateFormat df_input = new SimpleDateFormat(inputFormat, new Locale("es", "MX"));
            //SimpleDateFormat df_output = new SimpleDateFormat(outputFormat, new Locale("es", "MX"));
            try {
                parsed = df_input.parse(inputDate)
                outputDate = df_output.format(parsed)
            } catch (e: Exception) {
                Log.e(
                    "formattedDateFromString",
                    "Exception in formateDateFromstring(): " + e.message
                )
            }

            return outputDate
        }





        public  fun getDateFromTimeStamp(input :String):String?{
            val inputFormat = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
            val outputFormat = SimpleDateFormat("dd-MM-yyyy")
            val date = inputFormat.parse(input)
            val formattedDate = outputFormat.format(date)
            println(formattedDate)
           return  formattedDate;
        }

        public fun formattedDateFromStringValue(
            inputFormat: String,
            outputFormat: String,
            inputDate: String?
        ): String? {
            var inputFormat = inputFormat
            var outputFormat = outputFormat
            if (inputFormat == "") { // if inputFormat = "", set a default input format.
                inputFormat = "yyyy-MM-dd'T'hh:mm:ss.SSS'Z'"
            }
            if (outputFormat == "") {
                outputFormat =
                    "dd MMM yyyy hh:mm a" // if inputFormat = "", set a default output format.
            }
            var parsed: Date? = null
            var outputDate = ""
            val df_input =
                SimpleDateFormat(inputFormat, Locale.ENGLISH)

            val df_output =
                SimpleDateFormat(outputFormat, Locale.ENGLISH)

            try {
                parsed = df_input.parse(inputDate)
                outputDate = df_output.format(parsed)
            } catch (e: Exception) {
                Log.e(
                    "formattedDateFromString",
                    "Exception in formateDateFromstring(): " + e.message
                )
            }

            return outputDate
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

        public  fun getBitmap(path: String?, context: Context): Bitmap? {
            val uri = Uri.fromFile(File(path))
            var `in`: InputStream? = null
            return try {
                val IMAGE_MAX_SIZE = 1200000 // 1.2MP
                `in` = context.getContentResolver().openInputStream(uri)

                // Decode image size
                var o = BitmapFactory.Options()
                o.inJustDecodeBounds = true
                BitmapFactory.decodeStream(`in`, null, o)
                if (`in` != null) {
                    `in`.close()
                }
                var scale = 1
                while (o.outWidth * o.outHeight * (1 / Math.pow(scale.toDouble(), 2.0)) >
                    IMAGE_MAX_SIZE
                ) {
                    scale++
                }
                var bitmap: Bitmap? = null
                `in` = context.getContentResolver().openInputStream(uri)
                if (scale > 1) {
                    scale--
                    // scale to max possible inSampleSize that still yields an image
                    // larger than target
                    o = BitmapFactory.Options()
                    o.inSampleSize = scale
                    bitmap = BitmapFactory.decodeStream(`in`, null, o)

                    // resize to desired dimensions
                    val height = bitmap!!.height
                    val width = bitmap.width
                    val y = Math.sqrt(
                        IMAGE_MAX_SIZE
                                / (width.toDouble() / height)
                    )
                    val x = y / height * width
                    val scaledBitmap = Bitmap.createScaledBitmap(
                        bitmap, x.toInt(),
                        y.toInt(), true
                    )
                    bitmap.recycle()
                    bitmap = scaledBitmap
                    System.gc()
                } else {
                    bitmap = BitmapFactory.decodeStream(`in`)
                }
                if (`in` != null) {
                    `in`.close()
                }
                bitmap
            } catch (e: IOException) {
                null
            }
        }


        public fun compressImageFile(
            path: String,
            shouldOverride: Boolean = true,
            uri: Uri
        ): String {
//  var scaledBitmap: Bitmap? = null

            try {
                var file = File(path)
                val o = BitmapFactory.Options()
                o.inJustDecodeBounds = true
                o.inSampleSize = 6
// factor of downsizing the image
                var inputStream = FileInputStream(file)
                //Bitmap selectedBitmap = null;
                BitmapFactory.decodeStream(inputStream, null, o)
                inputStream.close()
                // The new size we want to scale to
                val REQUIRED_SIZE = 75
// Find the correct scale value. It should be the power of 2.
                var scale = 1
                while (o.outWidth / scale / 2 >= REQUIRED_SIZE &&
                    o.outHeight / scale / 2 >= REQUIRED_SIZE
                ) {
                    scale *= 2
                }
                val o2 = BitmapFactory.Options()
                o2.inSampleSize = scale
                inputStream = FileInputStream(file)
                val selectedBitmap = BitmapFactory.decodeStream(inputStream, null, o2)
                inputStream.close()

                // here i override the original image file
                file.createNewFile()
                val outputStream = FileOutputStream(file)
                selectedBitmap!!.compress(Bitmap.CompressFormat.JPEG, 100, outputStream)

                return file.path
            } catch (e: java.lang.Exception) {
                return ""
            }

            /* try {
                 val (hgt, wdt) = getImageHgtWdt(uri)

                 // Part 1: Decode image
                 val unscaledBitmap = decodeFile(this@compressImageFile, uri, wdt, hgt, ScalingLogic.FIT)
                 if (unscaledBitmap != null) if (!(unscaledBitmap.width <= 800 && unscaledBitmap.height <= 800)) {
                     // Part 2: Scale image
                     scaledBitmap = createScaledBitmap(unscaledBitmap, wdt, hgt, ScalingLogic.FIT)
                 } else {
                     scaledBitmap = unscaledBitmap
                 }

                 // Store to tmp file
                 val mFolder = File("$filesDir/Images")
                 if (!mFolder.exists()) {
                     mFolder.mkdir()
                 }

                 val tmpFile = File(mFolder.absolutePath, "IMG_${getTimestampString()}.jpg")

                 var fos: FileOutputStream? = null
                 try {
                     fos = FileOutputStream(tmpFile)
                     scaledBitmap?.compress(
                             Bitmap.CompressFormat.JPEG,
                             getImageQualityPercent(tmpFile),
                             fos
                     )
                     fos.flush()
                     fos.close()
                 } catch (e: FileNotFoundException) {
                     e.printStackTrace()

                 } catch (e: Exception) {
                     e.printStackTrace()
                 }

                 var compressedPath = ""
                 if (tmpFile.exists() && tmpFile.length() > 0) {
                     compressedPath = tmpFile.absolutePath
                     if (shouldOverride) {
                         val srcFile = File(path)
                         val result = tmpFile.copyTo(srcFile, true)
                         Log.d(tag, "copied file ${result.absolutePath}")
                         Log.d(tag, "Delete temp file ${tmpFile.delete()}")
                     }
                 }

                 scaledBitmap?.recycle()

                 return@withContext if (shouldOverride) path else compressedPath
             } catch (e: Throwable) {
                 e.printStackTrace()
             }

             return@withContext ""*/

        }

        @Throws(IOException::class)
        fun Context.getBitmapFromUri(uri: Uri, options: BitmapFactory.Options? = null): Bitmap? {
            val parcelFileDescriptor = contentResolver.openFileDescriptor(uri, "r")
            val fileDescriptor = parcelFileDescriptor?.fileDescriptor
            val image: Bitmap? = if (options != null)
                BitmapFactory.decodeFileDescriptor(fileDescriptor, null, options)
            else
                BitmapFactory.decodeFileDescriptor(fileDescriptor)
            parcelFileDescriptor?.close()
            return image
        }

        fun getTimestampString(): String {
            val date = Calendar.getInstance()
            return SimpleDateFormat("yyyy MM dd hh mm ss", Locale.US).format(date.time)
                .replace("", "")
        }


        fun openPdf(title: String, url: String, context: Context) {

            var newDir: File? = null

            try {
                val ext = Environment.getExternalStorageDirectory()
                newDir =
                    File(ext.toString() + "/" + Environment.DIRECTORY_DOCUMENTS + "/" + "mountCarmelDoc") //or any other folder for specific purpose
                if (!newDir.exists()) {
                    newDir.mkdir()
                }
            } catch (ex: java.lang.Exception) {
                ex.printStackTrace()
            }

            context.startActivity(
                PdfViewer.launchPdfFromUrl(
                    context,
                    url,
                    title,
                    newDir!!.path.toString(),
                    enableDownload = true
                )
            )


        }

        fun hideKeyboard(view: View, context: Context) {
            val inputMethodManager =
                context.getSystemService(Activity.INPUT_METHOD_SERVICE) as InputMethodManager
            inputMethodManager.hideSoftInputFromWindow(view.windowToken, 0)
        }


        @SuppressLint("InflateParams")
        fun showCustomToast(context: Context, message: String) {
            Toast.makeText(
                context,
                HtmlCompat.fromHtml(
                    "<font color='red'>$message</font>",
                    HtmlCompat.FROM_HTML_MODE_LEGACY
                ),
                Toast.LENGTH_LONG
            ).show()
        }


        fun EditText.addPrefix(prefix: String) {
            var text = ""
            var isPrefixModified = false
            val formattedPrefix = "$prefix "
            var lastCharSequence: CharSequence? = null

            val setEditText: () -> Unit = {
                setText(text)
                Selection.setSelection(editableText, text.length)
            }

            this.addTextChangedListener(object : TextWatcher {
                override fun afterTextChanged(editable: Editable?) {
                    val newText = editable.toString()

                    when {
                        isPrefixModified -> {
                            isPrefixModified = false
                            setEditText()
                        }
                        isTryingToDeletePrefix(newText) -> {
                            setEditText()
                        }
                        isNewInput(newText) -> {
                            text = "$formattedPrefix$newText"
                            setEditText()
                        }
                        else -> {
                            text = newText
                        }
                    }
                }

                override fun beforeTextChanged(charSequence: CharSequence?, start: Int,
                                               count: Int, after: Int) {
                    charSequence?.let {
                        if (it != lastCharSequence && it.isNotEmpty() && start <= prefix.length) {
                            isPrefixModified = true
                        }
                        lastCharSequence = charSequence
                    }
                }

                override fun onTextChanged(charSequence: CharSequence?, start: Int,
                                           before: Int, count: Int) {
                    // Ignore
                }

                private fun isTryingToDeletePrefix(newText: String) =
                    text.isNotEmpty() && newText.length < text.length && isNewInput(newText)

                private fun isNewInput(newText: String) = !newText.contains(formattedPrefix)
            })
        }


        fun isConnected(): Boolean {
            val connectivityManager = MountCarmelApplication.instance.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
            return connectivityManager.run {
                getNetworkCapabilities(activeNetwork)?.run {
                    hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR) || hasTransport(
                        NetworkCapabilities.TRANSPORT_WIFI) || hasTransport(NetworkCapabilities.TRANSPORT_ETHERNET)
                }
            } ?: false

            /* Below internet IN/OUT check code kept for future implementation */

            /*val mConnectivityManager = MyApplication.instance.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
            var mIsConnectionAvailable = false
            mConnectivityManager.run {
                registerDefaultNetworkCallback(object : ConnectivityManager.NetworkCallback() {
                    override fun onAvailable(network: Network) {
                        //take action when network connection is gained
                        mIsConnectionAvailable = true
                        Log.d(APP_LOG_TAG, "onAvailable: ")
                    }

                    override fun onLost(network: Network) {
                        //take action when network connection is lost
                        mIsConnectionAvailable = false
                        Log.d(APP_LOG_TAG, "onLost: ")
                    }
                })
                return mIsConnectionAvailable
            }*/
        }


    }




}
