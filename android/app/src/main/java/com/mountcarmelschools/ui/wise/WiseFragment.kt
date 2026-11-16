package com.mountcarmelschools.ui.wise

import android.Manifest
import android.annotation.SuppressLint
import android.app.Activity
import android.app.AlertDialog
import android.app.Dialog
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Color
import android.graphics.drawable.ColorDrawable
import android.os.Bundle
import android.text.Editable
import android.text.Selection
import android.text.TextWatcher
import android.util.DisplayMetrics
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.Window
import android.view.inputmethod.InputMethodManager
import android.widget.*
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import androidx.viewpager.widget.ViewPager
import com.bumptech.glide.Glide
import com.bumptech.glide.load.engine.DiskCacheStrategy
import com.bumptech.glide.request.RequestOptions
import com.google.android.material.imageview.ShapeableImageView
import com.google.android.material.textview.MaterialTextView
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseFragment
import com.mountcarmelschools.databinding.FragmentWiseBinding
import com.mountcarmelschools.di.data.classList.ClassListDropDownResponse
import com.mountcarmelschools.di.data.scann.ScanAPiResponse
import com.mountcarmelschools.di.data.scann.ScanPostData
import com.mountcarmelschools.di.data.wise.wiseRes.WiseList
import com.mountcarmelschools.di.data.wise.wiseRes.WisePostData
import com.mountcarmelschools.di.data.wise.wiseRes.WiseResponseForStudent
import com.mountcarmelschools.di.data.wise.wiseRes.wisepostdata.WisePostDataForApi
import com.mountcarmelschools.ui.commonAdapter.CommonInterface
import com.mountcarmelschools.ui.dashboard.DashboardActivity
import com.mountcarmelschools.ui.scanner.ScannerActivity
import com.mountcarmelschools.utlis.*
import com.mountcarmelschools.utlis.CommonUtils.showPermissionAlertDialog
import java.text.ParseException
import java.text.SimpleDateFormat
import java.util.*


