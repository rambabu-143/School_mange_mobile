package com.mountcarmelschools.ui.disciplinary.forstaff

import android.Manifest
import android.app.AlertDialog
import android.app.Dialog
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.graphics.drawable.ColorDrawable
import android.os.Bundle
import android.text.Editable
import android.text.Html
import android.text.TextWatcher
import android.util.Log
import android.view.*
import android.view.inputmethod.InputMethodManager
import android.widget.*
import androidx.core.content.ContextCompat
import androidx.lifecycle.Observer
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.bumptech.glide.Glide
import com.bumptech.glide.load.engine.DiskCacheStrategy
import com.google.android.material.textfield.TextInputLayout
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseFragment
import com.mountcarmelschools.databinding.FragmentDisciplinaryForStaffBinding
import com.mountcarmelschools.di.data.CommonResponse
import com.mountcarmelschools.di.data.classList.ClassListDropDownResponse
import com.mountcarmelschools.di.data.disciplinaryCard.DisciplinaryPostDataItem
import com.mountcarmelschools.di.data.disciplinaryCard.GetReasonListResponse
import com.mountcarmelschools.di.data.scann.ScanAPiResponse
import com.mountcarmelschools.di.data.scann.ScanPostData
import com.mountcarmelschools.di.data.staff.wiseStudentList.WiseListFromClassResponse
import com.mountcarmelschools.di.networking.ResponseStatus
import com.mountcarmelschools.di.networking.ResponseStatusError
import com.mountcarmelschools.ui.commonAdapter.CommonInterface
import com.mountcarmelschools.ui.dashboard.DashboardActivity
import com.mountcarmelschools.ui.scanner.ScannerActivity
import com.mountcarmelschools.utlis.CommonUtils
import com.mountcarmelschools.utlis.PermissionUtils
import com.mountcarmelschools.utlis.Utils
import java.text.SimpleDateFormat
import java.util.*


