package com.funidea.newonpe.login

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
import com.funidea.utils.Custom_Toast.Companion.custom_toast
import com.funidea.utils.set_User_info
import com.funidea.utils.set_User_info.Companion.access_token
import com.funidea.utils.set_User_info.Companion.fcm_token
import com.funidea.utils.set_User_info.Companion.student_id
import com.funidea.newonpe.R
import com.funidea.newonpe.login.search_id_pw.id_search_Activity
import com.funidea.newonpe.login.search_id_pw.pw_search_Activity
import com.funidea.newonpe.main_home.MainHomeActivity
import com.funidea.newonpe.SplashActivity.Companion.serverConnection
import kotlinx.android.synthetic.main.activity_login_page.*
import okhttp3.ResponseBody
import org.json.JSONException
import org.json.JSONObject
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.io.IOException


/** 로그인 Class
 *
 * 사용자가 앱을 사용하기 위해 로그인을 진행하는 Class
 *
 * 해당 페이지에서 사용자는 자신의 아이디와 비밀번호를 입력해 로그인을 진행하며,
 * 로그인 후에는 자동저장되어 다음 로그인시 부터는 자동 로그인이 설정된다.
 *
 */

class login_page_Activity : AppCompatActivity() {


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_login_page)


        //아이디 입력
        login_page_input_id_edittext.addTextChangedListener(id_textWatcher)

        //비밀번호 입력
        login_page_input_pw_edittext.addTextChangedListener(pw_textWatcher)

        //아이디찾기
        login_page_search_id_textview.setOnClickListener(id_search_button)

        //비밀번호 찾기
        login_page_search_pw_textview.setOnClickListener(pw_search_button)

        //회원가입
        login_page_join_textview.setOnClickListener(join_button)

        //로그인 버튼
        login_page_login_textview.setOnClickListener(login_button)


    }


    fun setUserinfo(dosa_id: String?, dosa_pw: String?) {

       serverConnection!!.login(dosa_id, dosa_pw, fcm_token).enqueue(object : Callback<ResponseBody> {
            override fun onResponse(call: Call<ResponseBody>, response: Response<ResponseBody>) {
                try {
                    val result = JSONObject(response.body()!!.string())
                    val result_value = result.toString()

                    Log.d("결과값", "onResponse:"+result_value)
                    var i : Iterator<String>
                    i =  result.keys()

                    if(!i.next().equals("fail"))
                    {

                        var setUserInfo = set_User_info()

                        setUserInfo.set_user_info(result)



                        custom_toast(this@login_page_Activity, "로그인이 되었습니다.")

                        val prefs = getSharedPreferences("user_info", Context.MODE_PRIVATE)
                        val editor = prefs.edit()

                        editor.putString("user_id", student_id)
                        editor.putString("user_access_token", access_token)

                        editor.commit()


                        val intent = Intent(this@login_page_Activity, MainHomeActivity::class.java)
                        startActivity(intent)
                        overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)
                        finish()
                    }
                    else
                    {
                        //Toast.makeText(this@login_page_Activity, "로그인이 되었습니다.", Toast.LENGTH_SHORT).show()


                        custom_toast(this@login_page_Activity, "아이디와 비밀번호를 확인해주세요.")


                    }



                } catch (e: JSONException) {
                    e.printStackTrace()
                } catch (e: IOException) {
                    e.printStackTrace()
                }
            }

            override fun onFailure(call: Call<ResponseBody>, t: Throwable) {


                custom_toast(this@login_page_Activity, resources.getString(R.string.fail_connect))

            }
        })
    }


    val id_search_button = View.OnClickListener {
        val intent = Intent(this, id_search_Activity::class.java)
        startActivity(intent)
        overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)
    }
    val pw_search_button = View.OnClickListener {
        val intent = Intent(this, pw_search_Activity::class.java)
        startActivity(intent)
        overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)
    }

    //회원가입 버튼
    val join_button = View.OnClickListener {

        val intent = Intent(this, join_page_Activity::class.java)
        startActivity(intent)
        overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)


    }

    //아이디 체크
    var id_textWatcher: TextWatcher = object : TextWatcher {
        override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {

           if(s.length>0)
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
    var pw_textWatcher: TextWatcher = object : TextWatcher {
        override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {

            if(s.length>0)
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
    //로그인 버튼
    val login_button = View.OnClickListener {

        if(TextUtils.isEmpty(login_page_input_id_edittext.text.toString())||
            TextUtils.isEmpty(login_page_input_pw_edittext.text.toString()))
        {
          if(TextUtils.isEmpty(login_page_input_id_edittext.text.toString()))
          {
              login_page_input_id_edittext.requestFocus()
          }
          else
          {
              login_page_input_pw_edittext.requestFocus()
          }

          Toast.makeText(this, "빈 칸을 확인해주세요.", Toast.LENGTH_SHORT).show()

        }
        else{

            //서버 전송 코드

            setUserinfo(login_page_input_id_edittext.text.toString(),
                    login_page_input_pw_edittext.text.toString())
        }

    }
}