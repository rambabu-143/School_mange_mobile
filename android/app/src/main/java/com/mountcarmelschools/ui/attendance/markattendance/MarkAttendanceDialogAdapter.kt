package com.mountcarmelschools.ui.attendance.markattendance

import android.annotation.SuppressLint
import android.content.Context
import android.graphics.Color
import android.os.Handler
import android.text.Editable
import android.text.TextWatcher
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.View.GONE
import android.view.View.VISIBLE
import android.view.ViewGroup
import android.view.inputmethod.EditorInfo
import android.widget.AdapterView
import android.widget.ArrayAdapter
import android.widget.EditText
import android.widget.ImageView
import android.widget.Spinner
import android.widget.TextView
import androidx.cardview.widget.CardView
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.recyclerview.widget.RecyclerView
import com.bumptech.glide.Glide
import com.bumptech.glide.load.engine.DiskCacheStrategy
import com.mountcarmelschools.R
import com.mountcarmelschools.di.data.staff.markAttandance.MarkAttendanceResponse


class MarkAttendanceDialogAdapter(
    private val mContext: Context,
    private val items: ArrayList<MarkAttendanceResponse.Data?>,
    private val mPath: String,
    private val mInterface: DialogInterface,
    private val reason: ArrayList<String>

) : RecyclerView.Adapter<MarkAttendanceDialogAdapter.ViewHolder>() {

    class ViewHolder(inflater: LayoutInflater, parent: ViewGroup) :
        RecyclerView.ViewHolder(
            inflater.inflate(
                R.layout.markattendance_dialog_adapterview,
                parent,
                false
            )
        ) {
        private var cl_container: ConstraintLayout? = null
        private var tv_student_name: TextView? = null
        private var tv_student_roll_no: TextView? = null
        private var tv_serial_no: TextView? = null
        private var cbFirstHalf: ImageView? = null
        private var cbSecondHalf: ImageView? = null
        private var mImageView: ImageView? = null
        private var information: Spinner? = null
        private var reasonSpinner: Spinner? = null
        private var otherLayout: CardView? = null
        private var others: EditText? = null
        private val mHandler: Handler = Handler()


        init {
            cl_container = itemView.findViewById(R.id.container)
            tv_student_name = itemView.findViewById(R.id.tv_student_name)
            tv_student_roll_no = itemView.findViewById(R.id.tv_student_roll_no)
            tv_serial_no = itemView.findViewById(R.id.tv_serial_no)
            mImageView = itemView.findViewById(R.id.iv_student_image)
            cbFirstHalf = itemView.findViewById(R.id.cb_first_half)
            cbSecondHalf = itemView.findViewById(R.id.cb_second_half)
            information = itemView.findViewById(R.id.information)
            reasonSpinner = itemView.findViewById(R.id.reason)
            others = itemView.findViewById(R.id.others)
            otherLayout = itemView.findViewById(R.id.otherLayout)
        }

        @SuppressLint("SetTextI18n")
        fun bind(
            items: MarkAttendanceResponse.Data?,
            context: Context,
            path: String,
            mInterface: DialogInterface,
            reason: ArrayList<String>
        ) {

            try {
                tv_student_name?.text = items?.name

                tv_student_roll_no?.text = items?.admissionNo
                tv_serial_no?.text = (adapterPosition + 1).toString()


                Glide.with(context)
                    .load(path + items?.profilePic)
                    .diskCacheStrategy(DiskCacheStrategy.RESOURCE)
                    .error(R.drawable.default_image)
                    .into(mImageView!!)

                if (items?.first.equals("first")) {
                    cbFirstHalf?.setImageResource(R.drawable.checkbox_active)

                }
                if (items?.second.equals("second")) {
                    cbSecondHalf?.setImageResource(R.drawable.checkbox_active)

                }
                var infoArr = arrayOf("Information Received", "YES", "NO")

                var edit_information = false
                var edit_reason = false

                if (!items!!.information.equals("")) { //edit case
                    infoArr = arrayOf("YES", "NO")
                    edit_information = true
                }

                if (!items!!.reason.equals("")) { //edit case
                    edit_reason = true
                }


                // Create adapter and add in AutoCompleteTextView
                val adapter = ArrayAdapter(
                    context,
                    R.layout.selected_text_view, infoArr
                )
                val reasonAdapter = ArrayAdapter(
                    context,
                    R.layout.selected_text_view, reason
                )

                information?.adapter = adapter
                reasonSpinner?.adapter = reasonAdapter

                information?.onItemSelectedListener =
                    object : AdapterView.OnItemSelectedListener {
                        override fun onNothingSelected(parent: AdapterView<*>?) {

                        }

                        override fun onItemSelected(
                            parent: AdapterView<*>?,
                            view: View?,
                            position: Int,
                            id: Long
                        ) {
                            if (!infoArr[position].equals("Select information") && (position > 0 || edit_reason)) {
                                mInterface.selectedInfo(infoArr[position], items?.id.toString())
                            } else if (infoArr[position].equals("Select information")) {
                                mInterface.selectedInfo("", items?.id.toString())
                            }

                        }

                    }

                others!!.addTextChangedListener(object : TextWatcher {
                    override fun afterTextChanged(s: Editable) {
                        mInterface.enteredOtherReason(
                            s.toString(),
                            items.id.toString()
                        )
                    }

                    override fun beforeTextChanged(
                        s: CharSequence, start: Int,
                        count: Int, after: Int
                    ) {
                    }

                    override fun onTextChanged(
                        s: CharSequence, start: Int,
                        before: Int, count: Int
                    ) {

                    }
                })

                reasonSpinner?.onItemSelectedListener =
                    object : AdapterView.OnItemSelectedListener {
                        override fun onNothingSelected(parent: AdapterView<*>?) {

                        }

                        override fun onItemSelected(
                            parent: AdapterView<*>?,
                            view: View?,
                            position: Int,
                            id: Long
                        ) {
                            if (!reason[position].equals("Select Reason") && (position > 0 || edit_information)) {
                                if (reason[position].toString().lowercase().equals("others")) {

                                    otherLayout!!.visibility = VISIBLE

                                    others!!.setImeOptions(EditorInfo.IME_ACTION_DONE);

                                } else {
                                    otherLayout!!.visibility = GONE
                                }

                                mInterface.selectedReason(
                                    reason[position],
                                    items.id.toString()
                                )
                            } else if (reason[position].equals("Select Reason")) {
                                otherLayout!!.visibility = GONE

                                mInterface.selectedReason(
                                    "",
                                    items.id.toString()
                                )
                            }
                        }

                    }


                if (!items!!.information.equals("")) {
                    information!!.setSelection(infoArr.indexOf(items.information))
                }

                if (!items.reason.equals("")) {
                    reasonSpinner!!.setSelection(reason.indexOf(items.reason))
                }
                if (!items.others.equals("")) {
                    others!!.setText(items.others)
                }

                if (items.standardSectionId?.section == "W") {
                    val mutedRed = Color.argb(72, 255, 150, 150)
                    cl_container?.setBackgroundColor(mutedRed)
                    cl_container?.alpha = 0.6F
                    information?.isEnabled = false
                    reasonSpinner?.isEnabled = false

                } else if (items.isSectionChanged == true) {
                    val mutedOrange = Color.argb(72, 255, 200, 150)
                    cl_container?.setBackgroundColor(mutedOrange)
                    cl_container?.alpha = 0.6F
                    information?.isEnabled = false
                    reasonSpinner?.isEnabled = false
                }

                /*       cbFirstHalf?.setOnClickListener {

                       if (cbFirstHalf?.tag.toString().equals("unCheck")
                       ) {

                           cbFirstHalf?.tag = "check"
                           cbFirstHalf?.setImageResource(R.drawable.checkbox_active)
                           //     markAttendance.firstSelect(items?.id!!, true)

                       } else {
                           cbFirstHalf?.tag = "unCheck"

                           cbFirstHalf?.setImageResource(R.drawable.ic_white_checkbox)
                           //   markAttendance.firstSelect(items?.id!!, false)

                       }

                   }
                   cbSecondHalf?.setOnClickListener {

                       if (cbSecondHalf?.tag.toString().equals("unCheck")
                       ) {
                           cbSecondHalf?.tag = "check"

                           cbSecondHalf?.setImageResource(R.drawable.checkbox_active)
                           //  markAttendance.secondSelect(items?.id!!, true)

                       } else {
                           cbSecondHalf?.tag = "unCheck"

                           cbSecondHalf?.setImageResource(R.drawable.ic_white_checkbox)
                           //  markAttendance.secondSelect(items?.id!!, false)

                       }
                   }*/

            }catch (ex: Exception){
                //
                Log.e("ex", ex.message!!)
            }

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

    override fun getItemCount(): Int = items.size


    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        var reason_copy = ArrayList<String>()
        reason_copy.addAll(reason)
        /*   if (!items?.get(position)!!.reason.equals("")) { //edit case
               reason_copy.removeAt(0)
           }*/

        holder.bind(items.get(position), mContext, mPath, mInterface, reason_copy)

    }


}