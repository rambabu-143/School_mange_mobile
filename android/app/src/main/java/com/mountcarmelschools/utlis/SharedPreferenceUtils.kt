package com.mountcarmelschools.utlis

import android.content.Context
import android.content.SharedPreferences

const val USER_ID = "userId"
const val STANDARD_ID = "standardId"
const val STANDARD_SECTION_ID = "standardSectionId"
const val STANDARD_NAME = "standard_name"
const val STUDENT_ROLL_NO = "studentRollno"
const val STUDENT_ID = "studentId"
const val SECTION_ID = "sectionId"
const val USER_NAME = "userName"
const val MOBILE_NUMBER = "mobileNumber"
const val USER_TYPE = "usertype"
const val AUTH_TOKEN = "auth_token"
const val STUDENT_DATA_FOR_PARENT = "studentDateForPatent"
const val BRANCH_DATA_FOR_STAFF = "branchDataForStaff"
const val CURRENT_BRANCH = "current_branch"
const val IS_PARENT = "isParent"
const val IS_STAFF = "isStaff"
const val STAFF_USER_ID = "staff_userId"
const val EMPLOYEE_CODE = "employee_code"
const val PARENT_URL = "parent_url"
const val PARENT_IMAGE_PATH = "parent_ImagePath"
const val YEAR_SESSION = "year_session"
const val DATE_OF_ADMISSION = "date_of_admission";
const val TEMP_OTP = "temp_otp";
const val PARENT_MOBILE_NO = "parent_mobile_no"
const val IS_LOGGED_IN = "is_logged_in"
const val STUDENT_EMAIL_ID = "student_email_id"
const val TEACHER_EMAIL_ID = "teacher_email_id"
const val PARENT_EMAIL_ID = "parent_email_id"
const val SHOW_STATUS = "show_status"
const val SHOW_ENABLE_SCREEN_LOCK_PROMPT = "show_enable_screen_lock_prompt"
const val SCREEN_LOCK_ENABLED = "screen_lock_enabled"

class SharedPreferenceUtils(var mContext: Context) {

    private val mSharedPreferences: SharedPreferences =
        mContext.getSharedPreferences("MyPreferences", Context.MODE_PRIVATE)
    private val mSharedPreferencesEditor: SharedPreferences.Editor?

    /**
     * to get key is stored in DB
     */
    fun getContainsKey(key: String?): Boolean {
        return mSharedPreferences.contains(key)
    }

    /**
     * Stores String value in preference
     *
     * @param key   key of preference
     * @param value value for that key
     */
    fun setValue(key: String?, value: String?) {
        mSharedPreferencesEditor!!.putString(key, value)
        mSharedPreferencesEditor.commit()
    }

    /**
     * Stores String value in preference
     *
     * @param key   key of preference
     * @param value value for that key
     */
    fun setStringValue(key: String?, value: String?) {
        mSharedPreferencesEditor!!.putString(key, value)
        mSharedPreferencesEditor.commit()
    }

    /**
     * Stores int value in preference
     *
     * @param key   key of preference
     * @param value value for that key
     */
    fun setValue(key: String?, value: Int) {
        mSharedPreferencesEditor!!.putInt(key, value)
        mSharedPreferencesEditor.commit()
    }

    /**
     * Stores Double value in String format in preference
     *
     * @param key   key of preference
     * @param value value for that key
     */
    fun setValue(key: String?, value: Double) {
        setValue(key, java.lang.Double.toString(value))
    }

    /**
     * Stores long value in preference
     *
     * @param key   key of preference
     * @param value value for that key
     */
    fun setValue(key: String?, value: Long) {
        mSharedPreferencesEditor!!.putLong(key, value)
        mSharedPreferencesEditor.commit()
    }

    /**
     * Stores boolean value in preference
     *
     * @param key   key of preference
     * @param value value for that key
     */
    fun setValue(key: String?, value: Boolean) {
        mSharedPreferencesEditor!!.putBoolean(key, value)
        mSharedPreferencesEditor.commit()
    }

    /**
     * Retrieves String value from preference
     *
     * @param key          key of preference
     * @param defaultValue default value if no key found
     */
    fun getStringValue(key: String?, defaultValue: String?): String? {
        return mSharedPreferences.getString(key, defaultValue)
    }

    /**
     * Retrieves int value from preference
     *
     * @param key          key of preference
     * @param defaultValue default value if no key found
     */
    fun getIntValue(key: String?, defaultValue: Int): Int {
        return mSharedPreferences.getInt(key, defaultValue)
    }

    /**
     * Retrieves long value from preference
     *
     * @param key          key of preference
     * @param defaultValue default value if no key found
     */
    fun getLongValue(key: String?, defaultValue: Long): Long {
        return mSharedPreferences.getLong(key, defaultValue)
    }

    /**
     * Retrieves boolean value from preference
     *
     * @param keyFlag      key of preference
     * @param defaultValue default value if no key found
     */
    fun getBoolanValue(keyFlag: String?, defaultValue: Boolean): Boolean {
        return mSharedPreferences.getBoolean(keyFlag, defaultValue)
    }

    /**
     * Removes key from preference
     *
     * @param key key of preference that is to be deleted
     */
    fun removeKey(key: String?) {
        if (mSharedPreferencesEditor != null) {
            mSharedPreferencesEditor.remove(key)
            mSharedPreferencesEditor.commit()
        }
    }

    /**
     * Clears all the preferences stored
     */
    fun clear() {

        val studentEmail = getInstance(mContext)
            ?.getStringValue(STUDENT_EMAIL_ID, "")!!

        val teacherEmail = getInstance(mContext)
            ?.getStringValue(TEACHER_EMAIL_ID, "")!!

        val parentMobile = getInstance(mContext)
            ?.getStringValue(PARENT_MOBILE_NO, "")!!

        mSharedPreferencesEditor!!.clear().commit()

        getInstance(mContext)
            ?.setStringValue(
                STUDENT_EMAIL_ID,
                studentEmail
            )
        getInstance(mContext)
            ?.setStringValue(
                TEACHER_EMAIL_ID,
                teacherEmail
            )

        getInstance(mContext)
            ?.setStringValue(
                PARENT_MOBILE_NO,
                parentMobile
            )
    }


    companion object {
        private var mSharedPreferenceUtils: SharedPreferenceUtils? = null

        /**
         * Creates single instance of SharedPreferenceUtils
         *
         * @param context context of Activity or Service
         * @return Returns instance of SharedPreferenceUtils
         */
        @Synchronized
        fun getInstance(context: Context): SharedPreferenceUtils? {
            if (mSharedPreferenceUtils == null) {
                mSharedPreferenceUtils =
                    SharedPreferenceUtils(context.applicationContext)
            }
            return mSharedPreferenceUtils
        }
    }

    init {

        mSharedPreferencesEditor = mSharedPreferences.edit()
    }


}