package com.mountcarmelschools.ui.disciplinary.forstaff

import android.annotation.SuppressLint
import android.app.Activity
import android.app.Dialog
import android.content.Context
import android.graphics.Color
import android.graphics.drawable.ColorDrawable
import android.text.Editable
import android.text.Html
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
import com.mountcarmelschools.di.data.disciplinaryCard.DisciplinaryPostDataItem
import com.mountcarmelschools.di.data.staff.wiseStudentList.WiseListFromClassResponse
import com.mountcarmelschools.di.data.wise.wiseRes.WisePostData
import com.mountcarmelschools.ui.wise.wiseInterface


class DisciplinaryForStaffAdapter(
    private val mContext: Context,
    private var list: ArrayList<WiseListFromClassResponse.Data?>,
    private var mPath: String,
    private var mDate: String,
    private val mSelectedList: ArrayList<DisciplinaryPostDataItem>,
    private val mDisciplinaryInterface: DisciplinaryInterface


) : RecyclerView.Adapter<DisciplinaryForStaffAdapter.ViewHolder>(), Filterable {

    private var mListFiltered = ArrayList<WiseListFromClassResponse.Data?>();

    init {
        mListFiltered.addAll(list)
    }


    class ViewHolder(inflater: LayoutInflater, parent: ViewGroup) : RecyclerView.ViewHolder(
        inflater.inflate(
            R.layout.row_staff_disciplinary_adapter, parent, false
        )
    ) {


        private var tvRed: LinearLayout? = null
        private var tvWarning: LinearLayout? = null
        private var tvTardy: LinearLayout? = null

        private var pinkCardCountTextView: TextView? = null
        private var yellowCardCountTextView: TextView? = null
        private var redCardCountTextView: TextView? = null
        private var iv_student_image: ImageView? = null
        private var tvStudentName: TextView? = null
        private var tvSerialNo: TextView? = null
        private var tv_serial_no: TextView? = null
        private var redCheckBox: CheckBox? = null
        private var tardyCheckBox: CheckBox? = null
        private var warningCheckBox: CheckBox? = null

        init {
            tv_serial_no = itemView.findViewById(R.id.tv_serial_no)
            tvWarning = itemView.findViewById(R.id.tv_warning)
            tvRed = itemView.findViewById(R.id.tv_red)
            tvTardy = itemView.findViewById(R.id.tv_tardy)

            pinkCardCountTextView = itemView.findViewById<TextView>(R.id.pinkTextView)
            yellowCardCountTextView = itemView.findViewById<TextView>(R.id.yellowCard)
            redCardCountTextView = itemView.findViewById<TextView>(R.id.redCard)

            iv_student_image = itemView.findViewById(R.id.iv_student_image)
            tvSerialNo = itemView.findViewById(R.id.tv_student_roll_no)
            tvStudentName = itemView.findViewById(R.id.tv_student_name)
            redCheckBox = itemView.findViewById(R.id.redCheckBox)
            tardyCheckBox = itemView.findViewById(R.id.tardyCheckBox)
            warningCheckBox = itemView.findViewById(R.id.warningCheckBox)

        }

        @SuppressLint("SetTextI18n")
        fun bind(
            context: Context,
            data: WiseListFromClassResponse.Data?,
            path: String,
            date: String,
            disciplinaryInterface: DisciplinaryInterface,
            selectedList: ArrayList<DisciplinaryPostDataItem>

        ) {

            tv_serial_no!!.setText("" + (adapterPosition + 1))

            val pinkHtml = "( <b>" + data?.disciplinary?.pink.toString() + "</b> )"
            pinkCardCountTextView?.text = Html.fromHtml(pinkHtml, Html.FROM_HTML_MODE_COMPACT)


            val yellowHtml = "( <b>" + data?.disciplinary?.yellow.toString() + "</b> )"
            yellowCardCountTextView?.text = Html.fromHtml(yellowHtml, Html.FROM_HTML_MODE_COMPACT)

            val redHtml = "( <b>" + data?.disciplinary?.red.toString() + "</b> )"
            redCardCountTextView?.text = Html.fromHtml(redHtml, Html.FROM_HTML_MODE_COMPACT)

            tvStudentName?.text = data?.name
            Glide.with(context).load(path + data?.profilePic)
                .diskCacheStrategy(DiskCacheStrategy.RESOURCE).error(R.drawable.default_image)
                .into(iv_student_image!!)

            tvSerialNo?.text = data?.admissionNo


            if (selectedList.size > 0) {
                if (isContain(data?.admissionNo, selectedList)) {

                    for (value in selectedList) {
                        if (value.admissionNo!! == data?.admissionNo) {

                            if (value.pink == 1) {

                                warningCheckBox!!.isChecked = true
                                tardyCheckBox!!.isChecked = false
                                redCheckBox!!.isChecked = false
                            } else if (value.yellow == 1) {

                                warningCheckBox!!.isChecked = false
                                tardyCheckBox!!.isChecked = true
                                redCheckBox!!.isChecked = false

                            } else if (value.red == 1) {

                                warningCheckBox!!.isChecked = false
                                tardyCheckBox!!.isChecked = false
                                redCheckBox!!.isChecked = true
                            } else {

                                warningCheckBox!!.isChecked = false
                                tardyCheckBox!!.isChecked = false
                                redCheckBox!!.isChecked = false
                            }

                        }

                    }

                } else {
                    warningCheckBox!!.isChecked = false
                    tardyCheckBox!!.isChecked = false
                    redCheckBox!!.isChecked = false
                }
            } else {
                warningCheckBox!!.isChecked = false
                tardyCheckBox!!.isChecked = false
                redCheckBox!!.isChecked = false
            }


            tvWarning?.setOnClickListener {
                if (warningCheckBox!!.isChecked) {
                    warningCheckBox!!.isChecked = false
                    if (selectedList.size > 0) {
                        disciplinaryInterface.removeData(data!!.admissionNo!!)
                    }
                } else if (isContain(data!!.admissionNo, selectedList)) {
                    if (selectedList.size > 0) {
                        disciplinaryInterface.removeData(data.admissionNo!!)
                    }
                    disciplinaryInterface.showDetailDialog("PINK", data)
                } else {
                    disciplinaryInterface.showDetailDialog("PINK", data)

                }

            }


            tvTardy?.setOnClickListener {
                if (tardyCheckBox!!.isChecked) {
                    tardyCheckBox!!.isChecked = false
                    if (selectedList.size > 0) {
                        disciplinaryInterface.removeData(data!!.admissionNo!!)
                    }
                } else if (isContain(data!!.admissionNo, selectedList)) {
                    if (selectedList.size > 0) {
                        disciplinaryInterface.removeData(data.admissionNo!!)
                    }
                    disciplinaryInterface.showDetailDialog("YELLOW", data)
                } else {
                    disciplinaryInterface.showDetailDialog("YELLOW", data)
                }
            }

            tvRed?.setOnClickListener {

                if (redCheckBox!!.isChecked) {
                    redCheckBox!!.isChecked = false
                    if (selectedList.size > 0) {
                        disciplinaryInterface.removeData(data!!.admissionNo!!)
                    }
                } else if (isContain(data!!.admissionNo, selectedList)) {
                    if (selectedList.size > 0) {
                        disciplinaryInterface.removeData(data.admissionNo!!)
                    }
                    disciplinaryInterface.showDetailDialog("RED", data)
                } else {
                    disciplinaryInterface.showDetailDialog("RED", data)
                }
            }

        }

        private fun isContain(
            admissionNo: String?, selectedList: ArrayList<DisciplinaryPostDataItem>
        ): Boolean {
            if (selectedList.size > 0) {

                for (value in selectedList) {
                    if (value.admissionNo!! == admissionNo) {
                        return true
                    }
                }

            } else {
                return false
            }
            return false
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

        holder.bind(
            mContext,
            mListFiltered.get(position),
            mPath,
            mDate,
            mDisciplinaryInterface,
            mSelectedList
        )

    }

    public fun update(mList: ArrayList<DisciplinaryPostDataItem>) {

        mSelectedList.clear()

        mSelectedList.addAll(mList)

        notifyDataSetChanged()
    }

    public fun updateAllData(data: List<WiseListFromClassResponse.Data?> ,path: String, date: String) {

        list.clear();
        mListFiltered.clear();
        list.addAll(data)
        mListFiltered.addAll(list)

        mPath=path;
        mDate = date

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
                                .contains(charString.toLowerCase()) || row.admissionNo!!.toLowerCase()
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
