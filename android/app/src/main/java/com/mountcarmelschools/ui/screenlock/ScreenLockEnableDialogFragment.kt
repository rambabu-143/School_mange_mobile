package com.mountcarmelschools.ui.screenlock

import android.app.Dialog
import android.content.DialogInterface
import android.os.Bundle
import android.widget.TextView
import androidx.appcompat.app.AlertDialog
import androidx.core.content.ContextCompat
import androidx.core.content.res.ResourcesCompat
import androidx.fragment.app.DialogFragment
import androidx.fragment.app.FragmentActivity
import com.mountcarmelschools.R
import com.mountcarmelschools.utlis.SHOW_ENABLE_SCREEN_LOCK_PROMPT
import com.mountcarmelschools.utlis.ScreenLockManager
import com.mountcarmelschools.utlis.SharedPreferenceUtils
import java.lang.ref.WeakReference

class ScreenLockEnableDialogFragment(private val activityWeakRef: WeakReference<FragmentActivity>) : DialogFragment() {
    private lateinit var screenLockManager: ScreenLockManager

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        screenLockManager = ScreenLockManager(activityWeakRef)
    }

    override fun onCreateDialog(savedInstanceState: Bundle?): Dialog {
        super.onCreateDialog(savedInstanceState)

        return AlertDialog.Builder(requireContext(), R.style.ScreenLockEnableDialogTheme)
            .setTitle("Enable Screen Lock")
            .setMessage("Enable Screen lock feature for quick and secure access to your account without logging out.\n\nYou can enable or disable it anytime from the settings.\n\n")
            .setPositiveButton("Enable Screen lock") { _, _ -> enableScreenLock() }
            .setNegativeButton("Not now") { _, _ -> turnOffScreenLockPrompt() }
            .create()
    }

    override fun onCancel(dialog: DialogInterface) {
        super.onCancel(dialog)
        turnOffScreenLockPrompt()
    }

    override fun onStart() {
        super.onStart()

        activityWeakRef.get()?.let { activity ->
            val messageView = dialog?.findViewById<TextView>(android.R.id.message)
            messageView?.let {
                // Set the text color
                it.setTextColor(ContextCompat.getColor(activity, R.color.black))

                // Set the font family
                val customFont = ResourcesCompat.getFont(activity, R.font.georgia)
                it.typeface = customFont
            }
        }
    }

    private fun turnOffScreenLockPrompt() {
        context?.let { SharedPreferenceUtils.getInstance(it)?.setValue(
            SHOW_ENABLE_SCREEN_LOCK_PROMPT, false
        )}
    }

    private fun enableScreenLock() {
        screenLockManager.authenticateUser(object : ScreenLockManager.AuthResultListener {
            override fun onSuccess() {
                screenLockManager.enable(true)
                activityWeakRef.get()?.let { activity ->
                    SharedPreferenceUtils.getInstance(activity)?.setValue(SHOW_ENABLE_SCREEN_LOCK_PROMPT, false)
                }
                ScreenLockManager.SCREEN_LOCKED = false
            }

            override fun onError(error: Exception) {
                val activity = activityWeakRef.get() ?: return
                AlertDialog.Builder(activity)
                    .setTitle("Unable to Enable App lock. Try again later!")
                    .setMessage(error.message)
                    .setNeutralButton("Okay", null)
                    .show()
            }
        })
    }
}