package com.mountcarmelschools.ui.home

import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.view.View
import androidx.activity.result.ActivityResultLauncher
import androidx.core.content.ContextCompat
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseRecyclerAdapter
import com.mountcarmelschools.databinding.RowTopItemsBinding
import com.mountcarmelschools.di.loginData.LoginResponse
import com.mountcarmelschools.ui.assessment.AssessmentFragment
import com.mountcarmelschools.ui.classlist.ClassListFragment
import com.mountcarmelschools.ui.dashboard.DashboardActivity
import com.mountcarmelschools.ui.gallery.GalleryFragment
import com.mountcarmelschools.ui.houselist.HouseListFragment
import com.mountcarmelschools.ui.message.MessageFragment
import com.mountcarmelschools.ui.notice.NoticeFragment
import com.mountcarmelschools.utlis.Utils

class HomeTopAdapter(
    private val mContext: Context,
    private val itemsTitles: Array<String>,
    private val itemsImages: Array<Int>,
    val staff: Boolean,
    val isOnlyStaff: Boolean,
    val messageCount: Int,
    val resultLauncher: ActivityResultLauncher<Intent>?

) : BaseRecyclerAdapter<LoginResponse, RowTopItemsBinding>() {


    override fun getItemCount(): Int {
        return itemsTitles.size
    }

    override fun onBindViewHolder(
        holder: Companion.BaseViewHolder<RowTopItemsBinding>, position: Int
    ) {
        dataBinding.tvMsgLabel.text = itemsTitles[position]
        dataBinding.ivImages.setImageResource(itemsImages[position])
        click(position)
    }

    override fun getLayoutInflater() = R.layout.row_top_items

    fun click(position: Int) {
        when (position) {
            0 -> {
                dataBinding.notificationCount.visibility = View.GONE

                if (!staff) {
                    dataBinding.cvImage.background =
                        ContextCompat.getDrawable(mContext, R.drawable.circle_light_blue_background)
                }
                if (isOnlyStaff) {
                    dataBinding.cvImage.background =
                        ContextCompat.getDrawable(mContext, R.drawable.circle_red_staff_background)
                }
                dataBinding.cvImage.setOnClickListener {

                    if (!Utils.getUserType(mContext).equals("4")) {
                        val fragment = AssessmentFragment()

                        val bundle = Bundle()
                        bundle.putString("from", "Assessment Record")


                        fragment.arguments = bundle

                        Utils.replaceFragment(
                            mContext, R.id.fl_dashboardContainer, fragment, "AssessmentRecord"
                        )
                    } else {

                        Utils.replaceFragment(
                            mContext,
                            R.id.fl_dashboardContainer,
                            ClassListFragment(),
                            "ClassListFragment"
                        )
                    }

                }
            }
            1 -> {
                dataBinding.notificationCount.visibility = View.GONE

                if (!staff) {
                    dataBinding.cvImage.background = ContextCompat.getDrawable(
                        mContext, R.drawable.circle_light_orange_background
                    )
                }
                if (isOnlyStaff) {
                    dataBinding.cvImage.background =
                        ContextCompat.getDrawable(mContext, R.drawable.circle_blue_staff_background)
                }
                dataBinding.cvImage.setOnClickListener {
                    if (Utils.getUserType(mContext).equals("4", true)) {
                        Utils.replaceFragment(
                            mContext,
                            R.id.fl_dashboardContainer,
                            HouseListFragment(),
                            "HomeTopAdapter"
                        )
                    } else Utils.replaceFragment(
                        mContext, R.id.fl_dashboardContainer, GalleryFragment(), "HomeTopAdapter"
                    )
                }
            }
            2 -> {
                dataBinding.notificationCount.visibility = View.GONE

//                if (!staff) {
                dataBinding.cvImage.background =
                    ContextCompat.getDrawable(mContext, R.drawable.circle_yellow_staff_background)
//                }
                if (isOnlyStaff) {
                    dataBinding.cvImage.background = ContextCompat.getDrawable(
                        mContext, R.drawable.circle_yellow_staff_background
                    )
                }
                dataBinding.cvImage.setOnClickListener {


                    Utils.replaceFragment(
                        mContext, R.id.fl_dashboardContainer, NoticeFragment(), "NoticeFragment"
                    )


                }
            }
            3 -> {



                if (messageCount > 0) {
                    dataBinding.notificationCount.visibility = View.VISIBLE

                    if (messageCount > 99) {
                        dataBinding.notificationCount.text = "99+"
                    } else {
                        dataBinding.notificationCount.text = messageCount.toString()
                    }
                } else {
                    dataBinding.notificationCount.visibility = View.GONE

                }
//                if (!staff) {
                dataBinding.cvImage.background =
                    ContextCompat.getDrawable(mContext, R.drawable.circle_green_staff_background)
//                }
                if (isOnlyStaff) {
                    dataBinding.cvImage.background = ContextCompat.getDrawable(
                        mContext, R.drawable.circle_green_staff_background
                    )
                }
                dataBinding.cvImage.setOnClickListener {

                    val fragment = MessageFragment()
                    Utils.replaceFragment(
                        mContext, R.id.fl_dashboardContainer, fragment, "MessageFragment"
                    )
                }

            }
        }
    }
}
