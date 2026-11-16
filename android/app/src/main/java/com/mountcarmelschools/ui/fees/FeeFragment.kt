package com.mountcarmelschools.ui.fees

import android.annotation.SuppressLint
import android.content.ActivityNotFoundException
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.view.View
import android.view.View.GONE
import android.view.View.VISIBLE
import androidx.core.content.ContextCompat
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseFragment
import com.mountcarmelschools.databinding.FragmentFeeBinding
import com.mountcarmelschools.ui.dashboard.DashboardActivity
import com.mountcarmelschools.utlis.Utils


class FeeFragment : BaseFragment<FragmentFeeBinding, FeeViewModel>() {

    private lateinit var mContext: Context

    companion object {
        fun newInstance() = FeeFragment()
    }

    override fun onAttach(context: Context) {
        super.onAttach(context)
        mContext = context
    }

    override fun onResume() {
        super.onResume()
        (mContext as DashboardActivity).setHeaderText(getString(R.string.fee))
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
        dataBinding.feeViewModel = viewModel

        val userType = Utils.getUserType(mContext)

        if (userType == "4") {
            dataBinding.cvSchoolFee.visibility = View.GONE
            dataBinding.tvBusFineLable.visibility = View.GONE
            dataBinding.tvBusFineAmount.visibility = View.GONE
            dataBinding.cvHostelFee.visibility = View.GONE
        }
        if (userType == "2" || userType == "3") {
            dataBinding.parentBackground.setBackgroundColor(
                ContextCompat.getColor(
                    mContext,
                    R.color.fourth_background
                )
            )
        } else {
            dataBinding.parentBackground.setBackgroundColor(
                ContextCompat.getColor(
                    mContext,
                    R.color.parent_background
                )
            )

        }

        if (Utils.isParent(mContext)) {
            updateViewForParent()

        } else if (Utils.isStaff(mContext)) {
            updateViewForStaff()
        }


    }

    @SuppressLint("SetTextI18n")
    public fun updateViewForParent() {

        //-----FEE------
        if ((mContext as DashboardActivity).studentDetail.data?.feeBillId?.installment != null &&
            (mContext as DashboardActivity).studentDetail.data?.feeBillId?.installment?.size!! > 0
        ) {

            dataBinding.cvSchoolFee.visibility = View.VISIBLE
            val listForFee =
                (mContext as DashboardActivity).studentDetail.data?.feeBillId?.installment

            for (value in listForFee!!) {
                if (value?.installmentType.toString().toLowerCase().equals("current")) {

                    dataBinding.tvPayment.text = value?.instNo
                    dataBinding.tvAmount.text = "₹" + value?.amount.toString()
                    dataBinding.tvDueAmount.text = "₹" + value?.amountPayble.toString()

                    if (value?.fine.toString().equals("")) {
                        dataBinding.tvFineAmount.text = "₹0"

                    } else {
                        dataBinding.tvFineAmount.text = "₹" + value?.fine.toString().split("\n").fold(0) { acc, curr ->
                            val currVal = curr.trim().toIntOrNull() ?: 0
                            acc + currVal
                        }
                    }

                }

            }
            dataBinding.tvViewBill.setOnClickListener {


                /*  val pdfLink =
                      Uri.parse((mContext as DashboardActivity).studentDetail.data?.feeBillId!!.filepath)
  */
                try {
                    mContext.startActivity(
                        Intent(
                            Intent.ACTION_VIEW,
                            Uri.parse((mContext as DashboardActivity).studentDetail.data?.feeBillId!!.filepath)
                        )
                    );

                } catch (e: ActivityNotFoundException) {


                }
            }
            if ((mContext as DashboardActivity).studentDetail.data?.fullPaymentReceived == true) {
                dataBinding.tvPayBill.text = "Paid"
                dataBinding.tvPayBill.setTextColor(ContextCompat.getColor(mContext, R.color.red))
            }




        } else {

            dataBinding.cvSchoolFee.visibility = View.GONE
        }


        //-----TRANSPORT------
        if ((mContext as DashboardActivity).studentDetail.data?.transportBillId?.installment != null &&
            (mContext as DashboardActivity).studentDetail.data?.transportBillId?.installment?.size!! > 0
        ) {

            dataBinding.cvTransportFee.visibility = View.VISIBLE
            val listForFee =
                (mContext as DashboardActivity).studentDetail.data?.transportBillId?.installment

            for (value in listForFee!!) {

                if (value?.installmentType.toString().toLowerCase().equals("current")) {

                    dataBinding.tvBusPayment.text = value?.instNo
                    dataBinding.tvBusAmount.text = "₹" + value?.amount.toString()
                    dataBinding.tvBusDueAmount.text = "₹" + value?.amountPayble.toString()

                    if (value?.fine.toString().equals("")) {
                        dataBinding.tvBusFineAmount.text = "₹0"

                    } else {
                        dataBinding.tvBusFineAmount.text = "₹" + value?.fine.toString()
                    }


                }
            }



            dataBinding.tvBusViewBill.setOnClickListener {


                /*  val pdfLink =
                      Uri.parse((mContext as DashboardActivity).studentDetail.data?.feeBillId!!.filepath)
  */
                try {
                    mContext.startActivity(
                        Intent(
                            Intent.ACTION_VIEW,
                            Uri.parse((mContext as DashboardActivity).studentDetail.data?.transportBillId!!.filepath)
                        )
                    );

                } catch (e: ActivityNotFoundException) {


                }
            }

            val transportBillId =
                (mContext as DashboardActivity).studentDetail.data?.transportBillId
            if (
                (transportBillId?.fullPaymentReceived == true) &&
                (transportBillId.payable!! <= 0)
            ) {
                dataBinding.tvBusPayBill.text = "Paid"
                dataBinding.tvBusPayBill.setTextColor(ContextCompat.getColor(mContext, R.color.red))
            }



        } else {
            dataBinding.cvTransportFee.visibility = View.GONE
        }


        //-----HOSTEL------
        if ((mContext as DashboardActivity).studentDetail.data?.hostelBillId?.installment != null &&
            (mContext as DashboardActivity).studentDetail.data?.hostelBillId?.installment?.size!! > 0
        ) {

            dataBinding.cvHostelFee.visibility = View.VISIBLE
            val listForFee =
                (mContext as DashboardActivity).studentDetail.data?.hostelBillId?.installment

            for (value in listForFee!!) {
                if (value?.installmentType.toString().toLowerCase().equals("current")) {

                    dataBinding.tvPaymentHostel.text = value?.instNo
                    dataBinding.tvAmountHostel.text = "₹" + value?.amount.toString()
                    dataBinding.tvDueAmountHostel.text = "₹" + value?.amountPayble.toString()

                    if (value?.fine.toString().equals("")) {
                        dataBinding.tvFineAmountHostel.text = "₹0"

                    } else {
                        dataBinding.tvFineAmountHostel.text = "₹" + value?.fine.toString()
                    }

                }

            }
            dataBinding.tvViewBillHostel.setOnClickListener {


                /*  val pdfLink =
                      Uri.parse((mContext as DashboardActivity).studentDetail.data?.feeBillId!!.filepath)
  */
                try {
                    mContext.startActivity(
                        Intent(
                            Intent.ACTION_VIEW,
                            Uri.parse((mContext as DashboardActivity).studentDetail.data?.hostelBillUrl)
                        )
                    );

                } catch (e: ActivityNotFoundException) {


                }
            }

            val hostelBillId = (mContext as DashboardActivity).studentDetail.data?.hostelBillId
            if (
                (hostelBillId?.fullPaymentReceived == true) &&
                (hostelBillId.totalPayable!! <= 0)
            ) {
                dataBinding.tvPayBillHostel.text = "Paid"
                dataBinding.tvPayBillHostel.setTextColor(
                    ContextCompat.getColor(
                        mContext,
                        R.color.red
                    )
                )
            }


        } else {

            dataBinding.cvHostelFee.visibility = View.GONE
        }
    }

