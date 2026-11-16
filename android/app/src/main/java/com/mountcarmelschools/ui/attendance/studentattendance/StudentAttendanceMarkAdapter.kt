package com.mountcarmelschools.ui.attendance.studentattendance

import android.annotation.SuppressLint
import android.content.Context
import android.graphics.Color
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Filter
import android.widget.Filterable
import android.widget.ImageView
import android.widget.TextView
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.recyclerview.widget.RecyclerView
import com.bumptech.glide.Glide
import com.bumptech.glide.load.engine.DiskCacheStrategy
import com.mountcarmelschools.R
import com.mountcarmelschools.di.data.staff.houseList.HouseListResponse
import com.mountcarmelschools.di.data.staff.markAttandance.MarkAttendanceResponse
import com.mountcarmelschools.ui.attendance.markattendance.MarkAttendanceInterface

class StudentAttendanceMarkAdapter(
    public val mContext: Context,
    private val student: MutableList<MarkAttendanceResponse.Data?>,
    private val houseList: List<HouseListResponse.Data>,
    var check: Int,
    val path: String,
    val markAttendance: MarkAttendanceInterface

) : RecyclerView.Adapter<StudentAttendanceMarkAdapter.ViewHolder>() , Filterable {


    private var mListFiltered = ArrayList<MarkAttendanceResponse.Data?>()

    init {
        mListFiltered.addAll(student)
    }


    class ViewHolder(inflater: LayoutInflater, parent: ViewGroup) :
        RecyclerView.ViewHolder(inflater.inflate(R.layout.row_staff_attendance, parent, false)) {
        private var tv_student_name: TextView? = null
        private var house_name: TextView? = null
        private var tv_student_roll_no: TextView? = null
        private var tv_serial_no: TextView? = null
        private var cbFirstHalf: ImageView? = null
        private var cbSecondHalf: ImageView? = null
        private var mImageView: ImageView? = null
        private var parentLayout: ConstraintLayout? = null


        init {
            tv_student_name = itemView.findViewById(R.id.tv_student_name)
            tv_student_roll_no = itemView.findViewById(R.id.tv_student_roll_no)
            tv_serial_no = itemView.findViewById(R.id.tv_serial_no)
            mImageView = itemView.findViewById(R.id.iv_student_image)
            cbFirstHalf = itemView.findViewById(R.id.cb_first_half)
            cbSecondHalf = itemView.findViewById(R.id.cb_second_half)
            house_name = itemView.findViewById(R.id.house_name)
            parentLayout = itemView.findViewById(R.id.parentLayout)
        }

        @SuppressLint("SetTextI18n")
        fun bind(
            items: MarkAttendanceResponse.Data?, position: Int,
            context: Context,
            path: String,
            markAttendance: MarkAttendanceInterface
        ) {

            tv_student_name?.text = items?.name

            tv_student_roll_no?.text = items?.admissionNo
            tv_serial_no?.text = (position + 1).toString()


            Glide.with(context)
                .load(path + items?.profilePic)
                .diskCacheStrategy(DiskCacheStrategy.RESOURCE)
                .error(R.drawable.default_image)
                .into(mImageView!!)


            if (items!!.first.equals("first")) {
                cbFirstHalf?.tag = "check"
                cbFirstHalf?.setImageResource(R.drawable.checkbox_active)
            } else {
                cbFirstHalf?.tag = "unCheck"

                cbFirstHalf?.setImageResource(R.drawable.ic_white_checkbox)
            }


            if (items.second.equals("second")) {

                cbSecondHalf?.tag = "check"

                cbSecondHalf?.setImageResource(R.drawable.checkbox_active)
            } else {
                cbSecondHalf?.tag = "unCheck"

                cbSecondHalf?.setImageResource(R.drawable.ic_white_checkbox)

            }

            /*  if (items!!.first.equals("first") && items!!.first.equals("second")) {
                  cbFirstHalf?.tag = "check"
                  cbFirstHalf?.setImageResource(R.drawable.checkbox_active)
                  cbSecondHalf?.tag = "check"

                  cbSecondHalf?.setImageResource(R.drawable.checkbox_active)
              }*/

            cbFirstHalf?.setOnClickListener {

                if (cbFirstHalf?.tag.toString().equals("unCheck")
                ) {

                    cbFirstHalf?.tag = "check"
                    cbFirstHalf?.setImageResource(R.drawable.checkbox_active)
                    markAttendance.firstSelect(items?.id!!, true)

                } else {
                    cbFirstHalf?.tag = "unCheck"

                    cbFirstHalf?.setImageResource(R.drawable.ic_white_checkbox)
                    markAttendance.firstSelect(items?.id!!, false)

                }

            }
            cbSecondHalf?.setOnClickListener {

                if (cbSecondHalf?.tag.toString().equals("unCheck")
                ) {
                    cbSecondHalf?.tag = "check"

                    cbSecondHalf?.setImageResource(R.drawable.checkbox_active)
                    markAttendance.secondSelect(items?.id!!, true)

                } else {
                    cbSecondHalf?.tag = "unCheck"

                    cbSecondHalf?.setImageResource(R.drawable.ic_white_checkbox)
                    markAttendance.secondSelect(items?.id!!, false)

                }
            }

            if (items.standardSectionId?.section.equals("W")) {
                val mutedRed = Color.argb(72, 255, 150, 150)
                parentLayout?.setBackgroundColor(mutedRed)
                parentLayout?.alpha = 0.5F
                cbFirstHalf?.isEnabled = false
                cbSecondHalf?.isEnabled = false
            } else if (items.isSectionChanged == true) {
                val mutedOrange = Color.argb(72, 255, 200, 150)
                parentLayout?.setBackgroundColor(mutedOrange)
                parentLayout?.alpha = 0.5F
                cbFirstHalf?.isEnabled = false
                cbSecondHalf?.isEnabled = false
            } else {
                parentLayout?.setBackgroundColor(Color.TRANSPARENT)
                parentLayout?.alpha = 1.0F
                cbFirstHalf?.isEnabled = true
                cbSecondHalf?.isEnabled = true
            }
        }

        fun bindHouseList(
            items: HouseListResponse.Data,
            position: Int,
            context: Context,
            path: String
        ) {
            tv_student_name?.text = items.name

            tv_student_roll_no?.text = items.admissionNo

            cbFirstHalf?.visibility = View.INVISIBLE
            cbSecondHalf?.visibility = View.INVISIBLE

            house_name?.visibility = View.VISIBLE
            house_name?.text = items.houseId?.houseNo

            tv_serial_no?.text = (position + 1).toString()


            Glide.with(context)
                .load(path + items.profilePic)
                .diskCacheStrategy(DiskCacheStrategy.RESOURCE)
                .error(R.drawable.default_image)
                .into(mImageView!!)

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

    override fun getItemCount(): Int {
        if (check == 2) {
            return houseList.size
        } else {
            return mListFiltered.size

        }
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {


        if (check == 2) {
            holder.bindHouseList(houseList.get(position), position, mContext, path)

        } else {
            holder.bind(mListFiltered.get(position), position, mContext, path, markAttendance)

        }

    }

    override fun getFilter(): Filter {
        return object : Filter() {
            override fun performFiltering(charSequence: CharSequence): FilterResults {
                val charString = charSequence.toString()
                if (charString.isEmpty()) {
                    mListFiltered.clear()
                    mListFiltered.addAll(student!!)
                } else {
                    val filteredList: MutableList<MarkAttendanceResponse.Data?> =
                        java.util.ArrayList<MarkAttendanceResponse.Data?>()
                    for (row in student!!) {

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
                    filterResults.values as java.util.ArrayList<MarkAttendanceResponse.Data?>
                notifyDataSetChanged()
            }
        }
    }

    fun updateData(mMarkStudentList: MutableList<MarkAttendanceResponse.Data?>) {

        student.clear()
        mListFiltered.clear()
        student.addAll(mMarkStudentList)
        mListFiltered.addAll(mMarkStudentList)
        notifyDataSetChanged()
    }
}


/*
BaseRecyclerAdapter<LoginResponse, RowStaffAttendanceBinding>() {

override fun getItemCount(): Int {
    if (check == 2) {
        return houseList.size
    } else {
        return student.size

    }
}

override fun onBindViewHolder(
    holder: Companion.BaseViewHolder<RowStaffAttendanceBinding>,
    position: Int
) {
    if (check != 0) {
        dataBinding.cbFirstHalf.visibility = View.GONE
        dataBinding.cbSecondHalf.visibility = View.GONE

        dataBinding.tvSerialNo.text = (position + 1).toString()

        dataBinding.tvStudentName.text = houseList.get(position).name

        dataBinding.tvStudentRollNo.text = houseList.get(position).admissionNo

        Glide.with(mContext)
            .load(path + houseList.get(position).profilePic)
            .diskCacheStrategy(DiskCacheStrategy.RESOURCE)
            .into(dataBinding.ivStudentImage)

    } else {
        /*   if (position == 0) {
               dataBinding.cbFirstHalf.setImageResource(R.drawable.checkbox_active)
               dataBinding.cbSecondHalf.setImageResource(R.drawable.checkbox_active)
           } else if (position == 1) {
               dataBinding.cbFirstHalf.setImageResource(R.drawable.checkbox_active)

           } else if (position == 2) {
               dataBinding.cbSecondHalf.setImageResource(R.drawable.checkbox_active)

           }*/
        dataBinding.tvSerialNo.text = (position + 1).toString()

        dataBinding.tvStudentName.text = student.get(position)?.name

        dataBinding.tvStudentRollNo.text = student.get(position)?.admissionNo

        Glide.with(mContext)
            .load(path + student.get(position)?.profilePic)
            .diskCacheStrategy(DiskCacheStrategy.RESOURCE)
            .into(dataBinding.ivStudentImage)

        dataBinding.cbFirstHalf.setOnClickListener {

            if (dataBinding.cbFirstHalf.getTag().toString().equals("unCheck")
            ) {

                dataBinding.cbFirstHalf.tag = "check"
                dataBinding.cbFirstHalf.setImageResource(R.drawable.checkbox_active)

            } else {
                dataBinding.cbFirstHalf.tag = "unCheck"

                dataBinding.cbFirstHalf.setImageResource(R.drawable.ic_white_checkbox)

            }

        }
        dataBinding.cbSecondHalf.setOnClickListener {

            if (dataBinding.cbSecondHalf.getTag().toString().equals("unCheck")
            ) {
                dataBinding.cbSecondHalf.tag = "check"

                dataBinding.cbSecondHalf.setImageResource(R.drawable.checkbox_active)

            } else {
                dataBinding.cbSecondHalf.tag = "unCheck"

                dataBinding.cbSecondHalf.setImageResource(R.drawable.ic_white_checkbox)

            }

        }
    }


}

override fun getLayoutInflater() = R.layout.row_staff_attendance

}
*/