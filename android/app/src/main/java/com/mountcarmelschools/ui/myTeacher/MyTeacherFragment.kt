package com.mountcarmelschools.ui.myTeacher

import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.RelativeLayout
import android.widget.TextView
import android.widget.Toast
import androidx.cardview.widget.CardView
import androidx.core.view.updateLayoutParams
import androidx.lifecycle.Observer
import com.bumptech.glide.Glide
import com.bumptech.glide.load.engine.DiskCacheStrategy
import com.google.android.material.textview.MaterialTextView
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseFragment
import com.mountcarmelschools.databinding.MyTeacherBinding
import com.mountcarmelschools.di.data.teacher.MyTeacherResponse
import com.mountcarmelschools.di.data.teacher.MyTeacherView
import com.mountcarmelschools.ui.dashboard.DashboardActivity
import com.mountcarmelschools.utlis.Utils

class MyTeacherFragment : BaseFragment<MyTeacherBinding, MyTeacherFragmentViewModel>() {

    private lateinit var mContext: Context


    override fun onAttach(context: Context) {
        super.onAttach(context)
        mContext = context
    }

    override fun onResume() {
        super.onResume()
        (mContext as DashboardActivity).setHeaderText("My Teachers")
    }

    override fun getLayoutID() = R.layout.my_teacher

    override fun getViewModel() = MyTeacherFragmentViewModel::class.java


    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        if (Utils.isNetworkAvailable(requireContext())) {
            getTeacherDetail()
        } else {
            Toast.makeText(requireContext(), "No internet connection", Toast.LENGTH_SHORT).show()
        }
    }


    private fun getTeacherDetail() {

        if (mContext is DashboardActivity)
            (mContext as DashboardActivity).showProgress()

        viewModel.getTeacher(Utils.getAccessToken(mContext), Utils.getUserId(mContext))
            .observe(
                viewLifecycleOwner, Observer {
                    (mContext as DashboardActivity).hideProgress()

                    if (it != null && it.status == true) {
                        if (isAdded && isVisible) {
                            updateView(it)
                        }
                    } else {

                        // Toast.makeText(context, it.message.toString(), Toast.LENGTH_SHORT).show()

                    }
                })
    }

    private fun updateView(it: MyTeacherResponse) {


        val teacher = ArrayList<MyTeacherView.Teacher?>()


        if (it.classX?.classTeacherId != null) {
            teacher.add(
                MyTeacherView.Teacher(
                    it.classX.classTeacherId.id,
                    it.classX.classTeacherId.name,
                    "Class Teacher",
                    it.path + "/" + it.classX.classTeacherId.profilePic
                )
            )
        }
        if (it.classX?.helperTeacherID != null) {
            teacher.add(
                MyTeacherView.Teacher(
                    it.classX.helperTeacherID.id,
                    it.classX.helperTeacherID.name,
                    "Helper Teacher",
                    it.path + "/" + it.classX.helperTeacherID.profilePic
                )
            )
        }

        if (it.house?.houseInchargeId != null) {
            for (value in it.house.houseInchargeId) {
                teacher.add(
                    MyTeacherView.Teacher(
                        value?.id,
                        value?.name,
                        "House Teacher",
                        it.path + "/" + value?.profilePic
                    )
                )
            }
        }

        updateTeacherView(teacher)


        if (it.subjects != null) {
            val isStudent = !(Utils.isParent(mContext) || Utils.isStaff(mContext)) // Utils.isParent(mContext)
            val standardNum = getStandardNumFromRoman(Utils.getStandardName(mContext))
            val showSurveyCTA = isStudent && standardNum != null && standardNum >= 9

            val token = Utils.getAccessToken(mContext)
            val studentId = Utils.getStudentID(mContext)
            val standardSectionId = Utils.getStandardSectionId(mContext) ?: (mContext as DashboardActivity).tempStandardSectionId?.id

            for (subjectTeacher in it.subjects) {
                val content =
                    LayoutInflater.from(mContext)
                        .inflate(R.layout.my_teacher_infalto, null)

                val title = content.findViewById<TextView>(R.id.title)
                val name = content.findViewById<TextView>(R.id.name)
                val profileImageSmall = content.findViewById<ImageView>(R.id.profileImageSmall)

                if (subjectTeacher != null && !subjectTeacher.subjectTeacherId.isNullOrEmpty()) {

                    val subjectTeacherImageUri = subjectTeacher.subjectTeacherId.getOrNull(0)?.staffId?.profilePic

                    if (!subjectTeacherImageUri.isNullOrEmpty()) {
                        Glide.with(this)
                            .load(it.path + "/" + subjectTeacherImageUri)
                            .diskCacheStrategy(DiskCacheStrategy.RESOURCE)
                            .error(R.drawable.default_image)
                            .into(profileImageSmall)
                    }

                    title.text = subjectTeacher.subjectName

                    val staffData = subjectTeacher.subjectTeacherId.getOrNull(0)?.staffId

                    name.text = staffData?.name

                    if (staffData != null && showSurveyCTA) {
                        val cardView = content.findViewById<CardView>(R.id.teacherCard)
                        val surveyCTA = content.findViewById<MaterialTextView>(R.id.surveyCTA)
                        val contentContainer = content.findViewById<RelativeLayout>(R.id.relativeLayout)

                        surveyCTA.visibility = View.VISIBLE
                        contentContainer.updateLayoutParams<ViewGroup.MarginLayoutParams> {
                            setMargins(0, mContext.resources.getDimensionPixelSize(R.dimen._12sdp), 0, 0)
                        }
                    }

                    dataBinding.subjectTeacher.addView(content)

                }


            }
        }


    }

    private fun updateTeacherView(hashMap: ArrayList<MyTeacherView.Teacher?>) {

        for (hash in hashMap) {
            val content =
                LayoutInflater.from(mContext)
                    .inflate(R.layout.my_teacher_infalto, null)

            val title = content.findViewById<TextView>(R.id.title)
            val name = content.findViewById<TextView>(R.id.name)
            val profileImageSmall = content.findViewById<ImageView>(R.id.profileImageSmall)

            hash?.profilePic?.let { profilePic ->
                Glide.with(this)
                    .load(profilePic)
                    .diskCacheStrategy(DiskCacheStrategy.RESOURCE)
                    .error(R.drawable.default_image)
                    .into(profileImageSmall)
            }

            title.text = hash?.title

            name.text = hash?.name

            dataBinding.upperLayout.addView(content)
        }
    }

    private fun getStandardNumFromRoman(roman: String?): Int? {
        return when (roman) {
            "I" -> 1
            "II" -> 2
            "III" -> 3
            "IV" -> 4
            "V" -> 5
            "VI" -> 6
            "VII" -> 7
            "VIII" -> 8
            "IX" -> 9
            "X" -> 10
            "XI" -> 10
            "XII" -> 10
            "XIII" -> 10
            "XIV" -> 10
            "XV" -> 10
            else -> null
        }
    }
}