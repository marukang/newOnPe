package com.funidea.newonpe.page.login


import android.content.Intent
import android.graphics.Color
import android.os.Bundle
import android.text.Editable
import android.text.TextUtils
import android.text.TextWatcher
import android.util.Log
import android.view.View
import android.widget.Toast
import com.funidea.newonpe.R
import com.funidea.newonpe.dialog.CommonDialog
import com.funidea.newonpe.network.ServerConnection
import com.funidea.newonpe.page.CommonActivity
import com.funidea.newonpe.page.login.LoginPage.Companion.serverConnectionSpec
import kotlinx.android.synthetic.main.activity_id_search.*
import kotlinx.android.synthetic.main.activity_join_page.*
import kotlinx.android.synthetic.main.activity_pw_search_change.*
import okhttp3.ResponseBody
import org.json.JSONException
import org.json.JSONObject
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.io.IOException
import java.util.regex.Pattern

/** PW 찾기 비밀번호 변경 Class
 *
 * 사용자가 자신의 PW를 찾기를 통해 인증 완료 후 새로운 비밀번호를 설정하는 화면
 *
 * 사용자는 PW를 찾기를 통해 자신의 이름, 이메일, 아이디를 입력하고 인증코드를 통해 본인 확인 후
 * 새로운 비밀번호를 설정하는 해당 화면으로 온다.
 * 해당 화면에서 새로운 비밀번호를 설정한다.
 *
 */

class ChangePasswordPage : CommonActivity() {

    var mAuthenticationCode : String=""
    var mInsertedEmailAddress : String =""

    override fun init(savedInstanceState: Bundle?)
    {
        setContentView(R.layout.activity_pw_search_change)

        mInsertedEmailAddress = intent.getStringExtra("insertedEmail").toString()
        mAuthenticationCode = intent.getStringExtra("authenticationCode").toString()

        //비밀번호 입력
        pw_search_change_input_pw_edittext.addTextChangedListener(mTextWatcherOfPasswordInputBox1)
        pw_search_change_input_confirm_pw_edittext.addTextChangedListener(mTextWatcherOfPasswordInputBox2)

        pw_search_change_confirm_button_textview.setOnClickListener {

            val insertedPassword = pw_search_change_input_pw_edittext.text.toString()

            ServerConnection.changePassword(mInsertedEmailAddress, insertedPassword, mAuthenticationCode) { isSuccess ->

                if (isSuccess)
                {
                    showDialog("알림", "성공적으로 패스워드가 변경 되었습니다", buttonCount = CommonDialog.ButtonCount.ONE) {
                        setResult(RESULT_OK)
                        onBackPressed()
                    }
                }
                else
                {
                    showDialog("알림", "패스워드 변경중 에러가 발생하였습니다", buttonCount = CommonDialog.ButtonCount.ONE)
                }
            }

        }
        pw_search_change_back_button.setOnClickListener{
            onBackPressed()
        }
    }

    override fun onBackPressed()
    {
        super.onBackPressed()
        overridePendingTransition(R.anim.anim_slide_in_left, R.anim.anim_slide_out_right)
    }


    //정규 표현식을 이용해 PW 입력을 확인한다.
    //PW 입력 확인을 위한 TextWatcher
    private var mTextWatcherOfPasswordInputBox1: TextWatcher = object : TextWatcher {
        override fun beforeTextChanged(charSequence: CharSequence, i: Int, i1: Int, i2: Int)
        {

        }
        override fun onTextChanged(charSequence: CharSequence, i: Int, i1: Int, i2: Int) {
            //특수문자를 포함하는 경우
            //!Pattern.matches("^(?=.*\\d)(?=.*[~`!@#$%\\^&*()-])(?=.*[a-zA-Z]).{8,20}$", charSequence)

            //비밀번호는 영어 대&소문자로 구성되며 8자리에서 16자리로 이루어진다.
            //사용이 불가능한 경우
            if (!Pattern.matches("^(?=.*\\d)(?=.*[~`!@#$%\\^&*()-])(?=.*[a-zA-Z]).{8,16}$", charSequence))
            {
                pw_search_change_input_pw_linearlayout.setBackgroundResource(R.drawable.view_red_color_round_edge)
                pw_search_change_input_pw_textview.setTextColor(Color.parseColor("#FF0000"))
            }
            else
            {
                pw_search_change_input_pw_linearlayout.setBackgroundResource(R.drawable.view_main_color_2_round_button)
                pw_search_change_input_pw_textview.setTextColor(Color.parseColor("#3378fd"))
            }

            updateConfirmButtonStatus()
        }

        override fun afterTextChanged(editable: Editable) {}
    }

    //정규 표현식을 이용해 입력 된 PW와 PW 확인을 비교해서 알려준다.
    //앞서 입력한 PW와 PW 재입력 확인을 위한 TextWatcher
    private var mTextWatcherOfPasswordInputBox2: TextWatcher = object : TextWatcher {
        override fun beforeTextChanged(charSequence: CharSequence, i: Int, i1: Int, i2: Int) {}
        override fun onTextChanged(charSequence: CharSequence, i: Int, i1: Int, i2: Int) {

            //앞서 입력한 PW와 같지 않은 경우
            if (!isPasswordDoubleChecked())
            {
                pw_search_change_input_confirm_pw_linearlayout.setBackgroundResource(R.drawable.view_red_color_round_edge)
                pw_search_change_input_confirm_pw_textview.setTextColor(Color.parseColor("#FF0000"))

            }
            else
            {
                pw_search_change_input_confirm_pw_linearlayout.setBackgroundResource(R.drawable.view_main_color_2_round_button)
                pw_search_change_input_confirm_pw_textview.setTextColor(Color.parseColor("#3378fd"))
            }

            //가입 버튼 활성화 클래스
            updateConfirmButtonStatus()
        }

        override fun afterTextChanged(editable: Editable) {}
    }


    private fun updateConfirmButtonStatus()
    {
        if (!isPasswordDoubleChecked() || !isRegularFormatPassword())
        {
            pw_search_change_confirm_button_textview.setBackgroundColor(Color.parseColor("#9f9f9f"))
            pw_search_change_confirm_button_textview.isEnabled = false
        }
        else
        {
            pw_search_change_confirm_button_textview.setBackgroundColor(Color.parseColor("#3378fd"))
            pw_search_change_confirm_button_textview.isEnabled = true
        }
    }

    private fun isRegularFormatPassword() : Boolean
    {
        val insertPassword = pw_search_change_input_pw_edittext.text.toString()
        return !TextUtils.isEmpty(insertPassword) && Pattern.matches("^(?=.*\\d)(?=.*[~`!@#$%\\^&*()-])(?=.*[a-zA-Z]).{8,16}$", insertPassword)
    }

    private fun isPasswordDoubleChecked() : Boolean
    {
        val insertedPassword1 = pw_search_change_input_pw_edittext.text.toString()
        val insertedPassword2 = pw_search_change_input_confirm_pw_edittext.text.toString()

        return (!TextUtils.isEmpty(insertedPassword1) && insertedPassword1 == insertedPassword2)
    }
}