    @SuppressLint("SetTextI18n")
    public fun updateViewForStaff() {
        if ((mContext as DashboardActivity).staffDetail.data?.transportBillId?.installment != null &&
            (mContext as DashboardActivity).staffDetail.data?.transportBillId?.installment?.size!! > 0
        ) {

            dataBinding.cvTransportFee.visibility = View.VISIBLE
            val listForFee =
                (mContext as DashboardActivity).staffDetail.data?.transportBillId?.installment

            for (value in listForFee!!) {

                if (value.installmentType.toString().toLowerCase().equals("current")) {

                    dataBinding.tvBusPayment.text = value.instNo
                    dataBinding.tvBusAmount.text = "₹" + value.amount.toString()
                    dataBinding.tvBusDueAmount.text = "₹" + value.amountPayble.toString()

                    if (value.amountPayble > 0) {
                        dataBinding.tvBusPayBill.visibility = VISIBLE
                    } else {
                        dataBinding.tvBusPayBill.visibility = GONE

                    }
                }

                /*  val sdf = SimpleDateFormat("dd-MM-yyyy")

                  val dateArr = value.date?.split("--").toTypedArray()

                  val startDate: Date = sdf.parse(dateArr[0])
                  val endDate: Date = sdf.parse(dateArr[1])
                  //  val date: Date = sdf.parse("02-07-2020")
                  val date = Date()

                  if (date.after(startDate) && date.before(endDate)) {

                      dataBinding.tvBusPayment.text = value.instNo
                      dataBinding.tvBusAmount.text = "₹" + value.amount.toString()
                      dataBinding.tvBusDueAmount.text = "₹" + value.amountPayble.toString()

                  }*/
            }



            dataBinding.tvBusViewBill.setOnClickListener {

                /*  val pdfLink =
                      Uri.parse((mContext as DashboardActivity).studentDetail.data?.feeBillId!!.filepath)
  */
                try {
                    mContext.startActivity(
                        Intent(
                            Intent.ACTION_VIEW,
                            Uri.parse((mContext as DashboardActivity).staffDetail.data?.transportBillId!!.filepath)
                        )
                    );

                } catch (e: ActivityNotFoundException) {


                }
            }

            val transportBillId = (mContext as DashboardActivity).staffDetail.data?.transportBillId
            if (
                (transportBillId?.fullPaymentReceived == true) &&
                (transportBillId.payable <= 0)
            ) {
                dataBinding.tvBusPayBill.text = "Paid"
                dataBinding.tvBusPayBill.setTextColor(ContextCompat.getColor(mContext, R.color.red))
            }

        } else {

            dataBinding.cvTransportFee.visibility = View.GONE
        }
    }

    override fun getLayoutID() = R.layout.fragment_fee

    override fun getViewModel() = FeeViewModel::class.java


    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        if (requestCode == 900) {
            (mContext as DashboardActivity).getStudentDetail();
        } else if (requestCode == 1000) {
            (mContext as DashboardActivity).getStaffDetail();

        }

    }
}
