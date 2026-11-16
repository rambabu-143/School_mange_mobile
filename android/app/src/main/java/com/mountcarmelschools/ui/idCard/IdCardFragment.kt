package com.mountcarmelschools.ui.idCard

import android.annotation.SuppressLint
import android.app.AlertDialog
import android.content.Context
import android.os.Bundle
import android.view.View
import android.widget.CheckBox
import android.widget.TextView
import androidx.lifecycle.Observer
import com.bumptech.glide.Glide
import com.bumptech.glide.load.engine.DiskCacheStrategy
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseFragment
import com.mountcarmelschools.databinding.FragmentIdcardBinding
import com.mountcarmelschools.di.data.studentIdCard.StudentIdCardPostData
import com.mountcarmelschools.ui.dashboard.DashboardActivity
import com.mountcarmelschools.utlis.Utils
import java.util.Locale


class IdCardFragment : BaseFragment<FragmentIdcardBinding, IdCardViewModel>() {


    private lateinit var mContext: Context


    companion object {
        fun newInstance() = IdCardFragment()
    }

    override fun onAttach(context: Context) {
        super.onAttach(context)
        mContext = context
    }


    override fun getLayoutID() = R.layout.fragment_idcard


    override fun getViewModel() = IdCardViewModel::class.java


    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {

        super.onViewCreated(view, savedInstanceState)

        (mContext as DashboardActivity).setHeaderText("ID CARD")

        dataBinding.changeRequired.setOnClickListener {
            showDialog()
        }

        dataBinding.confirmButton.setOnClickListener {
            val data = StudentIdCardPostData(
                address = false, allergies = false,
                bloodgroup = false, date_of_birth = false,
                fathers_name = false, name = false,
                profile_pic = false, sms_mobile = false,
                transport = false
            )
            updateData(data,true)
        }

        getIdCardData();
    }

    private fun showDialog() {
        val dialogBuilder = AlertDialog.Builder(requireContext())
        val inflater = this.layoutInflater
        val dialogView: View = inflater.inflate(R.layout.edit_id_card, null)
        dialogBuilder.setView(dialogView)


        val dialog = dialogBuilder.create()
        dialog.setCancelable(false)
        dialog.setCanceledOnTouchOutside(false)
        dialog.show()


        val ic_cancel = dialogView.findViewById<TextView>(R.id.ic_cancel)
        val studentPhotograph = dialogView.findViewById<CheckBox>(R.id.studentPhotograph)
        val name = dialogView.findViewById<CheckBox>(R.id.name)
        val dob = dialogView.findViewById<CheckBox>(R.id.dob)
        val bloodGroup = dialogView.findViewById<CheckBox>(R.id.bloodGroup)
        val allergies = dialogView.findViewById<CheckBox>(R.id.allergies)
        val parentName = dialogView.findViewById<CheckBox>(R.id.parentName)
        val address = dialogView.findViewById<CheckBox>(R.id.address)
        val mobile = dialogView.findViewById<CheckBox>(R.id.mobile)
        val transport = dialogView.findViewById<CheckBox>(R.id.transport)




        ic_cancel.setOnClickListener {
            dialog.dismiss()
            dialog.cancel()
        }
        val ic_save = dialogView.findViewById<TextView>(R.id.ic_save)

        ic_save.setOnClickListener {
            dialog.dismiss()
            dialog.cancel()

            val data = StudentIdCardPostData(
                address = address.isChecked, allergies = allergies.isChecked,
                bloodgroup = bloodGroup.isChecked, date_of_birth = dob.isChecked,
                fathers_name = parentName.isChecked, name = name.isChecked,
                profile_pic = studentPhotograph.isChecked, sms_mobile = mobile.isChecked,
                transport = transport.isChecked
            )
            updateData(data,true)

        }
    }


    private fun updateData(data: StudentIdCardPostData, popScreen:Boolean)
    {

        dataBinding.progressBar.visibility = View.VISIBLE

        viewModel.getPostIDCardDetail(
            Utils.getAccessToken(mContext),
            Utils.getStudentID(mContext),
            data
        ).observe(
            viewLifecycleOwner, Observer {
                dataBinding.progressBar.visibility = View.GONE

                if (it.status == true) {
                    showErrorToast(it.message.toString(), mContext)

                    if (popScreen)
                    {
                        (mContext as DashboardActivity).supportFragmentManager.popBackStack()

                    }
                    else {
                        (mContext as DashboardActivity).supportFragmentManager.popBackStack()
                    }
                } else {
                    showErrorToast(it.message!!, mContext)
                }
            }
        )
    }
    @SuppressLint("SetTextI18n")
    private fun getIdCardData() {
        dataBinding.progressBar.visibility = View.VISIBLE


        viewModel.getIDCardDetail(Utils.getAccessToken(mContext), Utils.getStudentID(mContext))
            .observe(

                viewLifecycleOwner, Observer {
                    dataBinding.progressBar.visibility = View.GONE

                    if (it.status) {

                        Glide.with(this)
                            .load(
                                it.path + it.data.profile_pic
                            )
                            .diskCacheStrategy(DiskCacheStrategy.RESOURCE)
                            .error(R.drawable.default_image).into(dataBinding.cvProfilePic)

                        val currentSession = it.data.session
                        if (!currentSession.isNullOrEmpty()) {
                            (mContext as DashboardActivity).setHeaderText("ID CARD ($currentSession)")
                        }
                        dataBinding.admissionNO.text = "Admission No.: " + it.data.admission_no
                        dataBinding.name.text = "Name: " + it.data.name
                        dataBinding.className.text = "Class/Section: " + it.data.class_section

                        val date =   Utils.formattedDateFromString(
                            "", "dd/MM/yyyy", it.data.date_of_birth
                        )

                        dataBinding.dob.text = "DOB: $date"
                        dataBinding.bloodGroup.text = "Blood Group: " + it.data.bloodgroup
                        dataBinding.allergies.text = "Allergies (if any): " + it.data.allergies
                        dataBinding.parentName.text = "Name: " + it.data.fathers_name
                        dataBinding.address.text = ("Address: " + it.data.address.local_address
                                + ", " + it.data.address.city
                                + "-" + it.data.address.pincode)
                        dataBinding.mobileNo.text = "Mobile No: " + it.data.sms_mobile

                        val morningRoute = it.data.morning_route
                        val eveningRoute = it.data.evening_route
                        if (morningRoute.isNotEmpty() || eveningRoute.isNotEmpty()) {
                            dataBinding.transport.text = "Transport: M:$morningRoute E:$eveningRoute"
                        } else {
                            val type = it.data.transport_type.uppercase(Locale.ROOT)
                            dataBinding.transport.text = "Transport: $type"
                        }

                        if (it.is_form_submitted) {
                            dataBinding.bottom.visibility = View.GONE
                        } else {
                            dataBinding.bottom.visibility = View.VISIBLE
                        }


                        if (it.is_change_request) {
                            dataBinding.changeMessage.text = it.change_message
                            dataBinding.changeMessage.visibility = View.VISIBLE
                        } else {
                            dataBinding.changeMessage.visibility = View.GONE
                        }


                    } else {
                        showErrorToast(it.message, mContext)
                    }
                }
            )

    }

}