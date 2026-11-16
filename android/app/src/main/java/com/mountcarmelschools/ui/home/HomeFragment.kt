package com.mountcarmelschools.ui.home

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.view.View
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.content.res.AppCompatResources.getDrawable
import androidx.core.content.ContextCompat.getColor
import androidx.recyclerview.widget.LinearLayoutManager
import com.bumptech.glide.Glide
import com.bumptech.glide.load.engine.DiskCacheStrategy
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseFragment
import com.mountcarmelschools.databinding.FragmentHomeBinding
import com.mountcarmelschools.ui.assessment.AssessmentFragment
import com.mountcarmelschools.ui.dashboard.DashboardActivity
import com.mountcarmelschools.utlis.Utils
import java.util.Calendar

class HomeFragment : BaseFragment<FragmentHomeBinding, HomeViewModel>() {


    private val studentImages =
        arrayOf(
            R.mipmap.ic_3rd_ar,
            R.drawable.ic_3rd_gallery,
            R.drawable.ic_staff_notice,
            R.drawable.icon_staff_message
        )

    private val student12Images =
        arrayOf(
            R.mipmap.ic_3rd_ar,
            R.drawable.ic_12th_gallery,
            R.drawable.ic_staff_notice,
            R.drawable.icon_staff_message
        )

    private val parentImages =
        arrayOf(
            R.mipmap.ic_3rd_ar,
            R.drawable.ic_parent_gallery,
            R.drawable.ic_staff_notice,
            R.drawable.icon_staff_message
        )

    private val staffImages =
        arrayOf(
            R.drawable.icon_staff_class_list,
            R.drawable.icon_staff_house_list,
            R.drawable.ic_staff_notice,
            R.drawable.icon_staff_message
        )

    private val itemsTitles =
        arrayOf(
            "AR", "Gallerie", "Notice", "Messages"
        )

    private val staffTitles =
        arrayOf(
            "Class List", "House List", "Notice", "Messages"
        )


    private lateinit var resultLauncher: ActivityResultLauncher<Intent>

    private lateinit var mContext: Context

    companion object {
        fun newInstance() = HomeFragment()
    }

    override fun getLayoutID() = R.layout.fragment_home

