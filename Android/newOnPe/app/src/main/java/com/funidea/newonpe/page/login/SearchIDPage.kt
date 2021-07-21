package com.funidea.newonpe.page.login

import android.content.Intent
import android.graphics.Color
import android.os.Bundle
import android.text.Editable
import android.text.TextUtils
import android.text.TextWatcher
import android.util.Log
import android.util.Patterns
import android.view.View
import android.widget.Button
import android.widget.Toast
import com.funidea.newonpe.R
import com.funidea.newonpe.dialog.CommonDialog
import com.funidea.newonpe.network.ServerConnection
import com.funidea.newonpe.page.CommonActivity
import com.funidea.newonpe.page.login.LoginPage.Companion.serverConnectionSpec
import kotlinx.android.synthetic.main.activity_id_search.*
import kotlinx.android.synthetic.main.activity_join_page.*
import okhttp3.ResponseBody
import org.json.JSONException
import org.json.JSONObject
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.io.IOException
import java.util.regex.Pattern

/** ID 찾기 Class
 *
 * 사용자가 자신의 ID를 분실한 경우 이름과 이메일을 통해 자신의 ID를 찾는다.
 */

class SearchIDPage : CommonActivity() {

    val mTextWatcherUserName: TextWatcher = object : TextWatcher {

        override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int)
        {
            if (!Pattern.matches("^[ㄱ-ㅎㅏ-ㅣ가-힣].{0,8}", s))
            {
                id_search_input_name_linearlayout.setBackgroundResource(R.drawable.view_red_color_round_edge)
                id_search_input_name_textview.setTextColor(Color.parseColor("#FF0000"))
            }
            else
            {
                if (!Pattern.matches("^[가-힣].{1,8}", s))
                {
                    id_search_input_name_linearlayout.setBackgroundResource(R.drawable.view_red_color_round_edge)
                    id_search_input_name_textview.setTextColor(Color.parseColor("#FF0000"))
                }
                else
                {
                    id_search_input_name_linearlayout.setBackgroundResource(R.drawable.view_main_color_2_round_button)
                    id_search_input_name_textview.setTextColor(Color.parseColor("#3378fd"))
                }
            }

            updateConfirmButtonStatus()
        }

        override fun afterTextChanged(arg0: Editable) {
            // 입력이 끝났을 때
        }

