package com.mountcarmelschools.utlis

import android.app.Activity
import android.app.KeyguardManager
import android.content.Intent
import androidx.activity.result.ActivityResult
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AppCompatActivity
import androidx.biometric.BiometricManager
import androidx.biometric.BiometricPrompt
import androidx.fragment.app.FragmentActivity
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.LifecycleOwner
import java.lang.ref.WeakReference

class ScreenLockManager(private val activityWeakRef: WeakReference<FragmentActivity>): DefaultLifecycleObserver {
    companion object {
        var SCREEN_LOCKED = true
    }

    interface AvailabilityListener {
        fun onSuccess(type: ScreenLockType);
        fun onError(error: Exception);
    }

    interface AuthResultListener {
        fun onSuccess();
        fun onError(error: Exception);
    }

    enum class ScreenLockType {
        BIOMETRIC,
        KEYGUARD,
    }

    private val allowedAuthenticator = BiometricManager.Authenticators.BIOMETRIC_WEAK or BiometricManager.Authenticators.BIOMETRIC_STRONG or BiometricManager.Authenticators.DEVICE_CREDENTIAL

    private val promptInfo: BiometricPrompt.PromptInfo = BiometricPrompt.PromptInfo.Builder()
        .setTitle("Biometric login for my app")
        .setSubtitle("Log in using your biometric credential")
//        .setNegativeButtonText("Cancel")
        .setAllowedAuthenticators(allowedAuthenticator)
        .build()

    private lateinit var resultLauncher: ActivityResultLauncher<Intent>

    private var keyGuardIntentResultListener: WeakReference<AuthResultListener>? = null

    init {
        activityWeakRef.get()?.lifecycle?.addObserver(this)
    }

    override fun onCreate(owner: LifecycleOwner) {
        super.onCreate(owner)
        val activity = activityWeakRef.get() ?: return

        resultLauncher = activity.registerForActivityResult(
            ActivityResultContracts.StartActivityForResult()
        ) { result ->
            handleActivityResult(result)
        }
    }

    fun isEnabled(): Boolean {
        val spUtils = activityWeakRef.get()?.let { SharedPreferenceUtils.getInstance(it) } ?: return false
        return spUtils.getBoolanValue(SCREEN_LOCK_ENABLED, false)
    }

    fun enable(value: Boolean): Boolean {
        // TODO: may be check if `isAvailable`
        val spUtils = activityWeakRef.get()?.let { SharedPreferenceUtils.getInstance(it) } ?: return false
        spUtils.setValue(SCREEN_LOCK_ENABLED, value)
        return true
    }

    fun isAvailable(listener: AvailabilityListener) {
        val activity = this.activityWeakRef.get() ?: run {
            listener.onError(Exception("Activity Reference not Available"))
            return
        }
        // Checking Biometric service
        val result = BiometricManager
            .from(activity.applicationContext)
            .canAuthenticate(allowedAuthenticator)
        if (result == BiometricManager.BIOMETRIC_SUCCESS) {
            listener.onSuccess(ScreenLockType.BIOMETRIC)
            return
        }
        // Since Biometric service is not available, fallback to KeyguardManager
        val keyguardManager = activity.getSystemService(AppCompatActivity.KEYGUARD_SERVICE) as? KeyguardManager
        if (keyguardManager == null) {
            listener.onError(Exception("KeyguardManager is null"))
            return
        }
        if (keyguardManager.isKeyguardSecure) {
            listener.onSuccess(ScreenLockType.KEYGUARD)
        } else {
            listener.onError(Exception("PIN, pattern or password are not set"))
        }
    }

    fun authenticateUser(listener: AuthResultListener) {
        isAvailable(object : AvailabilityListener {
            override fun onSuccess(type: ScreenLockType) {
                when (type) {
                    ScreenLockType.BIOMETRIC -> {
                        authenticateUsingBiometric(listener)
                    }
                    ScreenLockType.KEYGUARD -> {
                        authenticateUsingKeyguard(listener)
                    }
                }
            }
            override fun onError(error: Exception) {
                listener.onError(error)
            }
        })
    }

    private fun authenticateUsingBiometric(listener: AuthResultListener) {
        val activity = this.activityWeakRef.get() ?: run {
            listener.onError(Exception("Activity Reference not Available"))
            return
        }
        BiometricPrompt(activity, object : BiometricPrompt.AuthenticationCallback() {
            override fun onAuthenticationError(errorCode: Int, errString: CharSequence) {
                super.onAuthenticationError(errorCode, errString)
                listener.onError(Exception(errString.toString()))
            }

            override fun onAuthenticationFailed() {
                super.onAuthenticationFailed()
                listener.onError(Exception("Not recognised"))
            }

            override fun onAuthenticationSucceeded(result: BiometricPrompt.AuthenticationResult) {
                super.onAuthenticationSucceeded(result)
                listener.onSuccess()
            }
        }).authenticate(promptInfo)
    }

    private fun authenticateUsingKeyguard(listener: AuthResultListener) {
        val activity = this.activityWeakRef.get() ?: run {
            listener.onError(Exception("Activity Reference not Available"))
            return
        }
        val keyguardManager = activity.getSystemService(AppCompatActivity.KEYGUARD_SERVICE) as? KeyguardManager
        if (keyguardManager == null) {
            listener.onError(Exception("KeyguardManager is null"))
            return
        }
        if (!keyguardManager.isKeyguardSecure) {
            listener.onError(Exception("PIN, pattern or password are not set"))
            return
        }
        val intent: Intent? = keyguardManager.createConfirmDeviceCredentialIntent("Authentication Required", "Please enter your screen lock password to unlock the app")
        if (intent == null) {
            listener.onError(Exception("Unable to create Keyguard Device Credential Intent"))
            return
        }
        keyGuardIntentResultListener = WeakReference(listener)
        resultLauncher.launch(intent)
    }

    private fun handleActivityResult(result: ActivityResult) {
        val listener = keyGuardIntentResultListener?.get() ?: return
        if (result.resultCode == Activity.RESULT_OK) {
            listener.onSuccess()
        } else if (result.resultCode == Activity.RESULT_CANCELED) {
            listener.onError(Exception("User cancelled Authentication"))
        } else {
            listener.onError(Exception("Authentication failed"))
        }
        keyGuardIntentResultListener?.clear()
        keyGuardIntentResultListener = null
    }
}