class WiseFragment : BaseFragment<FragmentWiseBinding, WiseViewModel>(), CommonInterface,
    wiseInterface, Listener {

    private var mSelectedPosition: Int = 0
    private lateinit var mContext: Context
    private var currentPage = 0
    private var className: String = ""
    private var admissionID: String = ""
    private var studentId: String = ""

    private lateinit var wiseResponseForStudent: WiseResponseForStudent

    private lateinit var staffWiseAdapter: StaffWiseAdapter
    lateinit var mClassListDropDown: List<ClassListDropDownResponse.Data>;

    var tvWorthy: LinearLayout? = null
    var tvIntellect: LinearLayout? = null
    var tvStature: LinearLayout? = null
    var tvEmotion: LinearLayout? = null

    var reasonText: TextView? = null
    var worthyCheckBox: CheckBox? = null
    var intellectCheckBox: CheckBox? = null
    var statureCheckBox: CheckBox? = null
    var emotionCheckBox: CheckBox? = null
    var mStartDate = ""

    private var mList = ArrayList<WisePostData>()

    companion object {
        fun newInstance() = WiseFragment()
    }

    override fun onAttach(context: Context) {
        super.onAttach(context)
        mContext = context
    }

    override fun getLayoutID() = R.layout.fragment_wise

    override fun getViewModel() = WiseViewModel::class.java

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
        settingStudentListRecyclerView()





        dataBinding.ivWorthy.setOnClickListener {

            if (wiseResponseForStudent.data?.worthy?.data?.size!! > 0) {

                openDetails(1)
            }
        }
        dataBinding.ivIntellect.setOnClickListener {
            if (wiseResponseForStudent.data?.intellect?.data?.size!! > 0) {

                openDetails(2)

            }
        }
        dataBinding.ivStature.setOnClickListener {
            if (wiseResponseForStudent.data?.stature?.data?.size!! > 0) {

                openDetails(3)
            }
        }
        dataBinding.ivEmotion.setOnClickListener {
            if (wiseResponseForStudent.data?.emotion?.data?.size!! > 0) {

                openDetails(4)

            }
        }




        dataBinding.rlWorthy.setOnClickListener {
            if (wiseResponseForStudent.data?.worthy?.data?.size!! > 0) {
                openDetails(1)
            }
        }

        dataBinding.rlIntellect.setOnClickListener {
            if (wiseResponseForStudent.data?.intellect?.data?.size!! > 0) {

                openDetails(2)

            }
        }

        dataBinding.rlStature.setOnClickListener {
            if (wiseResponseForStudent.data?.stature?.data?.size!! > 0) {

                openDetails(3)
            }

        }
        dataBinding.rlEmotion.setOnClickListener {
            if (wiseResponseForStudent.data?.emotion?.data?.size!! > 0) {

                openDetails(4)
            }
        }


        val userType = Utils.getUserType(mContext)

        if (userType.equals("1")) {

            dataBinding.svStudentWise.setBackgroundColor(
                ContextCompat.getColor(
                    mContext, R.color.blue_background
                )
            )
            getWise()


        } else if (userType.equals("2") || userType.equals("3")) {
            dataBinding.svStudentWise.setBackgroundColor(
                ContextCompat.getColor(
                    mContext, R.color.fourth_background
                )
            )
            getWise()

        } else {


            dataBinding.svStudentWise.setBackgroundColor(
                ContextCompat.getColor(
                    mContext, R.color.parent_background
                )
            )

            getClassListForDropDown()

            dataBinding.sectionList.onItemSelectedListener =
                object : AdapterView.OnItemSelectedListener {
                    override fun onNothingSelected(parent: AdapterView<*>?) {

                    }

                    override fun onItemSelected(
                        parent: AdapterView<*>?, view: View?, position: Int, id: Long
                    ) {


                        mSelectedPosition = position
                        if (mSelectedPosition > 0) getWiseListForStaff(
                            mClassListDropDown.get(mSelectedPosition - 1)?._id.toString()
                        )

                    }

                }


            val cal = Calendar.getInstance();
            val df = SimpleDateFormat("dd-MM-yyyy")
            val startDate = df.format(cal.time)
            dataBinding.edtCalendar.text = startDate


            if (Utils.getUserType(mContext).equals("4")) {

                viewModel.getCurrentTermResponse(
                    Utils.getAccessToken(mContext),
                    CommonUtils.checkTerm()
                )
                    .observe(

                        viewLifecycleOwner, androidx.lifecycle.Observer {

                            (mContext as DashboardActivity).hideProgress()


                            mStartDate = it.data!!.startDate!!

                        })




                dataBinding.edtCalendar.setOnClickListener {

                    val startDateCal = Calendar.getInstance()

                    if (mStartDate == "") {
                        val date = SimpleDateFormat("dd-MM-yyyy").parse(
                            (mContext as DashboardActivity).mSessionStartDate
                        )
                        startDateCal.time = date!!

                    } else {
                        val data = Utils.formattedDateFromString(
                            "",
                            "dd-MM-yyyy",
                            mStartDate
                        )
                        val date = SimpleDateFormat("dd-MM-yyyy").parse(
                            data
                        )
                        startDateCal.time = date!!
                    }


                    Utils.showCalendarDialogWithFixDates(mContext, this, startDateCal)

                }
            }

        }

        dataBinding.btnSave.setOnClickListener {

            if (mSelectedPosition > 0 && mList.size > 0) {
                openDialog(
                    mClassListDropDown.get(mSelectedPosition - 1)?.standard.toString() + " " + mClassListDropDown.get(
                        mSelectedPosition - 1
                    )?.section.toString(), 0
                )
            }

        }


        dataBinding.btnSave1.setOnClickListener {

            openDialog(className, 1)
        }


        staffWiseAdapter = StaffWiseAdapter(
            mContext, listOf(), "", this, "", arrayListOf()
        )


        dataBinding.edtCalendar1.addTextChangedListener(object : TextWatcher {
            override fun afterTextChanged(s: Editable) {}
            override fun beforeTextChanged(
                s: CharSequence, start: Int, count: Int, after: Int
            ) {
            }

            override fun onTextChanged(
                s: CharSequence, start: Int, before: Int, count: Int
            ) {
                if (staffWiseAdapter != null) {
                    staffWiseAdapter.getFilter().filter(s)
                }
            }
        })
        /*    dataBinding.qrCodeScan.setOnClickListener {
                (mContext as DashboardActivity).openCamera()
            }*/



        dataBinding.tvClass.setOnClickListener {

            dataBinding.tvClass.background =
                ContextCompat.getDrawable(mContext, R.drawable.blue_border)
            dataBinding.tvClass.setTextColor(ContextCompat.getColor(mContext, R.color.purple))

            dataBinding.tvStudent.background =
                ContextCompat.getDrawable(mContext, R.drawable.gray_backgroud)
            dataBinding.tvStudent.setTextColor(ContextCompat.getColor(mContext, R.color.border))


            dataBinding.studentView.visibility = View.GONE
            dataBinding.classView.visibility = View.VISIBLE
        }

        dataBinding.tvStudent.setOnClickListener {

            dataBinding.tvStudent.background =
                ContextCompat.getDrawable(mContext, R.drawable.blue_border)
            dataBinding.tvStudent.setTextColor(ContextCompat.getColor(mContext, R.color.purple))

            dataBinding.tvClass.background =
                ContextCompat.getDrawable(mContext, R.drawable.gray_backgroud)
            dataBinding.tvClass.setTextColor(ContextCompat.getColor(mContext, R.color.border))

            dataBinding.studentView.visibility = View.VISIBLE
            dataBinding.classView.visibility = View.GONE
        }

        dataBinding.qrCodeScan.setOnClickListener {
            if (PermissionUtils.hasPermission(
                    mContext as DashboardActivity, Manifest.permission.CAMERA
                )
            ) {
                startActivity()

            } else {
                PermissionUtils.requestPermissions(
                    this, arrayOf(
                        Manifest.permission.CAMERA, Manifest.permission.WRITE_EXTERNAL_STORAGE
                    ), 10001
                )
            }
        }


        dataBinding.ivWiseLabel.setOnClickListener {


            val dialog = Dialog(mContext, android.R.style.Theme_Black_NoTitleBar_Fullscreen)
            dialog.setContentView(R.layout.image_view_dialog)

            dialog.show()

            var imageView = dialog.findViewById<ZoomableImageView>(R.id.imageView);
            var imageViewClose = dialog.findViewById<ImageView>(R.id.imageViewClose);

            val icon: Bitmap = BitmapFactory.decodeResource(resources, R.drawable.know_more_wise)

            imageView.setImageBitmap(icon)

            imageViewClose.setOnClickListener {

                dialog.dismiss()
                dialog.cancel()
            }

            val window = dialog.window!!

            window!!.setLayout(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT
            )

        }

    }


    override fun onRequestPermissionsResult(
        requestCode: Int, permissions: Array<out String>, grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)

        when (requestCode) {
            10001 -> if (grantResults.size > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                if (PermissionUtils.hasPermission(
                        mContext as DashboardActivity, Manifest.permission.WRITE_EXTERNAL_STORAGE
                    )
                ) {
                    startActivity()

                } else {
                    if (!ActivityCompat.shouldShowRequestPermissionRationale(
                            mContext as DashboardActivity,
                            Manifest.permission.WRITE_EXTERNAL_STORAGE
                        )
                    ) {
                        showPermissionAlertDialog(mContext as DashboardActivity)
                    }
                }
            } else {
                if (!ActivityCompat.shouldShowRequestPermissionRationale(
                        mContext as DashboardActivity, Manifest.permission.CAMERA
                    )
                ) {
                    showPermissionAlertDialog(mContext as DashboardActivity)
                }
            }
        }
    }

    fun startActivity() {
        val intent = Intent(mContext, ScannerActivity::class.java)

        startActivityForResult(intent, 10002)
    }


    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (data != null && data.hasExtra("id") && data.getStringExtra("id") != null) {
            dataBinding.studentContainer.removeAllViews()
            getStudentDetailFromQr(data.getStringExtra("id")!!)

        }

    }


    fun updateData() {
        (mContext as DashboardActivity).showProgress()


        val classValue = ArrayList<WisePostDataForApi>()

        for (data in mList) {
            var value = 0;
            var worthValue = 0;
            var intellectValue = 0;
            var statureValue = 0;
            var emotionValue = 0;

            if (data.type.equals("Worthy Card")) {
                worthValue = 1
            } else if (data.type.equals("Intellect Card")) {
                intellectValue = 1

            } else if (data.type.equals("Stature Card")) {
                statureValue = 1

            } else if (data.type.equals("Emotion Card")) {
                emotionValue = 1

            }

            var reasonValue = "";
            reasonValue = if (data.reason.toString().startsWith("For ")) {

                data.reason.toString().removePrefix("For ")

            } else {
                data.reason.toString();
            }


            val wiseData = WisePostDataForApi(

                data.admissionNo,
                emotionValue,
                intellectValue,
                reasonValue,
                statureValue,
                data.studentId,
                data.wiseDate,
                worthValue
            )
            classValue.add(wiseData)


        }


        updateWiseCardsToStudent(classValue, 0)
    }


    private fun openDialog(className: String?, value: Int) {
        val dialogBuilder = AlertDialog.Builder(mContext)
        val inflater = this.layoutInflater
        val dialogView: View = inflater.inflate(R.layout.wise_dialog, null)
        dialogBuilder.setView(dialogView)


        val close = dialogView.findViewById(R.id.close) as ImageView
        val publish = dialogView.findViewById(R.id.publish) as TextView
        val text = dialogView.findViewById(R.id.text) as TextView


        val b = dialogBuilder.create()
        b.setCancelable(false)
        b.setCanceledOnTouchOutside(false)
        b.show()

        val window: Window = b.getWindow()!!

        window.setLayout(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT)

        close.setOnClickListener {
            b.cancel()
            b.dismiss()

        }

        publish.setOnClickListener {

            if (value == 0) {
                updateData()

            } else {

                updateSingleStudentData();
            }
            b.cancel()
            b.dismiss()

        }
        if (value == 0) {
            text.text =
                "Congratulations for motivating students of $className \n Click here to publish"

        } else {

            text.text = "Congratulations for motivating  $className \n Click here to publish"
        }


    }

    @SuppressLint("SimpleDateFormat")
    private fun updateSingleStudentData() {


        val classValue = ArrayList<WisePostDataForApi>()

        var worthValue = 0;
        var intellectValue = 0;
        var statureValue = 0;
        var emotionValue = 0;

        if (worthyCheckBox!!.isChecked) {
            worthValue = 1
        } else if (intellectCheckBox!!.isChecked) {
            intellectValue = 1

        } else if (statureCheckBox!!.isChecked) {
            statureValue = 1

        } else if (emotionCheckBox!!.isChecked) {
            emotionValue = 1

        }
        val cal = Calendar.getInstance();
        val df = SimpleDateFormat("dd-MM-yyyy")
        val startDate = df.format(cal.time)


        var reasonValue = "";
        reasonValue = if (reasonText!!.text.toString().startsWith("For ")) {
            reasonText!!.text.toString().removePrefix("For ")
        } else {
            reasonText!!.text.toString();
        }

        val wiseData = WisePostDataForApi(

            admissionID,
            emotionValue,
            intellectValue,
            reasonValue,
            statureValue,
            studentId,
            startDate,
            worthValue
        )
        classValue.add(wiseData)


        updateWiseCardsToStudent(classValue, 1)
    }


    private fun updateWiseCardsToStudent(data: ArrayList<WisePostDataForApi>, value: Int) {

        (mContext as DashboardActivity).showProgress()

        viewModel.getUpdateStudentWise(
            Utils.getAccessToken(mContext), data
        ).observe(viewLifecycleOwner, androidx.lifecycle.Observer {

            (mContext as DashboardActivity).hideProgress()

            showSuccessToast(it.message!!, mContext)
            dataBinding.edtCalendar1.setText("")

            if (value == 0) {
                mList.clear()
                getWiseListForStaff(
                    mClassListDropDown.get(mSelectedPosition - 1)?._id.toString()
                )

            } else {
                dataBinding.studentContainer.removeAllViews();
                dataBinding.btnSave1.visibility = View.GONE

            }
        })

    }

    override fun onResume() {
        super.onResume()
        if (Utils.getUserType(mContext).equals("4", false)) {
            dataBinding.clStaffWise.visibility = View.VISIBLE
        } else {
            dataBinding.svStudentWise.visibility = View.VISIBLE
        }
        (mContext as DashboardActivity).setHeaderText(mContext.resources.getString(R.string.wise))

    }

    private fun settingStudentListRecyclerView() {
        dataBinding.rvStudentList.layoutManager =
            LinearLayoutManager(mContext, RecyclerView.VERTICAL, false)
        dataBinding.rvStudentList.hasFixedSize()

    }

    /**
     * This method is to show the Calendar dialog box.
     */
    var customDialog: Dialog? = null

    private fun openDetails(check: Int) {
        customDialog = Dialog(mContext, R.style.DialogTheme)
        customDialog?.requestWindowFeature(Window.FEATURE_NO_TITLE);
        customDialog?.window?.setBackgroundDrawable(ColorDrawable(Color.TRANSPARENT));


        //val customDialog = Dialog(mContext, R.style.AppThemeFull)
        // customDialog.requestWindowFeature(Window.FEATURE_NO_TITLE)
        customDialog?.setContentView(R.layout.dialog_wise_detais)
        val viewPager = customDialog?.findViewById(R.id.viewpager) as DynamicHeightViewPager

        //val image = customDialog.findViewById(R.id.iv_close) as ImageView
        val close = customDialog?.findViewById(R.id.close) as FrameLayout


        /*  image.setOnClickListener {
              customDialog.dismiss()
          }*/
        viewPager.setOnClickListener {
            customDialog?.dismiss()
        }
        close.setOnClickListener {
            customDialog?.dismiss()
        }
        init(viewPager, check)

        customDialog?.show()
    }

    fun dpToPx(dp: Int): Int {
        val displayMetrics = requireActivity().resources.displayMetrics
        return Math.round(dp * (displayMetrics.xdpi / DisplayMetrics.DENSITY_DEFAULT))
    }

    override fun close() {
        customDialog?.dismiss()
    }

    private fun init(viewpager: DynamicHeightViewPager, check: Int) {

        var adp: StudenWiseAdapter? = null
        viewpager.pageMargin = 10

        if (check == 1) {


            val list = ArrayList<WiseList>()

            wiseResponseForStudent.data?.worthy?.data!!.forEach {

                list.add(
                    WiseList(
                        it.staffId?.name, it.remarks, it.wiseDate, it.reason
                    )
                )

                adp = StudenWiseAdapter(
                    mContext, list, check, this
                )

            }
        } else if (check == 2) {
            val list = ArrayList<WiseList>()

            wiseResponseForStudent.data?.intellect?.data!!.forEach {

                list.add(
                    WiseList(
                        it.staffId?.name, it.remarks, it.wiseDate, it.reason
                    )
                )


                adp = StudenWiseAdapter(
                    mContext, list, check, this
                )


            }
        } else if (check == 3) {
            val list = ArrayList<WiseList>()

            wiseResponseForStudent.data?.stature?.data!!.forEach {

                list.add(
                    WiseList(
                        it.staffId?.name, it.remarks, it.wiseDate, it.reason
                    )
                )

                adp = StudenWiseAdapter(
                    mContext, list, check, this
                )

            }
        } else if (check == 4) {
            val list = ArrayList<WiseList>()

            wiseResponseForStudent.data?.emotion?.data!!.forEach {

                list.add(
                    WiseList(
                        it.staffId?.name, it.remarks, it.wiseDate, it.reason
                    )
                )
            }

            adp = StudenWiseAdapter(
                mContext, list, check, this
            )


        }


        viewpager.clipToPadding = false
        viewpager.setPadding(dpToPx(90), 0, dpToPx(90), 0)
        val scaleFactor = 0.98f

        adp?.let {


            viewpager.adapter = it

            viewpager.setPageTransformer(
                false
            ) { page, position ->
                page.scaleY = (1 - Math.abs(position) * (1 - scaleFactor));
                page.scaleX = scaleFactor + Math.abs(position) * (1 - scaleFactor);
            }

            viewpager.addOnPageChangeListener(object : ViewPager.OnPageChangeListener {
                override fun onPageScrollStateChanged(state: Int) {
                }

                override fun onPageScrolled(
                    position: Int, positionOffset: Float, positionOffsetPixels: Int
                ) {

                    /*Log.e("hmmm", ""+position)
                    Log.e("hmmm", ""+positionOffset)
                    Log.e("hmmm", ""+positionOffsetPixels)*/
                }

                override fun onPageSelected(position: Int) {

                    // viewpager.measure(viewpager.measuredWidth, viewpager.measuredHeight);

                    adp?.updateSelectedPos(position)
                }


            })
        }


    }

    @SuppressLint("SetTextI18n")
    private fun getWise() {

        (mContext as DashboardActivity).showProgress()

        if (!(mContext as DashboardActivity).userImage.equals("")) {

            Glide.with(this).load((mContext as DashboardActivity).userImage).override(120, 120)
                .centerCrop().error(R.drawable.default_image)
                .diskCacheStrategy(DiskCacheStrategy.RESOURCE).apply(RequestOptions().circleCrop())
                .into(dataBinding.cvStudentPic)

        }


        viewModel.getWise(Utils.getAccessToken(mContext), Utils.getStudentRollNo(mContext)).observe(

            viewLifecycleOwner, androidx.lifecycle.Observer {

                (mContext as DashboardActivity).hideProgress()
                wiseResponseForStudent = it

                dataBinding.worthyTextCount.text = it.data?.worthy!!.count.toString()

                dataBinding.intellectTextCount.text = it.data.intellect!!.count.toString()

                dataBinding.emotionTextCount.text = it.data.emotion!!.count.toString()

                dataBinding.statureTextCount.text = it.data.stature!!.count.toString()

                dataBinding.tvStudentClass.text =
                    it.student?.standardSectionId?.standard + "-" + it.student?.standardSectionId?.section

                dataBinding.tvStudentName.text = it.student!!.name


            })
    }

    private fun getWiseListForStaffForDate(id: String) {

        val previousDate = decrementDateByOne(dataBinding.edtCalendar.text.toString())

        viewModel.getWiseStudentListFromDate(
            Utils.getAccessToken(mContext),
            id,
            previousDate!!,
            dataBinding.edtCalendar.text.toString()
        ).observe(viewLifecycleOwner, androidx.lifecycle.Observer {


        })

    }

    private fun getWiseListForStaff(id: String) {

        (mContext as DashboardActivity).showProgress()
        viewModel.getWiseStudentList(
            Utils.getAccessToken(mContext), id
        ).observe(viewLifecycleOwner, androidx.lifecycle.Observer {

            (mContext as DashboardActivity).hideProgress()

            staffWiseAdapter = StaffWiseAdapter(
                mContext,
                it.data!!,
                it.path!!,
                this,
                dataBinding.edtCalendar.text.toString(),
                arrayListOf()
            )
            dataBinding.rvStudentList.adapter = staffWiseAdapter


        })

    }

    override fun selectedDate(date: String) {
        dataBinding.edtCalendar.text = date
        mList.clear()
        if (mSelectedPosition > 0) {
            getWiseListForStaff(
                mClassListDropDown.get(mSelectedPosition - 1)?._id.toString()
            )
        }
    }

    override fun selectClass(classId: String) {
    }

    override fun selectHouseId(houseId: String) {
    }

    @SuppressLint("SimpleDateFormat")
    fun decrementDateByOne(dtStart: String?): String? {
        var date = Date()
        val format = SimpleDateFormat("dd-MM-yyyy")
        try {
            date = format.parse(dtStart)
            System.out.println(date)
        } catch (e: ParseException) {
            e.printStackTrace()
        }
        val c = Calendar.getInstance()
        c.time = date
        c.add(Calendar.DATE, -1)


        return format.format(date);
    }

    override fun addData(wisePostData: WisePostData) {


        mList.add(wisePostData)
        staffWiseAdapter.update(mList)

    }

    override fun removeData(id: String) {
        if (mList.size > 0) {


            for (i in 0..mList.size - 1) {
                if (mList.get(i).admissionNo!!.equals(id)) {
                    mList.removeAt(i)
                    break
                }
            }

            staffWiseAdapter.update(mList)

        }


    }


    private fun getClassListForDropDown() {

        (mContext as DashboardActivity).showProgress()
        viewModel.getClassListForDropDown(
            Utils.getAccessToken(mContext)
        ).observe(viewLifecycleOwner, androidx.lifecycle.Observer {

            val list = ArrayList<String>()

            if (it.status!!) {

                if (it.data?.size!! > 0) {
                    mClassListDropDown = it.data as List<ClassListDropDownResponse.Data>;

                    list.add("Select")
                    for (data in it.data) {
                        list.add(data?.standard.toString() + " " + data?.section.toString())

                    }


                    // Create adapter and add in AutoCompleteTextView
                    val adapter = ArrayAdapter(
                        mContext, android.R.layout.simple_list_item_1, list
                    )
                    dataBinding.sectionList.adapter = adapter

                }
            }

            (mContext as DashboardActivity).hideProgress()

        })


    }

    fun getStudentDetailFromQr(id: String?) {
        (mContext as DashboardActivity).showProgress()

        var data = ScanPostData(id, "min-search")
        viewModel.getScan(Utils.getAccessToken(mContext), data).observe(

            viewLifecycleOwner, androidx.lifecycle.Observer {
                (mContext as DashboardActivity).hideProgress()

                if (it.status!!) {

                    updateView(it)

                    className = it.data?.get(0)?.name!!;
                    admissionID = it.data[0]?.admissionNo!!
                    studentId = it.data[0]!!.id!!
                } else {
                    showErrorToast(it.message!!, mContext)

                }


            })
    }

    private fun updateView(it: ScanAPiResponse?) {
        dataBinding.studentContainer.removeAllViews()
        val itemView = LayoutInflater.from(mContext).inflate(R.layout.row_staff_wise, null)


        var iv_student_image: ImageView? = null
        var tvStudentName: TextView? = null
        var tvSerialNo: TextView? = null


        tvWorthy = itemView.findViewById(R.id.tv_worthy)
        tvIntellect = itemView.findViewById(R.id.tv_intellect)
        tvStature = itemView.findViewById(R.id.tv_stature)
        tvEmotion = itemView.findViewById(R.id.tv_emotion)
        iv_student_image = itemView.findViewById(R.id.iv_student_image)
        tvSerialNo = itemView.findViewById(R.id.tv_student_roll_no)
        tvStudentName = itemView.findViewById(R.id.tv_student_name)
        reasonText = itemView.findViewById(R.id.reasonText)
        worthyCheckBox = itemView.findViewById(R.id.worthyCheckBox)
        intellectCheckBox = itemView.findViewById(R.id.intellectCheckBox)
        statureCheckBox = itemView.findViewById(R.id.statureCheckBox)
        emotionCheckBox = itemView.findViewById(R.id.emotionCheckBox)


        tvStudentName?.text = it?.data?.get(0)?.name
        Glide.with(mContext).load(it?.path + it?.data?.get(0)?.profilePic)
            .diskCacheStrategy(DiskCacheStrategy.RESOURCE).error(R.drawable.default_image)
            .into(iv_student_image!!)

        tvSerialNo?.text = it?.data?.get(0)?.admissionNo


        tvWorthy?.setOnClickListener {
            if (worthyCheckBox!!.isChecked) {
                worthyCheckBox!!.isChecked = false
                reasonText!!.visibility = View.GONE
                dataBinding.btnSave1.visibility = View.GONE

            } else {
                showNoteDialog("Worthy Card", mContext)
            }
        }


        tvIntellect?.setOnClickListener {
            if (intellectCheckBox!!.isChecked) {
                intellectCheckBox!!.isChecked = false
                reasonText!!.visibility = View.GONE
                dataBinding.btnSave1.visibility = View.GONE


            } else {
                showNoteDialog("Intellect Card", mContext)
                //dataBinding.intellectCheckBox.isChecked = true

            }
        }

        tvStature?.setOnClickListener {
            if (statureCheckBox!!.isChecked) {
                statureCheckBox!!.isChecked = false
                reasonText!!.visibility = View.GONE
                dataBinding.btnSave1.visibility = View.GONE


            } else {
                showNoteDialog("Stature Card", mContext)
            }
            //dataBinding.statureCheckBox.isChecked = true

        }

        tvEmotion?.setOnClickListener {
            if (emotionCheckBox!!.isChecked) {
                emotionCheckBox!!.isChecked = false
                reasonText!!.visibility = View.GONE
                dataBinding.btnSave1.visibility = View.GONE


            } else {
                showNoteDialog("Emotion Card", mContext)

            }
            //  dataBinding.emotionCheckBox.isChecked = true

        }
        dataBinding.studentContainer.addView(itemView)

    }

    private fun showNoteDialog(
        header: String, mContext: Context
    ) {
        val customProgressDialog = Dialog(mContext)
        customProgressDialog.setContentView(R.layout.custome_staff_dialog)
        customProgressDialog.window!!.setBackgroundDrawable(
            ColorDrawable(Color.TRANSPARENT)
        )
        val window: Window = customProgressDialog.getWindow()!!

        window.setLayout(
            ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT
        )


        val title = customProgressDialog.findViewById(R.id.tv_header) as MaterialTextView
        val textView6 = customProgressDialog.findViewById(R.id.textView6) as TextView
        val editText = customProgressDialog.findViewById(R.id.edt_reason) as EditText
        val ok = customProgressDialog.findViewById(R.id.ok) as Button
        title.text = header
        val close = customProgressDialog.findViewById(R.id.iv_close) as ShapeableImageView


        editText.requestFocus()
        val imm: InputMethodManager =
            mContext.getSystemService(Activity.INPUT_METHOD_SERVICE) as InputMethodManager
        imm.toggleSoftInput(InputMethodManager.SHOW_FORCED, 0)

        editText.addTextChangedListener(object : TextWatcher {
            override fun beforeTextChanged(
                s: CharSequence, start: Int, count: Int, after: Int
            ) {
            }

            override fun onTextChanged(
                s: CharSequence, start: Int, before: Int, count: Int
            ) {

            }

            override fun afterTextChanged(s: Editable) {
                if (!s.toString().startsWith("For ")) {
                    editText.setText("For ");
                    Selection.setSelection(editText.getText(), editText.getText().length);

                }
                textView6.setText((s.toString().length - 3).toString() + "/80")
            }
        })

        close.setOnClickListener {
            customProgressDialog.dismiss()
            customProgressDialog.cancel()
        }

        ok.setOnClickListener {
            if (editText.text.toString().equals("For ")) {
                customProgressDialog.dismiss()
                customProgressDialog.cancel()
            } else {

                reasonText!!.setText(editText.text.toString())
                reasonText!!.visibility = View.VISIBLE
                dataBinding.btnSave1.visibility = View.VISIBLE

                customProgressDialog.dismiss()
                customProgressDialog.cancel()

                if (header.equals("Worthy Card")) {
                    worthyCheckBox!!.isChecked = true
                    statureCheckBox!!.isChecked = false
                    emotionCheckBox!!.isChecked = false
                    intellectCheckBox!!.isChecked = false

                } else if (header.equals("Stature Card")) {
                    worthyCheckBox!!.isChecked = false
                    statureCheckBox!!.isChecked = true
                    emotionCheckBox!!.isChecked = false
                    intellectCheckBox!!.isChecked = false
                } else if (header.equals("Emotion Card")) {
                    worthyCheckBox!!.isChecked = false
                    statureCheckBox!!.isChecked = false
                    emotionCheckBox!!.isChecked = true
                    intellectCheckBox!!.isChecked = false

                } else if (header.equals("Intellect Card")) {
                    worthyCheckBox!!.isChecked = false
                    statureCheckBox!!.isChecked = false
                    emotionCheckBox!!.isChecked = false
                    intellectCheckBox!!.isChecked = true
                }


            }
        }
        try {
            customProgressDialog.show()
        } catch (e: Exception) {

        }


    }
}
