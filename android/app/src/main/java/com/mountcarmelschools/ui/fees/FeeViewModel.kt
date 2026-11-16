package com.mountcarmelschools.ui.fees

import android.view.View
import androidx.lifecycle.ViewModel
import com.mountcarmelschools.R
import com.mountcarmelschools.ui.viewbill.ViewBillFragment
import com.mountcarmelschools.utlis.Utils

class FeeViewModel : ViewModel() {

    fun onViewBill(view: View) {
        Utils.replaceFragment(
            view.context,
            R.id.fl_dashboardContainer,
            ViewBillFragment(),
            "ViewBillFragment"
        )
    }
}
