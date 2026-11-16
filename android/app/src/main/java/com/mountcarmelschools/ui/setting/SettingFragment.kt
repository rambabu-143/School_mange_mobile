package com.mountcarmelschools.ui.setting

import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.view.View
import android.view.View.GONE
import android.view.View.VISIBLE
import android.widget.AdapterView
import android.widget.ArrayAdapter
import android.widget.LinearLayout
import android.widget.Toast
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.widget.SwitchCompat
import androidx.core.content.ContextCompat
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import com.google.gson.Gson
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseFragment
import com.mountcarmelschools.databinding.FragmentSettingBinding
import com.mountcarmelschools.di.data.staffProfile.StaffProfileDetail
import com.mountcarmelschools.ui.dashboard.DashboardActivity
import com.mountcarmelschools.utlis.AUTH_TOKEN
import com.mountcarmelschools.utlis.CURRENT_BRANCH
import com.mountcarmelschools.utlis.SHOW_ENABLE_SCREEN_LOCK_PROMPT
import com.mountcarmelschools.utlis.ScreenLockManager
import com.mountcarmelschools.utlis.SharedPreferenceUtils
import com.mountcarmelschools.utlis.Utils

class SettingFragment : BaseFragment<FragmentSettingBinding, SettingViewModel>() {

    companion object {
        fun newInstance() = SettingFragment()
    }

