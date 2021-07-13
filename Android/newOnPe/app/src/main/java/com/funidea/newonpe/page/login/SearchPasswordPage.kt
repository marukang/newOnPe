package com.funidea.newonpe.page.login


import android.content.Intent
import android.graphics.Color
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.text.Editable
import android.text.TextWatcher
import android.util.Log
import android.util.Patterns
import android.view.View
import android.widget.Toast
import com.funidea.newonpe.R
import com.funidea.newonpe.page.login.SplashActivity.Companion.serverConnection
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

class SearchPasswordPage : AppCompatActivity() {

    var name_check : Boolean = false
    var email_check : Boolean = false
    var id_check : Boolean = false


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_pw_search)

        //이름 정규 표현식
        pw_search_input_name_edittext.addTextChangedListener(input_name_textWatcher)
        //이메일 정규 표현식
        pw_search_input_email_edittext.addTextChangedListener(input_email_check_textWatcher)
        //아이디 정규 표현식
        pw_search_input_id_edittext.addTextChangedListener(input_id_check_textWatcher)
        //뒤로 가기 버튼
        pw_search_back_button.setOnClickListener(back_button)
        //확인 버튼
        pw_search_confirm_textview.setOnClickListener(confirm_button)

    }

    //확인 버튼
    val confirm_button = View.OnClickListener {


        if(!name_check||!email_check||!id_check)
        {
            if(!name_check) {

                pw_search_input_name_edittext.requestFocus()
                Toast.makeText(this, "이름을 제대로 입력해주세요.", Toast.LENGTH_SHORT).show()
            }
            else if(!id_check)
            {
                pw_search_input_id_edittext.requestFocus()
                Toast.makeText(this, "아이디를 제대로 입력해주세요.", Toast.LENGTH_SHORT).show()
            }

            else if(!email_check){

                pw_search_input_email_edittext.requestFocus()
                Toast.makeText(this, "이메일을 제대로 입력해주세요.", Toast.LENGTH_SHORT).show()

            }


        }
        else
        {

            var pw_input_id : String = pw_search_input_id_edittext.text.toString()
            var pw_input_name : String = pw_search_input_name_edittext.text.toString()
            var pw_input_email : String = pw_search_input_email_edittext.text.toString()
            search_pw(pw_input_id,
                    pw_input_name,
                    pw_input_email)


        }
    }



    fun search_pw(user_id: String?, user_name: String?, user_email: String?) {


        serverConnection!!.find_pw(user_id, user_name, user_email).enqueue(object : Callback<ResponseBody> {
            override fun onResponse(call: Call<ResponseBody>, response: Response<ResponseBody>) {
                try {
                    val result = JSONObject(response.body()!!.string())
                    var result_value = result.toString()



                    var i : Iterator<String>
                    i =  result.keys()

                    if(i.next().equals("success"))
                    {
                        result_value = result.getString("success")


                        //추후 바꿀 것
                        val intent = Intent(this@SearchPasswordPage, EmailAuthenticationPage::class.java)
                        intent.putExtra("confirm_code", result_value)
                        intent.putExtra("input_email", user_email)
                        startActivity(intent)
                        finish()
                        overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)


                    }
                    else
                    {
                        result_value = result.getString("fail")


                        Toast.makeText(this@SearchPasswordPage, "이메일, 이름, 아이디를 다시 확인해주세요.", Toast.LENGTH_SHORT).show()

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

    //아이디 확인을 위한 TextWatcher
    val input_id_check_textWatcher: TextWatcher = object : TextWatcher {
        //입력되는 텍스트에 변화가 있을 때
        override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {


            if (!Pattern.matches("^(?=.*\\d)(?=.*[a-zA-Z]).{4,12}$", s)) {

                pw_search_input_id_linearlayout.setBackgroundResource(R.drawable.view_red_color_round_edge)
                pw_search_input_id_textview.setTextColor(Color.parseColor("#FF0000"))
                id_check = false

            }
            else
            {

                pw_search_input_id_linearlayout.setBackgroundResource(R.drawable.view_main_color_2_round_button)
                pw_search_input_id_textview.setTextColor(Color.parseColor("#3378fd"))

                id_check = true
            }

            //확인 버튼 활성화 여부 확인 클래스
            check_value()
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
    val input_name_textWatcher: TextWatcher = object : TextWatcher {
        override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {

            // 입력되는 텍스트에 변화가 있을 때

            //아래와 같이 한글 외에 것이 포함된 경우
            if (!Pattern.matches("^[ㄱ-ㅎㅏ-ㅣ가-힣].{0,8}", s)) {
                pw_search_input_name_linearlayout.setBackgroundResource(R.drawable.view_red_color_round_edge)
                pw_search_input_name_textview.setTextColor(Color.parseColor("#FF0000"))
                name_check = false
            } else {

                //자음만을 입력하는 것을 방지
                //자음+모음으로 이루어진 글자로 2~8글자 사이가 아닐 경우
                if (!Pattern.matches("^[가-힣].{1,8}", s)) {
                    pw_search_input_name_linearlayout.setBackgroundResource(R.drawable.view_red_color_round_edge)
                    pw_search_input_name_textview.setTextColor(Color.parseColor("#FF0000"))
                    name_check =false
                } else {

                    pw_search_input_name_linearlayout.setBackgroundResource(R.drawable.view_main_color_2_round_button)
                    pw_search_input_name_textview.setTextColor(Color.parseColor("#3378fd"))
                    name_check = true

                }
            }

            //확인 버튼 활성화 여부 확인 클래스
            check_value()
        }

        override fun afterTextChanged(arg0: Editable) {
            // 입력이 끝났을 때
        }

        override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {
            // 입력하기 전에
        }
    }
    //이메일 입력 확인을 위한 TextWatcher
    val input_email_check_textWatcher: TextWatcher = object : TextWatcher {
        override fun beforeTextChanged(charSequence: CharSequence, i: Int, i1: Int, i2: Int) {

            if (!Patterns.EMAIL_ADDRESS.matcher(charSequence).matches()) {

                pw_search_input_email_linearlayout.setBackgroundResource(R.drawable.view_red_color_round_edge)
                pw_search_input_email_textview.setTextColor(Color.parseColor("#FF0000"))

                email_check = false


            } else {
                pw_search_input_email_linearlayout.setBackgroundResource(R.drawable.view_main_color_2_round_button)
                pw_search_input_email_textview.setTextColor(Color.parseColor("#3378fd"))

                email_check = true
            }

            //확인 버튼 활성화 여부 확인 클래스
            check_value()
        }
        override fun onTextChanged(charSequence: CharSequence, i: Int, i1: Int, i2: Int) {

            //이메일이 양식에 맞는 지 확인한다.
            //이메일 양식에 일치하지 않는 경우
            if (!Patterns.EMAIL_ADDRESS.matcher(charSequence).matches()) {

                pw_search_input_email_linearlayout.setBackgroundResource(R.drawable.view_red_color_round_edge)
                pw_search_input_email_textview.setTextColor(Color.parseColor("#FF0000"))
                email_check = false


            } else {
                pw_search_input_email_linearlayout.setBackgroundResource(R.drawable.view_main_color_2_round_button)
                pw_search_input_email_textview.setTextColor(Color.parseColor("#3378fd"))
                email_check = true
            }

            //확인 버튼 활성화 여부 확인 클래스
            check_value()
        }

        override fun afterTextChanged(editable: Editable)
        {


        }
    }

    fun check_value()
    {
        if(!name_check||!email_check||!id_check)
        {
            pw_search_confirm_textview.setBackgroundColor(Color.parseColor("#9f9f9f"))
        }
        else
        {
            pw_search_confirm_textview.setBackgroundColor(Color.parseColor("#3378fd"))
        }

    }
}