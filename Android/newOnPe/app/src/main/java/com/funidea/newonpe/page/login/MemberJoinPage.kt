package com.funidea.newonpe.page.login

import android.content.Intent
import android.graphics.Color
import android.os.Bundle
import android.text.Editable
import android.text.TextWatcher
import android.util.Log
import android.util.Patterns
import android.view.View
import android.view.View.OnFocusChangeListener
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import com.funidea.utils.CustomToast.Companion.show
import com.funidea.newonpe.R
import com.funidea.newonpe.page.setting.PersonalAgreementPage
import com.funidea.newonpe.page.setting.terms_of_user_information_agreement_Activity
import com.funidea.newonpe.page.login.SplashActivity.Companion.serverConnection
import kotlinx.android.synthetic.main.activity_join_page.*
import okhttp3.ResponseBody
import org.json.JSONException
import org.json.JSONObject
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.io.IOException
import java.util.regex.Pattern

/** 회원 가입 Class
 *
 * 사용자 회원가입을 위한 Page이며, 해당 페이지에서
 * 사용자는 아이디, 비밀번호, 이름, 전화번호(선택), 이메일, 이메일 인증, 푸시 동의 등을 설정하게 되며
 * 회원가입을 진행하는 클래스이다.
 *
 */

class MemberJoinPage : AppCompatActivity() {

    var input_pw : String =""
    var id_check : Boolean = false
    var id_confirm_check : Boolean = false
    var pw_check : Boolean = false
    var pw_double_check : Boolean = false
    var name_check : Boolean = false
    var email_check : Boolean = false
    var email_confirm_check : Boolean = false
    var email_code_check : Boolean = false
    var checkbox_1_check : Boolean = false
    var checkbox_2_check : Boolean = false
    var checkbox_3_check : Boolean = false
    var checkbox_4_check : Boolean = false
    var email_confirm_code : String = ""
    var join_confirm : Boolean = false
    var student_push_agreement : String = "n"

