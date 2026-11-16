package com.mountcarmelschools.ui.screenlock

import android.app.Dialog
import android.content.DialogInterface
import android.content.Intent
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.view.KeyEvent
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AlertDialog
import androidx.fragment.app.DialogFragment
import androidx.fragment.app.FragmentActivity
import com.mountcarmelschools.R
import com.mountcarmelschools.ui.welcome.WelcomeActivity
import com.mountcarmelschools.utlis.IS_PARENT
import com.mountcarmelschools.utlis.IS_STAFF
import com.mountcarmelschools.utlis.ScreenLockManager
import com.mountcarmelschools.utlis.SharedPreferenceUtils
import com.mountcarmelschools.utlis.USER_NAME
import java.lang.ref.WeakReference

class ScreenLockDialogFragment(private val activityWeakRef: WeakReference<FragmentActivity>) : DialogFragment() {
    private var backPressedOnce = false
    private val handler = Handler(Looper.getMainLooper())
    private lateinit var screenLockManager: ScreenLockManager

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val view = inflater.inflate(R.layout.fragment_screen_lock_dialog, container, false)

        SharedPreferenceUtils.getInstance(requireContext())?.let {
            val name = it.getStringValue(USER_NAME, "Username")
            val isParent = it.getBoolanValue(IS_PARENT, false)
            val isStaff = it.getBoolanValue(IS_STAFF, false)

            val subtitleView = view.findViewById<TextView>(R.id.screenLockSubtitle)!!
            subtitleView.text = String.format(resources.getString(R.string.screen_lock_subtitle), name, if (isParent) { "Parent"} else if (isStaff) {"Staff"} else { "Student"})
        }

        val unlockButtonView = view.findViewById<Button>(R.id.unlockButton)!!
        unlockButtonView.setOnClickListener { handleAppUnlock() }

        val logoutButtonView = view.findViewById<Button>(R.id.logoutButton)!!
        logoutButtonView.setOnClickListener { handleLogout() }

        return view
    }

    override fun onStart() {
        super.onStart()
        dialog?.window?.setLayout(
            ViewGroup.LayoutParams.MATCH_PARENT,
            ViewGroup.LayoutParams.MATCH_PARENT
        )
    }

    private val backButtonHandler = DialogInterface.OnKeyListener { _, keyCode, event ->
        if (keyCode == KeyEvent.KEYCODE_BACK && event.action == KeyEvent.ACTION_UP) {
            Log.d("ScreenLockDialogFragment", "Back button was pressed")
            if (backPressedOnce) {
                requireActivity().finish()
            } else {
                backPressedOnce = true
                activityWeakRef.get()?.let { activity ->
                    Toast.makeText(activity, "Press again to exit", Toast.LENGTH_SHORT).show()
                }
                handler.postDelayed({ backPressedOnce = false }, 2000)
            }
            return@OnKeyListener true
        }
        return@OnKeyListener false
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        screenLockManager = ScreenLockManager(activityWeakRef)
        setStyle(STYLE_NORMAL, R.style.ScreenLockDialogTheme)
    }

    override fun onCreateDialog(savedInstanceState: Bundle?): Dialog {
        isCancelable = false

        val dialog = super.onCreateDialog(savedInstanceState)
        // Setting up back button press handler
        dialog.setOnKeyListener(backButtonHandler)

        return dialog
    }

    private var lastPresentDialog: AlertDialog? = null

    private fun handleAppUnlock() {
        screenLockManager.isAvailable(object : ScreenLockManager.AvailabilityListener {
            override fun onSuccess(type: ScreenLockManager.ScreenLockType) {
                screenLockManager.authenticateUser(object : ScreenLockManager.AuthResultListener {
                    override fun onSuccess() {
                        lastPresentDialog?.dismiss()
                        ScreenLockManager.SCREEN_LOCKED = false
                        dismiss()
                    }

                    override fun onError(error: Exception) {
                        lastPresentDialog?.dismiss()
                        activityWeakRef.get()?.let { activity ->
                            lastPresentDialog = AlertDialog.Builder(activity)
                                .setTitle("Authentication Failed")
                                .setMessage("${error.message}\nPlease try again")
                                .setNeutralButton("OK", null)
                                .show()
                        }
                    }
                })
            }

            override fun onError(error: Exception) {
                lastPresentDialog?.dismiss()
                activityWeakRef.get()?.let { activity ->
                    lastPresentDialog = AlertDialog.Builder(activity)
                        .setTitle("Unable to Unlock App")
                        .setMessage("${error.message}\nPlease try again later or logout")
                        .setNeutralButton("OK", null)
                        .setNegativeButton("Logout") { _, _ -> handleLogout() }
                        .show()
                }
            }
        })
    }

    private fun handleLogout() {
        val intent = Intent(requireContext(), WelcomeActivity::class.java)
        SharedPreferenceUtils.getInstance(requireContext())?.clear()
        requireContext().startActivity(intent)
    }
}