    private lateinit var mContext: Context
    private var mMobile: Boolean = false
    private var mSms: Boolean = false
    private var mEmail: Boolean = false

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)

        val userType = Utils.getUserType(mContext)

        if (userType.equals("1")) {

            dataBinding.parentBackground.setBackgroundColor(
                ContextCompat.getColor(
                    mContext,
                    R.color.blue_background
                )
            )
        } else if (userType.equals("2") || userType.equals("3")) {
            dataBinding.parentBackground.setBackgroundColor(
                ContextCompat.getColor(
                    mContext,
                    R.color.fourth_background
                )
            )

        } else if (userType.equals("4")) {

            if (Utils.getAllBranchList(mContext) != "") {

                var selectedPosition = 0;
                dataBinding.selectBranchLayout.visibility = VISIBLE
                val list = Gson().fromJson(
                    Utils.getAllBranchList(mContext),
                    Array<StaffProfileDetail.Data.Year.School>::class.java
                ).toList().toMutableList()

                val adapterList = ArrayList<String>()
                for ((i, data) in list.withIndex()) {
                    if (data.isAccess!!) {

                        adapterList.add(data.schoolCode.toString() + " (${data.branchCode})")
                    }

                }

                if (adapterList.size == 0) {
                    dataBinding.selectBranchLayout.visibility = GONE
                } else {
                    for ((i, data) in adapterList.withIndex()) {

                        if (data.contains(Utils.getSelectedBranch(mContext))) {
                            selectedPosition = i;
                        }

                    }
                }


                val adapter = ArrayAdapter(
                    mContext,
                    R.layout.selected_text_view, adapterList
                )

                dataBinding.selectBranch.adapter = adapter

                dataBinding.selectBranch.onItemSelectedListener =
                    object : AdapterView.OnItemSelectedListener {
                        override fun onNothingSelected(parent: AdapterView<*>?) {

                        }

                        override fun onItemSelected(
                            parent: AdapterView<*>?,
                            view: View?,
                            position: Int,
                            id: Long
                        ) {
                            if (selectedPosition != position) {

                                SharedPreferenceUtils.getInstance(mContext)
                                    ?.setStringValue(
                                        CURRENT_BRANCH,
                                        list[position].branchCode
                                    )

                                showDialog(list[position].branchCode.toString())

                            }
                        }

                    }

                if (adapterList.size >= selectedPosition) {
                    dataBinding.selectBranch.setSelection(selectedPosition)

                }

            } else {

                dataBinding.selectBranchLayout.visibility = GONE

            }
        } else
            dataBinding.parentBackground.setBackgroundColor(
                ContextCompat.getColor(
                    mContext,
                    R.color.parent_background
                )
            )

        dataBinding.edtCarGear.text = (mContext as DashboardActivity).currentYear.toString()

        getSettingDetail()

        updateListener()

        manageScreenLockView()
    }

    private fun updateData(branchCode: String) {

        (mContext as DashboardActivity).showProgress()
        viewModel.updateBranch(Utils.getAccessToken(mContext), branchCode)
            .observe(
                viewLifecycleOwner
            ) {

                (mContext as DashboardActivity).hideProgress()

                if (it.status!!) {

                    val intent = Intent(context, DashboardActivity::class.java)

                    SharedPreferenceUtils.getInstance(requireContext())
                        ?.setStringValue(
                            AUTH_TOKEN,
                            "Bearer " + it.metaData!!.token
                        )

                    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
                    requireActivity().startActivity(intent)

                    Toast.makeText(context, "Branch Updated", Toast.LENGTH_SHORT).show()


                } else {
                    Toast.makeText(context, it.message!!, Toast.LENGTH_SHORT).show()

                }

                requireActivity().finish()
            }

    }

    override fun onAttach(context: Context) {
        super.onAttach(context)
        mContext = context
    }

    override fun getLayoutID() = R.layout.fragment_setting

    override fun getViewModel() = SettingViewModel::class.java


    override fun onResume() {
        super.onResume()
        (mContext as DashboardActivity).setHeaderText("Settings")

    }

    fun getSettingDetail() {
        (mContext as DashboardActivity).showProgress()

        viewModel.getSetting(Utils.getAccessToken(mContext)).observe(

            viewLifecycleOwner, androidx.lifecycle.Observer {

                (mContext as DashboardActivity).hideProgress()

                if (it.status!!) {
                    for (i in 0..it.data!!.size - 1) {


                        /*  if (it?.data.get(i)!!.name.equals("email") && it?.data.get(i)!!.status!!) {
                        dataBinding.ivEmailOnOff.setShadowEffect(it?.data.get(i)!!.status!!)
                        dataBinding.ivEmailOnOff.setEnableEffect(it?.data.get(i)!!.status!!)
                        dataBinding.ivEmailOnOff.toggle(it?.data.get(i)!!.status!!)
                    }

                    if (it?.data.get(i)!!.name.equals("app") && it?.data.get(i)!!.status!!) {
                        dataBinding.ivMobileOnOff.setShadowEffect(it?.data.get(i)!!.status!!)
                        dataBinding.ivMobileOnOff.setEnableEffect(it?.data.get(i)!!.status!!)
                        dataBinding.ivMobileOnOff.toggle(it?.data.get(i)!!.status!!)
                    }


                    if (it?.data.get(i)!!.name.equals("sms") && it?.data.get(i)!!.status!!) {
                        dataBinding.ivSmsOnOff.setShadowEffect(it?.data.get(i)!!.status!!)
                        dataBinding.ivSmsOnOff.setEnableEffect(it?.data.get(i)!!.status!!)
                        dataBinding.ivSmsOnOff.toggle(it?.data.get(i)!!.status!!)
                    }*/

                    }
                } else {
                    showErrorToast(it.message!!, requireContext())
                }

            }
        )


    }

    fun updateListener() {

        /* dataBinding.ivMobileOnOff.setOnCheckedChangeListener { _, isChecked ->
             if (mMobile) {
                 val settingPostData = SettingPostData(
                     "app", isChecked.toString()
                 )

                 updateSettingDetail(settingPostData)
             } else {
                 mMobile = true
             }
         }*/


        /*dataBinding.ivEmailOnOff.setOnCheckedChangeListener { _, isChecked ->
            if (mEmail) {

                val settingPostData = SettingPostData(
                    "email", isChecked.toString()
                )

                updateSettingDetail(settingPostData)
            } else {
                mEmail = true
            }
        }*/
        /* dataBinding.ivSmsOnOff.setOnCheckedChangeListener { _, isChecked ->

             if (mSms) {

                 val settingPostData = SettingPostData(
                     "sms", isChecked.toString()
                 )

                 updateSettingDetail(settingPostData)
             } else {
                 mSms = true
             }
         }*/


    }


    fun updateSettingDetail(settingPostData: SettingPostData) {
        (mContext as DashboardActivity).showProgress()

        viewModel.updateSetting(Utils.getAccessToken(mContext), settingPostData).observe(

            viewLifecycleOwner, androidx.lifecycle.Observer {

                (mContext as DashboardActivity).hideProgress()

                showSuccessToast(it.message!!, mContext)

            }
        )


    }

    fun showDialog(id: String) {
        val alertDialogBuilder: MaterialAlertDialogBuilder = MaterialAlertDialogBuilder(
            mContext,
            R.style.ThemeOverlay_MaterialComponents_MaterialAlertDialog_Centered
        )
            .setTitle("Alert")
            .setMessage("Switch branch?")
            .setNegativeButton(
                "Switch"
            ) { dialog, _ ->

                updateData(id)

                dialog.dismiss()

            }
            .setPositiveButton(
                "Cancel"
            )  /* listener = */
            {

                    dialog, _ ->
                dialog.dismiss()

            }


        alertDialogBuilder.show()
    }

    private fun manageScreenLockView() {
        view?.findViewById<LinearLayout>(R.id.screenLockView)?.let { localScreenLockView ->
            val screenLockManager = (mContext as DashboardActivity).getScreenLockManager()
            screenLockManager.let { localScreenLockManager ->
                if (localScreenLockManager == null) {
                    localScreenLockView.visibility = GONE
                } else {
                    localScreenLockManager.isAvailable(object : ScreenLockManager.AvailabilityListener {
                        override fun onSuccess(type: ScreenLockManager.ScreenLockType) {
                            view?.findViewById<SwitchCompat>(R.id.screenLockSwitch)?.let {
                                localScreenLockView.visibility = VISIBLE
                                it.isChecked = localScreenLockManager.isEnabled()
                                it.setOnCheckedChangeListener { _buttonView, isChecked ->
                                    handleScreenLockSwitchChange(
                                        isChecked
                                    )
                                }
                            }
                        }

                        override fun onError(error: Exception) {
                            localScreenLockView.visibility = GONE
                        }
                    })
                }
            }
        }
    }

    private fun handleScreenLockSwitchChange(enabled: Boolean) {
        val screenLockManager = (mContext as DashboardActivity).getScreenLockManager()
        screenLockManager?.let { localScreenLockManager ->
            if (enabled) {
                localScreenLockManager.authenticateUser(object : ScreenLockManager.AuthResultListener {
                    override fun onSuccess() {
                        localScreenLockManager.enable(true)
                        SharedPreferenceUtils.getInstance(mContext)?.setValue(SHOW_ENABLE_SCREEN_LOCK_PROMPT, false)
                        ScreenLockManager.SCREEN_LOCKED = false
                    }

                    override fun onError(error: Exception) {
                        view?.findViewById<SwitchCompat>(R.id.screenLockSwitch)?.isChecked = false
                        activity?.let {
                            AlertDialog.Builder(mContext)
                                .setTitle("Authentication Failed")
                                .setMessage(error.message)
                                .setNeutralButton("Okay", null)
                                .show()
                        }
                    }
                })
            } else {
                localScreenLockManager.enable(false)
            }
        }
    }
}
