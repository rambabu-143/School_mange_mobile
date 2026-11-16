package com.mountcarmelschools.ui.login

import android.content.ContentValues.TAG
import android.content.IntentSender
import android.os.Bundle
import android.util.Log
import androidx.activity.result.IntentSenderRequest
import androidx.activity.result.contract.ActivityResultContracts
import com.google.android.gms.auth.api.identity.BeginSignInRequest
import com.google.android.gms.auth.api.identity.Identity
import com.google.android.gms.auth.api.identity.SignInClient
import com.google.android.gms.auth.api.signin.GoogleSignIn
import com.google.android.gms.auth.api.signin.GoogleSignInAccount
import com.google.android.gms.auth.api.signin.GoogleSignInClient
import com.google.android.gms.auth.api.signin.GoogleSignInOptions
import com.google.android.gms.common.api.ApiException
import com.google.android.gms.common.api.CommonStatusCodes
import com.mountcarmelschools.BuildConfig
import com.mountcarmelschools.R
import com.mountcarmelschools.base.BaseActivity
import com.mountcarmelschools.databinding.ActivityLoginBinding
import com.mountcarmelschools.utlis.STUDENT_EMAIL_ID
import com.mountcarmelschools.utlis.SharedPreferenceUtils
import com.mountcarmelschools.utlis.TEACHER_EMAIL_ID


class LoginActivity : BaseActivity<ActivityLoginBinding, LoginViewModel>(), LoginNavigator {


    private var oneTapClient: SignInClient? = null
    private lateinit var mGoogleSignInClient: GoogleSignInClient

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        dataBinding.loginViewModel = viewModel
        viewModel.setNavigator(this)

        val bundle = intent.extras;
        if (bundle != null) {
            if (bundle.getString("from").equals("staff")) {
                if (!SharedPreferenceUtils.getInstance(baseContext)!!
                        .getStringValue(TEACHER_EMAIL_ID, "").equals("")
                ) {


                    viewModel.email.set(
                        SharedPreferenceUtils.getInstance(
                            baseContext
                        )!!.getStringValue(TEACHER_EMAIL_ID, "")
                    )

                }


            } else if (bundle.getString("from").equals("student")) {
                if (!SharedPreferenceUtils.getInstance(baseContext)!!
                        .getStringValue(STUDENT_EMAIL_ID, "").equals("")
                ) {

                    viewModel.email.set(
                        SharedPreferenceUtils.getInstance(
                            baseContext
                        )!!.getStringValue(STUDENT_EMAIL_ID, "")
                    )


                }
            }


        }

        oneTapClient = Identity.getSignInClient(this)

        val gso = GoogleSignInOptions.Builder(GoogleSignInOptions.DEFAULT_SIGN_IN)
            .requestEmail()
            .requestIdToken(BuildConfig.ServerClientId)
            .build()
        mGoogleSignInClient = GoogleSignIn.getClient(this, gso);

