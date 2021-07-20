package com.funidea.newonpe.page.login

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

class SearchIDPage : AppCompatActivity() {

    var name_check : Boolean = false
    var email_check : Boolean = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_id_search)

        //아이디 찾기
        id_search_input_name_edittext.addTextChangedListener(input_name_textWatcher)

        //이메일 주소
        id_search_input_email_edittext.addTextChangedListener(input_email_check_textWatcher)

        //뒤로 가기 버튼
        id_search_back_button.setOnClickListener(back_button)

        //아이디 찾기 확인 버튼
        id_search_confirm_textview.setOnClickListener(confirm_button)
    }

    //확인 버튼
    val confirm_button = View.OnClickListener {


        if(!name_check||!email_check)
        {
           if(!name_check) {

               id_search_input_name_edittext.requestFocus()
               Toast.makeText(this, "이름을 제대로 입력해주세요.", Toast.LENGTH_SHORT).show()
           }
           else{

               id_search_input_email_edittext.requestFocus()
               Toast.makeText(this, "이메일을 제대로 입력해주세요.", Toast.LENGTH_SHORT).show()

           }

        }
        else
        {
            //아이디, 이메일 찾기
            search_id(id_search_input_name_edittext.text.toString(), id_search_input_email_edittext.text.toString())
        }
    }


    fun search_id(user_id: String?, user_email: String?) {


     serverConnectionSpec!!.find_id(user_id, user_email).enqueue(object : Callback<ResponseBody> {
            override fun onResponse(call: Call<ResponseBody>, response: Response<ResponseBody>) {
                try {
                    val result = JSONObject(response.body()!!.string())
                    var result_value = result.toString()
                    Log.d("debug", "++ [complexion] find_id onResponse result = " + result)
                    Log.d("debug", "++ [complexion] find_id onResponse  result_value = " + result_value)

                    var i : Iterator<String>
                    i =  result.keys()

                    if(i.next().equals("success"))
                    {
                        result_value = result.getString("success")



//                        val intent = Intent(this@SearchIDPage, id_search_complete_Activity::class.java)
//                        intent.putExtra("search_id", result_value)
//                        startActivity(intent)
//                        finish()
//                        overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)


                    }
                    else
                    {
                        result_value = result.getString("fail")


                        Toast.makeText(this@SearchIDPage, "이름과 이메일을 다시 확인해주세요.", Toast.LENGTH_SHORT).show()

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

    //이름 정규 표현식
    //이름 입력 확인을 위한 TextWatcher
    val input_name_textWatcher: TextWatcher = object : TextWatcher {
        override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {

            // 입력되는 텍스트에 변화가 있을 때

            //아래와 같이 한글 외에 것이 포함된 경우
            if (!Pattern.matches("^[ㄱ-ㅎㅏ-ㅣ가-힣].{0,8}", s)) {
                id_search_input_name_linearlayout.setBackgroundResource(R.drawable.view_red_color_round_edge)
                id_search_input_name_textview.setTextColor(Color.parseColor("#FF0000"))
                name_check = false
            } else {

                //자음만을 입력하는 것을 방지
                //자음+모음으로 이루어진 글자로 2~8글자 사이가 아닐 경우
                if (!Pattern.matches("^[가-힣].{1,8}", s)) {
                    id_search_input_name_linearlayout.setBackgroundResource(R.drawable.view_red_color_round_edge)
                    id_search_input_name_textview.setTextColor(Color.parseColor("#FF0000"))
                    name_check =false
                } else {

                    id_search_input_name_linearlayout.setBackgroundResource(R.drawable.view_main_color_2_round_button)
                    id_search_input_name_textview.setTextColor(Color.parseColor("#3378fd"))
                    name_check = true

                }
            }

            //찾기 버튼 활성화 클래스
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

                id_search_input_email_linearlayout.setBackgroundResource(R.drawable.view_red_color_round_edge)
                id_search_input_email_textview.setTextColor(Color.parseColor("#FF0000"))

                email_check = false


            } else {
                id_search_input_email_linearlayout.setBackgroundResource(R.drawable.view_main_color_2_round_button)
                id_search_input_email_textview.setTextColor(Color.parseColor("#3378fd"))

                email_check = true
            }

            //찾기 버튼 활성화 클래스
            check_value()
        }
        override fun onTextChanged(charSequence: CharSequence, i: Int, i1: Int, i2: Int) {
            //특수문자를 포함하는 경우
            //!Pattern.matches("^(?=.*\\d)(?=.*[~`!@#$%\\^&*()-])(?=.*[a-zA-Z]).{8,20}$", charSequence)

            //이메일이 양식에 맞는 지 확인한다.
            //이메일 양식에 일치하지 않는 경우
            if (!Patterns.EMAIL_ADDRESS.matcher(charSequence).matches()) {

                id_search_input_email_linearlayout.setBackgroundResource(R.drawable.view_red_color_round_edge)
                id_search_input_email_textview.setTextColor(Color.parseColor("#FF0000"))
                email_check = false


            } else {
                id_search_input_email_linearlayout.setBackgroundResource(R.drawable.view_main_color_2_round_button)
                id_search_input_email_textview.setTextColor(Color.parseColor("#3378fd"))
                email_check = true
            }

            //찾기 버튼 활성화 클래스
            check_value()
        }

        override fun afterTextChanged(editable: Editable)
        {


        }
    }

    //찾기 버튼 활성화 여부를 정해줄 함수
    //이름과 이메일이 정상적으로 입력되었는지를 확인 해준다.
    fun check_value()
    {
        if(!name_check||!email_check)
        {
            id_search_confirm_textview.setBackgroundColor(Color.parseColor("#9f9f9f"))
        }
        else
        {
            id_search_confirm_textview.setBackgroundColor(Color.parseColor("#3378fd"))
        }

    }
}