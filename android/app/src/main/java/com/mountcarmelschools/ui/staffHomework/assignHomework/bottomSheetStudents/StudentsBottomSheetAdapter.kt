package com.mountcarmelschools.ui.staffHomework.assignHomework.bottomSheetStudents

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.CheckBox
import android.widget.Filter
import android.widget.Filterable
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.bumptech.glide.Glide
import com.bumptech.glide.load.engine.DiskCacheStrategy
import com.bumptech.glide.load.resource.bitmap.CenterCrop
import com.bumptech.glide.load.resource.bitmap.RoundedCorners
import com.bumptech.glide.request.RequestOptions
import com.mountcarmelschools.R
import com.mountcarmelschools.di.data.staff.assignHomework.StudentsListResponse

class StudentsBottomSheetAdapter(
    private val context: Context,
    val students: List<StudentsListResponse.StudentData>,
    val selectedStudentIds: List<String>,
    initialFilterQuery: String?,
    val onStudentChecked: ((StudentsListResponse.StudentData, Boolean) -> Unit)
) : RecyclerView.Adapter<StudentsBottomSheetAdapter.StudentViewHolder>(), Filterable {
    private var filteredStudents = ArrayList<StudentsListResponse.StudentData>()

    init {
        filteredStudents.clear()
        val filteredList = filterListByQuery(students, initialFilterQuery)
        filteredStudents.addAll(filteredList)
    }

    inner class StudentViewHolder(val inflater: LayoutInflater, val parent: ViewGroup) : RecyclerView.ViewHolder(inflater.inflate(R.layout.list_item_user, parent, false)) {
        private var studentNameTV: TextView? = null
        private var dividerView: View? = null
        private var contentContainer: LinearLayout? = null
        private var studentImageView: ImageView? = null
        private var checkboxView: CheckBox? = null

        init {
            studentNameTV = itemView.findViewById(R.id.txt_student_name)
            dividerView = itemView.findViewById(R.id.horizontal_divider)
            contentContainer = itemView.findViewById(R.id.ll_student)
            studentImageView = itemView.findViewById(R.id.img_student)
            checkboxView = itemView.findViewById(R.id.cb_student)
        }

        fun bind(student: StudentsListResponse.StudentData?, context: Context, isLast: Boolean) {
            if (student == null) {
                return
            }
            studentNameTV?.text = student.name

            // Adjust bottom margin and divider visibility
            if (isLast) {
                dividerView?.visibility = View.GONE
            } else {
                dividerView?.visibility = View.VISIBLE
            }

            val studentImageUri = student.studentImg ?: if (student.profilePic.isNullOrEmpty()) {
                null
            } else {
                "https://www.mountcarmelschool.com/uploads/profile-pic/student/${student.profilePic}"
            }

            studentImageUri?.let {  uri ->
                // Load the student image using Glide
                val requestOptions = RequestOptions().transforms(CenterCrop(), RoundedCorners(64))
                studentImageView?.let { imageView ->
                    Glide.with(context)
                        .load(uri)
                        .thumbnail(0.5f)
                        .apply(requestOptions
                            .override(imageView.width, imageView.height)
                            .diskCacheStrategy(DiskCacheStrategy.AUTOMATIC)
                        )
                        .into(imageView)
                }
            }

            // Ensure the checkbox state is correctly reflected based on the student's isChecked property
            checkboxView?.setOnCheckedChangeListener(null) // Unbind the listener first
            checkboxView?.isChecked = selectedStudentIds.contains(student.id)

            // Update the selection when the checkbox state changes
            checkboxView?.setOnCheckedChangeListener { _, isChecked ->
                onStudentChecked(student, isChecked)
            }
        }
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): StudentViewHolder {
        val inflater = LayoutInflater.from(parent.context)
        return StudentViewHolder(inflater, parent)
    }

    override fun onBindViewHolder(holder: StudentViewHolder, position: Int) {
        holder.bind(filteredStudents.getOrNull(position), context, position == (filteredStudents.size - 1))
    }

    override fun getItemCount(): Int = filteredStudents.size

    override fun getFilter(): Filter {
        return object : Filter() {
            override fun performFiltering(constraint: CharSequence): FilterResults {
                val query = constraint.toString()

                filteredStudents.clear()

                val filteredList = filterListByQuery(students, query)
                filteredStudents.addAll(filteredList)

                val filterResults = FilterResults()
                filterResults.values = filteredStudents
                return filterResults
            }

            override fun publishResults(
                charSequence: CharSequence,
                results: FilterResults
            ) {
                filteredStudents = results.values as ArrayList<StudentsListResponse.StudentData>
                notifyDataSetChanged()
            }
        }
    }

    fun filterListByQuery(list: List<StudentsListResponse.StudentData>, query: String?): List<StudentsListResponse.StudentData> {
        if (query.isNullOrEmpty()) {
            return list
        }
        val lowercaseCharString = query.lowercase()
        return list.filter { it.name?.lowercase()?.contains(lowercaseCharString) == true }
    }
}