        signIn()

    }

    override fun getLayoutId() = R.layout.activity_login

    override fun getViewModel() = LoginViewModel::class.java
    override fun finishLogin() {
        finish()
    }


    override fun onSignInClick() {

        updateGmailLogin()
    }

    private fun createSignInRequest(onlyAuthorizedAccounts: Boolean): BeginSignInRequest =
        BeginSignInRequest.builder()
            .setPasswordRequestOptions(
                BeginSignInRequest.PasswordRequestOptions.builder()
                    .setSupported(true)
                    .build()
            )
            .setGoogleIdTokenRequestOptions(
                BeginSignInRequest.GoogleIdTokenRequestOptions.builder()
                    .setSupported(true)
                    .setServerClientId(BuildConfig.ServerClientId)
                    .setFilterByAuthorizedAccounts(onlyAuthorizedAccounts)
                    .build()
            )
            .build()


    private fun signIn() {
        val signInRequest = createSignInRequest(onlyAuthorizedAccounts = true)

        oneTapClient!!.beginSignIn(signInRequest)
            .addOnSuccessListener(this) { result ->
                try {
                    val intentSenderRequest =
                        IntentSenderRequest.Builder(result.pendingIntent.intentSender).build()
                    startForResult.launch(intentSenderRequest)


                } catch (e: IntentSender.SendIntentException) {
                    Log.e(TAG, "Couldn't start One Tap UI: ${e.localizedMessage}")
                }
            }
            .addOnFailureListener(this) { e ->
                Log.d(TAG, e.localizedMessage)
                // No saved credentials found. Launch the One Tap sign-up flow
                if (e.localizedMessage?.lowercase()?.contains("user disabled the feature") == true)
                {
                    updateGmailLogin()
                }else {
                    signUp()
                }
            }
    }

    //New ON TAP SIGNIN
    private fun signUp() {
        val signUpRequest = createSignInRequest(onlyAuthorizedAccounts = false)

        oneTapClient!!.beginSignIn(signUpRequest)
            .addOnSuccessListener(this) { result ->
                try {
                    val intentSenderRequest =
                        IntentSenderRequest.Builder(result.pendingIntent.intentSender).build()
                    startForResult.launch(intentSenderRequest)

                } catch (e: IntentSender.SendIntentException) {
                    Log.e(TAG, "Couldn't start One Tap UI: ${e.localizedMessage}")
                }
            }
            .addOnFailureListener(this) { e ->
                e.localizedMessage?.let { Log.d(TAG, it) }

                // No saved credentials found. Show error
            }
    }


    private val startForResult =
        registerForActivityResult(ActivityResultContracts.StartIntentSenderForResult()) { result ->

            if (result != null) {
                try {
                    val credential = oneTapClient!!.getSignInCredentialFromIntent(result.data)
                    val idToken = credential.googleIdToken
                    val username = credential.id
                    val password = credential.password

                    viewModel.onGoogleSuccess(applicationContext, username, idToken!!)

                    when {
                        idToken != null -> {
                            // Got an ID token from Google. Use it to authenticate
                            // with your backend.
                            Log.d(TAG, "Got ID token: $idToken")
                        }
                        username != null -> {
                            Log.d(TAG, "Got name: $username")
                        }
                        password != null -> {
                            // Got a saved username and password. Use them to authenticate
                            // with your backend.
                            Log.d(TAG, "Got password: $password")
                        }
                        else -> {
                            // Shouldn't happen.
                            Log.d(TAG, "No ID token or password!")
                        }
                    }


                } catch (e: ApiException) {
                    when (e.statusCode) {
                        CommonStatusCodes.CANCELED -> {
                            Log.d(TAG, "One-tap dialog was closed.")
                            // Don't re-prompt the user.
                        }
                        CommonStatusCodes.NETWORK_ERROR -> {
                            Log.d(TAG, "One-tap encountered a network error.")
                            // Try again or just ignore.
                        }
                        else -> {
                            Log.d(
                                TAG, "Couldn't get credential from result." +
                                        " (${e.localizedMessage})"
                            )
                        }
                    }


                }
            }

        }


    //OLD LOGIN

    private fun updateGmailLogin() {


        val googleSignInAccount = GoogleSignIn.getLastSignedInAccount(this)
        if (googleSignInAccount != null) {
            mGoogleSignInClient.signOut()
        }
        resultLauncher.launch(mGoogleSignInClient.signInIntent)

    }
    private var resultLauncher =
        registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result ->
            val task = GoogleSignIn.getSignedInAccountFromIntent(result.data)

            try {
                val account: GoogleSignInAccount = task.getResult(ApiException::class.java)
                viewModel.onGoogleSuccess(applicationContext, account.email!!, account.idToken!!)

            } catch (e: ApiException) {
                // The ApiException status code indicates the detailed failure reason.
                // Please refer to the GoogleSignInStatusCodes class reference for more information.
                Log.e("TAG", "signInResult:failed code=" + e.statusCode)
            }
        }


}