    override fun onCreate(savedInstanceState: Bundle?)
    {
        super.onCreate(savedInstanceState)

        setContentView(R.layout.activity_join_page)

        join_page_personal_info_agreement_textview.setOnClickListener(personal_info_agree) //개인정보 이용 동의
        join_page_terms_of_user_info_agree.setOnClickListener(terms_of_user_info_agree) //온체육 서비스 이용 약관 동의


        //전체 선택 버튼
        join_page_checkbox_all.setOnClickListener(all_check)
        //선택버튼
        join_page_checkbox_1.setOnClickListener(onCheckBoxClickListener);
        join_page_checkbox_2.setOnClickListener(onCheckBoxClickListener);
        join_page_checkbox_3.setOnClickListener(onCheckBoxClickListener);
        join_page_checkbox_4.setOnClickListener(onCheckBoxClickListener);
        //뒤로가기 버튼
        join_page_back_button.setOnClickListener(back_button)

        //아이디 입력
        join_page_input_id_edittext.addTextChangedListener(input_id_check_textWatcher)
        //아이디 중복확인 버튼
        join_page_check_id_textview.setOnClickListener(check_id)
        //비밀번호 입력
        join_page_input_pw_edittext.addTextChangedListener(input_pw_check_textWatcher)
        //비밀번호 eidtText 포커스
        join_page_input_pw_edittext.onFocusChangeListener = OnFocusChangeListener { _, gainFocus ->
            if (gainFocus) {
                if (join_page_input_pw_confirm_edittext.text.toString() != input_pw && join_page_input_pw_confirm_edittext.getText().toString() != "") {
                    join_page_input_pw_confirm_linearlayout.setBackgroundResource(R.drawable.view_red_color_round_edge)
                    join_page_input_pw_confirm_textview.setTextColor(Color.parseColor("#FF0000"))
                    pw_double_check = false
                } else if (join_page_input_pw_confirm_edittext.text.toString() == input_pw && join_page_input_pw_confirm_edittext.getText().toString() != "") {
                    join_page_input_pw_confirm_linearlayout.setBackgroundResource(R.drawable.view_main_color_2_round_button)
                    join_page_input_pw_confirm_textview.setTextColor(Color.parseColor("#3378fd"))
                    pw_double_check = true
                }
            } else {
                if (join_page_input_pw_confirm_edittext.text.toString() != input_pw && join_page_input_pw_confirm_edittext.getText().toString() != "") {
                    join_page_input_pw_confirm_linearlayout.setBackgroundResource(R.drawable.view_red_color_round_edge)
                    join_page_input_pw_confirm_textview.setTextColor(Color.parseColor("#FF0000"))
                    pw_double_check = false
                } else if (join_page_input_pw_confirm_edittext.text.toString() == input_pw && join_page_input_pw_confirm_edittext.getText().toString() != "") {
                    join_page_input_pw_confirm_linearlayout.setBackgroundResource(R.drawable.view_main_color_2_round_button)
                    join_page_input_pw_confirm_textview.setTextColor(Color.parseColor("#3378fd"))
                    pw_double_check = true
                }
            }
        }
        //비밀번호 입력 확인
        join_page_input_pw_confirm_edittext.addTextChangedListener(input_pw_double_check_textWatcher)
        join_page_input_pw_confirm_edittext.onFocusChangeListener = OnFocusChangeListener { _, gainFocus ->
            if (gainFocus) {
                if (join_page_input_pw_confirm_edittext.text.toString() != input_pw || input_pw == "") {
                    join_page_input_pw_confirm_linearlayout.setBackgroundResource(R.drawable.view_red_color_round_edge)
                    join_page_input_pw_confirm_textview.setTextColor(Color.parseColor("#FF0000"))
                    pw_double_check = false  }
            } else {

                if (join_page_input_pw_confirm_edittext.text.toString() == input_pw) {
                    join_page_input_pw_confirm_linearlayout.setBackgroundResource(R.drawable.view_main_color_2_round_button)
                    join_page_input_pw_confirm_textview.setTextColor(Color.parseColor("#3378fd"))
                    pw_double_check = true
                }
            }
        }

        //이름 입력
        join_page_input_name_edittext.addTextChangedListener(input_name_textWatcher)
        //핸드폰 입력
        join_page_input_phone_edittext.addTextChangedListener(input_phone_check_textWatcher)
        //이메일 입력
        join_page_input_email_edittext.addTextChangedListener(input_email_check_textWatcher)
        //이메일 중복확인
        join_page_check_email_textview.setOnClickListener(check_email)
        //인증번호 입력
        join_page_input_email_code_confirm_edittext.addTextChangedListener(email_code_textWatcher)
        //인증번호 확인 버튼
        join_page_check_email_code_textview.setOnClickListener(check_email_code)
        //회원가입 버튼
        join_page_confirm_textview.setOnClickListener(join_button)
    }

