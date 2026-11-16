package com.mountcarmelschools.ui.attendance.attendancesummary

import android.annotation.SuppressLint
import android.content.Context
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.TextView
import androidx.cardview.widget.CardView
import androidx.recyclerview.widget.RecyclerView
import com.mountcarmelschools.R
import com.mountcarmelschools.di.data.staff.attendanceSummery.AttendanceSummeryResponse
import com.mountcarmelschools.utlis.Utils

class AttendanceSummaryAdapter(
    public val mContext: Context,
    private val list: List<AttendanceSummeryResponse.Data?>?
) :
    RecyclerView.Adapter<AttendanceSummaryAdapter.ViewHolder>() {


    override fun getItemCount(): Int {
        return list!!.size
    }

    class ViewHolder(inflater: LayoutInflater, parent: ViewGroup) :
        RecyclerView.ViewHolder(inflater.inflate(R.layout.row_attendance_summary, parent, false)) {
        private var mTitleView: TextView? = null
        private var mDate: TextView? = null
        private var mLinearLayout: LinearLayout? = null
        private var mCardView: CardView? = null
        private var mDropdown: ImageView? = null


        init {
            mTitleView = itemView.findViewById(R.id.tv_label)
            mDate = itemView.findViewById(R.id.tv_time)
            mLinearLayout = itemView.findViewById(R.id.linearLayoutContainer)
            mCardView = itemView.findViewById(R.id.cardView)
            mDropdown = itemView.findViewById(R.id.iv_dropdown)
        }

        @SuppressLint("SetTextI18n")
        fun bind(list: AttendanceSummeryResponse.Data?, mContext: Context) =
            if (list!!.isAttendanceMarked!!) {
                Log.e("---------", list!!.standard + "--" + list.section)

                /*    mTitleView?.text =
                        list.standard.toString() + " " + list.section.toString() + " - " + list.students.count() + " Student absent out of " + list.totalStudent
    */
                mDate?.text =
                    Utils.formattedDateFromString(
                        "",
                        "dd-MM-yyyy '|' hh:mm a",
                        list.attendanceMarkedAt
                    )

                mDate?.visibility = View.VISIBLE

                mDropdown?.setOnClickListener {
                    if (list.students!!.count() > 0) {

                        if (mCardView?.visibility == View.VISIBLE) {
                            mCardView?.visibility = View.GONE
                            mDropdown?.setImageResource(R.drawable.ic_dropdown_arrow)

                        } else {
                            mCardView?.visibility = View.VISIBLE
                            mDropdown?.setImageResource(R.drawable.ic_arrow_up)

                        }
                    }

                }

                if (list.students!!.count() > 0) {
                    mLinearLayout!!.removeAllViews()
                    for (Student in list.students) {
                        val content =
                            LayoutInflater.from(mContext)
                                .inflate(R.layout.inflator_attendance_summary, null)

                        val tv_reason = content.findViewById<TextView>(R.id.tv_reason)
                        val tv_label = content.findViewById<TextView>(R.id.tv_label)
                        tv_label.text =
                            Student?.studentId?.admissionNo + "-" + Student?.studentId?.name


                        if (Student?.reason.toString().lowercase() == "others") {
                            if (Student?.value == 0.5) {
                                tv_reason.text = "Half Day" + " | " + Student.details
                            } else {
                                tv_reason.text = "Full Day" + " | " + Student?.details

                            }

                        } else {
                            if (Student?.value == 0.5) {
                                tv_reason.text = "Half Day" + if (Student.reason == ""
                                ) "" else " | " + Student.reason
                            } else {
                                tv_reason.text = "Full Day" + if (Student!!.reason == ""
                                ) "" else " | " + Student.reason
                            }
                        }
                        mLinearLayout?.apply {
                            addView(content)
                        }
                    }
                    mTitleView?.text =
                        list.standard.toString() + " " +
                                list.section.toString() + "  " +
                                list.students.count() + " absent /" +
                                list.totalStudent

                } else {

                    mTitleView?.text =
                        list?.standard.toString() + " " + list?.section.toString() + "  All present"

                }


            } else {
                Log.e("---------", list!!.standard + "--" + list.section)

                mTitleView?.text =
                    list?.standard.toString() + " " + list?.section.toString()

                mDate?.text = "Attendance Not Marked"
                mDate?.visibility = View.VISIBLE
            }
    }

    override fun getItemId(position: Int): Long {
        return position.toLong()
    }

    override fun getItemViewType(position: Int): Int {
        return position
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val inflater = LayoutInflater.from(parent.context)
        return ViewHolder(inflater, parent)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        holder.bind(list?.get(position), mContext)

    }

}