    override fun getViewModel() = HomeViewModel::class.java

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Registering the callback
        resultLauncher = registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result ->
            if (result.resultCode == Activity.RESULT_OK) {
                // fetch updated user details
                (mContext as DashboardActivity).fetchUserDetails()

                // navigate to assessment record fragment
                val bundle = Bundle()
                bundle.putString("from", "Assessment Record")

                val fragment = AssessmentFragment()
                fragment.arguments = bundle

                Utils.replaceFragment(
                    mContext, R.id.fl_dashboardContainer, fragment, "AssessmentRecord"
                )
            }
        }
    }
    override fun onAttach(context: Context) {
        super.onAttach(context)
        mContext = context
    }


    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
        dataBinding.homeViewModel = viewModel

        dataBinding.tvMsgLabel.text = getGreetingMessage()
        if (Utils.getUserType(mContext).equals("3", true)) {
            onParent()
            dataBinding.mainContainer.setBackgroundColor(
                getColor(
                    mContext,
                    R.color.staffBackground
                )
            )

        } else if (Utils.getUserType(mContext).equals("4", true)) {
            onStaff()
            dataBinding.mainContainer.setBackgroundColor(
                getColor(
                    mContext,
                    R.color.fourth_background
                )
            )

        } else if (Utils.getUserType(mContext).equals("2", true)) {
            on4To12()
            dataBinding.mainContainer.setBackgroundColor(
                getColor(
                    mContext,
                    R.color.fourth_background
                )
            )
        } else {
            onBelow4()
        }

        if (!(mContext as DashboardActivity).userImage.equals("")) {

            Glide.with(this)
                .load((mContext as DashboardActivity).userImage)
                .diskCacheStrategy(DiskCacheStrategy.RESOURCE)
                .error(R.drawable.default_image)
                .into(dataBinding.hexagonMaskView)

        }
        settingTopRecyclerView(Utils.getUserType(mContext))

        configureActionNeededView()
    }

    override fun onResume() {
        super.onResume()
        (mContext as DashboardActivity).setHeaderText("")
        (mContext as DashboardActivity).navigation()
        (mContext as DashboardActivity).hideViewForHome()
        (mContext as DashboardActivity).checkVersion()
        if (!Utils.isStaff(mContext)) {
            (mContext as DashboardActivity).getDashboardDetail()
        }


        if (Utils.isParent(mContext) || Utils.isStaff(mContext)) {
            (mContext as DashboardActivity).showParentHeader(true)
        }


        if (Utils.isStaff(mContext)) {
            (mContext as DashboardActivity).getNotificationCount()
        } else {
            (mContext as DashboardActivity).getStudentNotificationCount()
        }
    }

    public fun settingTopRecyclerView(userType: String) {
        dataBinding.rvTopCategory.layoutManager =
            LinearLayoutManager(mContext, LinearLayoutManager.HORIZONTAL, false)
        dataBinding.rvTopCategory.hasFixedSize()
        when {
            userType.equals("1", false) -> dataBinding.rvTopCategory.adapter =
                HomeTopAdapter(
                    mContext,
                    itemsTitles,
                    studentImages,
                    false,
                    false,
                    (mContext as DashboardActivity).mTotalMessageCount,
                    resultLauncher
                )

            userType.equals("2", false) -> dataBinding.rvTopCategory.adapter =
                HomeTopAdapter(
                    mContext,
                    itemsTitles,
                    student12Images,
                    true,
                    false,
                    (mContext as DashboardActivity).mTotalMessageCount,
                    resultLauncher
                )

            userType.equals("3", false) -> dataBinding.rvTopCategory.adapter =
                HomeTopAdapter(
                    mContext,
                    itemsTitles,
                    parentImages,
                    true,
                    false,
                    (mContext as DashboardActivity).mTotalMessageCount,
                    resultLauncher
                )


            userType.equals("4", false) -> dataBinding.rvTopCategory.adapter =
                HomeTopAdapter(
                    mContext,
                    staffTitles,
                    staffImages,
                    true,
                    true,
                    (mContext as DashboardActivity).mTotalMessageCount,
                    resultLauncher
                )


        }
    }

    fun onBelow4() {
        dataBinding.clAssignHomework.visibility = View.GONE

        dataBinding.ivHomework.setImageResource(R.drawable.ic_3rd_holiday_homework)
        dataBinding.clHomework.background = getDrawable(mContext, R.drawable.light_pink_background)
        dataBinding.tvHomework.text = getString(R.string.homework_label)
    }

    fun on4To12() {
        dataBinding.ivAttendance.setImageResource(R.drawable.ic_12th_attendance)
        dataBinding.tvAttendance.text = getString(R.string.attendance)


        dataBinding.ivSchoolCalendar.setImageResource(R.drawable.ic_12th_school_calendar)
        dataBinding.tvCalendar.text = getString(R.string.school_calendar)

        dataBinding.ivTimeTable.setImageResource(R.drawable.discipline_student)
        dataBinding.tvTimeTable.text = getString(R.string.disciplinary)



        dataBinding.clAttendance.background = getDrawable(mContext, R.drawable.white_background)
        dataBinding.clCalendar.background = getDrawable(mContext, R.drawable.white_background)
        dataBinding.clTimeTable.background = getDrawable(mContext, R.drawable.white_background)
        dataBinding.clWise.background = getDrawable(mContext, R.drawable.white_background)

        dataBinding.clAssignHomework.visibility = View.GONE

        dataBinding.ivHomework.setImageResource(R.drawable.ic_12th_holiday_homework)
        dataBinding.clHomework.background = getDrawable(mContext, R.drawable.white_background)
        dataBinding.tvHomework.text = getString(R.string.homework_label)
    }

    private fun onParent() {

        dataBinding.ivAttendance.setImageResource(R.drawable.ic_parent_attendance)
        dataBinding.ivSchoolCalendar.setImageResource(R.drawable.ic_parent_school_calendar)
        dataBinding.ivTimeTable.setImageResource(R.drawable.discipline_student)
        dataBinding.clAttendance.background = getDrawable(mContext, R.drawable.white_background)
        dataBinding.clCalendar.background = getDrawable(mContext, R.drawable.white_background)
        dataBinding.clTimeTable.background = getDrawable(mContext, R.drawable.white_background)
        dataBinding.clWise.background = getDrawable(mContext, R.drawable.white_background)
        dataBinding.clCalendar.isClickable = false

        dataBinding.clAssignHomework.visibility = View.GONE

        dataBinding.ivHomework.setImageResource(R.drawable.ic_parent_holiday)
        dataBinding.clHomework.background = getDrawable(mContext, R.drawable.white_background)
        dataBinding.tvHomework.text = getString(R.string.homework_label)

    }

    private fun onStaff() {

        dataBinding.tvAssessment.text = "Fee"
        /*dataBinding.tvFee.setCompoundDrawablesWithIntrinsicBounds(
            0,
            R.drawable.ic_fee_parent,
            0,
            0
        )*/

        dataBinding.ivAssessment.setImageResource(R.drawable.fee);
        dataBinding.ivAttendance.setImageResource(R.drawable.ic_staff_mark_attendance)
        dataBinding.tvAttendance.text = getString(R.string.mark_attendance)
        dataBinding.ivSchoolCalendar.setImageResource(R.drawable.ic_staff_attendance_summary)
        dataBinding.tvCalendar.text = getString(R.string.attendance_summary)
        dataBinding.ivTimeTable.setImageResource(R.drawable.discipline_student)
        dataBinding.tvTimeTable.text = getString(R.string.disciplinary)
        dataBinding.clAttendance.background = getDrawable(mContext, R.drawable.white_background)
        dataBinding.clCalendar.background = getDrawable(mContext, R.drawable.white_background)
        dataBinding.clTimeTable.background = getDrawable(mContext, R.drawable.white_background)
        dataBinding.clWise.background = getDrawable(mContext, R.drawable.white_background)

        dataBinding.clAssignHomework.visibility = View.VISIBLE

        dataBinding.ivHomework.setImageResource(R.drawable.ic_3rd_holiday_homework)
        dataBinding.clHomework.background = getDrawable(mContext, R.drawable.white_background)
        dataBinding.tvHomework.text = getString(R.string.assigned_homework_label)
    }

    fun getGreetingMessage(): String {
        val c = Calendar.getInstance()
        val timeOfDay = c.get(Calendar.HOUR_OF_DAY)

        return when (timeOfDay) {
            in 0..11 -> "Good Morning!"
            in 12..16 -> "Good Afternoon!"
            in 17..23 -> "Good Evening!"
            else -> ""
        }
    }

    fun updateProfile(userImage: String) {
        Glide.with(this)
            .load(userImage)
            .diskCacheStrategy(DiskCacheStrategy.RESOURCE)
            .error(R.drawable.default_image)
            .into(dataBinding.hexagonMaskView)

    }

    fun configureActionNeededView() {
        if ((mContext as DashboardActivity).mShowTransportReport) {
            dataBinding.ttActionNeededViewTitle.text = "Good News!"
            dataBinding.ttActionNeededViewHeading.text = "School Transport is available for your ward in (2025-26)."
            dataBinding.ttActionNeededViewSubtitle.text = "Click here for more details"
            showActionNeededView()
            return
        }
        hideActionNeededView()
    }

    fun showActionNeededView() {
        dataBinding.llActionNeededView.visibility = View.VISIBLE
    }

    fun hideActionNeededView() {
        dataBinding.llActionNeededView.visibility = View.GONE
    }
}
