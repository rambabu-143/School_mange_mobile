package com.mountcarmelschools.ui.welcome

import android.content.Intent
import android.view.View
import com.mountcarmelschools.base.BaseViewModel
import com.mountcarmelschools.base.McopBaseViewModel
import com.mountcarmelschools.ui.login.LoginActivity
import com.mountcarmelschools.ui.parentlogin.ParentLoginActivity

class WelcomeViewModel: BaseViewModel<WelcomeNavigator>() {

    fun onStaffClick(view: View) {
        val intent = Intent(view.context,LoginActivity::class.java)
        intent.putExtra("from","staff")
        view.context.startActivity(intent)
        getNavigator()?.finishWelcome()
    }

    fun onParentClick(view: View) {
        val intent = Intent(view.context,ParentLoginActivity::class.java)
        view.context.startActivity(intent)
        getNavigator()?.finishWelcome()
    }
    fun onStudentClick(view: View) {
        val intent = Intent(view.context,LoginActivity::class.java)
        intent.putExtra("from","student")
        view.context.startActivity(intent)
        getNavigator()?.finishWelcome()
    }
}