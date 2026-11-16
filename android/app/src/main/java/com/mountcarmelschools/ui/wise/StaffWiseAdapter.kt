package com.mountcarmelschools.ui.wise

import android.annotation.SuppressLint
import android.app.Activity
import android.app.Dialog
import android.content.Context
import android.graphics.Color
import android.graphics.drawable.ColorDrawable
import android.text.Editable
import android.text.Selection
import android.text.TextWatcher
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.Window
import android.view.inputmethod.InputMethodManager
import android.widget.*
import androidx.recyclerview.widget.RecyclerView
import com.bumptech.glide.Glide
import com.bumptech.glide.load.engine.DiskCacheStrategy
import com.google.android.material.imageview.ShapeableImageView
import com.google.android.material.textview.MaterialTextView
import com.mountcarmelschools.R
import com.mountcarmelschools.di.data.staff.wiseStudentList.WiseListFromClassResponse
import com.mountcarmelschools.di.data.wise.wiseRes.WisePostData


class StaffWiseAdapter(
    private val mContext: Context,
    private val list: List<WiseListFromClassResponse.Data?>,
    private val mPath: String,
    private val mInterface: wiseInterface,
    private val mDate: String,
    private val mSelectedList: ArrayList<WisePostData>


) : RecyclerView.Adapter<StaffWiseAdapter.ViewHolder>(), Filterable {

    private var mListFiltered = ArrayList<WiseListFromClassResponse.Data?>();

    init {
        mListFiltered.addAll(list)
    }


    class ViewHolder(inflater: LayoutInflater, parent: ViewGroup) :
        RecyclerView.ViewHolder(inflater.inflate(R.layout.row_staff_wise, parent, false)) {


        private var tvWorthy: LinearLayout? = null
        private var tvIntellect: LinearLayout? = null
        private var tvStature: LinearLayout? = null
        private var tvEmotion: LinearLayout? = null
        private var iv_student_image: ImageView? = null
        private var tvStudentName: TextView? = null
        private var tvSerialNo: TextView? = null
        private var reasonText: TextView? = null
        private var tv_serial_no: TextView? = null
        private var worthyCheckBox: CheckBox? = null
        private var intellectCheckBox: CheckBox? = null
        private var statureCheckBox: CheckBox? = null
        private var emotionCheckBox: CheckBox? = null

        init {
            tvWorthy = itemView.findViewById(R.id.tv_worthy)
            tv_serial_no = itemView.findViewById(R.id.tv_serial_no)
            tvIntellect = itemView.findViewById(R.id.tv_intellect)
            tvStature = itemView.findViewById(R.id.tv_stature)
            tvEmotion = itemView.findViewById(R.id.tv_emotion)
            iv_student_image = itemView.findViewById(R.id.iv_student_image)
            tvSerialNo = itemView.findViewById(R.id.tv_student_roll_no)
            tvStudentName = itemView.findViewById(R.id.tv_student_name)
            reasonText = itemView.findViewById(R.id.reasonText)
            worthyCheckBox = itemView.findViewById(R.id.worthyCheckBox)
            intellectCheckBox = itemView.findViewById(R.id.intellectCheckBox)
            statureCheckBox = itemView.findViewById(R.id.statureCheckBox)
            emotionCheckBox = itemView.findViewById(R.id.emotionCheckBox)

        }

        @SuppressLint("SetTextI18n")
        fun bind(
            context: Context,
            data: WiseListFromClassResponse.Data?,
            path: String,
            wiseInterface: wiseInterface,
            date: String,
            selectedList: ArrayList<WisePostData>

        ) {

            tv_serial_no!!.setText("" + (adapterPosition + 1))


            if (selectedList.size > 0) {
                if (isContain(data?.admissionNo, selectedList)) {

                    for (value in selectedList) {
                        if (value.admissionNo!!.equals(data?.admissionNo)) {

                            if (value.type.equals("Worthy Card")) {
                                worthyCheckBox!!.isChecked = true
                                reasonText!!.visibility = View.VISIBLE

                                reasonText!!.text = value.reason
                            } else if (value.type.equals("Intellect Card")) {
                                intellectCheckBox!!.isChecked = true
                                reasonText!!.visibility = View.VISIBLE

                                reasonText!!.text = value.reason

                            } else if (value.type.equals("Stature Card")) {
                                statureCheckBox!!.isChecked = true

                                reasonText!!.visibility = View.VISIBLE

                                reasonText!!.text = value.reason
                            } else if (value.type.equals("Emotion Card")) {
                                emotionCheckBox!!.isChecked = true
                                reasonText!!.visibility = View.VISIBLE

                                reasonText!!.text = value.reason

                            }

                        }

                    }

                } else {
                    reasonText!!.visibility = View.GONE
                    worthyCheckBox!!.isChecked = false
                    intellectCheckBox!!.isChecked = false
                    statureCheckBox!!.isChecked = false
                    emotionCheckBox!!.isChecked = false
                }
            } else {
                reasonText!!.visibility = View.GONE
                worthyCheckBox!!.isChecked = false
                intellectCheckBox!!.isChecked = false
                statureCheckBox!!.isChecked = false
                emotionCheckBox!!.isChecked = false

            }

            tvWorthy?.setOnClickListener {
                if (worthyCheckBox!!.isChecked) {
                    worthyCheckBox!!.isChecked = false
                    if (selectedList.size > 0) {
                        wiseInterface.removeData(data!!.admissionNo!!)
                    }
                } else if (isContain(data!!.admissionNo, selectedList)) {
                    if (selectedList.size > 0) {
                        wiseInterface.removeData(data!!.admissionNo!!)
                    }
                    showNoteDialog("Worthy Card", context, data, wiseInterface, date)
                } else {
                    showNoteDialog("Worthy Card", context, data, wiseInterface, date)
                }
            }


            tvIntellect?.setOnClickListener {
                if (intellectCheckBox!!.isChecked) {
                    intellectCheckBox!!.isChecked = false
                    if (selectedList.size > 0) {
                        wiseInterface.removeData(data!!.admissionNo!!)
                    }
                } else if (isContain(data!!.admissionNo, selectedList)) {
                    if (selectedList.size > 0) {
                        wiseInterface.removeData(data!!.admissionNo!!)
                    }
                    showNoteDialog("Intellect Card", context, data, wiseInterface, date)

                } else {
                    showNoteDialog("Intellect Card", context, data, wiseInterface, date)
                    //dataBinding.intellectCheckBox.isChecked = true

                }
            }

            tvStature?.setOnClickListener {
                if (statureCheckBox!!.isChecked) {
                    statureCheckBox!!.isChecked = false
                    if (selectedList.size > 0) {
                        wiseInterface.removeData(data!!.admissionNo!!)
                    }
                } else if (isContain(data!!.admissionNo, selectedList)) {

                    if (selectedList.size > 0) {
                        wiseInterface.removeData(data!!.admissionNo!!)
                    }
                    showNoteDialog("Stature Card", context, data, wiseInterface, date)
                } else {
                    showNoteDialog("Stature Card", context, data, wiseInterface, date)
                }
                //dataBinding.statureCheckBox.isChecked = true

            }

            tvEmotion?.setOnClickListener {
                if (emotionCheckBox!!.isChecked) {
                    emotionCheckBox!!.isChecked = false
                    if (selectedList.size > 0) {
                        wiseInterface.removeData(data!!.admissionNo!!)
                    }
                } else if (isContain(data!!.admissionNo, selectedList)) {
                    if (selectedList.size > 0) {
                        wiseInterface.removeData(data!!.admissionNo!!)
                    }
                    showNoteDialog("Emotion Card", context, data, wiseInterface, date)
                } else {
                    showNoteDialog("Emotion Card", context, data, wiseInterface, date)

                }
                //  dataBinding.emotionCheckBox.isChecked = true

            }

            tvStudentName?.text = data?.name
            Glide.with(context).load(path + data?.profilePic)
                .diskCacheStrategy(DiskCacheStrategy.RESOURCE).error(R.drawable.default_image)
                .into(iv_student_image!!)

            tvSerialNo?.text = data?.admissionNo


        }

        private fun isContain(
            admissionNo: String?, selectedList: ArrayList<WisePostData>
        ): Boolean {
            if (selectedList.size > 0) {

                for (value in selectedList) {
                    if (value.admissionNo!!.equals(admissionNo)) {
                        return true
                    }
                }

            } else {
                return false
            }
            return false
        }

        private fun showNoteDialog(
            header: String,
            mContext: Context,
            data: WiseListFromClassResponse.Data?,
            wiseInterface: wiseInterface,
            date: String

        ) {
            val customProgressDialog = Dialog(mContext)
            customProgressDialog.setContentView(R.layout.custome_staff_dialog)
            customProgressDialog.window!!.setBackgroundDrawable(
                ColorDrawable(Color.TRANSPARENT)
            )


            val window: Window = customProgressDialog.getWindow()!!

            window.setLayout(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT
            )


            val title = customProgressDialog.findViewById(R.id.tv_header) as MaterialTextView
            val textView6 = customProgressDialog.findViewById(R.id.textView6) as TextView
            val editText = customProgressDialog.findViewById(R.id.edt_reason) as EditText
            val ok = customProgressDialog.findViewById(R.id.ok) as Button
            title.text = header
            val close = customProgressDialog.findViewById(R.id.iv_close) as ShapeableImageView


            editText.requestFocus()
            val imm: InputMethodManager =
                mContext.getSystemService(Activity.INPUT_METHOD_SERVICE) as InputMethodManager
            imm.toggleSoftInput(InputMethodManager.SHOW_FORCED, 0)

            editText.addTextChangedListener(object : TextWatcher {
                override fun beforeTextChanged(
                    s: CharSequence, start: Int, count: Int, after: Int
                ) {
                }

                override fun onTextChanged(
                    s: CharSequence, start: Int, before: Int, count: Int
                ) {

                }

                override fun afterTextChanged(s: Editable) {
                    if (!s.toString().startsWith("For ")) {
                        editText.setText("For ");
                        Selection.setSelection(editText.getText(), editText.getText().length);

                    }
                    textView6.setText((s.toString().length - 3).toString() + "/80")
                }
            })

            close.setOnClickListener {
                customProgressDialog.dismiss()
                customProgressDialog.cancel()
            }

            ok.setOnClickListener {
                if (editText.text.toString().equals("For ")) {
                    customProgressDialog.dismiss()
                    customProgressDialog.cancel()
                } else {
                    var postData = WisePostData(
                        data!!.admissionNo,
                        editText.text.toString(),
                        data.id!!.toString(),
                        date,
                        header
                    )
                    customProgressDialog.dismiss()
                    customProgressDialog.cancel()

                    wiseInterface.addData(postData)
                }
            }
            try {

                customProgressDialog.show()
            } catch (e: Exception) {

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

    override fun getItemCount(): Int = mListFiltered.size


    override fun onBindViewHolder(holder: ViewHolder, position: Int) {

        holder.bind(mContext, mListFiltered.get(position), mPath, mInterface, mDate, mSelectedList)

    }

    public fun update(mList: ArrayList<WisePostData>) {

        mSelectedList.clear()

        mSelectedList.addAll(mList)

        notifyDataSetChanged()
    }


    override fun getFilter(): Filter {

        return object : Filter() {
            override fun performFiltering(charSequence: CharSequence): FilterResults {
                val charString = charSequence.toString()
                if (charString.isEmpty()) {
                    mListFiltered.addAll(list)
                } else {
                    val filteredList: MutableList<WiseListFromClassResponse.Data?> =
                        java.util.ArrayList<WiseListFromClassResponse.Data?>()
                    for (row in list!!) {

                        // name match condition. this might differ depending on your requirement
                        // here we are looking for name or phone number match
                        if (row?.name!!.toLowerCase()
                                .contains(charString.toLowerCase())
                            || row.admissionNo!!.toLowerCase()
                                .contains(charString.toLowerCase())
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
                charSequence: CharSequence, filterResults: FilterResults
            ) {
                mListFiltered =
                    filterResults.values as java.util.ArrayList<WiseListFromClassResponse.Data?>
                notifyDataSetChanged()
            }
        }
    }


}
