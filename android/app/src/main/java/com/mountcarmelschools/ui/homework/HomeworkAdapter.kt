package com.mountcarmelschools.ui.homework

import android.content.Context
import android.text.Html
import android.text.method.LinkMovementMethod
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Filter
import android.widget.Filterable
import android.widget.ImageButton
import android.widget.LinearLayout
import android.widget.TextView
import androidx.core.content.ContextCompat
import androidx.core.text.HtmlCompat.FROM_HTML_MODE_LEGACY
import androidx.recyclerview.widget.RecyclerView
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.google.android.material.bottomsheet.BottomSheetDialog
import com.mountcarmelschools.R
import com.mountcarmelschools.di.data.homework.HomeworkResponse
import com.mountcarmelschools.utlis.Utils


class HomeworkAdapter(
    private val context: Context,
    val homeworkList: List<HomeworkResponse.Data>?,
) : RecyclerView.Adapter<HomeworkAdapter.ViewHolder>(), Filterable {
    private var mListFiltered = ArrayList<HomeworkResponse.Data>()

    init {
        mListFiltered.clear()
        mListFiltered.addAll(homeworkList!!)
    }

    class ViewHolder(val inflater: LayoutInflater, val parent: ViewGroup) : RecyclerView.ViewHolder(inflater.inflate(R.layout.row_homework, parent, false)) {
        private var homeworkDateTV: TextView? = null
        private var homeworkTextTV: TextView? = null
        private var teacherNameTV: TextView? = null
        private var attachmentContainerLL: LinearLayout? = null
        private var attachmentTV: TextView? = null

        init {
            homeworkTextTV = itemView.findViewById(R.id.homework_text)
            homeworkDateTV = itemView.findViewById(R.id.homework_date)
            teacherNameTV = itemView.findViewById(R.id.teacher_name)
            attachmentContainerLL = itemView.findViewById(R.id.homework_attachment_container)
            attachmentTV = itemView.findViewById(R.id.attachment)
        }

        fun bind(listItem: HomeworkResponse.Data?, mContext: Context) {
            listItem?.let { listItemData ->
                homeworkTextTV?.let { textview ->
                    listItemData.text?.let { homeworkText ->
                        textview.text = homeworkText
                        textview.setOnClickListener {
                            showBottomSheetDialog(homeworkText)
                        }
                    }
                }

                homeworkDateTV?.text = String.format(mContext.resources.getString(R.string.homework_assigned_on_date), Utils.formattedDateFromString(
                    "",
                    "MMM dd, yyyy",
                    listItemData.date
                ) ?: "")

                listItemData.sentByStaff.let {
                    if (it == null) {
                        teacherNameTV?.visibility = View.GONE
                    } else {
                        teacherNameTV?.visibility = View.VISIBLE
                        teacherNameTV?.text = String.format(mContext.resources.getString(R.string.homework_assigned_by), it.name)
                    }
                }

                listItemData.googleDriveLink.let {
                    if (it == null) {
                        attachmentContainerLL?.visibility = View.GONE
                    } else {
                        attachmentContainerLL?.visibility = View.VISIBLE

                        attachmentTV?.let { attachmentTV ->
                            val hyperlinkStr =
                                "<a href=\"${it}\">${listItemData.attachment ?: "Attachment"}</a>"

                            attachmentTV.text = Html.fromHtml(hyperlinkStr, FROM_HTML_MODE_LEGACY)
                            attachmentTV.movementMethod = LinkMovementMethod.getInstance()
                            attachmentTV.setLinkTextColor(ContextCompat.getColor(mContext, R.color.blue))
                        }
                    }
                }
            }
        }

        private fun showBottomSheetDialog(text: String) {
            val bottomSheetDialog = BottomSheetDialog(parent.context)
            bottomSheetDialog.behavior.state = BottomSheetBehavior.STATE_EXPANDED // opens bottom sheet in full screen mode if content is large enough
            bottomSheetDialog.behavior.isDraggable = false // this allows nested scrollview to work properly

            bottomSheetDialog.setContentView(R.layout.homework_text_bottom_sheet_layout)

            val textView = bottomSheetDialog.findViewById<TextView>(R.id.full_homework_text_view)
            textView?.text = text

            val closeButton = bottomSheetDialog.findViewById<ImageButton>(R.id.close_button)
            closeButton?.setOnClickListener {
                bottomSheetDialog.hide()
            }

            bottomSheetDialog.show()
        }
    }

    override fun getItemId(position: Int): Long {
        return position.toLong()
    }

//    override fun getItemViewType(position: Int): Int {
//        return position
//    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val inflater = LayoutInflater.from(parent.context)
        return ViewHolder(inflater, parent)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        holder.bind(mListFiltered[position], context)
    }

    override fun getItemCount(): Int {
        return mListFiltered.size
    }

    override fun getFilter(): Filter {
        return object : Filter() {
            override fun performFiltering(charSequence: CharSequence): FilterResults {
                val charString = charSequence.toString()
                if (charString.isEmpty()) {
                    mListFiltered.clear()
                    mListFiltered.addAll(homeworkList!!)
                } else {
                    val lowercaseCharString = charString.lowercase()
                    val filteredList = homeworkList!!.filter {
                        (
                            it.text?.lowercase()?.contains(lowercaseCharString) == true ||
                            it.sentByStaff?.name?.lowercase()?.contains(lowercaseCharString) == true ||
                            it.attachment?.lowercase()?.contains(lowercaseCharString) == true
                        )
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
                mListFiltered = filterResults.values as ArrayList<HomeworkResponse.Data>
                notifyDataSetChanged()
            }
        }
    }
}
