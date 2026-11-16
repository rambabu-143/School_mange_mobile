package com.mountcarmelschools.ui.attendance.termAttendance

import android.annotation.SuppressLint
import android.content.Context
import android.view.LayoutInflater
import android.view.ViewGroup
import android.widget.Filter
import android.widget.Filterable
import android.widget.ImageView
import android.widget.TextView
import androidx.core.content.ContextCompat
import androidx.recyclerview.widget.RecyclerView
import com.bumptech.glide.Glide
import com.bumptech.glide.load.engine.DiskCacheStrategy
import com.mountcarmelschools.R
import com.mountcarmelschools.di.data.staff.termAttandance.TermAttandanceResponse
import com.mountcarmelschools.utlis.Utils
import java.text.DecimalFormat

class AttendanceDayEntryAdapter(
    private val mContext: Context,
    private val list: List<TermAttandanceResponse.Data?>?,
    private val mPath: String
) :
    RecyclerView.Adapter<AttendanceDayEntryAdapter.ViewHolder>(), Filterable {


    private var mListFiltered = ArrayList<TermAttandanceResponse.Data?>()

    init {
        mListFiltered.clear()
        mListFiltered.addAll(list!!)
    }


    override fun getItemCount(): Int {
        return mListFiltered!!.size
    }

    class ViewHolder(inflater: LayoutInflater, parent: ViewGroup) :
        RecyclerView.ViewHolder(inflater.inflate(R.layout.row_attendance_day, parent, false)) {
        private var mTitleView: TextView? = null
        private var mRollNo: TextView? = null
        private var mTotalPresent: TextView? = null
        private var tv_serial_no: TextView? = null
        private var tv_pre: TextView? = null
        private var mProfileImage: ImageView? = null


        init {
            mProfileImage = itemView.findViewById(R.id.iv_student_image)
            mTitleView = itemView.findViewById(R.id.tv_student_name)
            mRollNo = itemView.findViewById(R.id.tv_student_roll_no)
            tv_serial_no = itemView.findViewById(R.id.tv_serial_no)
            mTotalPresent = itemView.findViewById(R.id.tv_presnt_total)
            tv_pre = itemView.findViewById(R.id.tv_pre)

        }

        @SuppressLint("SetTextI18n")
        fun bind(list: TermAttandanceResponse.Data?, mContext: Context, mPath: String) {

            Glide.with(mContext)
                .load(mPath + list?.profilePic)
                .error(R.drawable.default_image)
                .diskCacheStrategy(DiskCacheStrategy.RESOURCE)
                .into(mProfileImage!!)

            if (list?.date_of_withdrawal != null) {
                val date = Utils.formattedDateFromString(
                    "",
                    "dd-MM-yyyy",
                    list.date_of_withdrawal
                )
                mTitleView?.text = list.name + "\n(DOW:" + date + ")"
                mTitleView!!.setTextColor(ContextCompat.getColor(mContext, R.color.red))
                mRollNo!!.setTextColor(ContextCompat.getColor(mContext, R.color.red))

            } else {
                mTitleView?.text = list?.name
                mTitleView!!.setTextColor(ContextCompat.getColor(mContext, R.color.black))
                mRollNo!!.setTextColor(ContextCompat.getColor(mContext, R.color.black))

            }

            mRollNo?.text = list?.admissionNo

            tv_serial_no?.text = (adapterPosition + 1).toString()

            var totalPresent = if (list?.attendanceData?.totalPresent!!.toString().contains(".0")) {
                list.attendanceData.totalPresent.toInt().toString()
            } else {
                list.attendanceData.totalPresent.toString()

            }

            mTotalPresent?.text =
                "" + (list.attendanceData.totalDays?.toInt()) + "/" + totalPresent



            if (list.attendanceData.totalPresent != 0.0 && list.attendanceData.totalPresent != 0.0) {
                val totalPercentage = calculatePercentage(
                    list.attendanceData.totalPresent,
                    list.attendanceData.totalDays
                )?.let {
                    it
                }

                if (totalPercentage.toString().contains(".")) {
                    tv_pre?.text = DecimalFormat("##.##").format(totalPercentage) + "%"

                } else {
                    tv_pre?.text = "$totalPercentage%";

                }
            } else {
                tv_pre?.text = "0%";

            }
        }

        private fun calculatePercentage(obtained: Double?, total: Double?): Double? {
            return obtained!! * 100 / total!!

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
        holder.bind(mListFiltered.get(position), mContext, mPath)

    }

    override fun getFilter(): Filter {
        return object : Filter() {
            override fun performFiltering(charSequence: CharSequence): FilterResults {
                val charString = charSequence.toString()
                if (charString.isEmpty()) {
                    mListFiltered.clear()
                    mListFiltered.addAll(list!!)
                } else {
                    val filteredList: MutableList<TermAttandanceResponse.Data?> =
                        java.util.ArrayList<TermAttandanceResponse.Data?>()
                    for (row in list!!) {

                        // name match condition. this might differ depending on your requirement
                        // here we are looking for name or phone number match
                        if (row?.name!!.toLowerCase().contains(charString.toLowerCase())
                            || row?.admissionNo!!.toLowerCase().contains(charString.toLowerCase())
                        ) {
                            filteredList.add(row)
                        }
                    }
                    mListFiltered.clear()
                    mListFiltered.addAll(filteredList)

                }
                val filterResults = FilterResults()
                filterResults.values = mListFiltered
                return filterResults
            }

            override fun publishResults(
                charSequence: CharSequence,
                filterResults: FilterResults
            ) {
                mListFiltered =
                    filterResults.values as java.util.ArrayList<TermAttandanceResponse.Data?>
                notifyDataSetChanged()
            }
        }

    }


}