        override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {
            // 입력하기 전에
        }
    }

    val mTextWatcherEmailAddress: TextWatcher = object : TextWatcher {

        override fun beforeTextChanged(charSequence: CharSequence, i: Int, i1: Int, i2: Int) {

            if (!Patterns.EMAIL_ADDRESS.matcher(charSequence).matches())
            {
                id_search_input_email_linearlayout.setBackgroundResource(R.drawable.view_red_color_round_edge)
                id_search_input_email_textview.setTextColor(Color.parseColor("#FF0000"))
            }
            else
            {
                id_search_input_email_linearlayout.setBackgroundResource(R.drawable.view_main_color_2_round_button)
                id_search_input_email_textview.setTextColor(Color.parseColor("#3378fd"))
            }

            //찾기 버튼 활성화 클래스
            updateConfirmButtonStatus()
        }
        override fun onTextChanged(charSequence: CharSequence, i: Int, i1: Int, i2: Int) {
            //특수문자를 포함하는 경우
            //!Pattern.matches("^(?=.*\\d)(?=.*[~`!@#$%\\^&*()-])(?=.*[a-zA-Z]).{8,20}$", charSequence)

            //이메일이 양식에 맞는 지 확인한다.
            //이메일 양식에 일치하지 않는 경우
            if (!Patterns.EMAIL_ADDRESS.matcher(charSequence).matches()) {

                id_search_input_email_linearlayout.setBackgroundResource(R.drawable.view_red_color_round_edge)
                id_search_input_email_textview.setTextColor(Color.parseColor("#FF0000"))
            }
            else
            {
                id_search_input_email_linearlayout.setBackgroundResource(R.drawable.view_main_color_2_round_button)
                id_search_input_email_textview.setTextColor(Color.parseColor("#3378fd"))
            }

            //찾기 버튼 활성화 클래스
            updateConfirmButtonStatus()
        }

        override fun afterTextChanged(editable: Editable)
        {


        }
    }

    private val mClickActionOfConfirmButton = View.OnClickListener {

        if (!isRegularFormatName())
        {
            id_search_input_name_edittext.requestFocus()
            Toast.makeText(this, "이름을 제대로 입력해주세요.", Toast.LENGTH_SHORT).show()
        }
        else if (mSMSAuthButton.isSelected || TextUtils.isEmpty(mAuthedStudentPhoneNumber))
        {
            showDialog("알림", "본인인증을 실행해주세요", buttonCount = CommonDialog.ButtonCount.ONE)
        }
        else
        {
            val insertedName = id_search_input_name_edittext.text.toString()

            Log.d("debug", "++ mClickActionOfConfirmButton insertedName = ${insertedName}")
            Log.d("debug", "++ mClickActionOfConfirmButton mAuthedStudentPhoneNumber = ${mAuthedStudentPhoneNumber}")

            ServerConnection.searchId(insertedName, mAuthedStudentPhoneNumber!!) { isSuccess, userId ->

                if (isSuccess)
                {
                    val message = "회원님의 아이디는 [${userId}] 입니다."
                    showDialog("알림", message, buttonCount = CommonDialog.ButtonCount.ONE) {

                        onBackPressed()
                    }
                }
                else
                {
                    showDialog("알림", "입력된 정보와 일치하는 회원 정보가 없습니다", buttonCount = CommonDialog.ButtonCount.ONE)
                }
            }
        }
    }

    private lateinit var mSMSAuthButton : Button

    private var mAuthedStudentName : String? = ""
    private var mAuthedStudentBirthDate : String? = ""
    private var mAuthedStudentPhoneNumber : String? = ""

    override fun init(savedInstanceState: Bundle?)
    {
        setContentView(R.layout.activity_id_search)

        id_search_input_name_edittext.addTextChangedListener(mTextWatcherUserName)
        id_search_input_email_edittext.addTextChangedListener(mTextWatcherEmailAddress)
        id_search_back_button.setOnClickListener {
            onBackPressed()
        }
        id_search_confirm_textview.setOnClickListener(mClickActionOfConfirmButton)

        mSMSAuthButton = findViewById(R.id.sending_sms_auth_code)
        mSMSAuthButton.isSelected = true
        mSMSAuthButton.setOnClickListener {
            val intent = Intent(this, SMSAuthPage::class.java)
            startActivityForResult(intent, SMSAuthPage.CALL)
            overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)
        }
    }

    override fun onBackPressed()
    {
        super.onBackPressed()
        overridePendingTransition(R.anim.anim_slide_in_left, R.anim.anim_slide_out_right)
    }

    @Suppress("NULLABILITY_MISMATCH_BASED_ON_JAVA_ANNOTATIONS")
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        when (requestCode)
        {
            SMSAuthPage.CALL ->
            {
                val userData = data?.getStringExtra("user")
                if (!TextUtils.isEmpty(userData) && resultCode == RESULT_OK)
                {
                    mSMSAuthButton.isSelected = false
                    mSMSAuthButton.text = "본인인증 완료"

                    val json = JSONObject(userData)
                    mAuthedStudentName = json.getString("name")
                    mAuthedStudentPhoneNumber = json.getString("phone")
                    mAuthedStudentBirthDate = json.getString("birthday")

                    updateConfirmButtonStatus()
                }
            }
        }
    }

    private fun updateConfirmButtonStatus()
    {
        if (isRegularFormatName() && !mSMSAuthButton.isSelected)
        {
            id_search_confirm_textview.setBackgroundColor(Color.parseColor("#3378fd"))
        }
        else
        {
            id_search_confirm_textview.setBackgroundColor(Color.parseColor("#9f9f9f"))
        }
    }

    private fun isRegularFormatName() : Boolean
    {
        val insertedName = id_search_input_name_edittext.text.toString()
        return !TextUtils.isEmpty(insertedName) &&
                Pattern.matches("^[ㄱ-ㅎㅏ-ㅣ가-힣].{0,8}", insertedName) && Pattern.matches("^[가-힣].{1,8}", insertedName)
    }
}