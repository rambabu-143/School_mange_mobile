package com.mountcarmelschools.ui.profile

import android.content.Context
import android.os.Bundle
import android.view.View
import androidx.fragment.app.Fragment
import com.bumptech.glide.Glide
import com.bumptech.glide.load.engine.DiskCacheStrategy
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseFragment
import com.mountcarmelschools.databinding.FragmentProfileBinding
import com.mountcarmelschools.ui.dashboard.DashboardActivity
import com.mountcarmelschools.ui.profile.general.GeneralFragment
import com.mountcarmelschools.ui.profile.health.HealthFragment
import com.mountcarmelschools.ui.profile.parent.ParentFragment
import com.mountcarmelschools.ui.profile.sibling.SiblingFragment
import com.mountcarmelschools.ui.profile.staff.editProfile.EditStaffProfileFragment
import com.mountcarmelschools.ui.profile.staff.staffDepartment.StaffDepartment
import com.mountcarmelschools.ui.profile.staff.staffGeneral.GeneralStaff
import com.mountcarmelschools.ui.profile.staff.staffQualification.StaffQualification
import com.mountcarmelschools.ui.profile.transport.TransportFragment
import com.mountcarmelschools.utlis.Utils

class   ProfileFragment : BaseFragment<FragmentProfileBinding, ProfileViewModel>() {

    private lateinit var mContext: Context

    companion object{
        fun getInstance(from_top_header: Boolean): Fragment{
            var frag = ProfileFragment()
            var bundle = Bundle()
            bundle.putBoolean("from_top_header", from_top_header)
            frag.arguments = bundle
            return frag
        }
    }



    override fun onAttach(context: Context) {
        super.onAttach(context)

        mContext = context

    }

    override fun onResume() {
        super.onResume()
        (mContext as DashboardActivity).setHeaderText("Profile")

    }

    override fun getLayoutID(): Int {
        return R.layout.fragment_profile
    }

    override fun getViewModel(): Class<ProfileViewModel> {
        return ProfileViewModel::class.java
    }

    var from_top_header = false

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        val userType = Utils.getUserType(mContext)

        /*if(arguments?.containsKey("from_top_header") == true)
            from_top_header = arguments!!.getBoolean("from_top_header")

        var is_staff_view = false
        if(Utils.isStaff(mContext) && from_top_header){
            dataBinding.profileImageSmall.setImageResource(R.drawable.ic_bottom_profile_staff)
            dataBinding.posterImage.setImageResource(R.drawable.ic_bottom_profile_staff)
            dataBinding.number.setText("+919019090090")
            dataBinding.id.visibility = View.VISIBLE
            dataBinding.id.setText("AN-020")
            dataBinding.staff.visibility = View.VISIBLE
            dataBinding.student.visibility = View.GONE
            is_staff_view = true

        }else*/ if (userType.equals("4")) {
            dataBinding.profileImageSmall.setImageResource(R.drawable.ic_bottom_profile_staff)
            dataBinding.posterImage.setImageResource(R.drawable.ic_bottom_profile_staff)
            dataBinding.number.setText("+919019090090")
            dataBinding.id.visibility = View.VISIBLE
            dataBinding.id.setText("AN-020")
            dataBinding.staff.visibility = View.VISIBLE
            dataBinding.student.visibility = View.GONE
            dataBinding.staffEditFloatingButton.visibility = View.VISIBLE
         //   is_staff_view = true

        }


        /*if(is_staff_view){

            if (!(mContext as DashboardActivity).userImage.equals("")) {

                Glide.with(this)
                        .load((mContext as DashboardActivity).userImage)
                        .diskCacheStrategy(DiskCacheStrategy.RESOURCE)
                        .error(R.drawable.default_image)
                        .into(dataBinding.profileImageSmall)


                Glide.with(this)
                        .load((mContext as DashboardActivity).userImage)
                        .diskCacheStrategy(DiskCacheStrategy.RESOURCE)
                        .error(R.drawable.default_image)
                        .into(dataBinding.posterImage)

            }
        }else {*/

            if (!(mContext as DashboardActivity).userImage.equals("")) {

                Glide.with(this)
                        .load((mContext as DashboardActivity).userImage)
                        .diskCacheStrategy(DiskCacheStrategy.RESOURCE)
                        .error(R.drawable.default_image)
                        .into(dataBinding.profileImageSmall)


                Glide.with(this)
                        .load((mContext as DashboardActivity).userImage)
                        .diskCacheStrategy(DiskCacheStrategy.RESOURCE)
                        .error(R.drawable.default_image)
                        .into(dataBinding.posterImage)

            }
       // }

        if (!(mContext as DashboardActivity).userName.equals("")) {

            dataBinding.name.text = (mContext as DashboardActivity).userName

        }

        if (!(mContext as DashboardActivity).userAdmission.equals("")) {

            dataBinding.number.text = (mContext as DashboardActivity).userAdmission

        }


        if (Utils.isParent(mContext)) {
            dataBinding.transportLayout.visibility = View.VISIBLE
        }


        dataBinding.general.setOnClickListener {

            Utils.replaceFragment(
                mContext,
                R.id.fl_dashboardContainer,
                GeneralFragment(),
                "GeneralFragment"
            )


        }
        dataBinding.generalStaff.setOnClickListener {

            Utils.replaceFragment(
                mContext,
                R.id.fl_dashboardContainer,
                GeneralStaff(),
                "GeneralStaff"
            )
        }
        dataBinding.parent.setOnClickListener {
            Utils.replaceFragment(
                mContext,
                R.id.fl_dashboardContainer,
                ParentFragment(),
                "ParentFragment"
            )

        }
        dataBinding.health.setOnClickListener {
            Utils.replaceFragment(
                mContext,
                R.id.fl_dashboardContainer,
                HealthFragment(),
                "HealthFragment"
            )

        }
        dataBinding.sibling.setOnClickListener {
            Utils.replaceFragment(
                mContext,
                R.id.fl_dashboardContainer,
                SiblingFragment(),
                "SiblingFragment"
            )

        }
        dataBinding.transport.setOnClickListener {
            Utils.replaceFragment(
                mContext,
                R.id.fl_dashboardContainer,
                TransportFragment(),
                "TransportFragment"
            )

        }

        dataBinding.transportStaff.setOnClickListener {
            Utils.replaceFragment(
                mContext,
                R.id.fl_dashboardContainer,
                TransportFragment(),
                "TransportFragment"
            )

        }

        dataBinding.staffDepartment.setOnClickListener {
            Utils.replaceFragment(
                mContext,
                R.id.fl_dashboardContainer,
                StaffDepartment(),
                "StaffDepartment"
            )

        }

        dataBinding.staffQualification.setOnClickListener {
            Utils.replaceFragment(
                mContext,
                R.id.fl_dashboardContainer,
                StaffQualification(),
                "StaffQualification"
            )

        }

        dataBinding.staffEditFloatingButton.setOnClickListener {

            Utils.replaceFragment(
                mContext,
                R.id.fl_dashboardContainer,
                EditStaffProfileFragment(),
                "EditStaffProfileFragment"
            )
        }


    }


}