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
import com.funidea.utils.Utility
import kotlinx.android.synthetic.main.activity_id_search.*
import kotlinx.android.synthetic.main.activity_join_page.*
import kotlinx.android.synthetic.main.activity_pw_search.*
import okhttp3.ResponseBody
import org.json.JSONException
import org.json.JSONObject
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.io.IOException
import java.util.regex.Pattern

/** PW 찾기 Class
 *
 * 사용자가 자신의 PW를 분실한 경우 이름, 이메일, 아이디를 통해 자신의 PW를 찾는다.
 */

class SearchPasswordPage : CommonActivity() {

    //아이디 확인을 위한 TextWatcher
    private val mTextWatcherInsertedId: TextWatcher = object : TextWatcher {
        //입력되는 텍스트에 변화가 있을 때
        override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {


            // if (!Pattern.matches("^(?=.*\\d)(?=.*[a-zA-Z]).{4,12}$", s))
            if (!Patterns.EMAIL_ADDRESS.matcher(s).matches())
            {

                pw_search_input_id_linearlayout.setBackgroundResource(R.drawable.view_red_color_round_edge)
                pw_search_input_id_textview.setTextColor(Color.parseColor("#FF0000"))
            }
            else
            {
                pw_search_input_id_linearlayout.setBackgroundResource(R.drawable.view_main_color_2_round_button)
                pw_search_input_id_textview.setTextColor(Color.parseColor("#3378fd"))
            }

            //확인 버튼 활성화 여부 확인 클래스
            updateConfirmButtonStatus()
        }

        override fun afterTextChanged(arg0: Editable) {
            // 입력이 끝났을 때
        }

        override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {
            // 입력하기 전에
        }
    }


    //이름 정규 표현식
    //이름 입력 확인을 위한 TextWatcher
    private val mTextWatcherInsertedName: TextWatcher = object : TextWatcher {
        override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {

            // 입력되는 텍스트에 변화가 있을 때

            //아래와 같이 한글 외에 것이 포함된 경우
            if (!Pattern.matches("^[ㄱ-ㅎㅏ-ㅣ가-힣].{0,8}", s))
            {
                pw_search_input_name_linearlayout.setBackgroundResource(R.drawable.view_red_color_round_edge)
                pw_search_input_name_textview.setTextColor(Color.parseColor("#FF0000"))
            }
            else
            {
                if (!Pattern.matches("^[가-힣].{1,8}", s))
                {
                    pw_search_input_name_linearlayout.setBackgroundResource(R.drawable.view_red_color_round_edge)
                    pw_search_input_name_textview.setTextColor(Color.parseColor("#FF0000"))
                }
                else
                {
                    pw_search_input_name_linearlayout.setBackgroundResource(R.drawable.view_main_color_2_round_button)
                    pw_search_input_name_textview.setTextColor(Color.parseColor("#3378fd"))
                }
            }

            //확인 버튼 활성화 여부 확인 클래스
            updateConfirmButtonStatus()
        }

        override fun afterTextChanged(arg0: Editable) {
            // 입력이 끝났을 때
        }

        override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {
            // 입력하기 전에
        }
    }
    //이메일 입력 확인을 위한 TextWatcher
    private val mTextWatcherInsertedEmail: TextWatcher = object : TextWatcher {
        override fun beforeTextChanged(charSequence: CharSequence, i: Int, i1: Int, i2: Int) {

            if (!Patterns.EMAIL_ADDRESS.matcher(charSequence).matches())
            {

                pw_search_input_email_linearlayout.setBackgroundResource(R.drawable.view_red_color_round_edge)
                pw_search_input_email_textview.setTextColor(Color.parseColor("#FF0000"))

            }
            else
            {
                pw_search_input_email_linearlayout.setBackgroundResource(R.drawable.view_main_color_2_round_button)
                pw_search_input_email_textview.setTextColor(Color.parseColor("#3378fd"))
            }

            //확인 버튼 활성화 여부 확인 클래스
            updateConfirmButtonStatus()
        }
        override fun onTextChanged(charSequence: CharSequence, i: Int, i1: Int, i2: Int) {

            //이메일이 양식에 맞는 지 확인한다.
            //이메일 양식에 일치하지 않는 경우
            if (!Patterns.EMAIL_ADDRESS.matcher(charSequence).matches())
            {

                pw_search_input_email_linearlayout.setBackgroundResource(R.drawable.view_red_color_round_edge)
                pw_search_input_email_textview.setTextColor(Color.parseColor("#FF0000"))

            }
            else
            {
                pw_search_input_email_linearlayout.setBackgroundResource(R.drawable.view_main_color_2_round_button)
                pw_search_input_email_textview.setTextColor(Color.parseColor("#3378fd"))
            }

            //확인 버튼 활성화 여부 확인 클래스
            updateConfirmButtonStatus()
        }

        override fun afterTextChanged(editable: Editable)
        {


        }
    }