    val terms_of_user_info_agree = View.OnClickListener {

        val intent = Intent(this, terms_of_user_information_agreement_Activity::class.java)
        startActivity(intent)
        overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)

    }

    val personal_info_agree = View.OnClickListener {

        val intent = Intent(this, PersonalAgreementPage::class.java)
        startActivity(intent)
        overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)
    }

    //회원가입 버튼
    val join_button = View.OnClickListener {


        if(!id_confirm_check||!pw_check||!pw_double_check||!name_check||!email_code_check||
                !checkbox_1_check||!checkbox_2_check||!checkbox_4_check ||!Pattern.matches("^[가-힣]{2,8}", join_page_input_name_edittext.text.toString()))
        {

            join_page_confirm_textview.setBackgroundResource(R.color.gray)

               if(!id_confirm_check){
                   Toast.makeText(this,"아이디 중복확인을 진행 해주세요.", Toast.LENGTH_SHORT).show()
                   join_page_input_id_edittext.requestFocus()
               }
               else if(!pw_check){
                   Toast.makeText(this,"비밀번호를 확인해주세요.", Toast.LENGTH_SHORT).show()
                   join_page_input_pw_edittext.requestFocus()
               }
               else if(!pw_double_check){
                   Toast.makeText(this,"비밀번호를 확인해주세요.", Toast.LENGTH_SHORT).show()
                   join_page_input_pw_confirm_edittext.requestFocus()
               }
               else if(!name_check||!Pattern.matches("^[가-힣]{2,8}", join_page_input_name_edittext.text.toString())){
                   Toast.makeText(this,"이름을 확인해주세요.", Toast.LENGTH_SHORT).show()
                   join_page_input_name_edittext.requestFocus()
               }
               else if(!email_confirm_check)
               {
                   Toast.makeText(this,"이메일을 입력해주세요.", Toast.LENGTH_SHORT).show()
                   join_page_input_email_edittext.requestFocus()
               }
               else if(!email_code_check)
               {
                   Toast.makeText(this,"이메일 인증번호를 확인해주세요.", Toast.LENGTH_SHORT).show()
                   join_page_input_email_code_confirm_edittext.requestFocus()
               }

               else if(!checkbox_1_check)Toast.makeText(this,"약관 동의를 확인 해주세요.", Toast.LENGTH_SHORT).show()
               else if(!checkbox_2_check)Toast.makeText(this,"약관 동의를 확인 해주세요.", Toast.LENGTH_SHORT).show()
               else if(!checkbox_4_check)Toast.makeText(this,"약관 동의를 확인 해주세요.", Toast.LENGTH_SHORT).show()



        }
        else
        {
            //서버 전송
            join_page_confirm_textview.setBackgroundResource(R.color.main_color)
            //Toast.makeText(this,"서버 전송 가능", Toast.LENGTH_SHORT).show()

            var student_id = join_page_input_id_edittext.text.toString()
            var student_name = join_page_input_name_edittext.text.toString()
            var student_password = join_page_input_pw_edittext.text.toString()
            var student_phone = join_page_input_phone_edittext.text.toString()
            var student_email = join_page_input_email_edittext.text.toString()
            var authentication_code = join_page_input_email_code_confirm_edittext.text.toString()

            if(join_page_checkbox_3.isChecked)
            {
               student_push_agreement = "y"
            }
            else
            {
                student_push_agreement = "n"
            }

            //공백제거
            student_id =student_id.trim()
            student_name = student_name.trim()
            student_password = student_password.trim()
            student_phone = student_phone.trim()
            student_email = student_email.trim()
            authentication_code = authentication_code.trim()



            if(student_phone.length==0)
            {
                send_user_info_no_phone_number(student_id, student_name, student_password, student_email,
                        authentication_code, student_push_agreement)
            }
            else
            {
                send_user_info(student_id, student_name, student_password, student_phone,student_email,
                        authentication_code, student_push_agreement)
            }





        }
    }

    //아이디 중복 검사
    fun id_overlap_check(student_id : String)
    {
        serverConnection!!.id_overlap_check(student_id).enqueue(object : Callback<ResponseBody>
        {

            override fun onResponse(call: Call<ResponseBody>, response: Response<ResponseBody>) {

                try {
                    val result = JSONObject(response.body()!!.string())
                    val result_value = result.getString("success")

                    if(result_value.equals("n"))
                    {
                        //서버로 중복 여부 확인해주기
                        Toast.makeText(this@MemberJoinPage,"사용 가능한 아이디입니다.", Toast.LENGTH_SHORT).show()
                        join_page_check_id_textview.setTextColor(Color.parseColor("#3378fd"))
                        id_confirm_check = true
                    }
                    else if(result_value.equals("y"))
                    {
                        Toast.makeText(this@MemberJoinPage,"이미 사용 중이거나, 사용이 불가능한 아이디입니다.", Toast.LENGTH_SHORT).show()

                    }


                    //Log.d("결과값", "onResponse:"+result_value)

                } catch (e: JSONException) {
                    e.printStackTrace()
                } catch (e: IOException) {
                    e.printStackTrace()
                }
            }

            override fun onFailure(call: Call<ResponseBody>, t: Throwable) {

            }


        })
    }
    //이메일 중복 검사
    fun email_overlap_check(student_email : String)
    {
        serverConnection!!.email_authentication(student_email).enqueue(object : Callback<ResponseBody>
        {

            override fun onResponse(call: Call<ResponseBody>, response: Response<ResponseBody>) {

                try {

                    val result = JSONObject(response.body()!!.string())

                    var result_value : String

                    var i : Iterator<String>
                    i =  result.keys()


                    if(i.next().equals("success"))
                    {
                        result_value = result.getString("success")

                        Toast.makeText(this@MemberJoinPage,"중복 확인이 완료되었습니다. 해당 이메일에서 인증코드를 확인 후 입력 해주세요.", Toast.LENGTH_SHORT).show()
                        join_page_check_email_textview.setTextColor(Color.parseColor("#3378fd"))
                        email_confirm_check = true

                        email_confirm_code = result_value

                        Log.d("인증번호", "onResponse:"+result_value)
                    }
                    else
                    {
                        result_value = result.getString("fail")

                        if(result_value.equals("email_overlap"))
                        {
                            Toast.makeText(this@MemberJoinPage,"이미 사용 중인 이메일입니다.", Toast.LENGTH_SHORT).show()
                        }
                        else
                        {
                            Toast.makeText(this@MemberJoinPage,"인터넷 상태를 다시 확인해주세요.", Toast.LENGTH_SHORT).show()

                        }
                    }



                } catch (e: JSONException) {
                    e.printStackTrace()
                } catch (e: IOException) {
                    e.printStackTrace()
                }
            }

            override fun onFailure(call: Call<ResponseBody>, t: Throwable) {

            }


        })
    }


    //회원 가입
    fun send_user_info(student_id : String, student_name : String, student_password : String,
                       student_phone: String, student_email : String,  authentication_code : String,
                       student_push_agreement : String)
    {
       serverConnection!!.sign_up(student_id, student_name,student_password,
               student_phone,  student_email, authentication_code, student_push_agreement).enqueue(object : Callback<ResponseBody> {
            override fun onResponse(call: Call<ResponseBody>, response: Response<ResponseBody>)
            {
                try {
                    val result = JSONObject(response.body()!!.string())

                    val i : Iterator<String> = result.keys()
                    if (i.next() == "success")
                    {
                        memberShipJoinForm.visibility = View.GONE
                        memberShipJoinCompletion.visibility = View.VISIBLE
                    }
                    else
                    {
                        show(this@MemberJoinPage, "인터넷 연결상태를 다시 확인해주세요.")
                    }

                } catch (e: JSONException) {
                    e.printStackTrace()
                } catch (e: IOException) {
                    e.printStackTrace()
                }
            }

            override fun onFailure(call: Call<ResponseBody>, t: Throwable) {

                Log.d("실패", "onResponse: "+t)
                Log.d("실패", "onResponse: "+call)

            }
        })
    }

    //회원 가입
    fun send_user_info_no_phone_number(student_id : String, student_name : String, student_password : String,
                                       student_email : String,  authentication_code : String,
                                       student_push_agreement : String)
    {
        serverConnection!!.sign_up_no_phone_number(student_id, student_name,student_password,
                student_email, authentication_code, student_push_agreement).enqueue(object : Callback<ResponseBody> {
            override fun onResponse(call: Call<ResponseBody>, response: Response<ResponseBody>)
            {
                try {
                    val result = JSONObject(response.body()!!.string())

                    val i : Iterator<String> = result.keys()
                    if (i.next() == "success")
                    {
                        memberShipJoinForm.visibility = View.GONE
                        memberShipJoinCompletion.visibility = View.VISIBLE
                    }
                    else
                    {
                        show(this@MemberJoinPage, "인터넷 연결상태를 다시 확인해주세요.")
                    }

                } catch (e: JSONException) {
                    e.printStackTrace()
                } catch (e: IOException) {
                    e.printStackTrace()
                }
            }

            override fun onFailure(call: Call<ResponseBody>, t: Throwable) {

                Log.d("실패", "onResponse: "+t)
                Log.d("실패", "onResponse: "+call)

            }
        })
    }



    //email 중복 확인
    val check_email = View.OnClickListener {

        if(email_check)
        {

            var get_email_address =  join_page_input_email_edittext.text.toString()
            get_email_address = get_email_address.trim()

            email_overlap_check(get_email_address)

          /*  //서버에서 중복 확인 해줄 것
            email_confirm_check = true
            Toast.makeText(this,"중복 확인이 완료되었습니다. 해당 이메일에서 인증코드를 확인 후 입력 해주세요.", Toast.LENGTH_SHORT).show()
            join_page_check_email_textview.setTextColor(Color.parseColor("#3378fd"))*/
        }
        else
        {
            email_confirm_check = false
            Toast.makeText(this,"이메일을 양식에 맞게 입력해주세요.", Toast.LENGTH_SHORT).show()
        }

    }

    //email 인증코드 확인 버튼
    val check_email_code = View.OnClickListener {

        if(email_confirm_check)
        {

            if(email_confirm_code.equals(join_page_input_email_code_confirm_edittext.text.toString()))
            {
                //인증코드 확인해주기
                Toast.makeText(this,"인증코드 확인이 완료되었습니다.", Toast.LENGTH_SHORT).show()
                join_page_check_email_code_textview.setTextColor(Color.parseColor("#3378fd"))
                email_code_check = true
            }
            else
            {
                Toast.makeText(this,"인증코드 다시 확인해주세요.", Toast.LENGTH_SHORT).show()
            }




        }
        else
        {
            Toast.makeText(this,"이메일을 양식 혹은 중복검사를 진행해주세요.", Toast.LENGTH_SHORT).show()

        }
        //가입 버튼 활성화 클래스
        check_join_value()
    }
    //아이디 중복 확인 버튼
    val check_id = View.OnClickListener {

        if(id_check)
        {

            //아이디 중복확인
            id_overlap_check(join_page_input_id_edittext.text.toString())



        }
        else
        {
            Toast.makeText(this,"영어+숫자 (4자리~12자리)로 구성 된 아이디로 입력 해주세요.", Toast.LENGTH_SHORT).show()
        }
        //가입 버튼 활성화 클래스
        check_join_value()
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

                join_page_id_linearlayout.setBackgroundResource(R.drawable.view_red_color_round_edge)
                join_page_input_id_textview.setTextColor(Color.parseColor("#FF0000"))
                id_check = false
                id_confirm_check = false
            }
            else
            {

                join_page_id_linearlayout.setBackgroundResource(R.drawable.view_main_color_2_round_button)
                join_page_input_id_textview.setTextColor(Color.parseColor("#3378fd"))
                join_page_check_id_textview.setTextColor(Color.parseColor("#FF0000"))
                id_check = true
            }

            //가입 버튼 활성화 클래스
            check_join_value()
        }

        override fun afterTextChanged(arg0: Editable) {
            // 입력이 끝났을 때
        }

        override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {
            // 입력하기 전에
        }
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
                join_page_input_pw_linearlayout.setBackgroundResource(R.drawable.view_red_color_round_edge)
                join_page_input_pw_textview.setTextColor(Color.parseColor("#FF0000"))

                pw_check = false
            }
            else
            {
                join_page_input_pw_linearlayout.setBackgroundResource(R.drawable.view_main_color_2_round_button)
                join_page_input_pw_textview.setTextColor(Color.parseColor("#3378fd"))

                pw_check = true
                //
                // Toast.makeText(getApplicationContext(), input_pw+"", Toast.LENGTH_SHORT).show();
            }

            input_pw  = join_page_input_pw_edittext.text.toString()

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
                join_page_input_pw_confirm_linearlayout.setBackgroundResource(R.drawable.view_red_color_round_edge)
                join_page_input_pw_confirm_textview.setTextColor(Color.parseColor("#FF0000"))
                pw_double_check = false

            } else if (charSequence.toString() == input_pw) {
                join_page_input_pw_confirm_linearlayout.setBackgroundResource(R.drawable.view_main_color_2_round_button)
                join_page_input_pw_confirm_textview.setTextColor(Color.parseColor("#3378fd"))
                pw_double_check = true
            }

            //가입 버튼 활성화 클래스
            check_join_value()
        }

        override fun afterTextChanged(editable: Editable) {}
    }

    //이름 정규 표현식
    //이름 입력 확인을 위한 TextWatcher
    val input_name_textWatcher: TextWatcher = object : TextWatcher {
        override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {

            // 입력되는 텍스트에 변화가 있을 때

            //아래와 같이 한글 외에 것이 포함된 경우
            if (!Pattern.matches("^[ㄱ-ㅎㅏ-ㅣ가-힣].{0,8}", s)) {
                join_page_input_name_linearlayout.setBackgroundResource(R.drawable.view_red_color_round_edge)
                join_page_input_name_textview.setTextColor(Color.parseColor("#FF0000"))
                name_check = false
            } else {

                //자음만을 입력하는 것을 방지
                //자음+모음으로 이루어진 글자로 2~8글자 사이가 아닐 경우
                if (!Pattern.matches("^[가-힣].{1,8}", s)) {
                    join_page_input_name_linearlayout.setBackgroundResource(R.drawable.view_red_color_round_edge)
                    join_page_input_name_textview.setTextColor(Color.parseColor("#FF0000"))
                    name_check =false
                } else {

                    join_page_input_name_linearlayout.setBackgroundResource(R.drawable.view_main_color_2_round_button)
                    join_page_input_name_textview.setTextColor(Color.parseColor("#3378fd"))
                    name_check = true

                }
            }

            //가입 버튼 활성화 클래스
            check_join_value()
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

                join_page_input_email_linearlayout.setBackgroundResource(R.drawable.view_red_color_round_edge)
                join_page_input_email_textview.setTextColor(Color.parseColor("#FF0000"))
                join_page_check_email_textview.setTextColor(Color.parseColor("#FF0000"))
                email_check = false
                email_confirm_check = false

            } else {
                join_page_input_email_linearlayout.setBackgroundResource(R.drawable.view_main_color_2_round_button)
                join_page_input_email_textview.setTextColor(Color.parseColor("#3378fd"))
                join_page_check_email_textview.setTextColor(Color.parseColor("#FF0000"))
                email_check = true
            }

            //가입 버튼 활성화 클래스
            check_join_value()
        }
        override fun onTextChanged(charSequence: CharSequence, i: Int, i1: Int, i2: Int) {
            //특수문자를 포함하는 경우
            //!Pattern.matches("^(?=.*\\d)(?=.*[~`!@#$%\\^&*()-])(?=.*[a-zA-Z]).{8,20}$", charSequence)

            //이메일이 양식에 맞는 지 확인한다.
            //이메일 양식에 일치하지 않는 경우
            if (!Patterns.EMAIL_ADDRESS.matcher(charSequence).matches()) {

                join_page_input_email_linearlayout.setBackgroundResource(R.drawable.view_red_color_round_edge)
                join_page_input_email_textview.setTextColor(Color.parseColor("#FF0000"))
                join_page_check_email_textview.setTextColor(Color.parseColor("#FF0000"))
                email_check = false
                email_confirm_check = false

            } else {
                join_page_input_email_linearlayout.setBackgroundResource(R.drawable.view_main_color_2_round_button)
                join_page_input_email_textview.setTextColor(Color.parseColor("#3378fd"))
                join_page_check_email_textview.setTextColor(Color.parseColor("#FF0000"))
                email_check = true
            }

            //가입 버튼 활성화 클래스
            check_join_value()
        }

        override fun afterTextChanged(editable: Editable)
        {


        }
    }
    //핸드폰 번호 입력 확인을 위한 TextWatcher
    val input_phone_check_textWatcher: TextWatcher = object : TextWatcher {
        private var _beforeLenght = 0
        private var _afterLenght = 0
        override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {
            _beforeLenght = s.length
        }

        override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {
            if (s.length <= 0) {

                return
            }

            //해당 문자 선택하기.
            //ex 가나다라(라고 쓴 경우) 3번째(3-1=2 // 0 , 1, 2로해서)를 선택하게 되면 다가 나옴.
            val inputChar = s[s.length - 1]

            //delete함수(삭제 시작점, 삭제 끝점)
            if (inputChar != '-' && (inputChar < '0' || inputChar > '9')) {
                join_page_input_phone_edittext.getText().delete(s.length - 1, s.length)

                return
            }
            _afterLenght = s.length

            // 삭제 중
            if (_beforeLenght > _afterLenght) {
                // 삭제 중에 마지막에 -는 자동으로 지우기
                if (s.toString().endsWith("-")) {
                    join_page_input_phone_edittext.setText(s.toString().substring(0, s.length - 1))
                }
            } else if (_beforeLenght < _afterLenght) {
                //총 길이가 4이고, "-"라는 문자열이 존재하지 않을 때,
                //ex String aa = 12345; 가정
                //subSequence - 해당 부분의 문자열을 추출해준다. (0, 3) 일 경우 1,2,3 발췌
                //substring - 시작점부터 문자열을 뽑아낸다.(3, aa.length()) 일 경우 4,5를 가져온다.
                //indexof에 값이 존재하지 않으면 '-1'로 반환한다.
                if (_afterLenght == 4 && s.toString().indexOf("-") < 0) {
                    join_page_input_phone_edittext.setText(
                        s.toString().subSequence(0, 3).toString() + "-" + s.toString().substring(3, s.length)
                    )
                } else if (_afterLenght == 9) {
                    join_page_input_phone_edittext.setText(
                        s.toString().subSequence(0, 8).toString() + "-" + s.toString().substring(8, s.length)
                    )
                }
            }

            if(s.length==13)
            {
                join_page_input_phone_linearlayout.setBackgroundResource(R.drawable.view_main_color_round_edge)
                join_page_input_phone_textview.setTextColor(Color.parseColor("#3378fd"))
            }
            else
            {
                join_page_input_phone_linearlayout.setBackgroundResource(R.drawable.view_gray_color_round_edge)
                join_page_input_phone_textview.setTextColor(Color.parseColor("#404040"))
            }
            join_page_input_phone_edittext.setSelection(join_page_input_phone_edittext.length())
        }

        override fun afterTextChanged(s: Editable) {
            // 생략
        }
    }

    //이메일 인증코드 확인
    var email_code_textWatcher: TextWatcher = object : TextWatcher {
        override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {

            if(s.length>0)
            {
                if(join_page_input_email_code_confirm_edittext.length()==6)
                {
                    join_page_input_email_code_textview.setTextColor(Color.parseColor("#3378fd"))
                    join_page_check_email_code_textview.setTextColor(Color.parseColor("#FF0000"))
                    join_page_input_email_code_linearlayout.setBackgroundResource(R.drawable.view_main_color_round_edge)
                }
                else if(join_page_input_email_code_confirm_edittext.length()<=5)

                {   join_page_check_email_code_textview.setTextColor(Color.parseColor("#FF0000"))
                    join_page_input_email_code_textview.setTextColor(Color.parseColor("#FF0000"))
                    join_page_input_email_code_linearlayout.setBackgroundResource(R.drawable.view_red_color_round_edge)
                }

            }
            else
            {
                //login_page_login_textview.setBackgroundResource(R.color.gray)
                join_page_check_email_code_textview.setTextColor(Color.parseColor("#9f9f9f"))
                join_page_input_email_code_textview.setTextColor(Color.parseColor("#9f9f9f"))
                join_page_input_email_code_linearlayout.setBackgroundResource(R.drawable.view_gray_color_round_edge)
            }


        }

        override fun afterTextChanged(arg0: Editable) {
            // 입력이 끝났을 때
        }

        override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {
            // 입력하기 전에
        }
    }

    //전체 동의 버튼
    val all_check = View.OnClickListener {

        if(join_page_checkbox_all.isChecked){
            join_page_checkbox_1.isChecked = true
            join_page_checkbox_2.isChecked = true
            join_page_checkbox_3.isChecked = true
            join_page_checkbox_4.isChecked = true

            checkbox_1_check = true
            checkbox_2_check = true
            checkbox_3_check = true
            checkbox_4_check = true

        }
        else{

            join_page_checkbox_1.isChecked = false
            join_page_checkbox_2.isChecked = false
            join_page_checkbox_3.isChecked = false
            join_page_checkbox_4.isChecked = false

            checkbox_1_check = false
            checkbox_2_check = false
            checkbox_3_check = false
            checkbox_4_check = false
        }
        check_join_value()
    }



    fun check_join_value()
    {

        if(!id_confirm_check||!pw_check||!pw_double_check||!name_check||!email_code_check||
                !checkbox_1_check||!checkbox_2_check||!checkbox_4_check)
        {

            join_page_confirm_textview.setBackgroundResource(R.color.gray)


            join_confirm = false
        }
        else
        {
            //서버 전송
            join_page_confirm_textview.setBackgroundResource(R.color.main_color)

            join_confirm = true
        }


    }


    /**
     * 이용약관 클릭 시 isAllCheck()라는 값을 return 받는다.
     * 받은 값에 따라서 all_agreement_checkbox의 체크 여부를 결정해준다.
     */
    private val onCheckBoxClickListener = View.OnClickListener {
        if (isAllChecked()) {
            join_page_checkbox_all.setChecked(true)
            check_set()
            check_join_value()

        } else {
            join_page_checkbox_all.setChecked(false)
            check_set()
            check_join_value()

        }
    }

    fun check_set()
    {
        Log.d("확인좀", "check_set:"+join_page_checkbox_1.isChecked)
        Log.d("확인좀", "check_set:"+join_page_checkbox_2.isChecked)
        Log.d("확인좀", "check_set:"+join_page_checkbox_3.isChecked)
        Log.d("확인좀", "check_set:"+join_page_checkbox_4.isChecked)

        if(join_page_checkbox_1.isChecked){ checkbox_1_check = true}
        else{ checkbox_1_check = false}
        if(join_page_checkbox_2.isChecked){ checkbox_2_check = true}
        else{ checkbox_2_check = false}
        if(join_page_checkbox_3.isChecked){ checkbox_3_check = true}
        else{ checkbox_3_check = false}
        if(join_page_checkbox_4.isChecked){ checkbox_4_check = true}
        else{ checkbox_4_check = false}

        Log.d("확인좀1", "check_set:"+join_page_checkbox_1.isChecked+checkbox_1_check)
        Log.d("확인좀2", "check_set:"+join_page_checkbox_2.isChecked+checkbox_2_check)
        Log.d("확인좀3", "check_set:"+join_page_checkbox_3.isChecked+checkbox_3_check)
        Log.d("확인좀4", "check_set:"+join_page_checkbox_4.isChecked+checkbox_4_check)
    }


    //체크 여부를 확인해서 모든 체크박스가 체크가 되어 있다면, true 값을 반환하고 아닐 경우 false 값을 반환한다.
    //ex ) A ? B : C ; 라고 생각했을 때 A가 참이면 B를 리턴, 거짓이면 C를 리턴한다.
    private fun isAllChecked(): Boolean {
        return if (join_page_checkbox_1.isChecked() && join_page_checkbox_2.isChecked() && join_page_checkbox_3.isChecked() && join_page_checkbox_4.isChecked()) true else false
    }
    }

