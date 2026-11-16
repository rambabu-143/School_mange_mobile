package com.mountcarmelschools.ui.dashboard

import android.Manifest
import android.animation.Animator
import android.animation.AnimatorListenerAdapter
import android.annotation.SuppressLint
import android.app.Activity
import android.app.AlertDialog
import android.content.ActivityNotFoundException
import android.content.Context
import android.content.DialogInterface
import android.content.Intent
import android.content.pm.PackageManager
import android.content.res.ColorStateList
import android.graphics.*
import android.net.Uri
import android.os.*
import android.provider.MediaStore
import android.provider.Settings
import android.text.TextUtils
import android.util.Log
import android.view.*
import android.view.View.*
import android.view.inputmethod.InputMethodManager
import android.widget.*
import androidx.activity.result.contract.ActivityResultContracts
import androidx.annotation.ColorRes
import androidx.annotation.RequiresApi
import androidx.appcompat.app.ActionBarDrawerToggle
import androidx.constraintlayout.solver.widgets.Rectangle
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import androidx.core.content.FileProvider
import androidx.core.widget.ImageViewCompat
import androidx.drawerlayout.widget.DrawerLayout
import androidx.fragment.app.Fragment
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.bumptech.glide.Glide
import com.bumptech.glide.load.engine.DiskCacheStrategy
import com.google.android.gms.auth.api.signin.GoogleSignIn
import com.google.android.gms.auth.api.signin.GoogleSignInOptions
import com.google.android.gms.tasks.OnCompleteListener
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import com.google.firebase.messaging.FirebaseMessaging
import com.google.gson.Gson
import com.mistory.mistoryview.data.entity.MiStoryModel
import com.mistory.mistoryview.data.entity.MiUserStoryModel
import com.mistory.mistoryview.ui.activity.MiStoryDisplayActivity
import com.mistory.mistoryview.util.MiMediaType
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseActivity
import com.mountcarmelschools.databinding.ActivityDashboardBinding
import com.mountcarmelschools.di.data.GetStatusList
import com.mountcarmelschools.di.data.NotificationCountModel
import com.mountcarmelschools.di.data.dashboardApi.DashboardApiResponse
import com.mountcarmelschools.di.data.login.LoginResponseFromApi
import com.mountcarmelschools.di.data.setting.SwitchStudentRequest
import com.mountcarmelschools.di.data.staffDashboard.StaffDashboard
import com.mountcarmelschools.di.data.staffProfile.StaffProfileDetail
import com.mountcarmelschools.di.data.studentDetail.SingleStudentDetail
import com.mountcarmelschools.di.data.updateToken.TokenPostData
import com.mountcarmelschools.di.data.versionControl.GetVersionResponse
import com.mountcarmelschools.di.networking.RetrofitClient
import com.mountcarmelschools.ui.assessment.AssessmentFragment
import com.mountcarmelschools.ui.assignment.AssignmentFragment
import com.mountcarmelschools.ui.assignment.assignementUpdated.AssignmentUpdatedFragment
import com.mountcarmelschools.ui.attendance.termAttendance.AttendanceDayEntryFragment
import com.mountcarmelschools.ui.fees.FeeFragment
import com.mountcarmelschools.ui.holidayHomework.HolidayHomeWorkFragment
import com.mountcarmelschools.ui.home.HomeFragment
import com.mountcarmelschools.ui.idCard.IdCardFragment
import com.mountcarmelschools.ui.profile.ProfileFragment
import com.mountcarmelschools.ui.screenlock.ScreenLockDialogFragment
import com.mountcarmelschools.ui.screenlock.ScreenLockEnableDialogFragment
import com.mountcarmelschools.ui.selfAwareness.SelfAwarenessFragment
import com.mountcarmelschools.ui.setting.SettingFragment
import com.mountcarmelschools.ui.streamSelection.StreamSelectionFragment
import com.mountcarmelschools.ui.transportRenewal.TransportRenewalFragment
import com.mountcarmelschools.ui.webviewScreen.WebViewScreenFragment
import com.mountcarmelschools.ui.welcome.WelcomeActivity
import com.mountcarmelschools.utlis.*
import com.mountcarmelschools.utlis.CommonUtils.getMimeType
import com.mountcarmelschools.utlis.MountCarmelUtils.Companion.assignments
import com.mountcarmelschools.utlis.MountCarmelUtils.Companion.chronicles
import com.mountcarmelschools.utlis.MountCarmelUtils.Companion.date_sheet
import com.mountcarmelschools.utlis.MountCarmelUtils.Companion.email_group
import com.mountcarmelschools.utlis.MountCarmelUtils.Companion.fee
import com.mountcarmelschools.utlis.MountCarmelUtils.Companion.getDrawerIconsAndLabel
import com.mountcarmelschools.utlis.MountCarmelUtils.Companion.holiday_homework
import com.mountcarmelschools.utlis.MountCarmelUtils.Companion.id_Card
import com.mountcarmelschools.utlis.MountCarmelUtils.Companion.news_letter
import com.mountcarmelschools.utlis.MountCarmelUtils.Companion.privacy_policy
import com.mountcarmelschools.utlis.MountCarmelUtils.Companion.self_awareness
import com.mountcarmelschools.utlis.MountCarmelUtils.Companion.setting
import com.mountcarmelschools.utlis.MountCarmelUtils.Companion.staff_attendance
import com.mountcarmelschools.utlis.MountCarmelUtils.Companion.stream_selection
import com.mountcarmelschools.utlis.MountCarmelUtils.Companion.syllabus
import com.mountcarmelschools.utlis.MountCarmelUtils.Companion.term_attendance
import com.mountcarmelschools.utlis.MountCarmelUtils.Companion.time_table
import com.mountcarmelschools.utlis.MountCarmelUtils.Companion.transport_renewal
import com.mountcarmelschools.utlis.Utils.Companion.compressImageFile
import com.mountcarmelschools.utlis.Utils.Companion.getParentImagePath
import com.mountcarmelschools.utlis.Utils.Companion.getParentProfilePath
import com.mountcarmelschools.utlis.Utils.Companion.getStandardName
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.io.ByteArrayOutputStream
import java.io.File
import java.lang.ref.WeakReference
import java.net.URLConnection
import java.text.SimpleDateFormat
import java.util.*