    private var mAuthedStudentName : String? = ""
    private var mAuthedStudentBirthDate : String? = ""
    private var mAuthedStudentPhoneNumber : String? = ""

    override fun init(savedInstanceState: Bundle?)
    {
        setContentView(R.layout.activity_pw_search)

        pw_search_input_name_edittext.addTextChangedListener(mTextWatcherInsertedName)
        pw_search_input_email_edittext.addTextChangedListener(mTextWatcherInsertedEmail)
        pw_search_input_id_edittext.addTextChangedListener(mTextWatcherInsertedId)
        pw_search_back_button.setOnClickListener {
            onBackPressed()
        }

        pw_search_confirm_textview.setOnClickListener {
            val intent = Intent(this, SMSAuthPage::class.java)
            startActivityForResult(intent, SMSAuthPage.CALL)
            overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)
        }
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
                    val json = JSONObject(userData)
                    mAuthedStudentName = json.getString("name")
                    mAuthedStudentPhoneNumber = Utility.getPhoneNumberWithHyphen(json.getString("phone"))
                    mAuthedStudentBirthDate = json.getString("birthday")

                    val insertedId : String = pw_search_input_id_edittext.text.toString()
                    val insertedName : String = pw_search_input_name_edittext.text.toString()
                    if (!TextUtils.isEmpty(mAuthedStudentName) && mAuthedStudentName.equals(insertedName))
                    {
                        ServerConnection.searchPassword(insertedId, mAuthedStudentName!!, mAuthedStudentPhoneNumber!!) { isSuccess, authenticationCode, emailAddress ->

                            if (isSuccess)
                            {
                                movePasswordChangePage(emailAddress!!, authenticationCode!!)
                            }
                            else
                            {
                                showDialog("알림", "일치하는 회원정보가 없습니다", buttonCount = CommonDialog.ButtonCount.ONE)
                            }
                        }
                    }
                    else
                    {
                        showDialog("알림", "실명인증한 정보와 일치하지 않습니다", buttonCount = CommonDialog.ButtonCount.ONE)
                    }
                }
            }

            999 ->
            {
                if (resultCode == RESULT_OK)
                {
                    setResult(RESULT_OK)

                    onBackPressed()
                }
            }

        }
    }

    override fun onBackPressed()
    {
        super.onBackPressed()
        overridePendingTransition(R.anim.anim_slide_in_left, R.anim.anim_slide_out_right)
    }

    private fun updateConfirmButtonStatus()
    {
        if(isRegularFormatId() && isRegularFormatName())
        {
            pw_search_confirm_textview.setBackgroundColor(Color.parseColor("#3378fd"))
        }
        else
        {
            pw_search_confirm_textview.setBackgroundColor(Color.parseColor("#9f9f9f"))
        }
    }

    private fun isRegularFormatId() : Boolean
    {
        val insertedId = pw_search_input_id_edittext.text.toString()
        // return !TextUtils.isEmpty(insertedId) && Pattern.matches("^(?=.*\\d)(?=.*[a-zA-Z]).{4,12}$", insertedId)
        return !TextUtils.isEmpty(insertedId) && Patterns.EMAIL_ADDRESS.matcher(insertedId).matches()
    }

    private fun isRegularFormatName() : Boolean
    {
        val insertedName = pw_search_input_name_edittext.text.toString()
        return !TextUtils.isEmpty(insertedName) &&
                Pattern.matches("^[ㄱ-ㅎㅏ-ㅣ가-힣].{0,8}", insertedName) && Pattern.matches("^[가-힣].{1,8}", insertedName)
    }

    private fun movePasswordChangePage(insertedEmail : String, authenticationCode : String)
    {
        val intent = Intent(this@SearchPasswordPage, ChangePasswordPage::class.java)
        intent.putExtra("insertedEmail", insertedEmail)
        intent.putExtra("authenticationCode", authenticationCode)
        startActivityForResult(intent, 999)
        overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)
    }
}