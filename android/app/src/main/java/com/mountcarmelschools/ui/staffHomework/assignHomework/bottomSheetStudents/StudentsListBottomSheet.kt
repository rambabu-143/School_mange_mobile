package com.mountcarmelschools.ui.staffHomework.assignHomework.bottomSheetStudents

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import androidx.core.content.res.ResourcesCompat
import androidx.core.widget.doOnTextChanged
import androidx.databinding.DataBindingUtil
import androidx.recyclerview.widget.LinearLayoutManager
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.google.android.material.bottomsheet.BottomSheetDialog
import com.google.android.material.bottomsheet.BottomSheetDialogFragment
import com.mountcarmelschools.R
import com.mountcarmelschools.databinding.BottomSheetUsersBinding
import com.mountcarmelschools.di.data.staff.assignHomework.StudentsListResponse

class StudentsListBottomSheet : BottomSheetDialogFragment() {
    private lateinit var binding: BottomSheetUsersBinding

    private var listRVAdapter: StudentsBottomSheetAdapter? = null

    private var title: String? = null
    private var list: List<StudentsListResponse.StudentData>? = null
    private var selectedItemIds = mutableListOf<String>()

    private var onDoneClickListener: ((List<String>) -> Unit)? = null

    fun setData(
        title: String,
        list: List<StudentsListResponse.StudentData>,
        selectedItemIds: List<String>,
    ) {
        this.title = title
        this.list = list

        this.selectedItemIds.clear()
        this.selectedItemIds.addAll(selectedItemIds)
    }

    fun setOnDoneClickListener(listener: (List<String>) -> Unit) {
        this.onDoneClickListener = listener
    }

    fun getLayoutID() = R.layout.bottom_sheet_users

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        binding = DataBindingUtil.inflate(inflater, getLayoutID(), container, false)
        binding.lifecycleOwner = this
        return binding.root
    }

    override fun onStart() {
        super.onStart()

        val dialog = dialog as BottomSheetDialog
        val bottomSheet = dialog.findViewById<View>(com.google.android.material.R.id.design_bottom_sheet) as FrameLayout

        bottomSheet.background = ResourcesCompat.getDrawable(resources, R.drawable.bottom_sheet_background, null)

        val behavior = BottomSheetBehavior.from(bottomSheet)

        // Set the height of the BottomSheet in the expanded state
        val layoutParams = bottomSheet.layoutParams
        layoutParams.height = (resources.displayMetrics.heightPixels * 0.95).toInt()
        bottomSheet.layoutParams = layoutParams

        // Set the bottom sheet to expand to 85% of the screen height
        behavior.peekHeight = (resources.displayMetrics.heightPixels * 0.95 * 0.7).toInt()

        // Set the bottom sheet to start in the expanded state
        behavior.state = BottomSheetBehavior.STATE_EXPANDED
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        configureTitle()

        configureCancelButton()

        configureDoneButton()

        configureSelectionCounterView()

        configureSearchBar()

        configureListView()
    }

    private fun configureTitle() {
        binding.txtClassName.text = title
    }

    private fun configureCancelButton() {
        binding.txtCancel.setOnClickListener {
            dismissAllowingStateLoss()
        }
    }

    private fun configureDoneButton() {
        binding.txtDone.setOnClickListener {
            onDoneClickListener?.invoke(selectedItemIds.toList())

            dismissAllowingStateLoss()
        }
    }

    private fun configureSelectionCounterView() {
        binding.txtCount.text = String.format(
            resources.getString(R.string.student_selected_label),
            selectedItemIds.size.toString(),
            list?.size.toString()
        )
    }

    private fun configureSearchBar() {
        binding.searchBox.isEnabled = !list.isNullOrEmpty()

        binding.searchBox.doOnTextChanged { charSeq, _, _, _ ->
            // Show clear icon if there is text, otherwise hide it
            binding.clearIcon.visibility = if (charSeq.isNullOrEmpty()) View.GONE else View.VISIBLE

            listRVAdapter?.filter?.filter(charSeq)
        }

        // configure clear search bar button
        binding.clearIcon.setOnClickListener {
            binding.searchBox.setText("")
        }
    }

    private fun configureListView() {
        binding.recyclerView.layoutManager = LinearLayoutManager(context, LinearLayoutManager.VERTICAL, false)

        val list = list
        if (list.isNullOrEmpty()) {
            binding.recyclerView.visibility = View.GONE
            binding.emptyView.visibility = View.VISIBLE
        } else {
            binding.recyclerView.visibility = View.VISIBLE
            binding.emptyView.visibility = View.GONE

            val adapter = context?.let {
                StudentsBottomSheetAdapter(
                    it,
                    list,
                    selectedItemIds,
                    binding.searchBox.text.toString(),
                ) { data, checked ->
                    if (data.id != null) {
                        val presentInList = selectedItemIds.contains(data.id)
                        if (checked && !presentInList) {
                            selectedItemIds.add(data.id)
                        } else if (presentInList) {
                            selectedItemIds.remove(data.id)
                        }
                    }

                    binding.txtCount.text = String.format(
                        resources.getString(R.string.student_selected_label),
                        selectedItemIds.size.toString(),
                        list.size.toString()
                    )
                }
            }
            listRVAdapter = adapter
            binding.recyclerView.adapter = adapter
        }
    }
}