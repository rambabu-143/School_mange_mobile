package com.mountcarmelschools.ui.disciplinary.forstudent

import android.annotation.SuppressLint
import android.app.Dialog
import android.content.Context
import android.graphics.Color
import android.graphics.drawable.ColorDrawable
import android.os.Bundle
import android.util.DisplayMetrics
import android.view.View
import android.view.Window
import android.widget.FrameLayout
import androidx.lifecycle.Observer
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import androidx.viewpager.widget.ViewPager
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseFragment
import com.mountcarmelschools.databinding.FragmentDisciplinaryCardBinding
import com.mountcarmelschools.di.data.disciplinaryCard.DisciplinaryCardResponse
import com.mountcarmelschools.di.networking.ResponseStatus
import com.mountcarmelschools.di.networking.ResponseStatusError
import com.mountcarmelschools.ui.dashboard.DashboardActivity
import com.mountcarmelschools.ui.disciplinary.DisciplinaryAdapter
import com.mountcarmelschools.ui.disciplinary.Listener
import com.mountcarmelschools.utlis.DynamicHeightViewPager
import com.mountcarmelschools.utlis.Utils


class DisciplinaryCardFragment :
    BaseFragment<FragmentDisciplinaryCardBinding, DisciplinaryCardViewModel>(), Disciplinary,
    Listener {
    lateinit var mContext: Context

    override fun onAttach(context: Context) {
        super.onAttach(context)
        mContext = context
    }

    override fun onResume() {
        super.onResume()
        (mContext as DashboardActivity).setHeaderText("Disciplinary Card")

    }

    override fun getLayoutID(): Int {

        return R.layout.fragment_disciplinary_card
    }

    override fun getViewModel(): Class<DisciplinaryCardViewModel> {

        return DisciplinaryCardViewModel::class.java

    }

    @SuppressLint("ClickableViewAccessibility")
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        dataBinding.viewModel = viewModel

        dataBinding.rvDisciplinary.layoutManager =
            LinearLayoutManager(mContext, RecyclerView.VERTICAL, false)
        initObserver()

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

    private fun initObserver() {

        viewModel.liveDataNetworkError.observe(viewLifecycleOwner, observerError)
        viewModel.liveDataDisciplinaryCard.observe(viewLifecycleOwner, observerDisciplinary)

        getDisciplinaryCard()
    }


    private fun getDisciplinaryCard() {
        (mContext as DashboardActivity).showProgress()
        viewModel.callDisciplinaryCard(
            requireContext(),
            Utils.getAccessToken(mContext),
            Utils.getStudentRollNo(mContext),
        )
    }

    private val observerDisciplinary =
        Observer<ResponseStatus<DisciplinaryCardResponse>> { responseStatus ->
            (mContext as DashboardActivity).hideProgress()

            when (responseStatus) {
                is ResponseStatus.Success -> {

                    val list = ArrayList<DisciplinaryCustomList>()


                    val pinkDataList =
                        ArrayList<DisciplinaryCustomList.DisciplinaryCustomListData>()
                    for (values in responseStatus.response.data?.pink?.data!!) {
                        val value = DisciplinaryCustomList.DisciplinaryCustomListData(
                            actionTaken = values?.actionTaken.toString(),
                            housePoint = values?.housePoint!!.toString()
                                    +" ("+ values.studentId?.houseId?.houseNo+") ",
                            issueDate = values.issueDate!!,
                            reason = values.reason!!,
                            reasonOther = if (values.reasonOther != null) values.reasonOther!! else "",
                            staffName = values.staffId?.name.toString(),
                            issuedTo = responseStatus.response.student?.name + " ("+
                                    responseStatus.response.student?.admissionNo+") "+
                                    responseStatus.response.student?.standardSectionId?.standard +
                                    responseStatus.response.student?.standardSectionId?.section
                        )
                        pinkDataList.add(value);
                    }

                    val data = DisciplinaryCustomList(
                        cardName = "WARNING CARD",
                        color = R.color.pink_card_light,
                        count = responseStatus.response.data?.pink?.count.toString(),
                        color_name = "pink",
                        data = pinkDataList
                    )


                    val yellowDataList =
                        ArrayList<DisciplinaryCustomList.DisciplinaryCustomListData>()
                    for (values in responseStatus.response.data.yellow?.data!!) {

                        val value = DisciplinaryCustomList.DisciplinaryCustomListData(
                            actionTaken = values?.actionTaken.toString(),
                            housePoint = values?.housePoint!!.toString()
                                    +" ("+ values.studentId?.houseId?.houseNo+") ",
                            issueDate = values.issueDate!!,
                            reason = values.reason!!,
                            reasonOther = if (values.reasonOther != null) values.reasonOther!! else "",
                            staffName = values.staffId?.name.toString(),
                            issuedTo = responseStatus.response.student?.name + " ("+
                                    responseStatus.response.student?.admissionNo+") "+
                                    responseStatus.response.student?.standardSectionId?.standard +
                                    responseStatus.response.student?.standardSectionId?.section
                        )
                        yellowDataList.add(value);
                    }
                    val data1 = DisciplinaryCustomList(
                        cardName = "TARDY CARD",
                        color = R.color.yellow_card_light,
                        count = responseStatus.response.data.yellow.count.toString(),
                        color_name = "yellow",
                        data = yellowDataList
                    )
                    val redDataList =
                        ArrayList<DisciplinaryCustomList.DisciplinaryCustomListData>()
                    for (values in responseStatus.response.data.red?.data!!) {
                        val value = DisciplinaryCustomList.DisciplinaryCustomListData(
                            actionTaken = values?.actionTaken.toString(),
                            housePoint = values?.housePoint!!.toString()
                                    +" ("+ values.studentId?.houseId?.houseNo+") ",
                            issueDate = values.issueDate!!,
                            reason = values.reason!!,
                            reasonOther = if (values.reasonOther != null) values.reasonOther!! else "",
                            staffName = values.staffId?.name.toString(),
                                    issuedTo = responseStatus.response.student?.name + " ("+
                                    responseStatus.response.student?.admissionNo+") "+
                                    responseStatus.response.student?.standardSectionId?.standard +
                                    responseStatus.response.student?.standardSectionId?.section
                        )
                        redDataList.add(value);
                    }

                    val data2 = DisciplinaryCustomList(
                        cardName = "RED CARD",
                        color = R.color.red_card_light,
                        count = responseStatus.response.data?.red?.count.toString(),
                        color_name = "red",

                        data = redDataList

                    )
                    list.add(data)
                    list.add(data1)
                    list.add(data2)


                    val adapter =
                        DisciplinaryCardAdapter(mContext, list, this, responseStatus.response.data)
                    dataBinding.rvDisciplinary.adapter = adapter


                }

                is ResponseStatus.Error -> {

                    showErrorToast(responseStatus.responseMessage, requireContext())
                }

                is ResponseStatus.TechnicalError -> {
                    showErrorToast(responseStatus.responseMessage, requireContext())

                }
            }
        }


    override fun onClick(value: DisciplinaryCustomList, data: DisciplinaryCardResponse.Data?) {

        if (value.cardName == "WARNING CARD") {
            openDetails(0, value)
        } else if (value.cardName == "TARDY CARD") {
            openDetails(1, value)

        } else if (value.cardName == "RED CARD") {
            openDetails(2, value)

        }
    }

    /**
     * This method is to show the Calendar dialog box.
     */
    var customDialog: Dialog? = null

    private fun openDetails(check: Int, data: DisciplinaryCustomList) {
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
        init(viewPager, check, data)

        customDialog?.show()
    }

    private fun init(
        viewpager: DynamicHeightViewPager,
        check: Int,
        data: DisciplinaryCustomList
    ) {

        var adp: DisciplinaryAdapter? = null
        viewpager.pageMargin = 10

        adp = DisciplinaryAdapter(
            mContext, data, check, this
        )


        viewpager.clipToPadding = false
        viewpager.setPadding(dpToPx(30), 0, dpToPx(30), 0)
        val scaleFactor = 1f

        adp.let {


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

                }

                override fun onPageSelected(position: Int) {

                    // viewpager.measure(viewpager.measuredWidth, viewpager.measuredHeight);

                    adp.updateSelectedPos(position)
                }


            })
        }


    }

    fun dpToPx(dp: Int): Int {
        val displayMetrics = requireActivity().resources.displayMetrics
        return Math.round(dp * (displayMetrics.xdpi / DisplayMetrics.DENSITY_DEFAULT))
    }

    override fun close() {
        customDialog?.dismiss()
    }


}