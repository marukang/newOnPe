package com.funidea.newonpe.page.login

import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.text.Editable
import android.text.TextUtils
import android.text.TextWatcher
import android.util.Log
import android.view.View
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import com.funidea.newonpe.R
import com.funidea.newonpe.dialog.CommonDialog
import com.funidea.newonpe.model.CurrentLoginStudent
import com.funidea.newonpe.model.Student
import com.funidea.newonpe.network.ServerConnection
import com.funidea.newonpe.page.CommonActivity
import com.funidea.newonpe.page.main.MainHomePage
import com.funidea.newonpe.services.MyFirebaseMessagingService
import com.google.android.gms.common.internal.service.Common
import kotlinx.android.synthetic.main.activity_login_page.*


/** 로그인 Class
 *
 * 사용자가 앱을 사용하기 위해 로그인을 진행하는 Class
 *
 * 해당 페이지에서 사용자는 자신의 아이디와 비밀번호를 입력해 로그인을 진행하며,
 * 로그인 후에는 자동저장되어 다음 로그인시 부터는 자동 로그인이 설정된다.
 *
 */

class EmailLoginPage : CommonActivity() {


    override fun init(savedInstanceState: Bundle?)
    {
        setContentView(R.layout.activity_login_page)

        login_page_input_id_edittext.addTextChangedListener(mTextWatcherInsertedID) //아이디 입력
        login_page_input_pw_edittext.addTextChangedListener(mTextWatcherInsertedPassword) //비밀번호 입력
        login_page_search_id_textview.setOnClickListener(mClickActionOfIDSearch) //아이디찾기
        login_page_search_pw_textview.setOnClickListener(mClickActionOfPasswordSearch) //비밀번호 찾기
        login_page_join_textview.setOnClickListener(mClickActionOfJoinMember) //회원가입
        login_page_login_textview.setOnClickListener(mClickActionOfLogin) //로그인 버튼
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        when
        {
            requestCode == MemberJoinPage.CALL && resultCode == RESULT_OK ->
            {
                val intent = Intent(this@EmailLoginPage, MainHomePage::class.java)
                startActivity(intent)
                finish()
                overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)
            }
        }
    }

    override fun onBackPressed()
    {
        super.onBackPressed()
        overridePendingTransition(R.anim.anim_slide_in_left, R.anim.anim_slide_out_right)
    }

    private val mClickActionOfIDSearch = View.OnClickListener {
        val intent = Intent(this, SearchIDPage::class.java)
        startActivityForResult(intent, 0)
        overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)
    }
    private val mClickActionOfPasswordSearch = View.OnClickListener {
        val intent = Intent(this, SearchPasswordPage::class.java)
        startActivityForResult(intent, 1)
        overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)
    }

    //회원가입 버튼
    private val mClickActionOfJoinMember = View.OnClickListener {
        val intent = Intent(this, MemberJoinPage::class.java)
        startActivityForResult(intent, MemberJoinPage.CALL)
        overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)
    }

    //로그인 버튼
    private val mClickActionOfLogin = View.OnClickListener {

        val insertedId = login_page_input_id_edittext.text.toString()
        val insertedPassword = login_page_input_pw_edittext.text.toString()

        if (TextUtils.isEmpty(insertedId) || TextUtils.isEmpty(insertedPassword))
        {
          if (TextUtils.isEmpty(insertedId))
          {
              login_page_input_id_edittext.requestFocus()
          }
          else
          {
              login_page_input_pw_edittext.requestFocus()
          }

          Toast.makeText(this, "빈 칸을 확인해주세요.", Toast.LENGTH_SHORT).show()
        }
        else
        {
            var sharedPreferencesSavedToken: String? = ""
            val sharedPreferences = getSharedPreferences("user_info", Context.MODE_PRIVATE)
            if (sharedPreferences.contains("user_id"))
            {
                val sharedPreferencesSavedId : String = sharedPreferences.getString("user_id", "").toString()
                if (sharedPreferencesSavedId == insertedId && !TextUtils.isEmpty(sharedPreferencesSavedId))
                {
                    sharedPreferencesSavedToken = sharedPreferences.getString("user_access_token", "").toString()
                    Log.d("debug", ">> [complexion] snsLogin sharedPreferencesSavedId = $sharedPreferencesSavedId")
                    Log.d("debug", ">> [complexion] snsLogin sharedPreferencesSavedToken = $sharedPreferencesSavedToken")
                }
            }

            val callBack : (Int?, Any?) -> Unit = { code, response ->

                Log.d("debug", ">> [complexion] login callBack code = $code")
                Log.d("debug", ">> [complexion] login callBack response = $response")

                if (code!! > -1)
                {
                    CurrentLoginStudent.root = response as Student

                    val preferences = getSharedPreferences("user_info", Context.MODE_PRIVATE)
                    val editor = preferences.edit()

                    editor.putString("user_id", CurrentLoginStudent.root!!.student_id)
                    editor.putString("user_access_token", CurrentLoginStudent.root!!.access_token)
                    editor.commit()

                    if (TextUtils.isEmpty(CurrentLoginStudent.root!!.student_name))
                    {
                        val intent = Intent(this@EmailLoginPage, ProfileRegistrationPage::class.java)
                        startActivityForResult(intent, 4)
                        overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)
                    }
                    else
                    {
                        val intent = Intent(this@EmailLoginPage, MainHomePage::class.java)
                        startActivity(intent)
                        finish()
                        overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)
                    }
                }
                else if (code == -1)
                {
                    showDialog("알림", "입력한 아이디 및 패스워드를 다시 확인해주세요", buttonCount = CommonDialog.ButtonCount.ONE)
                }
                else
                {
                    showDialog("알림", "서버와 통신중에 오류가 발생하였습니다. 다시 시도하여 주세요", buttonCount = CommonDialog.ButtonCount.ONE)
                }
            }

            ServerConnection.login(insertedId, insertedPassword, callBack)
        }
    }

    //아이디 체크
    private var mTextWatcherInsertedID: TextWatcher = object : TextWatcher {
        override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {

            if (s.isNotEmpty())
            {
                if(login_page_input_pw_edittext.length()>0)
                {
                    login_page_login_textview.setBackgroundResource(R.color.main_color)
                }
                else if(login_page_input_pw_edittext.length()<=0)
                {
                    login_page_login_textview.setBackgroundResource(R.color.gray)
                }

            }
            else
            {
                login_page_login_textview.setBackgroundResource(R.color.gray)
            }
        }

        override fun afterTextChanged(arg0: Editable) {
            // 입력이 끝났을 때
        }

        override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {
            // 입력하기 전에
        }
    }
    //비밀번호 체크
    private var mTextWatcherInsertedPassword: TextWatcher = object : TextWatcher {
        override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {

            if(s.isNotEmpty())
            {
                if(login_page_input_id_edittext.length()>0)
                {
                    login_page_login_textview.setBackgroundResource(R.color.main_color)
                }
                else if(login_page_input_id_edittext.length()<=0)
                {
                    login_page_login_textview.setBackgroundResource(R.color.gray)
                }

            }
            else
            {
                login_page_login_textview.setBackgroundResource(R.color.gray)
            }
        }

        override fun afterTextChanged(arg0: Editable) {
            // 입력이 끝났을 때
        }

        override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {
            // 입력하기 전에
        }
    }
}