class DisciplinaryForStaffFragment :
    BaseFragment<FragmentDisciplinaryForStaffBinding, DisciplinaryForStaffViewModel>(),
    CommonInterface, DisciplinaryInterface {
    private lateinit var mSpinnerAdapter: ArrayAdapter<String>
    private lateinit var disciplinaryStaffAdapter: DisciplinaryForStaffAdapter
    lateinit var mContext: Context
    private var className: String = ""
    private var admissionID: String = ""
    private var studentId: String = ""
    private var studentName: String = ""
    private var selectedCard: String = ""
    private var selectedReason: String = ""
    private var house_point: String = ""
    private var mActionTaken: String = ""
    private var reason_other: String = ""
    lateinit var mClassListDropDown: List<ClassListDropDownResponse.Data>;

    private var mList = ArrayList<DisciplinaryPostDataItem>()
    var mStartDate = ""
    private var mSelectedPosition: Int = 0
    val mSpinnerList = ArrayList<String>()

    private lateinit var progress_circular: ProgressBar
    private lateinit var reason: AutoCompleteTextView
    var mReasonList = ArrayList<String>()
    val housingPointArray = arrayListOf<String>("1", "2", "3", "4", "5")

    var imagePath: String = ""
    var test: String = ""
    var mWhichScreen: String = "Class"


    companion object {
        fun newInstance() = DisciplinaryForStaffFragment()
    }

    override fun onAttach(context: Context) {
        super.onAttach(context)
        mContext = context
    }

    override fun onResume() {
        super.onResume()
        (mContext as DashboardActivity).setHeaderText("Disciplinary Card")

    }

    override fun getLayoutID() = R.layout.fragment_disciplinary_for_staff


    override fun getViewModel() = DisciplinaryForStaffViewModel::class.java


    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
        dataBinding.lifecycleOwner = this    // add this line

        initObserver()

        settingStudentListRecyclerView()


        getClassListForDropDown()


        val cal = Calendar.getInstance();
        val df = SimpleDateFormat("dd-MM-yyyy")
        val startDate = df.format(cal.time)
        dataBinding.edtCalendar.text = startDate



        viewModel.getCurrentTermResponse(
            Utils.getAccessToken(mContext), CommonUtils.checkTerm()
        ).observe(

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
                    "", "dd-MM-yyyy", mStartDate
                )
                val date = SimpleDateFormat("dd-MM-yyyy").parse(
                    data
                )
                startDateCal.time = date!!
            }


            Utils.showCalendarDialogWithFixDates(mContext, this, startDateCal)

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

        dataBinding.tvClass.setOnClickListener {

            dataBinding.tvClass.background =
                ContextCompat.getDrawable(mContext, R.drawable.blue_border)
            dataBinding.tvClass.setTextColor(ContextCompat.getColor(mContext, R.color.purple))

            dataBinding.tvStudent.background =
                ContextCompat.getDrawable(mContext, R.drawable.gray_backgroud)
            dataBinding.tvStudent.setTextColor(ContextCompat.getColor(mContext, R.color.border))


            dataBinding.studentView.visibility = View.GONE
            dataBinding.classView.visibility = View.VISIBLE

            mWhichScreen = "Class"
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

            mWhichScreen = "Student"

        }


        disciplinaryStaffAdapter = DisciplinaryForStaffAdapter(
            mContext,
            arrayListOf(),
            imagePath,
            dataBinding.edtCalendar.text.toString(),
            arrayListOf(),
            this
        )
        dataBinding.rvStudentList.adapter = disciplinaryStaffAdapter

        mSpinnerAdapter = ArrayAdapter(
            mContext, android.R.layout.simple_list_item_1, mSpinnerList
        )
        mSpinnerAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        dataBinding.sectionList.adapter = mSpinnerAdapter
        mSpinnerAdapter.notifyDataSetChanged();


        dataBinding.sectionList.onItemSelectedListener =
            object : AdapterView.OnItemSelectedListener {
                override fun onNothingSelected(parent: AdapterView<*>?) {

                }

                override fun onItemSelected(
                    parent: AdapterView<*>?, view: View?, position: Int, id: Long
                ) {

                    mSelectedPosition = position
                    if (mSelectedPosition > 0) {
                        dataBinding.edtCalendar1.setText("")
                        getWiseListForStaff(
                            mClassListDropDown.get(mSelectedPosition - 1)._id.toString()
                        )
                    }

                }

            }

        dataBinding.edtCalendar1.addTextChangedListener(object : TextWatcher {
            override fun afterTextChanged(s: Editable) {}
            override fun beforeTextChanged(
                s: CharSequence, start: Int, count: Int, after: Int
            ) {
            }

            override fun onTextChanged(
                s: CharSequence, start: Int, before: Int, count: Int
            ) {
                if (::disciplinaryStaffAdapter.isInitialized && disciplinaryStaffAdapter != null) {
                    disciplinaryStaffAdapter.getFilter().filter(s)
                }
            }
        })

        dataBinding.btnSave.setOnClickListener {

            showDialog("", "list")

        }
    }

    fun startActivity() {
        val intent = Intent(mContext, ScannerActivity::class.java)

        startActivityForResult(intent, 10002)
    }

    private fun getClassListForDropDown() {

        (mContext as DashboardActivity).showProgress()

        viewModel.getClassListForDropDown(
            Utils.getAccessToken(mContext)
        ).observe(viewLifecycleOwner, androidx.lifecycle.Observer {
            mSpinnerList.clear()

            if (it.status!!) {

                if (it.data?.size!! > 0) {
                    mClassListDropDown = it.data as List<ClassListDropDownResponse.Data>;

                    mSpinnerList.add("Select")
                    for (data in it.data) {
                        mSpinnerList.add(data?.standard.toString() + " " + data?.section.toString())

                    }

                    mSpinnerAdapter.notifyDataSetChanged()

                }
            }

            (mContext as DashboardActivity).hideProgress()

        })


    }

    private fun settingStudentListRecyclerView() {
        dataBinding.rvStudentList.layoutManager =
            LinearLayoutManager(mContext, RecyclerView.VERTICAL, false)
        dataBinding.rvStudentList.hasFixedSize()

    }


    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (data != null && data.hasExtra("id") && data.getStringExtra("id") != null) {
            dataBinding.studentContainer.removeAllViews()
            getStudentDetailFromQr(data.getStringExtra("id")!!)

        }

    }

    private fun getStudentDetailFromQr(id: String?) {
        (mContext as DashboardActivity).showProgress()

        val data = ScanPostData(id, "min-search")
        viewModel.callScanQrCode(mContext, Utils.getAccessToken(mContext), data)

    }


    override val observerError = Observer<ResponseStatusError> {
        (mContext as DashboardActivity).hideProgress()

        when (it) {

            is ResponseStatusError.NoInternetError -> {
                showSuccessToast(getString(R.string.check_internet_connection), requireContext())
            }

            is ResponseStatusError.TechnicalError -> {
                showSuccessToast(it.errorMessageCode.toString(), requireContext())
            }

            is ResponseStatusError.ErrorResponseError -> {
            }
        }
    }

    private fun getWiseListForStaff(id: String) {

        activity?.runOnUiThread {
            (mContext as DashboardActivity).showProgress()
        }


        if (::disciplinaryStaffAdapter.isInitialized) {
            disciplinaryStaffAdapter.update(arrayListOf())
        }

        viewModel.getWiseStudentList(
            Utils.getAccessToken(mContext), id
        ).observe(viewLifecycleOwner) {

         //   Log.e("","11111188989")
            if(it.status==true && it.data!!.isNotEmpty()) {

                imagePath = it.path.toString();

                disciplinaryStaffAdapter.updateAllData(
                    it.data,
                    imagePath,
                    dataBinding.edtCalendar.toString()
                )

                    (mContext as DashboardActivity).hideProgress()
            }

        }

    }


    private fun initObserver() {

        viewModel.liveDataNetworkError.observe(viewLifecycleOwner, observerError)
        viewModel.liveDataScanQrCode.observe(viewLifecycleOwner, observerScanQR)
        viewModel.liveDataReasonList.observe(viewLifecycleOwner, observerReasonList)
        viewModel.liveDataProvideDisciplinary.observe(
            viewLifecycleOwner, observerProvideDisciplinaryData
        )

    }


    private val observerScanQR = Observer<ResponseStatus<ScanAPiResponse>> { responseStatus ->
        (mContext as DashboardActivity).hideProgress()

        when (responseStatus) {
            is ResponseStatus.Success -> {
                updateView(responseStatus.response)

                className = responseStatus.response.data?.get(0)?.name!!;
                admissionID = responseStatus.response.data[0]?.admissionNo!!
                studentId = responseStatus.response.data[0]!!.id!!
                studentName = responseStatus.response.data[0]!!.name!!

            }

            is ResponseStatus.Error -> {

                showErrorToast(responseStatus.responseMessage, requireContext())
            }

            is ResponseStatus.TechnicalError -> {
                showErrorToast(responseStatus.responseMessage, requireContext())

            }
        }
    }


    private val observerProvideDisciplinaryData =
        Observer<ResponseStatus<CommonResponse>> { responseStatus ->
            (mContext as DashboardActivity).hideProgress()

            when (responseStatus) {
                is ResponseStatus.Success -> {
                    if (mWhichScreen == "Class") {
                        mList.clear()
                        getWiseListForStaff(
                            mClassListDropDown.get(mSelectedPosition - 1)._id.toString()
                        )
                    } else {
                        (mContext as DashboardActivity).supportFragmentManager.popBackStack()
                    }
                }

                is ResponseStatus.Error -> {

                    showErrorToast(responseStatus.responseMessage, requireContext())
                }

                is ResponseStatus.TechnicalError -> {
                    showErrorToast(responseStatus.responseMessage, requireContext())

                }
            }
        }


    private val observerReasonList =
        Observer<ResponseStatus<GetReasonListResponse>> { responseStatus ->
            progress_circular.visibility = View.GONE

            when (responseStatus) {
                is ResponseStatus.Success -> {

                    mReasonList.clear()

                    mReasonList.add("Please Select Reason")
                    for (data in responseStatus.response.data!!) {

                        mReasonList.add(data!!.reason.toString())
                    }

                    // Create adapter and add in AutoCompleteTextView
                    val adapter = ArrayAdapter(
                        mContext, android.R.layout.simple_list_item_1, mReasonList
                    )
                    reason.setAdapter(adapter)
                    reason.setText(reason.adapter.getItem(0).toString(), false);

                }

                is ResponseStatus.Error -> {

                    showErrorToast(responseStatus.responseMessage, requireContext())
                }

                is ResponseStatus.TechnicalError -> {
                    showErrorToast(responseStatus.responseMessage, requireContext())

                }
            }
        }

    private fun updateView(it: ScanAPiResponse) {
        dataBinding.studentContainer.removeAllViews()

        dataBinding.qrImage.visibility = View.GONE
        dataBinding.qrCodeScan.visibility = View.GONE

        val itemView = LayoutInflater.from(mContext).inflate(R.layout.row_staff_discoplinary, null)


        var iv_student_image: ImageView? = null
        var tvStudentName: TextView? = null
        var tvSerialNo: TextView? = null


        iv_student_image = itemView.findViewById(R.id.iv_student_image)
        tvSerialNo = itemView.findViewById(R.id.tv_student_roll_no)
        tvStudentName = itemView.findViewById(R.id.tv_student_name)
        val redCheckBox = itemView.findViewById<CheckBox>(R.id.redCheckBox)
        val tardyCheckBox = itemView.findViewById<CheckBox>(R.id.tardyCheckBox)
        val warningCheckBox = itemView.findViewById<CheckBox>(R.id.warningCheckBox)
        progress_circular = itemView.findViewById<ProgressBar>(R.id.progressBar)
        reason = itemView.findViewById<AutoCompleteTextView>(R.id.reason)
        val housePoints = itemView.findViewById<AutoCompleteTextView>(R.id.housePoints)
        val reasonTextInput = itemView.findViewById<TextInputLayout>(R.id.reasonTextInput)
        val housingPointContainer =
            itemView.findViewById<TextInputLayout>(R.id.housingPointContainer)
        val edtReasonTextInputLayout =
            itemView.findViewById<TextInputLayout>(R.id.edtReasonTextInputLayout)
        val textContainer = itemView.findViewById<TextInputLayout>(R.id.textContainer)
        val edtReason_txt = itemView.findViewById<EditText>(R.id.edtReason_txt)
        val actionTaken = itemView.findViewById<EditText>(R.id.actionTaken)
        val bottom = itemView.findViewById<LinearLayout>(R.id.bottom)
        val issue = itemView.findViewById<TextView>(R.id.btn_continue)
        val rescan = itemView.findViewById<TextView>(R.id.btn_reScan)
        val pinkCardCountTextView = itemView.findViewById<TextView>(R.id.pinkTextView)
        val yellowCardCountTextView = itemView.findViewById<TextView>(R.id.yellowCard)
        val redCardCountTextView = itemView.findViewById<TextView>(R.id.redCard)


        val pinkHtml = "( Pink - <b>" + it.disciplinary?.warning.toString() + "</b> )"
        pinkCardCountTextView.text = Html.fromHtml(pinkHtml, Html.FROM_HTML_MODE_COMPACT)


        val yellowHtml = "( Yellow - <b>" + it.disciplinary?.tardy.toString() + "</b> )"
        yellowCardCountTextView.text = Html.fromHtml(yellowHtml, Html.FROM_HTML_MODE_COMPACT)

        val redHtml = "( Red - <b>" + it.disciplinary?.red.toString() + "</b> )"
        redCardCountTextView.text = Html.fromHtml(redHtml, Html.FROM_HTML_MODE_COMPACT)


        rescan.setOnClickListener {
            dataBinding.studentContainer.removeAllViews()
            dataBinding.qrImage.visibility = View.VISIBLE
            dataBinding.qrCodeScan.visibility = View.VISIBLE

        }
        issue.setOnClickListener {

            if (selectedReason == "" || selectedReason == "Please Select Reason") {
                showSuccessToast("Please select reason", mContext);
            } else if (edtReasonTextInputLayout.visibility == View.VISIBLE && edtReason_txt.text.toString() == "") {
                showSuccessToast("Please enter reason details", mContext);
            } else if (actionTaken.text.toString() == "") {
                showSuccessToast("Please enter Action Taken", mContext);
            } else if (house_point == "") {
                showSuccessToast("Please select total house points", mContext);
            } else {
                reason_other = edtReason_txt.text.toString()
                mActionTaken = actionTaken.text.toString()
                if (redCheckBox.isChecked) {
                    showDialog("Red", "scan")
                } else if (tardyCheckBox.isChecked) {
                    showDialog("Tardy", "scan")
                } else if (warningCheckBox.isChecked) {
                    showDialog("Warning", "scan")
                }
            }
        }

        reasonTextInput.visibility = View.GONE
        housingPointContainer.visibility = View.GONE
        edtReasonTextInputLayout.visibility = View.GONE
        textContainer.visibility = View.GONE
        bottom.visibility = View.GONE
        edtReasonTextInputLayout.visibility = View.GONE

        tvStudentName?.text = it.data?.get(0)?.name
        Glide.with(mContext).load(it.path + it.data?.get(0)?.profilePic)
            .diskCacheStrategy(DiskCacheStrategy.RESOURCE).error(R.drawable.default_image)
            .into(iv_student_image!!)

        tvSerialNo?.text = it.data?.get(0)?.admissionNo


        redCheckBox.setOnClickListener { view ->
            if ((view as CompoundButton).isChecked) {
                getReasonList("PINK")
                tardyCheckBox.isChecked = false
                warningCheckBox.isChecked = false

                reasonTextInput.visibility = View.VISIBLE
                housingPointContainer.visibility = View.VISIBLE
                textContainer.visibility = View.VISIBLE
                bottom.visibility = View.VISIBLE
                edtReasonTextInputLayout.visibility = View.GONE
                selectedCard = "RED"
            } else {
                println("Un-Checked")
                reasonTextInput.visibility = View.GONE
                housingPointContainer.visibility = View.GONE
                edtReasonTextInputLayout.visibility = View.GONE
                textContainer.visibility = View.GONE
                bottom.visibility = View.GONE

            }
        }

        tardyCheckBox.setOnClickListener { view ->
            if ((view as CompoundButton).isChecked) {
                getReasonList("YELLOW")
                redCheckBox.isChecked = false
                warningCheckBox.isChecked = false


                reasonTextInput.visibility = View.VISIBLE
                housingPointContainer.visibility = View.VISIBLE
                textContainer.visibility = View.VISIBLE
                bottom.visibility = View.VISIBLE
                edtReasonTextInputLayout.visibility = View.GONE
                selectedCard = "YELLOW"


            } else {
                println("Un-Checked")
                reasonTextInput.visibility = View.GONE
                housingPointContainer.visibility = View.GONE
                edtReasonTextInputLayout.visibility = View.GONE
                textContainer.visibility = View.GONE
                bottom.visibility = View.GONE

            }
        }

        warningCheckBox.setOnClickListener { view ->
            if ((view as CompoundButton).isChecked) {
                getReasonList("RED")
                redCheckBox.isChecked = false
                tardyCheckBox.isChecked = false

                reasonTextInput.visibility = View.VISIBLE
                housingPointContainer.visibility = View.VISIBLE
                textContainer.visibility = View.VISIBLE
                bottom.visibility = View.VISIBLE
                edtReasonTextInputLayout.visibility = View.GONE
                selectedCard = "PINK"

            } else {
                println("Un-Checked")


                reasonTextInput.visibility = View.GONE
                housingPointContainer.visibility = View.GONE
                edtReasonTextInputLayout.visibility = View.GONE
                textContainer.visibility = View.GONE
                bottom.visibility = View.GONE

            }
        }

        reason.onItemClickListener = AdapterView.OnItemClickListener { parent, view, position, id ->
            val inputMethodManager: InputMethodManager? =
                mContext.getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager?
            inputMethodManager?.hideSoftInputFromWindow(view.windowToken, 0)


            if (mReasonList[position] == "Any other reason") {
                edtReasonTextInputLayout.visibility = View.VISIBLE

            } else {
                edtReasonTextInputLayout.visibility = View.GONE

            }
            selectedReason = mReasonList[position]

        }

        val adapter = ArrayAdapter(
            mContext, android.R.layout.simple_list_item_1, housingPointArray
        )
        housePoints.setAdapter(adapter)

        housePoints.onItemClickListener =
            AdapterView.OnItemClickListener { parent, view, position, id ->
                val inputMethodManager: InputMethodManager? =
                    mContext.getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager?
                inputMethodManager?.hideSoftInputFromWindow(view.windowToken, 0)
                house_point = housingPointArray[position]

            }

        dataBinding.studentContainer.addView(itemView)


    }

    private fun getReasonList(data: String) {

        progress_circular.visibility = View.VISIBLE

        selectedReason = ""
        viewModel.callGetReasonList(mContext, Utils.getAccessToken(mContext), data);

    }

    fun showDialog(card: String, from: String) {
        val dialogBuilder = AlertDialog.Builder(mContext)
        val inflater =
            (mContext).getSystemService(Context.LAYOUT_INFLATER_SERVICE) as LayoutInflater
        val dialogView: View = inflater.inflate(R.layout.disciplinary_submit_dialog, null)
        dialogBuilder.setView(dialogView)

        val dialog = dialogBuilder.create()
        dialog.setCancelable(false)
        dialog.setCanceledOnTouchOutside(false)
        dialog.show()

        val cancel = dialogView.findViewById(R.id.close) as TextView
        val save = dialogView.findViewById(R.id.save) as TextView
        val label = dialogView.findViewById(R.id.label) as TextView

        if (from == "scan") {
            label.text = "You have issued a $card Card to $studentName"

        } else {
            label.text = "You have issued a Cards"

        }
        cancel.setOnClickListener {
            dialog.dismiss()
        }

        save.setOnClickListener {

            (mContext as DashboardActivity).showProgress()

            if (from == "scan") {
                var pink = 0;
                var yellow = 0;
                var red = 0;

                if (selectedCard.equals("PINK")) {
                    pink = 1
                } else if (selectedCard.equals("YELLOW")) {
                    yellow = 1
                } else if (selectedCard.equals("RED")) {
                    red = 1
                }

                val formatter = SimpleDateFormat("dd-MM-yyyy")
                val date = Date()

                val issuedate = formatter.format(date);
                val dataItem = DisciplinaryPostDataItem(
                    actionTaken = mActionTaken,
                    admissionNo = admissionID,
                    housePoint = house_point,
                    issueDate = issuedate,
                    pink = pink,
                    reason = selectedReason,
                    red = red,
                    studentId = studentId,
                    yellow = yellow,
                    reason_other = reason_other
                )
                val data = ArrayList<DisciplinaryPostDataItem>()
                data.add(dataItem)

                viewModel.callProvideDisciplinary(mContext, Utils.getAccessToken(mContext), data)

            } else {

                viewModel.callProvideDisciplinary(mContext, Utils.getAccessToken(mContext), mList)

            }
            dialog.dismiss()
        }
    }

    override fun selectedDate(date: String) {
        dataBinding.edtCalendar.text = date
        mList.clear()
        if (mSelectedPosition > 0) {
            getWiseListForStaff(
                mClassListDropDown.get(mSelectedPosition - 1)._id.toString()
            )
        }
    }

    override fun selectClass(classId: String) {

    }

    override fun selectHouseId(houseId: String) {

    }

    private fun showCardDialog(
        header: String, data: WiseListFromClassResponse.Data?
    ) {
        val itemView = Dialog(mContext)
        itemView.setContentView(R.layout.raw_staff_disciplinary_dialog)
        itemView.window!!.setBackgroundDrawable(
            ColorDrawable(Color.TRANSPARENT)
        )


        var selectedHeader = header;
        val window: Window = itemView.getWindow()!!

        window.setLayout(
            ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT
        )


        var iv_student_image: ImageView? = null
        var tvStudentName: TextView? = null
        var tvSerialNo: TextView? = null


        iv_student_image = itemView.findViewById(R.id.iv_student_image)
        tvSerialNo = itemView.findViewById(R.id.tv_student_roll_no)
        tvStudentName = itemView.findViewById(R.id.tv_student_name)
        val redCheckBox = itemView.findViewById<CheckBox>(R.id.redCheckBox)
        val tardyCheckBox = itemView.findViewById<CheckBox>(R.id.tardyCheckBox)
        val warningCheckBox = itemView.findViewById<CheckBox>(R.id.warningCheckBox)
        progress_circular = itemView.findViewById<ProgressBar>(R.id.progressBar)
        reason = itemView.findViewById<AutoCompleteTextView>(R.id.reason)
        val housePoints = itemView.findViewById<AutoCompleteTextView>(R.id.housePoints)
        val reasonTextInput = itemView.findViewById<TextInputLayout>(R.id.reasonTextInput)
        val housingPointContainer =
            itemView.findViewById<TextInputLayout>(R.id.housingPointContainer)
        val edtReasonTextInputLayout =
            itemView.findViewById<TextInputLayout>(R.id.edtReasonTextInputLayout)
        val textContainer = itemView.findViewById<TextInputLayout>(R.id.textContainer)
        val edtReason_txt = itemView.findViewById<EditText>(R.id.edtReason_txt)
        val actionTaken = itemView.findViewById<EditText>(R.id.actionTaken)
        val bottom = itemView.findViewById<LinearLayout>(R.id.bottom)
        val issue = itemView.findViewById<TextView>(R.id.btn_continue)
        val rescan = itemView.findViewById<TextView>(R.id.btn_reScan)

        val pinkCardCountTextView = itemView.findViewById<TextView>(R.id.pinkTextView)
        val yellowCardCountTextView = itemView.findViewById<TextView>(R.id.yellowCard)
        val redCardCountTextView = itemView.findViewById<TextView>(R.id.redCard)



        housingPointContainer.setOnClickListener {
            val inputManager = requireActivity()
                .getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
            inputManager.hideSoftInputFromWindow(
                itemView.currentFocus?.windowToken,
                InputMethodManager.HIDE_NOT_ALWAYS
            )
        }

        edtReasonTextInputLayout.setOnClickListener {
            val inputManager = requireActivity()
                .getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
            inputManager.hideSoftInputFromWindow(
                itemView.currentFocus?.windowToken,
                InputMethodManager.HIDE_NOT_ALWAYS
            )
        }

        when (selectedHeader) {
            "PINK" -> {
                warningCheckBox.isChecked = true

            }
            "YELLOW" -> {
                tardyCheckBox.isChecked = true
            }
            "RED" -> {

                redCheckBox.isChecked = true

            }
        }
        val pinkHtml = "( Pink - <b>" + data?.disciplinary?.pink.toString() + "</b> )"
        pinkCardCountTextView.text = Html.fromHtml(pinkHtml, Html.FROM_HTML_MODE_COMPACT)


        val yellowHtml = "( Yellow - <b>" + data?.disciplinary?.yellow.toString() + "</b> )"
        yellowCardCountTextView.text = Html.fromHtml(yellowHtml, Html.FROM_HTML_MODE_COMPACT)

        val redHtml = "( Red - <b>" + data?.disciplinary?.red.toString() + "</b> )"
        redCardCountTextView.text = Html.fromHtml(redHtml, Html.FROM_HTML_MODE_COMPACT)


        /*reasonTextInput.visibility = View.GONE
        housingPointContainer.visibility = View.GONE
        edtReasonTextInputLayout.visibility = View.GONE
        textContainer.visibility = View.GONE
        bottom.visibility = View.GONE
        edtReasonTextInputLayout.visibility = View.GONE*/

        tvStudentName?.text = data?.name
        Glide.with(mContext).load(imagePath + data?.profilePic)
            .diskCacheStrategy(DiskCacheStrategy.RESOURCE).error(R.drawable.default_image)
            .into(iv_student_image!!)

        tvSerialNo?.text = data?.admissionNo


        rescan.setOnClickListener {
            itemView.cancel()
            itemView.dismiss()
        }


        redCheckBox.setOnClickListener { view ->
            if ((view as CompoundButton).isChecked) {
                getReasonList("PINK")
                tardyCheckBox.isChecked = false
                warningCheckBox.isChecked = false

                reasonTextInput.visibility = View.VISIBLE
                housingPointContainer.visibility = View.VISIBLE
                textContainer.visibility = View.VISIBLE
                bottom.visibility = View.VISIBLE
                edtReasonTextInputLayout.visibility = View.GONE
                selectedCard = "RED"
            } else {
                println("Un-Checked")
                reasonTextInput.visibility = View.GONE
                housingPointContainer.visibility = View.GONE
                edtReasonTextInputLayout.visibility = View.GONE
                textContainer.visibility = View.GONE
                bottom.visibility = View.GONE

            }
        }

        tardyCheckBox.setOnClickListener { view ->
            if ((view as CompoundButton).isChecked) {
                getReasonList("YELLOW")
                redCheckBox.isChecked = false
                warningCheckBox.isChecked = false


                reasonTextInput.visibility = View.VISIBLE
                housingPointContainer.visibility = View.VISIBLE
                textContainer.visibility = View.VISIBLE
                bottom.visibility = View.VISIBLE
                edtReasonTextInputLayout.visibility = View.GONE
                selectedCard = "YELLOW"


            } else {
                println("Un-Checked")
                reasonTextInput.visibility = View.GONE
                housingPointContainer.visibility = View.GONE
                edtReasonTextInputLayout.visibility = View.GONE
                textContainer.visibility = View.GONE
                bottom.visibility = View.GONE

            }
        }

        warningCheckBox.setOnClickListener { view ->
            if ((view as CompoundButton).isChecked) {
                getReasonList("RED")
                redCheckBox.isChecked = false
                tardyCheckBox.isChecked = false

                reasonTextInput.visibility = View.VISIBLE
                housingPointContainer.visibility = View.VISIBLE
                textContainer.visibility = View.VISIBLE
                bottom.visibility = View.VISIBLE
                edtReasonTextInputLayout.visibility = View.GONE
                selectedCard = "PINK"

            } else {
                println("Un-Checked")


                reasonTextInput.visibility = View.GONE
                housingPointContainer.visibility = View.GONE
                edtReasonTextInputLayout.visibility = View.GONE
                textContainer.visibility = View.GONE
                bottom.visibility = View.GONE

            }
        }

        reason.onItemClickListener = AdapterView.OnItemClickListener { parent, view, position, id ->


            if (mReasonList[position] == "Any other reason") {
                edtReasonTextInputLayout.visibility = View.VISIBLE

            } else {
                edtReasonTextInputLayout.visibility = View.GONE

            }
            selectedReason = mReasonList[position]

        }

        reason.setOnTouchListener { p0, p1 ->

            reason.showDropDown()
            val inputManager = requireActivity()
                .getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
            inputManager.hideSoftInputFromWindow(
                itemView.currentFocus?.windowToken,
                InputMethodManager.HIDE_NOT_ALWAYS
            )
            false
        }

        val adapter = ArrayAdapter(
            mContext, android.R.layout.simple_list_item_1, housingPointArray
        )
        housePoints.setAdapter(adapter)

        housePoints.onItemClickListener =
            AdapterView.OnItemClickListener { parent, view, position, id ->


                house_point = housingPointArray[position]

            }

        housePoints.setOnTouchListener { p0, p1 ->

            housePoints.showDropDown()
            val inputManager = requireActivity()
                .getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
            inputManager.hideSoftInputFromWindow(
                itemView.currentFocus?.windowToken,
                InputMethodManager.HIDE_NOT_ALWAYS
            )
            false
        }

        getReasonList(selectedHeader)

        issue.setOnClickListener {

            if (selectedReason == "" || selectedReason == "Please Select Reason") {
                showSuccessToast("Please select reason", mContext);
            } else if (edtReasonTextInputLayout.visibility == View.VISIBLE && edtReason_txt.text.toString() == "") {
                showSuccessToast("Please enter reason details", mContext);
            } else if (actionTaken.text.toString() == "") {
                showSuccessToast("Please enter Action Taken", mContext);
            } else if (house_point == "") {
                showSuccessToast("Please select total house points", mContext);
            } else {
                reason_other = edtReason_txt.text.toString()

                mActionTaken = actionTaken.text.toString()

                if (redCheckBox.isChecked) {
                    selectedHeader = "RED";
                } else if (tardyCheckBox.isChecked) {
                    selectedHeader = "YELLOW";
                } else if (warningCheckBox.isChecked) {
                    selectedHeader = "PINK";
                }

                var pink = 0;
                var yellow = 0;
                var red = 0;

                when (selectedHeader) {
                    "PINK" -> {
                        pink = 1
                    }
                    "YELLOW" -> {
                        yellow = 1
                    }
                    "RED" -> {
                        red = 1
                    }
                }

                val dataItem = DisciplinaryPostDataItem(
                    actionTaken = mActionTaken,
                    admissionNo = data?.admissionNo,
                    housePoint = house_point,
                    issueDate = dataBinding.edtCalendar.text.toString(),
                    pink = pink,
                    reason = selectedReason,
                    red = red,
                    studentId = data?.id,
                    yellow = yellow,
                    reason_other = reason_other
                )

                mList.add(dataItem)

                itemView.dismiss()

                dataBinding.edtCalendar1.setText("")

                dataBinding.btnSave.performClick()

                getWiseListForStaff(
                    mClassListDropDown.get(mSelectedPosition - 1)._id.toString()
                )

            }
        }


        try {
            itemView.show()
        } catch (e: Exception) {

        }


    }

    override fun showDetailDialog(card: String, data: WiseListFromClassResponse.Data?) {
        showCardDialog(card, data)
    }

    override fun removeData(id: String) {
        if (mList.size > 0) {

            for (i in 0 until mList.size) {
                if (mList.get(i).admissionNo!!.equals(id)) {
                    mList.removeAt(i)
                    break
                }
            }

            disciplinaryStaffAdapter.update(mList)

        }

    }

}