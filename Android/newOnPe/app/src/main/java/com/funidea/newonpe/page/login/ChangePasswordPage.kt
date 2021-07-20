package com.funidea.newonpe.page.login


import android.content.Intent
import android.graphics.Color
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.text.Editable
import android.text.TextWatcher
import android.util.Log
import android.view.View
import android.widget.Toast
import com.funidea.newonpe.R
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

class ChangePasswordPage : AppCompatActivity() {


    var input_pw : String =""
    var pw_check : Boolean = false
    var pw_double_check : Boolean = false

    var confirm_code : String=""
    var input_email : String =""

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_pw_search_change)


        var getIntent = intent

        input_email = getIntent.getStringExtra("input_email").toString()
        confirm_code = getIntent.getStringExtra("confirm_code").toString()

        //비밀번호 입력
        pw_search_change_input_pw_edittext.addTextChangedListener(input_pw_check_textWatcher)
        //비밀번호 재확인
        pw_search_change_input_confirm_pw_edittext.addTextChangedListener(input_pw_double_check_textWatcher)

        //확인 버튼
        pw_search_change_confirm_button_textview.setOnClickListener(confirm_button)
        //뒤로가기 버튼
        pw_search_change_back_button.setOnClickListener(back_button)
    }

    val confirm_button = View.OnClickListener {

        if(!pw_check||!pw_double_check)
        {
            if(!pw_check)
            {
                Toast.makeText(this, "비밀번호를 양식에 맞추어 다시 입력해주세요.", Toast.LENGTH_SHORT).show()
                pw_search_change_input_pw_edittext.requestFocus()

            }
            else if(!pw_double_check)
            {
                Toast.makeText(this, "재확인 비밀번호를 다시 확인해주세요.", Toast.LENGTH_SHORT).show()
                pw_search_change_input_confirm_pw_textview.requestFocus()
            }


        }
        else
        {
            if(pw_search_change_input_pw_edittext.text.toString().equals(pw_search_change_input_confirm_pw_edittext.text.toString()))
            {
                pw_search_change_confirm_button_textview.setBackgroundColor(Color.parseColor("#3378fd"))
                //서버 전송 코드
                val change_pw = pw_search_change_input_pw_edittext.text.toString()

                search_change_pw(input_email, change_pw, confirm_code)

            }
            else
            {
                pw_search_change_confirm_button_textview.setBackgroundColor(Color.parseColor("#9f9f9f"))
                Toast.makeText(this, "비밀번호 입력란을 다시 확인해주세요.", Toast.LENGTH_SHORT).show()
                pw_search_change_input_confirm_pw_linearlayout.setBackgroundResource(R.drawable.view_red_color_round_edge)
                pw_search_change_input_confirm_pw_textview.setTextColor(Color.parseColor("#FF0000"))
                pw_double_check = false
                pw_search_change_input_confirm_pw_edittext.requestFocus()
            }

        }
    }


    fun search_change_pw(user_email: String?, user_password: String?, email_code: String?) {


        serverConnectionSpec!!.find_change_pw(user_email, user_password, email_code).enqueue(object : Callback<ResponseBody> {
            override fun onResponse(call: Call<ResponseBody>, response: Response<ResponseBody>) {
                try {
                    val result = JSONObject(response.body()!!.string())
                    var result_value = result.toString()


                    var i : Iterator<String>
                    i =  result.keys()

                    if(i.next().equals("success"))
                    {
                        result_value = result.getString("success")
                        Toast.makeText(this@ChangePasswordPage, "비밀번호가 변경되었습니다.", Toast.LENGTH_SHORT).show()



                        val intent = Intent(this@ChangePasswordPage, EmailLoginPage::class.java)

                        startActivity(intent)
                        finish()
                        overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)

                    }
                    else
                    {
                        result_value = result.getString("fail")
                        Toast.makeText(this@ChangePasswordPage, "실패", Toast.LENGTH_SHORT).show()

                    }



                } catch (e: JSONException) {
                    e.printStackTrace()
                } catch (e: IOException) {
                    e.printStackTrace()
                }
            }

            override fun onFailure(call: Call<ResponseBody>, t: Throwable) {

                Log.d("결과값", "onResponse: "+t)
                Log.d("결과값", "onResponse: "+call)

            }
        })
    }



    //뒤로 가기 버튼
    val back_button = View.OnClickListener {
        onBackPressed()
    }

    override fun onBackPressed()
    {
        super.onBackPressed()
        overridePendingTransition(R.anim.anim_slide_in_left, R.anim.anim_slide_out_right)
    }


    //정규 표현식을 이용해 PW 입력을 확인한다.
    //PW 입력 확인을 위한 TextWatcher
    var input_pw_check_textWatcher: TextWatcher = object : TextWatcher {
        override fun beforeTextChanged(charSequence: CharSequence, i: Int, i1: Int, i2: Int) {}
        override fun onTextChanged(charSequence: CharSequence, i: Int, i1: Int, i2: Int) {
            //특수문자를 포함하는 경우
            //!Pattern.matches("^(?=.*\\d)(?=.*[~`!@#$%\\^&*()-])(?=.*[a-zA-Z]).{8,20}$", charSequence)

            //비밀번호는 영어 대&소문자로 구성되며 8자리에서 16자리로 이루어진다.
            //사용이 불가능한 경우
            if (!Pattern.matches("^(?=.*\\d)(?=.*[~`!@#$%\\^&*()-])(?=.*[a-zA-Z]).{8,16}$", charSequence)) {
                pw_search_change_input_pw_linearlayout.setBackgroundResource(R.drawable.view_red_color_round_edge)
                pw_search_change_input_pw_textview.setTextColor(Color.parseColor("#FF0000"))

                pw_check = false
            }
            else
            {
                pw_search_change_input_pw_linearlayout.setBackgroundResource(R.drawable.view_main_color_2_round_button)
                pw_search_change_input_pw_textview.setTextColor(Color.parseColor("#3378fd"))

                pw_check = true
                //
                // Toast.makeText(getApplicationContext(), input_pw+"", Toast.LENGTH_SHORT).show();
            }

            input_pw  = pw_search_change_input_pw_edittext.text.toString()
            check_value()
            Log.d("확인", "onTextChanged:"+input_pw)
        }

        override fun afterTextChanged(editable: Editable) {}
    }

    //정규 표현식을 이용해 입력 된 PW와 PW 확인을 비교해서 알려준다.
    //앞서 입력한 PW와 PW 재입력 확인을 위한 TextWatcher
    var input_pw_double_check_textWatcher: TextWatcher = object : TextWatcher {
        override fun beforeTextChanged(charSequence: CharSequence, i: Int, i1: Int, i2: Int) {}
        override fun onTextChanged(charSequence: CharSequence, i: Int, i1: Int, i2: Int) {


            //Toast.makeText(getApplicationContext(), charSequence.toString()+"", Toast.LENGTH_SHORT).show();

            //앞서 입력한 PW와 같은지 비교를 한다.

            //앞서 입력한 PW와 같지 않은 경우
            if (charSequence.toString() != input_pw || input_pw == "") {
                pw_search_change_input_confirm_pw_linearlayout.setBackgroundResource(R.drawable.view_red_color_round_edge)
                pw_search_change_input_confirm_pw_textview.setTextColor(Color.parseColor("#FF0000"))
                pw_double_check = false

            } else if (charSequence.toString() == input_pw) {
                pw_search_change_input_confirm_pw_linearlayout.setBackgroundResource(R.drawable.view_main_color_2_round_button)
                pw_search_change_input_confirm_pw_textview.setTextColor(Color.parseColor("#3378fd"))
                pw_double_check = true
            }

            //가입 버튼 활성화 클래스
            check_value()
        }

        override fun afterTextChanged(editable: Editable) {}
    }


    fun check_value()
    {
        if(!pw_check||!pw_double_check)
        {
            pw_search_change_confirm_button_textview.setBackgroundColor(Color.parseColor("#9f9f9f"))
        }
        else
        {
            if(pw_search_change_input_pw_edittext.text.toString().equals(pw_search_change_input_confirm_pw_edittext.text.toString()))
            {
                pw_search_change_confirm_button_textview.setBackgroundColor(Color.parseColor("#3378fd"))
            }
            else
            {
                pw_search_change_confirm_button_textview.setBackgroundColor(Color.parseColor("#9f9f9f"))
            }

        }

    }



}