/*
* created  by Dated: 19/05/2020
* */
class DashboardActivity : BaseActivity<ActivityDashboardBinding, DashboardViewModel>(),
    DashboardNavigator {

    var mStreamSelectionData: DashboardApiResponse.Stream? = null

    private lateinit var userType: String

    val mListOfStory: ArrayList<MiUserStoryModel> = ArrayList()

    public var userImage = ""
    var userName = ""
    var userAdmission = ""
    var currentYear = ""
    public var path = ""
    var switchSelectedAdmissionChild = ""
    lateinit var mSessionStartDate: String

    lateinit var mSessionEndDate: String

    var mTotalMessageCount = 0

    var mShowSelfAwareness = false;
    var mShowStreamSelection = false;
    var mShowTransportRenewal = false;
    var mShowTransportReport = false
    var mShowIdCard = false;
    var mSelfAwarenessStartDate = "";
    var mSelfAwarenessEndDate = "";
    var mStreamEndDate = "";
    var mBranchCodeForStreamSelection = "";
    var mNextSession = "";
    var tempStandardSectionId: DashboardApiResponse.Nomination.Setting.StandardSectionId? = null;


    lateinit var staffDetail: StaffProfileDetail
    lateinit var studentDetail: SingleStudentDetail
    private lateinit var image_path: String
    final var emailGroupFile: String = ""
    final var mChronicles: String = ""
    final var mNewsletter: String = ""

    private val PICK_IMAGE_GALLERY = 100
    val READ_STORAGE_PERMISSION_REQUEST = 200
    val CAMERA_PERMISSION_REQUEST = 300
    val PICK_IMAGE_CAMERA = 400
    val WRITE_STORAGE_PERMISSION_REQUEST = 500


    private val launcher =
        registerForActivityResult(ActivityResultContracts.StartActivityForResult()) {
            try {
                if (it.resultCode == Activity.RESULT_OK) {
                    val list = arrayListOf<MiUserStoryModel>()

                    it.data?.hasExtra(MiStoryDisplayActivity.MI_LIST_OF_STORY)
                        ?.let { hasMiStoryList ->
                            if (hasMiStoryList) {
                                it.data?.getParcelableArrayListExtra<MiUserStoryModel>(
                                    MiStoryDisplayActivity.MI_LIST_OF_STORY
                                )?.let { listOfUserStories ->
                                    list.addAll(listOfUserStories)
                                }
                            }
                        }


                    /*   if (!mListOfStory.containsAll(list)) {
                           storyAdapter.setUserStoryData(list)
                           mViewModel.updateListOfUser(list)
                       }*/

                }
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }


    override fun getLayoutId() = R.layout.activity_dashboard

    override fun getViewModel() = DashboardViewModel::class.java


    @SuppressLint("ClickableViewAccessibility")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        dataBinding.dashboardViewModel = viewModel
        viewModel.setNavigator(this)
        userType = Utils.getUserType(this)

        viewModel.setScreenLockManager(ScreenLockManager(WeakReference(this@DashboardActivity)))

        if (intent.extras != null && !intent.extras!!.isEmpty) {
            if (!intent.extras!!.getString("").equals("switchChild")) {
                switchSelectedAdmissionChild = intent.extras!!.getString("switchChild").toString()
            }

        }

        dataBinding.navMenu.setOnClickListener {
            //      navigation()
            dataBinding.drawerLayout.openDrawer(Gravity.LEFT)

        }
        dataBinding.drawerLayout.setOnTouchListener(handleTouch)


        if (Utils.isNetworkAvailable(this)) {
            if (Utils.isStaff(this)) {
                getStaffDashboardDetail()

            } else {
                getDashboardDetail()
            }
        } else {
            Toast.makeText(this, "No internet connection", Toast.LENGTH_SHORT).show()
            settingNavigationRecyclerView(userType)

        }




        Utils.addFragment(
            this, R.id.fl_dashboardContainer, HomeFragment(), "HomeFragment"
        )


        val actionBarDrawerToggle = object : ActionBarDrawerToggle(
            this, dataBinding.drawerLayout, R.string.open, R.string.close
        ) {
            private val scaleFactor = 6f
            override fun onDrawerSlide(
                drawerView: View, slideOffset: Float
            ) {
                super.onDrawerSlide(drawerView, slideOffset)
                val slideX = drawerView.width * slideOffset
                dataBinding.clContainer.translationX = slideX
                dataBinding.clContainer.scaleX = 1 - slideOffset / scaleFactor
                dataBinding.clContainer.scaleY = 1 - slideOffset / 10f
                if (slideOffset > 0.50) {
                    runOnUiThread {
                        dataBinding.ivSetting.visibility = View.INVISIBLE
                        dataBinding.rlLogout.visibility = View.VISIBLE
                        //    dataBinding.navMenu.visibility = View.VISIBLE
                    }
                } else {
                    runOnUiThread {
                        dataBinding.ivSetting.visibility = View.GONE
                        dataBinding.rlLogout.visibility = View.GONE
                        //     dataBinding.navMenu.visibility = View.VISIBLE

                    }
                }
            }
        }
        dataBinding.drawerLayout.setScrimColor(Color.TRANSPARENT)
//        dataBinding.drawerLayout.setDrawerElevation(0f)
        dataBinding.drawerLayout.addDrawerListener(actionBarDrawerToggle)


        dataBinding.backIcon.setOnClickListener {

            supportFragmentManager.popBackStack();

        }

        dataBinding.cvProfilePic.setOnClickListener {

            if (Utils.isParent(this)) {
                //showAlertForImageUpload()

            } else {
                Utils.replaceFragment(
                    this,
                    R.id.fl_dashboardContainer,
                    ProfileFragment.getInstance(true),
                    "ProfileFragment"
                )
            }

        }
        dataBinding.parentHeader.setOnClickListener {
            openDialog()
        }



        dataBinding.ivNotification.setOnClickListener {

            popAllFragment()

        }

        // User can be student / staff / parent
        fetchUserDetails()

        handleScreenLock()
    }

    public fun fetchUserDetails() {
        val my_date = "02/01/2023"

        val sdf = SimpleDateFormat("dd/MM/yyyy")
        val strDate: Date = sdf.parse(my_date)
        val your_date_is_outdated = Date().before(strDate)

        if (userType.equals("1") || userType.equals("2") || userType.equals("3")) {
            if (Utils.isNetworkAvailable(this)) {
                if (your_date_is_outdated) {
                    getStudentStatus(Utils.getUserId(this))
                }
                getStudentDetail()
            } else {
                Toast.makeText(getContext()!!, "No internet connection", Toast.LENGTH_SHORT).show()
            }
        } else if (userType.equals("4")) {
            if (Utils.isNetworkAvailable(this)) {
                if (your_date_is_outdated) {
                    getStaffStatus(Utils.getUserId(this))
                }
                getStaffDetail()
            } else {
                Toast.makeText(getContext()!!, "No internet connection", Toast.LENGTH_SHORT).show()
            }

        }
    }

    private fun handleScreenLock() {
        val screenLockManager = getScreenLockManager() ?: return
        if (screenLockManager.isEnabled()) {
            mayShowScreenLockDialog()
            return
        }
        val spUtils = SharedPreferenceUtils.getInstance(this@DashboardActivity)
        val showScreenLockEnablePrompt = spUtils?.getBoolanValue(SHOW_ENABLE_SCREEN_LOCK_PROMPT, true) ?: true
        if (showScreenLockEnablePrompt) {
            mayShowScreenLockEnableDialog()
        }
    }

    private fun mayShowScreenLockDialog() {
        if (!ScreenLockManager.SCREEN_LOCKED) {
            return
        }
        val screenLockDialogFragment = ScreenLockDialogFragment(WeakReference(this@DashboardActivity))
        screenLockDialogFragment.show(supportFragmentManager, "ScreenLockDialogFragment")
    }

    private fun mayShowScreenLockEnableDialog() {
        val screenLockManager = getScreenLockManager() ?: return
        screenLockManager.isAvailable(object : ScreenLockManager.AvailabilityListener {
            override fun onSuccess(type: ScreenLockManager.ScreenLockType) {
                val screenLockEnableDialogFragment = ScreenLockEnableDialogFragment(WeakReference(this@DashboardActivity))
                screenLockEnableDialogFragment.show(supportFragmentManager, "ScreenLockEnableDialogFragment")
            }
            override fun onError(error: Exception) {
                Log.d("DashboardActivity", "Screen Lock not available\nError: ${error.message}")
            }
        })
    }

    fun getScreenLockManager(): ScreenLockManager? {
        return viewModel.screenLockManager
    }

    override fun dispatchTouchEvent(ev: MotionEvent?): Boolean {
        if (currentFocus != null) {
            val imm = getSystemService(INPUT_METHOD_SERVICE) as InputMethodManager
            imm.hideSoftInputFromWindow(currentFocus!!.windowToken, 0)
        }
        return super.dispatchTouchEvent(ev)
    }

    private fun settingNavigationRecyclerView(userType: String) {
        val drawerRecyclerView =
            dataBinding.rlChild2.findViewById<RecyclerView>(R.id.recycler_navigation)

        drawerRecyclerView.layoutManager =
            GridLayoutManager(this, 2, GridLayoutManager.VERTICAL, false)

        drawerRecyclerView.setHasFixedSize(false)

        /*  when {
              userType.equals("1", false) -> {
                  if (Utils.isParent(this)) {
                      recycler_navigation.adapter =
                          DashboardNavigationAdapter(this, getDrawerIconsAndLabel(userType,"",true), this)
                  } else {

                      recycler_navigation.adapter =
                          DashboardNavigationAdapter(this, titlesForStudent, imagesForStudent, this)
                  }
              }

              userType.equals("2", false) -> {

                  if (Utils.isParent(this)) {
                      recycler_navigation.adapter =
                          DashboardNavigationAdapter(this, titlesForParents, imagesForParent, this)
                  } else {
                      recycler_navigation.adapter =
                          DashboardNavigationAdapter(this, titlesForStudent, imagesFor12Student, this)
                  }
              }

              userType.equals("3", false) -> {


                  recycler_navigation.adapter =
                      DashboardNavigationAdapter(this, titlesForParents, imagesForParent, this)
              }

              userType.equals("4", false) -> {
                  dataBinding.tvEmployeeCode.visibility = View.VISIBLE
                  recycler_navigation.adapter =
                      DashboardNavigationAdapter(this, titlesForStaff, imagesForStaff, this)
              }
          }*/

        drawerRecyclerView.adapter =
            DashboardNavigationAdapter(
                this, getDrawerIconsAndLabel(
                    userType,
                    getStandardName(this), Utils.isParent(this),
                    mShowSelfAwareness, mShowStreamSelection,
                    mShowTransportRenewal,
                    mShowIdCard
                ), this
            )


        if (userType != "1") {

            dataBinding.recyclerViewBackground.setBackgroundColor(
                ContextCompat.getColor(
                    this, R.color.staffBackground
                )
            )

            dataBinding.parent.setBackgroundColor(
                ContextCompat.getColor(
                    this, R.color.staffBackground
                )
            )

            dataBinding.tvClass.setTextColor(ContextCompat.getColor(this, R.color.black))

            dataBinding.tvUserName.setTextColor(ContextCompat.getColor(this, R.color.black))

            dataBinding.tvEmployeeCode.setTextColor(ContextCompat.getColor(this, R.color.black))

            dataBinding.ivSetting.setTint(R.color.black)
        } else {
            dataBinding.recyclerViewBackground.setBackgroundResource(R.drawable.screen_background)
        }

    }

    fun ImageView.setTint(@ColorRes colorRes: Int) {
        ImageViewCompat.setImageTintList(
            this, ColorStateList.valueOf(ContextCompat.getColor(context, colorRes))
        )
    }

    public fun showParentHeader(value: Boolean) {

        if (value) {
            dataBinding.parentHeader.visibility = VISIBLE
        } else {
            dataBinding.parentHeader.visibility = GONE

        }
    }

    fun hideViewForHome() {
        dataBinding.view.visibility = View.GONE

    }

    fun setHeaderText(text: String?) {
        if (text != null) {
            dataBinding.tvHeader.text = text
            dataBinding.tvHeader.visibility = View.VISIBLE
            dataBinding.view.visibility = View.VISIBLE
            dataBinding.drawerLayout.setDrawerLockMode(DrawerLayout.LOCK_MODE_LOCKED_CLOSED)
        }


        val f: Fragment =
            supportFragmentManager.findFragmentById(R.id.fl_dashboardContainer) as Fragment
        if (f is HomeFragment && f.isVisible) {
            dataBinding.backIcon.visibility = View.GONE
            dataBinding.view.visibility = View.GONE

            if (Utils.isParent(this) || Utils.isStaff(this)) {

                showParentHeader(true)

            }

        } else {
            if (!text.equals("")) {
                dataBinding.backIcon.visibility = View.VISIBLE
            }
            showParentHeader(false)
        }

    }

    fun navigation() {
        val actionBarDrawerToggle = object : ActionBarDrawerToggle(
            this, dataBinding.drawerLayout, R.string.open, R.string.close
        ) {
            private val scaleFactor = 6f
            override fun onDrawerSlide(
                drawerView: View, slideOffset: Float
            ) {
                super.onDrawerSlide(drawerView, slideOffset)
                val slideX = drawerView.width * slideOffset
                dataBinding.clContainer.translationX = slideX
                dataBinding.clContainer.scaleX = 1 - slideOffset / scaleFactor
                dataBinding.clContainer.scaleY = 1 - slideOffset / 10f
                if (slideOffset > 0) {
                    runOnUiThread {
                        dataBinding.ivSetting.visibility = View.VISIBLE
                        dataBinding.rlLogout.visibility = View.VISIBLE
                    }
                } else {
                    runOnUiThread {
                        dataBinding.ivSetting.visibility = View.GONE
                        dataBinding.rlLogout.visibility = View.GONE
                    }
                }
            }
        }
        dataBinding.drawerLayout.setScrimColor(Color.TRANSPARENT)
//        dataBinding.drawerLayout.setDrawerElevation(0f)
        dataBinding.drawerLayout.addDrawerListener(actionBarDrawerToggle)
    }

    override fun onBackPressed() {
        super.onBackPressed()
    }


    @SuppressLint("ClickableViewAccessibility", "WrongConstant")
    private val handleTouch = OnTouchListener { v, event ->
        val x = event.x.toInt()
        val y = event.y.toInt()
        val rect = Rectangle() //use your points co-ordinates
        val rect1 = Rectangle() //use your points co-ordinates
        rect.setBounds(
            dataBinding.ivSetting.x.toInt(),
            dataBinding.ivSetting.y.toInt(),
            dataBinding.ivSetting.width,
            dataBinding.ivSetting.height
        )
        rect1.setBounds(
            dataBinding.rlLogout.x.toInt(),
            dataBinding.rlLogout.y.toInt(),
            dataBinding.rlLogout.width,
            dataBinding.rlLogout.height
        )
        if (rect.contains(x, y) && dataBinding.ivSetting.visibility == View.VISIBLE) {

            val f: Fragment =
                supportFragmentManager.findFragmentById(R.id.fl_dashboardContainer) as Fragment
            if (f is SettingFragment && f.isVisible) {
                dataBinding.drawerLayout.closeDrawer(Gravity.START)

            } else {
                // add your code here
                Utils.replaceFragment(
                    this, R.id.fl_dashboardContainer, SettingFragment(), "SettingFragment"
                )

            }


        } else if (rect1.contains(x, y)) {

            val intent = Intent(this@DashboardActivity, WelcomeActivity::class.java)
            intent.flags =
                Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
            SharedPreferenceUtils.getInstance(this@DashboardActivity)?.clear()
            startActivity(intent)
            finish()


        } else {
            dataBinding.drawerLayout.closeDrawer(Gravity.START)
        }



        true
    }

    @SuppressLint("WrongConstant")
    override fun itemClick(position: Int, name: String) {

        dataBinding.drawerLayout.closeDrawer(Gravity.START)



        when (name) {

            assignments -> {
                val fragment = AssignmentUpdatedFragment()

                val bundle = Bundle()
                bundle.putString("from", "Assignments")

                fragment.arguments = bundle


                Utils.replaceFragment(
                    this, R.id.fl_dashboardContainer, fragment, "AssignmentFragment"
                )

            }
            syllabus -> {
                val bundle = Bundle()
                bundle.putString("from", "Syllabus")

                val fragment = AssignmentFragment()
                fragment.arguments = bundle
                Utils.replaceFragment(
                    this, R.id.fl_dashboardContainer, fragment, "AssignmentFragment"
                )

            }
            date_sheet -> {

                val fragment = AssessmentFragment()

                val bundle1 = Bundle()
                bundle1.putString("from", "Date Sheet")

                fragment.arguments = bundle1

                Utils.replaceFragment(
                    this, R.id.fl_dashboardContainer, fragment, "AssessmentFragment"
                )
            }
            holiday_homework -> {
                Utils.replaceFragment(
                    this,
                    R.id.fl_dashboardContainer,
                    HolidayHomeWorkFragment(),
                    "HolidayHomeWorkFragment"
                )
            }
            fee -> {
                Utils.replaceFragment(
                    this, R.id.fl_dashboardContainer, FeeFragment(), "FeeFragment"
                )
            }
            self_awareness -> {
                Utils.replaceFragment(
                    this,
                    R.id.fl_dashboardContainer,
                    SelfAwarenessFragment(),
                    "SelfAwarenessFragment"
                )
            }
            setting -> {
                Utils.replaceFragment(
                    this, R.id.fl_dashboardContainer, SettingFragment(), "SettingFragment"
                )
            }
            privacy_policy -> {
                val fragment = WebViewScreenFragment.newInstance(
                    "Privacy Policy",
                    "https://mountcarmelschool.com/privacy-policy/"
                )
                Utils.replaceFragment(
                    this, R.id.fl_dashboardContainer, fragment, "WebViewScreenFragment"
                ) 
            }

            staff_attendance -> {
            }

            email_group -> {


                if (!emailGroupFile.equals("")) {
                    try {
                        try {
                            Utils.openPdf("Email Group", emailGroupFile, this)

                        } catch (e: ActivityNotFoundException) {
                            val uri = Uri.parse(emailGroupFile)
                            // Chrome is probably not installed
                            // OR not selected as default browser OR if no Browser is selected as default browser
                            val i = Intent(Intent.ACTION_VIEW, uri)
                            i.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                            startActivity(i)
                        }
                    } catch (ex: Exception) {

                    }
                } else {
                    getEmailGroup()
                }

            }

            time_table -> {
            }

            stream_selection -> {
                Utils.replaceFragment(
                    this,
                    R.id.fl_dashboardContainer,
                    StreamSelectionFragment(),
                    "StreamSelectionFragment"
                )
            }

            transport_renewal -> {
                Utils.replaceFragment(
                    this,
                    R.id.fl_dashboardContainer,
                    TransportRenewalFragment(),
                    "TransportRenewalFragment"
                )
            }
            term_attendance -> {
                Utils.replaceFragment(
                    this,
                    R.id.fl_dashboardContainer,
                    AttendanceDayEntryFragment(),
                    "AttendanceDayEntryFragment"
                )
            }
            chronicles -> {
                if(mChronicles!="") {
                    val bundle = Bundle()
                    bundle.putString("from", "Chronicles")
                    bundle.putString("data", mChronicles)

                    val fragment = AssessmentFragment()
                    fragment.arguments = bundle
                    Utils.replaceFragment(
                        this, R.id.fl_dashboardContainer, fragment, "AssessmentFragment"
                    )
                } else {
                    Toast.makeText(this, "Chronicles data not found", Toast.LENGTH_SHORT).show()
                }
            }
            id_Card -> {
                Utils.replaceFragment(
                    this,
                    R.id.fl_dashboardContainer,
                    IdCardFragment(),
                    "AttendanceDayEntryFragment"
                )
            }
            news_letter -> {


                if (mNewsletter!="") {
                    val bundle = Bundle()
                    bundle.putString("from", "NewsLetter")
                    bundle.putString("data", mNewsletter)

                    val fragment = AssessmentFragment()
                    fragment.arguments = bundle
                    Utils.replaceFragment(
                        this, R.id.fl_dashboardContainer, fragment, "AssessmentFragment"
                    )

                } else {
                    Toast.makeText(this, "NewsLetter data not found", Toast.LENGTH_SHORT).show()
                }
            }


        }
        /* when (position) {
             0 -> {
                 if (userType.equals("4")) {


 //                    Utils.replaceFragment(
 //                        this,
 //                        R.id.fl_dashboardContainer,
 //                        TimeTableFragment(),
 //                        "TimeTableFragment"
 //                    )


                 } else {

                     val fragment = AssignmentUpdatedFragment()

                     val bundle = Bundle()
                     bundle.putString("from", "Assignments")

                     fragment.arguments = bundle


                     Utils.replaceFragment(
                         this, R.id.fl_dashboardContainer, fragment, "AssignmentFragment"
                     )


                 }

             }

             1 -> {
                 if (userType.equals("4")) {

                     if (!emailGroupFile.equals("")) {
                         try {
                             try {
                                 *//*val uri = Uri.parse("googlechrome://navigate?url=" + emailGroupFile)
                                val i = Intent(Intent.ACTION_VIEW, uri)
                                i.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                                startActivity(i)*//*

                                Utils.openPdf("Email Group", emailGroupFile, this)

                            } catch (e: ActivityNotFoundException) {
                                val uri = Uri.parse(emailGroupFile)
                                // Chrome is probably not installed
                                // OR not selected as default browser OR if no Browser is selected as default browser
                                val i = Intent(Intent.ACTION_VIEW, uri)
                                i.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                                startActivity(i)
                            }
                        } catch (ex: Exception) {

                        }
                    } else {
                        getEmailGroup()
                    }


                } else {
                    val bundle = Bundle()
                    bundle.putString("from", "Syllabus")

                    val fragment = AssignmentFragment()
                    fragment.arguments = bundle
                    Utils.replaceFragment(
                        this, R.id.fl_dashboardContainer, fragment, "AssignmentFragment"
                    )
                }
            }

            2 -> {

                if (userType.equals("4")) {
                    Utils.replaceFragment(
                        this, R.id.fl_dashboardContainer, SettingFragment(), "SettingFragment"
                    )

                } else {

                    val fragment = AssessmentFragment()

                    val bundle1 = Bundle()
                    bundle1.putString("from", "Date Sheet")

                    fragment.arguments = bundle1

                    Utils.replaceFragment(
                        this, R.id.fl_dashboardContainer, fragment, "AssessmentFragment"
                    )
                }
            }
            3 -> {
                if (userType.equals("4")) {


                } else {

                    Utils.replaceFragment(
                        this,
                        R.id.fl_dashboardContainer,
                        HolidayHomeWorkFragment(),
                        "HolidayHomeWorkFragment"
                    )

                }
            }

            4 -> {

                if (userType.equals("4")) {
                    Utils.replaceFragment(
                        this, R.id.fl_dashboardContainer, AttendanceFragment(), "HomeViewModel"
                    )
                } else {

                    Utils.replaceFragment(
                        this, R.id.fl_dashboardContainer, FeeFragment(), "HomeViewModel"
                    )

                }
            }

            5 -> {
                if (userType.equals("4")) {
                    Utils.replaceFragment(
                        this,
                        R.id.fl_dashboardContainer,
                        AttendanceSummaryFragment(),
                        "AttendanceSummaryFragment"
                    )
                } else {

                    Utils.replaceFragment(
                        this,
                        R.id.fl_dashboardContainer,
                        SelfAwarenessFragment(),
                        "SelfAwarenessFragment"
                    )


                }
            }
            6 -> {
                if (userType.equals("4")) {
                    Utils.replaceFragment(
                        this,
                        R.id.fl_dashboardContainer,
                        AttendanceDayEntryFragment(),
                        "AttendanceDayEntryFragment"
                    )
                } else {
                    Utils.replaceFragment(
                        this, R.id.fl_dashboardContainer, SettingFragment(), "SettingFragment"
                    )

                }
            }
        }*/


    }

    override fun logoutDialog(view: View) {
        val dialogBuilder = AlertDialog.Builder(view.context)
        val inflater =
            (view.context).getSystemService(Context.LAYOUT_INFLATER_SERVICE) as LayoutInflater
        val dialogView: View = inflater.inflate(R.layout.logout_dialog, null)
        dialogBuilder.setView(dialogView)

        val dialog = dialogBuilder.create()
        dialog.setCancelable(false)
        dialog.setCanceledOnTouchOutside(false)
        dialog.show()

        val cancel = dialogView.findViewById(R.id.btn_cancel) as TextView
        val logout = dialogView.findViewById(R.id.btn_continue) as TextView

        cancel.setOnClickListener {
            dialog.dismiss()
        }

        logout.setOnClickListener {

            val gso = GoogleSignInOptions.Builder(GoogleSignInOptions.DEFAULT_SIGN_IN).build()
            val googleSignInClient = GoogleSignIn.getClient(this, gso)
            googleSignInClient.signOut()

            dialog.dismiss()
            val intent = Intent(this@DashboardActivity, WelcomeActivity::class.java)
            intent.flags =
                Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
            SharedPreferenceUtils.getInstance(this@DashboardActivity)?.clear()
            startActivity(intent)
            finish()
        }
    }

    override fun getContext(): Context? {
        return this;
    }

    override fun onError(message: String) {

        hideProgress();
        if (message.equals("Session Expired, Please login Again")) {

            val gso = GoogleSignInOptions.Builder(GoogleSignInOptions.DEFAULT_SIGN_IN).build()
            val googleSignInClient = GoogleSignIn.getClient(this, gso)
            googleSignInClient.signOut()

            val intent = Intent(this@DashboardActivity, WelcomeActivity::class.java)
            intent.flags =
                Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
            SharedPreferenceUtils.getInstance(this@DashboardActivity)?.clear()
            startActivity(intent)
            finish()
        } else {
            Toast.makeText(this@DashboardActivity, message, Toast.LENGTH_SHORT).show()
        }
    }


    fun popAllFragment() {
        for (a in 1..supportFragmentManager.backStackEntryCount) {

            supportFragmentManager.popBackStack()
        }
    }


    public fun getStaffDetail() {
        showProgress()
        viewModel.getStaffDetail(
            Utils.getAccessToken(this), Utils.getUserId(this)

        ).observe(this,

            androidx.lifecycle.Observer {

                hideProgress()

                if (it.status!!) {

                    staffDetail = it


                    dataBinding.tvUserName.text = staffDetail.data?.name


                    userName = staffDetail.data?.name.toString()

                    dataBinding.tvClass.text = staffDetail.data?.mobile


                    userImage = staffDetail.path + "/" + staffDetail.data?.profilePic


                    if (Utils.getSelectedBranch(this).equals("")) {
                        SharedPreferenceUtils.getInstance(this)?.setStringValue(
                            CURRENT_BRANCH, staffDetail.data!!.branchCode
                        )
                    }

                    for (data in staffDetail.data!!.years!!) {
                        if (staffDetail.data!!.defaultYearSession == data!!.yearSession) {
                            val branchList = Gson().toJson(data.schools)
                            SharedPreferenceUtils.getInstance(this)?.setStringValue(
                                BRANCH_DATA_FOR_STAFF, branchList
                            )
                        }

                    }




                    Glide.with(this).load(userImage).diskCacheStrategy(DiskCacheStrategy.RESOURCE)
                        .error(R.drawable.default_image).into(dataBinding.cvProfilePic)

                    updateUserProfile(userImage)



                    Log.e(
                        "path",
                        "" + getParentProfilePath(this) + "-------------" + getParentImagePath(
                            this
                        )
                    )
                    Glide.with(this)
                        .load(getParentProfilePath(this) + "/" + getParentImagePath(this))
                        .diskCacheStrategy(DiskCacheStrategy.RESOURCE)
                        .error(R.drawable.default_image).into(dataBinding.studentImage)

                    dataBinding.studentName.text = Utils.getUserName(this)


                    /*    var years = currentYear.split("-")

                        mSessionStartDate = "01-04-" + years[0].toString()


                        mSessionEndDate = "31-03-" + (years[0].toInt().plus(1)).toString()

        */
                    currentYear = Utils.getYearSession(this)

                    val years = currentYear.split("-")

                    mSessionStartDate = "01-04-" + years[0].toString()


                    mSessionEndDate = "31-03-" + (years[0].toInt().plus(1)).toString()

                    getEmailGroup()

                    FirebaseMessaging.getInstance().token.addOnCompleteListener(OnCompleteListener { task ->
                        if (!task.isSuccessful) {
                            Log.w(
                                "TAG", "Fetching FCM registration token failed", task.exception
                            )
                            return@OnCompleteListener
                        }

                        // Get new FCM registration token
                        val token = task.result
                        updateStaffToken(token)

                    })


                } else {
                    hideProgress()
                    showErrorToast(it.message!!)
                }
            }

        )


    }


    @SuppressLint("SetTextI18n")
    public fun getStudentDetail() {

        showProgress()

        viewModel.getStudentDetail(
            Utils.getAccessToken(this), Utils.getUserId(this)

        ).observe(this, androidx.lifecycle.Observer {

            hideProgress()

            studentDetail = it

            val f: Fragment =
                supportFragmentManager.findFragmentById(R.id.fl_dashboardContainer) as Fragment
            if (f is FeeFragment && f.isVisible) {
                f.updateViewForParent()
            }

            userImage = studentDetail.path + studentDetail.data?.profilePic.toString()


            if (Utils.isParent(this) || Utils.isStaff(this)) {
                dataBinding.tvUserName.text = Utils.getUserName(this)

                dataBinding.tvClass.text = Utils.getMobileNumber(this)


                if (Utils.isParent(this)) {
                    Glide.with(this)
                        .load(getParentProfilePath(this) + "/" + getParentImagePath(this))
                        .diskCacheStrategy(DiskCacheStrategy.RESOURCE)
                        .error(R.drawable.parent_default_image).into(dataBinding.cvProfilePic)

                } else {

                    Glide.with(this)
                        .load(getParentProfilePath(this) + "/" + getParentImagePath(this))
                        .diskCacheStrategy(DiskCacheStrategy.RESOURCE)
                        .error(R.drawable.default_image).into(dataBinding.cvProfilePic)

                }


                SharedPreferenceUtils.getInstance(this)?.setStringValue(
                    DATE_OF_ADMISSION, Utils.getDateFromTimeStamp(
                        studentDetail.data?.dateOfAdmission.toString()
                    )
                )


            } else {
                dataBinding.tvUserName.text = studentDetail.data?.name
                dataBinding.tvClass.text =
                    studentDetail.data?.standardId!!.name + " " + studentDetail.data?.section
//                        val admissionDate =  Utils.formattedDateFromString(
//                                "",
//                                "dd-MM-yyyy",
//                                studentDetail.data?.dateOfAdmission
//                        )
                SharedPreferenceUtils.getInstance(this)?.setStringValue(
                    DATE_OF_ADMISSION, Utils.getDateFromTimeStamp(
                        studentDetail.data?.dateOfAdmission.toString()
                    )
                )

                Log.d("TTAAAG", "getStudentDetail: " + studentDetail.data?.dateOfAdmission)
                Glide.with(this).load(userImage).diskCacheStrategy(DiskCacheStrategy.RESOURCE)
                    .error(R.drawable.default_image).into(dataBinding.cvProfilePic)

            }
            dataBinding.studentName.text = studentDetail.data?.name


            userName = studentDetail.data?.name.toString()
            userAdmission = studentDetail.data?.admissionNo.toString()

            currentYear = studentDetail.data?.yearSession.toString();

            val years = currentYear.split("-")

            mSessionStartDate = "01-04-" + years[0].toString()


            mSessionEndDate = "31-03-" + (years[0].toInt().plus(1)).toString()

//                    (years[0].toInt().plus(1)).toString()


            Glide.with(this).load(userImage).diskCacheStrategy(DiskCacheStrategy.RESOURCE)
                .error(R.drawable.default_image).into(dataBinding.studentImage)





            updateUserProfile(userImage)


            FirebaseMessaging.getInstance().token.addOnCompleteListener(OnCompleteListener { task ->
                if (!task.isSuccessful) {
                    Log.w("TAG", "Fetching FCM registration token failed", task.exception)
                    return@OnCompleteListener
                }

                // Get new FCM registration token
                val token = task.result
                updateStudentToken(token)

            })

        })


    }

    private fun updateUserProfile(imagePath: String) {
        val f: Fragment =
            supportFragmentManager.findFragmentById(R.id.fl_dashboardContainer) as Fragment
        if (f is HomeFragment && f.isVisible) {
            f.updateProfile(imagePath)
        }

    }

    fun updateStudentToken(token: String) {

        var data = TokenPostData(token)

        viewModel.updateToken(
            Utils.getAccessToken(this), Utils.getUserId(this), data
        ).observe(this, androidx.lifecycle.Observer {})


    }


    fun updateStaffToken(token: String) {

        val data = TokenPostData(token)

        viewModel.updateStaffToken(
            Utils.getAccessToken(this), Utils.getUserId(this), data
        ).observe(this, androidx.lifecycle.Observer {})


    }

    fun getEmailGroup() {


        viewModel.getEmailGroup(
            Utils.getAccessToken(this)
        ).observe(this, androidx.lifecycle.Observer {

            emailGroupFile = it.data!!.emailGroupFile!!
        })


    }


    public fun showProgress() {

        dataBinding.progressBar.visibility = VISIBLE

        getWindow().setFlags(
            WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE,
            WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE
        );

    }

    public fun hideProgress() {

        dataBinding.progressBar.visibility = GONE

        window.clearFlags(WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE);

    }

    @SuppressLint("InflateParams")
    private fun openDialog() {
        val dialogBuilder = AlertDialog.Builder(this)
        val inflater = this.layoutInflater
        val dialogView: View = inflater.inflate(R.layout.student_dialog, null)
        dialogBuilder.setView(dialogView)


        val layoutContainer = dialogView.findViewById(R.id.layoutContainer) as LinearLayout


        val close = dialogView.findViewById(R.id.close) as ImageView


        val list = Gson().fromJson(
            Utils.getAllStudentDetail(this), Array<LoginResponseFromApi.User.Student>::class.java
        ).toList().toMutableList()

        if (Utils.isStaff(this) && SharedPreferenceUtils.getInstance(this)!!
                .getStringValue(USER_TYPE, "") != "4"

        ) {
            val newValue = LoginResponseFromApi.User.Student(
                "", LoginResponseFromApi.User.Student.StudentId(
                    null,
                    Utils.getStaffEmail(this),
                    null,
                    Utils.getUserName(this),
                    getParentProfilePath(this) + "/" + getParentImagePath(this),
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null
                ), ""
            )

            list.add(0, newValue)
        }
        val dialog = dialogBuilder.create()
        dialog.setCancelable(false)
        dialog.setCanceledOnTouchOutside(false)

        if (window.decorView.isShown) {

            //Show Your Progress Dialog
            if (list.size > 0) {
                dialog?.show()
            }

        }
//        val window: Window = b.getWindow()!!
//
//        window.setLayout(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT)


        for ((index, value) in list.withIndex()) {

            val content = LayoutInflater.from(applicationContext)
                .inflate(R.layout.student_dialog_inflator, null)

            val parentLayout = content.findViewById<ConstraintLayout>(R.id.parentLayout)
            val studentName = content.findViewById<TextView>(R.id.studentName)
            val studentImage = content.findViewById<ImageView>(R.id.studentImage)


            parentLayout.setOnClickListener {

                val switchStudent: SwitchStudentRequest

                if (Utils.isParent(this)) {

                    switchStudent = SwitchStudentRequest(
                        value.studentId!!.email!!, "android", value.studentId.admissionNo!!
                    )

                } else {
                    switchStudent = SwitchStudentRequest(
                        value.studentId!!.email!!, "android", value.studentId.admissionNo!!
                    )
                }

                showProgress()

                viewModel.switchUser(
                    Utils.getAccessToken(this), switchStudent
                ).observe(
                    this
                ) {


                    hideProgress()

                    runOnUiThread {
                        dialog.dismiss()
                        dialog.cancel()
                    }

                    val intent = Intent(this, DashboardActivity::class.java)
                    intent.putExtra("switchChild", value.studentId.admissionNo)
                    startActivity(intent)
                    finish();
                }


            }

            studentName.text = value.studentId!!.name
            var profile_pic = value.studentId.studentImg
            if (TextUtils.isEmpty(profile_pic)) profile_pic = value.studentId.profilePic
            else if (!profile_pic!!.contains("http")) profile_pic = value.studentId.profilePic
            Glide.with(this).load(profile_pic).diskCacheStrategy(DiskCacheStrategy.RESOURCE)
                .error(R.drawable.default_image).into(studentImage)
            layoutContainer.addView(content)

        }

        close.setOnClickListener {

            dialog.dismiss()
            dialog.cancel()
        }

    }

    fun showAlertForImageUpload() {
        val alertDialogBuilder: MaterialAlertDialogBuilder = MaterialAlertDialogBuilder(
            this, R.style.ThemeOverlay_MaterialComponents_MaterialAlertDialog_Centered
        ).setTitle("Alert").setMessage("Please Select the option for upload the image")
            .setNegativeButton("Gallery", DialogInterface.OnClickListener { dialog, which ->

                if (PermissionUtils.hasPermission(
                        this, Manifest.permission.READ_EXTERNAL_STORAGE
                    )
                ) {
                    val galleryIntent = Intent()
                    galleryIntent.type = "image/*"
                    galleryIntent.action = Intent.ACTION_GET_CONTENT
                    startActivityForResult(
                        Intent.createChooser(
                            galleryIntent, "select picture"
                        ), PICK_IMAGE_GALLERY
                    )
                } else {
                    PermissionUtils.requestPermissions(
                        this,
                        arrayOf(Manifest.permission.READ_EXTERNAL_STORAGE),
                        READ_STORAGE_PERMISSION_REQUEST
                    )
                }
                dialog.dismiss()

            }).setPositiveButton("Camera",  /* listener = */
                DialogInterface.OnClickListener {

                        dialog, which ->
                    dialog.dismiss()
                    if (PermissionUtils.hasPermission(
                            this, Manifest.permission.CAMERA
                        ) && PermissionUtils.hasPermission(
                            this, Manifest.permission.WRITE_EXTERNAL_STORAGE
                        )
                    ) {
                        val capturePic = Intent(MediaStore.ACTION_IMAGE_CAPTURE)
                        val f = File(
                            Environment.getExternalStorageDirectory(),
                            System.currentTimeMillis().toString() + "IMAGE.jpg"
                        )
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                            val uriForFile = FileProvider.getUriForFile(
                                this,
                                "com.mountcarmelschools.com.carmel.mountschool.fileprovider",
                                f
                            )
                            capturePic.putExtra(MediaStore.EXTRA_OUTPUT, uriForFile)
                            capturePic.addFlags(
                                Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_WRITE_URI_PERMISSION
                            )
                        } else {
                            capturePic.putExtra(
                                MediaStore.EXTRA_OUTPUT, Uri.fromFile(f)
                            )
                        }
                        image_path = f.absolutePath
                        startActivityForResult(capturePic, PICK_IMAGE_CAMERA)
                    } else if (!PermissionUtils.hasPermission(
                            this, Manifest.permission.CAMERA
                        ) || !PermissionUtils.hasPermission(
                            this, Manifest.permission.WRITE_EXTERNAL_STORAGE
                        )
                    ) PermissionUtils.requestPermissions(
                        this, arrayOf(
                            Manifest.permission.CAMERA, Manifest.permission.WRITE_EXTERNAL_STORAGE
                        ), CAMERA_PERMISSION_REQUEST
                    )

                })


        alertDialogBuilder.show()
    }

    @RequiresApi(Build.VERSION_CODES.KITKAT)
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        when (requestCode) {
            PICK_IMAGE_CAMERA -> if (resultCode == RESULT_OK) {
                val bitmap: Bitmap? = Utils.getBitmap(image_path, this)
                val stream = ByteArrayOutputStream()
                bitmap?.compress(Bitmap.CompressFormat.JPEG, 60, stream)
                updateImage(bitmap)
            } else {
                Log.e("", "")
            }
            PICK_IMAGE_GALLERY -> if (resultCode == RESULT_OK) {
                image_path = CommonUtils.getPath(this, data!!.data)

                try {
                    val bitmap1: Bitmap? = Utils.getBitmap(image_path, this)

                    val stream1 = ByteArrayOutputStream()
                    bitmap1?.compress(Bitmap.CompressFormat.JPEG, 60, stream1)
                    updateImage(bitmap1)
                } catch (e: Exception) {
                    Log.i("DEBUG", "Exception: " + e.message)
                }
            }
        }

    }

    private fun updateImage(bitmap: Bitmap?) {

        Glide.with(this).load(bitmap).diskCacheStrategy(DiskCacheStrategy.RESOURCE)
            .error(R.drawable.default_image).into(dataBinding.cvProfilePic)


        var file = File(image_path)
        var res = compressImageFile(image_path, false, Uri.fromFile(file))
        if (!TextUtils.isEmpty(res)) {
            uploadImageProfile(getMimeType(Uri.fromFile(file), this), file)

        } else {

            showErrorToast("Something wents wrong")

        }
    }

    fun uploadImageProfile(mimeType: String, file: File) {

        showProgress()

        viewModel.uploadProfile(Utils.getAccessToken(this), mimeType, file).observe(

            this, androidx.lifecycle.Observer {

                hideProgress()


                SharedPreferenceUtils.getInstance(this)?.setValue(PARENT_IMAGE_PATH, it.fileName)

                showSuccessToast(it.message!!)

            })

    }

    override fun onRequestPermissionsResult(
        requestCode: Int, permissions: Array<out String>, grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)

        when (requestCode) {
            CAMERA_PERMISSION_REQUEST -> if (grantResults.size > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                if (PermissionUtils.hasPermission(
                        this, Manifest.permission.WRITE_EXTERNAL_STORAGE
                    )
                ) {
                    // mProfileViewModel.openSelectImageGalleryDialog();
                    val capturePic = Intent(MediaStore.ACTION_IMAGE_CAPTURE)
                    val f = File(
                        Environment.getExternalStorageDirectory(),
                        System.currentTimeMillis().toString() + "IMAGE.jpg"
                    )
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                        val uriForFile = FileProvider.getUriForFile(
                            this, "com.mountcarmelschools.com.carmel.mountschool.fileprovider", f
                        )
                        capturePic.putExtra(MediaStore.EXTRA_OUTPUT, uriForFile)
                        capturePic.addFlags(
                            Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_WRITE_URI_PERMISSION
                        )
                    } else {
                        capturePic.putExtra(MediaStore.EXTRA_OUTPUT, Uri.fromFile(f))
                    }
                    image_path = f.absolutePath
                    startActivityForResult(capturePic, PICK_IMAGE_CAMERA)
                } else {
                    if (!ActivityCompat.shouldShowRequestPermissionRationale(
                            this, Manifest.permission.WRITE_EXTERNAL_STORAGE
                        )
                    ) {
                        showPermissionAlertDialog()
                    }
                }
            } else {
                if (!ActivityCompat.shouldShowRequestPermissionRationale(
                        this, Manifest.permission.CAMERA
                    )
                ) {
                    showPermissionAlertDialog()
                }
            }
            WRITE_STORAGE_PERMISSION_REQUEST -> if (grantResults.size > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                // mProfileViewModel.openSelectImageGalleryDialog();
                val capturePic = Intent(MediaStore.ACTION_IMAGE_CAPTURE)
                val f = File(
                    Environment.getExternalStorageDirectory(),
                    System.currentTimeMillis().toString() + "IMAGE.jpg"
                )
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    val uriForFile = FileProvider.getUriForFile(
                        this, "com.mountcarmelschools.com.carmel.mountschool.fileprovider", f
                    )
                    capturePic.putExtra(MediaStore.EXTRA_OUTPUT, uriForFile)
                    capturePic.addFlags(
                        Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_WRITE_URI_PERMISSION
                    )
                } else {
                    capturePic.putExtra(MediaStore.EXTRA_OUTPUT, Uri.fromFile(f))
                }
                image_path = f.absolutePath
                startActivityForResult(capturePic, PICK_IMAGE_CAMERA)
            } else {
                if (!ActivityCompat.shouldShowRequestPermissionRationale(
                        this, Manifest.permission.WRITE_EXTERNAL_STORAGE
                    )
                ) {
                    showPermissionAlertDialog()
                } else {
                    PermissionUtils.requestPermissions(
                        this,
                        arrayOf(Manifest.permission.WRITE_EXTERNAL_STORAGE),
                        WRITE_STORAGE_PERMISSION_REQUEST
                    )
                }
            }
            READ_STORAGE_PERMISSION_REQUEST -> if (grantResults.size > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                val galleryIntent = Intent()
                galleryIntent.type = "image/*"
                galleryIntent.action = Intent.ACTION_GET_CONTENT
                startActivityForResult(
                    Intent.createChooser(galleryIntent, "select picture"), PICK_IMAGE_GALLERY
                )
            } else {
                if (!ActivityCompat.shouldShowRequestPermissionRationale(
                        this, Manifest.permission.READ_EXTERNAL_STORAGE
                    )
                ) {
                    showPermissionAlertDialog()
                }
            }
        }

    }

    private fun showPermissionAlertDialog() {
        val alertDialog = AlertDialog.Builder(this)
        alertDialog.setMessage("Please go to setting and gave the permissions")
        alertDialog.setPositiveButton(
            "Ok"
        ) { dialog, which ->
            val intent = Intent()
            intent.action = Settings.ACTION_APPLICATION_DETAILS_SETTINGS
            val uri = Uri.fromParts(
                "package", this.getPackageName(), null
            )
            intent.data = uri
            startActivity(intent)
        }
        alertDialog.setNegativeButton(
            "No"
        ) { dialog, which ->
            dialog.cancel()
            dialog.dismiss()
        }
        alertDialog.show()
    }

    /*  override fun handleResult(rawResult: Result?) {

      }*/

    /*  public fun openCamera()
      {
          mScannerView!!.setResultHandler(this); // Register ourselves as a handler for scan results.
          mScannerView!!.startCamera();
      }

      public fun closeCamera()
      {
          mScannerView!!.stopCamera();           // Stop camera on pause

      }*/


    fun showCustomToastAnimation(message: String, backGroundColor: Int, textColor: Int) {
        runOnUiThread {
            if (dataBinding.labelTextView.visibility != VISIBLE) {
                dataBinding.labelTextView.text = message
                dataBinding.labelTextView.setTextColor(ContextCompat.getColor(this, textColor))
                dataBinding.labelTextView.background.colorFilter = PorterDuffColorFilter(
                    ContextCompat.getColor(this, backGroundColor), PorterDuff.Mode.SRC_ATOP
                )
                dataBinding.labelTextView.visibility = View.VISIBLE
                dataBinding.labelTextView.animate().alpha(0.9f).setDuration(2000)
                    .setListener(object : AnimatorListenerAdapter() {
                        override fun onAnimationEnd(animation: Animator) {
                            super.onAnimationEnd(animation)
                            dataBinding.labelTextView.visibility = GONE
                            dataBinding.labelTextView.alpha = 1f
                        }
                    })
            }
        }

    }   fun showCustomToastAnotherAnimation(message: String, backGroundColor: Int, textColor: Int) {
        runOnUiThread {
            if (dataBinding.anotherLabelTextView.visibility != VISIBLE) {
                dataBinding.anotherLabelTextView.text = message
                dataBinding.anotherLabelTextView.visibility = View.VISIBLE
                dataBinding.anotherLabelTextView.animate().alpha(0.9f).setDuration(2200)
                    .setListener(object : AnimatorListenerAdapter() {
                        override fun onAnimationEnd(animation: Animator) {
                            super.onAnimationEnd(animation)
                            dataBinding.anotherLabelTextView.visibility = GONE
                            dataBinding.anotherLabelTextView.alpha = 1f
                        }
                    })
            }
        }

    }

    override fun onResume() {
        super.onResume()


    }

    fun checkVersion() {
        val manager = packageManager
        val info = manager?.getPackageInfo(
            packageName, 0
        )

        val versionName = info?.versionName
        val versionNumber = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            info?.longVersionCode
        } else {
            info?.versionCode
        }


        val responseCall: Call<GetVersionResponse> = RetrofitClient.apiService.getVersion()

        responseCall.enqueue(object : Callback<GetVersionResponse?> {
            override fun onResponse(
                call: Call<GetVersionResponse?>, response: Response<GetVersionResponse?>
            ) {
                if (response.body() != null && response.body()?.status!!) {

                    if (versionNumber!!.toInt() < Integer.valueOf(response.body()!!.data!!.version!!)) {
                        val builder: AlertDialog.Builder? =
                            AlertDialog.Builder(this@DashboardActivity)

                                .setCancelable(false).setTitle("Update Available")
                                .setMessage("A new version of Mount Carmel School App is available. Please update to new version")

                                .setPositiveButton(
                                    "Update"
                                ) { dialog, _ ->


                                    try {
                                        startActivity(
                                            Intent(
                                                Intent.ACTION_VIEW,
                                                Uri.parse("market://details?id=$packageName")
                                            )
                                        )
                                    } catch (e: ActivityNotFoundException) {
                                        startActivity(
                                            Intent(
                                                Intent.ACTION_VIEW,
                                                Uri.parse("https://play.google.com/store/apps/details?id=$packageName")
                                            )
                                        )
                                    }

                                    dialog.dismiss()

                                }


                        builder!!.show()

                    }


                }
            }

            override fun onFailure(
                call: Call<GetVersionResponse?>, t: Throwable
            ) {
                Log.d("", t.localizedMessage!!)
            }
        }

        )
    }

    fun getStaffStatus(studentID: String) {

        val responseCall: Call<GetStatusList> =
            RetrofitClient.apiService.getStaffStatus(Utils.getAccessToken(this), studentID)

        responseCall.enqueue(object : Callback<GetStatusList?> {
            override fun onResponse(
                call: Call<GetStatusList?>, response: Response<GetStatusList?>
            ) {
                if (response.body() != null && response.body()?.status!!) {

                    if (response.body()!!.data != null && response.body()!!.data!!.isNotEmpty()) {

                        updateStatus(response.body()!!.data, response.body()!!.path)

                        dataBinding.msvStory.visibility = VISIBLE

                    } else {

                        dataBinding.msvStory.visibility = GONE
                    }

                }
            }

            override fun onFailure(
                call: Call<GetStatusList?>, t: Throwable
            ) {
                Log.d("", t.localizedMessage!!)
            }
        }

        )
    }


    fun getDashboardDetail() {

        val calendar = Calendar.getInstance()
        calendar.add(Calendar.MONTH, 0)
        calendar[Calendar.DATE] = calendar.getActualMinimum(Calendar.DAY_OF_MONTH)
        val monthFirstDay = calendar.time
        calendar[Calendar.DATE] = calendar.getActualMaximum(Calendar.DAY_OF_MONTH)
        val monthLastDay = calendar.time

        val df = SimpleDateFormat("dd-MM-yyyy")
        val startDateStr = df.format(monthFirstDay)
        val endDateStr = df.format(monthLastDay)
        val responseCall: Call<DashboardApiResponse> =
            RetrofitClient.apiService.getDashboardDetailApi(
                Utils.getAccessToken(this),
                Utils.getUserId(this),
                startDateStr,
                endDateStr
            )

        responseCall.enqueue(object : Callback<DashboardApiResponse?> {
            @SuppressLint("SimpleDateFormat")
            override fun onResponse(
                call: Call<DashboardApiResponse?>, response: Response<DashboardApiResponse?>
            ) {
                if (response.body() != null && response.body()?.status == true) {

                    mNextSession= response.body()!!.sessionDetails.nextSession.toString()

                    tempStandardSectionId = response.body()!!.nomination?.setting?.standardSectionId

                    if (response.body()!!.selfAwareness != null) {

                        if (response.body()!!.selfAwareness!!.setting != null) {
                            val startDate = Utils.formattedDateFromString(
                                "yyyy-MM-dd'T'hh:mm:ss.SSS'Z'",
                                "dd-MM-yyyy",
                                response.body()!!.selfAwareness!!.setting!!.startDate
                            )
                            val endDate = Utils.formattedDateFromString(
                                "yyyy-MM-dd'T'hh:mm:ss.SSS'Z'",
                                "dd-MM-yyyy",
                                response.body()!!.selfAwareness!!.setting!!.endDate
                            )

                            mSelfAwarenessStartDate =
                                startDate + " | " + response.body()!!.selfAwareness!!.setting!!.startTime

                            mSelfAwarenessEndDate =
                                endDate + " | " + response.body()!!.selfAwareness!!.setting!!.endTime


                            val sdf = SimpleDateFormat("dd-MM-yyyy | hh:mm")


                            val startDate1 = sdf.parse(mSelfAwarenessStartDate)
                            val endDate1 = sdf.parse(mSelfAwarenessEndDate)
                            val d = Date()
                            val currDt = sdf.format(d)

                            mShowSelfAwareness =
                                if (d.after(startDate1) && d.before(endDate1) || currDt == startDate1?.let {
                                        sdf.format(
                                            it
                                        )
                                    } || currDt == endDate1?.let { sdf.format(it) }
                                ) {
                                    println("Date is between")
                                    //it should be true
                                    true;

                                } else {
                                    println("Date is not between ")
                                    false

                                }


                        }

                    }

                    if (response.body()!!.stream != null) {
                        mStreamSelectionData = response.body()!!.stream!!

                        if (response.body()!!.stream!!.setting != null) {
                            val startDate = Utils.formattedDateFromString(
                                "yyyy-MM-dd'T'hh:mm:ss.SSS'Z'",
                                "dd-MM-yyyy",
                                response.body()!!.stream!!.setting!!.startDate
                            )
                            val endDate = Utils.formattedDateFromString(
                                "yyyy-MM-dd'T'hh:mm:ss.SSS'Z'",
                                "dd-MM-yyyy",
                                response.body()!!.stream!!.setting!!.endDate
                            )

                            val streamStartDate =
                                startDate + " " + response.body()!!.stream!!.setting!!.startTime

                            mStreamEndDate =
                                endDate + " " + response.body()!!.stream!!.setting!!.endTime

                            mBranchCodeForStreamSelection =
                                response.body()!!.stream!!.setting!!.branchCode.toString()

                            val sdf = SimpleDateFormat("dd-MM-yyyy HH:mm")


                            val startDate1 = sdf.parse(streamStartDate)
                            val endDate1 = sdf.parse(mStreamEndDate)
                            val d = Date()
                            val currDt = sdf.format(d)


                            mShowStreamSelection =
                                if (d.after(startDate1) && d.before(endDate1) || currDt == startDate1?.let {
                                        sdf.format(
                                            it
                                        )
                                    } || currDt == endDate1?.let { sdf.format(it) }
                                ) {
                                    println("Date is between")
                                    //it should be true

                                    true
                                } else {
                                    println("Date is not between ")

                                    false

                                }

                        }

                    }

                    if (response.body()!!.transportRenewal_Form != null) {
                        mShowTransportRenewal = response.body()!!.transportRenewal_Form!!.isShow

                    }

                    mShowTransportReport = response.body()!!.transportRequest!!.isShow ?: false

                    if (response.body()!!.id_card != null) {
                        mShowIdCard = response.body()!!.id_card!!.isShow

                    }



                    mNewsletter = if (response.body()!!.newsletter.data != null) {
                        response.body()!!.newsletter.path + response.body()!!.newsletter.data?.fileName
                    } else {
                        response.body()!!.newsletter.path

                    }


                    mChronicles = if (response.body()!!.chronicles.data != null) {
                        response.body()!!.chronicles.path + response.body()!!.chronicles.data?.fileName
                    } else {
                        response.body()!!.chronicles.path
                    }

                    settingNavigationRecyclerView(userType)

                    val dashboardContainerFragment = supportFragmentManager.findFragmentById(R.id.fl_dashboardContainer)
                    if (dashboardContainerFragment is HomeFragment) {
                        dashboardContainerFragment.configureActionNeededView()
                    }
                } else {
                    onError(response.body()?.message!!)

                }
            }

            override fun onFailure(
                call: Call<DashboardApiResponse?>, t: Throwable
            ) {
                Log.d("", t.localizedMessage!!)
                settingNavigationRecyclerView(userType)

            }
        }

        )
    }


    @SuppressLint("ClickableViewAccessibility")
    private fun updateStatus(data: List<GetStatusList.Data?>?, path: String?) {

        if (data!!.isNotEmpty()) {
            val storyListOfUser = ArrayList<MiStoryModel>()
            var miStoryModel: MiStoryModel? = null
            for (value in data) {
                if (value!!.file_name != null) {


                    if (isImageFile("$path" + "${value!!.file_name}")) {
                        miStoryModel = MiStoryModel(
                            "$path" + "${value.file_name}", "", "", true, MiMediaType.IMAGE, false
                        )
                    } else {
                        miStoryModel = MiStoryModel(
                            "$path" + "${value.file_name}", "", "", true, MiMediaType.VIDEO, true
                        )
                    }
                    storyListOfUser.add(miStoryModel!!)
                }

            }

            if (storyListOfUser.isNotEmpty()) {

                dataBinding.msvStory.visibility = VISIBLE

                val miUserStoryModel = MiUserStoryModel("", "", storyListOfUser)
                mListOfStory.add(miUserStoryModel)
            } else {
                dataBinding.msvStory.visibility = GONE

            }


            window.decorView.rootView.apply {

                setOnTouchListener { _, motionEvent ->
                    dataBinding.msvStory.dispatchTouchEvent(motionEvent)
                    true
                }

                dataBinding.msvStory.apply {

                    if (storyListOfUser.isNotEmpty()) {

                        setActivity(this@DashboardActivity)
                        setLauncher(launcher)

                        if (storyListOfUser.isNotEmpty()) {
                            setImageUrls(mListOfStory, 0)
                        }

                        setTheme(R.style.AppTheme);

                        if (SharedPreferenceUtils.getInstance(context)
                                ?.getBoolanValue(SHOW_STATUS, false) == false
                        ) {
                            showStatus()
                        }

                        dataBinding.msvStory.visibility = VISIBLE

                    } else {
                        dataBinding.msvStory.visibility = GONE
                    }


                }

            }
        }


    }

    private fun showStatus() {
        val downTime = SystemClock.uptimeMillis()
        val eventTime = SystemClock.uptimeMillis() + 100
        val x = 0.0f
        val y = 0.0f
        val metaState = 0
        val motionEvent = MotionEvent.obtain(
            downTime, eventTime, MotionEvent.ACTION_UP, x, y, metaState
        )

        SharedPreferenceUtils.getInstance(this)?.setValue(SHOW_STATUS, true)

        dataBinding.msvStory.dispatchTouchEvent(motionEvent)
    }

    fun isImageFile(path: String?): Boolean {
        val mimeType: String = URLConnection.guessContentTypeFromName(path)
        return mimeType != null && mimeType.startsWith("image")
    }


    fun getStudentStatus(studentID: String) {

        val responseCall: Call<GetStatusList> =
            RetrofitClient.apiService.getStudentStatus(Utils.getAccessToken(this), studentID)

        responseCall.enqueue(object : Callback<GetStatusList?> {
            override fun onResponse(
                call: Call<GetStatusList?>, response: Response<GetStatusList?>
            ) {
                if (response.body() != null && response.body()?.status!!) {

                    if (response.body()!!.data != null && response.body()!!.data!!.isNotEmpty()) {
                        updateStatus(response.body()!!.data, response.body()!!.path)
                        dataBinding.msvStory.visibility = VISIBLE

                    } else {

                        dataBinding.msvStory.visibility = GONE
                    }

                }
            }

            override fun onFailure(
                call: Call<GetStatusList?>, t: Throwable
            ) {
                Log.d("", t.localizedMessage!!)
            }
        }

        )
    }

    public fun getNotificationCount() {

        val responseCall: Call<NotificationCountModel> =
            RetrofitClient.apiService.getStaffNotificationCount(
                Utils.getAccessToken(this),
                Utils.getUserId(this)
            )
        responseCall.enqueue(object : Callback<NotificationCountModel?> {
            override fun onResponse(
                call: Call<NotificationCountModel?>, response: Response<NotificationCountModel?>
            ) {
                if (response.body() != null && response.body()?.status!!) {

                    if (response.body()!!.notification_count > 0) {
                        dataBinding.notificationCount.visibility = VISIBLE
                        if (response.body()!!.notification_count > 99) {
                            dataBinding.notificationCount.text = "99+"
                        } else {
                            dataBinding.notificationCount.text =
                                response.body()!!.notification_count.toString()
                        }

                    } else {
                        dataBinding.notificationCount.visibility = GONE

                    }

                    mTotalMessageCount = response.body()!!.sms_count
                    updateMessageCount()
                }

            }

            override fun onFailure(
                call: Call<NotificationCountModel?>, t: Throwable
            ) {
                Log.d("", t.localizedMessage!!)
            }
        }

        )
    }

    public fun getStudentNotificationCount() {

        val responseCall: Call<NotificationCountModel> =
            RetrofitClient.apiService.getStudentNotificationCount(
                Utils.getAccessToken(this),
                Utils.getUserId(this)
            )
        responseCall.enqueue(object : Callback<NotificationCountModel?> {
            override fun onResponse(
                call: Call<NotificationCountModel?>, response: Response<NotificationCountModel?>
            ) {
                if (response.body() != null && response.body()?.status!!) {

                    if (response.body()!!.notification_count > 0) {
                        dataBinding.notificationCount.visibility = VISIBLE
                        if (response.body()!!.notification_count > 99) {
                            dataBinding.notificationCount.text = "99+"
                        } else {
                            dataBinding.notificationCount.text =
                                response.body()!!.notification_count.toString()
                        }


                    } else {
                        dataBinding.notificationCount.visibility = GONE

                    }

                    mTotalMessageCount = response.body()!!.sms_count
                    updateMessageCount()
                }
            }

            override fun onFailure(
                call: Call<NotificationCountModel?>, t: Throwable
            ) {
                Log.d("", t.localizedMessage!!)
            }
        }

        )
    }

    fun updateMessageCount() {


        val f: Fragment? = supportFragmentManager.findFragmentById(R.id.fl_dashboardContainer)
        if (f is HomeFragment) {
            (f as HomeFragment).settingTopRecyclerView(Utils.getUserType(this))
        }
    }

    fun getStaffDashboardDetail() {

        val calendar = Calendar.getInstance()
        calendar.add(Calendar.MONTH, 0)
        calendar[Calendar.DATE] = calendar.getActualMinimum(Calendar.DAY_OF_MONTH)
        val monthFirstDay = calendar.time
        calendar[Calendar.DATE] = calendar.getActualMaximum(Calendar.DAY_OF_MONTH)
        val monthLastDay = calendar.time

        val df = SimpleDateFormat("dd-MM-yyyy")
        val startDateStr = df.format(monthFirstDay)
        val endDateStr = df.format(monthLastDay)
        val responseCall: Call<StaffDashboard> =
            RetrofitClient.apiService.getStaffDashboardDetailApi(
                Utils.getAccessToken(this),
                Utils.getUserId(this),
                startDateStr,
                endDateStr
            )

        responseCall.enqueue(object : Callback<StaffDashboard?> {
            @SuppressLint("SimpleDateFormat")
            override fun onResponse(
                call: Call<StaffDashboard?>, response: Response<StaffDashboard?>
            ) {
                if (response.body() != null && response.body()?.status == true) {

                    mNewsletter = if (response.body()!!.newsletter?.data != null) {
                        response.body()!!.newsletter?.path + response.body()!!.newsletter?.data?.fileName
                    } else ({
                        response.body()!!.newsletter?.path

                    }).toString()

                    mChronicles = if (response.body()!!.chronicles?.data != null) {
                        response.body()!!.chronicles?.path + response.body()!!.chronicles?.data?.fileName
                    } else {
                        (response.body()!!.chronicles?.path ?: "").toString()
                    }


                } else {
                    onError(response.body()?.message!!)

                }
                settingNavigationRecyclerView(userType)

            }

            override fun onFailure(
                call: Call<StaffDashboard?>, t: Throwable
            ) {
                Log.d("", t.localizedMessage!!)
                settingNavigationRecyclerView(userType)

            }
        }

        )
    }
}
