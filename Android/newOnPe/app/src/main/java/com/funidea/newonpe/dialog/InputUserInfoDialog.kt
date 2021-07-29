package com.funidea.newonpe.dialog

import android.content.Context
import android.graphics.Color
import android.text.Editable
import android.text.TextWatcher
import android.util.Log
import android.view.View
import android.widget.Toast
import com.funidea.utils.CustomToast.Companion.show
import com.funidea.utils.SimpleSharedPreferences
import com.funidea.utils.set_User_info
import com.funidea.utils.set_User_info.Companion.student_age
import com.funidea.utils.set_User_info.Companion.student_content
import com.funidea.utils.set_User_info.Companion.student_sex
import com.funidea.utils.set_User_info.Companion.student_tall
import com.funidea.utils.set_User_info.Companion.student_weight
import com.funidea.newonpe.R
import com.funidea.newonpe.page.login.LoginPage.Companion.serverConnectionSpec
import com.google.android.material.bottomsheet.BottomSheetDialog
import kotlinx.android.synthetic.main.input_user_info_bottom_dialog.*
import kotlinx.android.synthetic.main.input_user_info_bottom_dialog.view.*
import okhttp3.ResponseBody
import org.json.JSONException
import org.json.JSONObject
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.io.IOException


/** 가입 시 첫 사용자의 정보를 입력할 Bottom Dialog
 *
 * 가입 후 사용자가 첫 로그인 시 해당 화면이 보여지며
 * 사용자는 자신의 기초정보  자기소개, 키, 몸무게, 나이 등을 입력할 수 있는 화면을 보여준다.
 *
 */

class InputUserInfoDialog(context: Context) : BottomSheetDialog(context) {


    var get_user_info_Listener : InputUserInfoListener? =null


    //기초 정보 관리
    var user_introduction_value : Boolean = false
    var user_height_value : Boolean = true
    var user_weight_value : Boolean = true
    var user_age_value : Boolean = true
    //기초 정보 관리 끝

    var input_student_sex : String = "z"

    interface InputUserInfoListener
    {
        fun input_code(input_code : String?)

    }

    fun setInputUserInfoListener(get_user_info_Listener : InputUserInfoListener)
    {
        this.get_user_info_Listener = get_user_info_Listener
    }

    init {
        val view: View = layoutInflater.inflate(R.layout.input_user_info_bottom_dialog, null)
        setContentView(view)


        //기초정보관리 변경 버튼
        bottom_dialog_join_page_confirm_textview.setOnClickListener{
            if(!user_introduction_value||!user_height_value||!user_weight_value||!user_age_value||input_student_sex.isEmpty())
            {
                if(!user_introduction_value){
                    Toast.makeText(context, "좌우명을 입력해주세요.", Toast.LENGTH_SHORT).show()
                    bottom_dialog_add_user_info_input_introduction_edittext.requestFocus()
                }
                else if(!user_height_value){
                    Toast.makeText(context, "키를 입력해주세요.", Toast.LENGTH_SHORT).show()
                    bottom_dialog_add_user_info_input_height_edittext.requestFocus()
                }
                else if(!user_weight_value){
                    Toast.makeText(context, "몸무게를 입력해주세요.", Toast.LENGTH_SHORT).show()
                    bottom_dialog_add_user_info_input_weight_edittext.requestFocus()
                }
                else if(!user_age_value){
                    Toast.makeText(context, "나이를 입력해주세요.", Toast.LENGTH_SHORT).show()
                    bottom_dialog_add_user_info_input_age_edittext.requestFocus()
                }
                else if(input_student_sex.isEmpty())
                {
                    Toast.makeText(context, "성별을 선택해주세요.", Toast.LENGTH_SHORT).show()
                }



            }
            else
            {

                var student_content_str =  bottom_dialog_add_user_info_input_introduction_edittext.text.toString()
                //수정 전 - 기존 온체육 학생 키, 몸무게, 나이 입력
                /*var student_tall_str =  bottom_dialog_add_user_info_input_height_edittext.text.toString()
                var student_weight_str =  bottom_dialog_add_user_info_input_weight_edittext.text.toString()
                var student_age_str =  bottom_dialog_add_user_info_input_age_edittext.text.toString()
                */
                var student_tall_str =  "180"
                var student_weight_str ="70"
                var student_age_str =   "20"


                first_user_information_change(student_content_str, student_tall_str, student_weight_str, student_age_str, input_student_sex)
            }
        }

        view.bottom_dialog_add_user_info_male_textview.setOnClickListener{

            bottom_dialog_add_user_info_male_textview.setTextColor(Color.parseColor("#3378fd"))
            bottom_dialog_add_user_info_male_textview.setBackgroundResource(R.drawable.view_main_color_round_edge)
            bottom_dialog_add_user_info_female_textview.setTextColor(Color.parseColor("#9f9f9f"))
            bottom_dialog_add_user_info_female_textview.setBackgroundResource(R.drawable.view_gray_color_round_edge)
            input_student_sex = "m"

        }
        view.bottom_dialog_add_user_info_female_textview.setOnClickListener{

            bottom_dialog_add_user_info_female_textview.setTextColor(Color.parseColor("#3378fd"))
            bottom_dialog_add_user_info_female_textview.setBackgroundResource(R.drawable.view_main_color_round_edge)
            bottom_dialog_add_user_info_male_textview.setTextColor(Color.parseColor("#9f9f9f"))
            bottom_dialog_add_user_info_male_textview.setBackgroundResource(R.drawable.view_gray_color_round_edge)
            input_student_sex = "f"

        }

        //자기소개 텍스트 입력 감지
        var introduction_textWatcher: TextWatcher = object : TextWatcher {
            override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {

                if(s.length>0)
                {
                    if(bottom_dialog_add_user_info_input_introduction_edittext.length()>0)
                    {
                        bottom_dialog_add_user_info_input_introduction_textview.setTextColor(Color.parseColor("#3378fd"))
                        bottom_dialog_add_user_info_input_introduction_linearlayout.setBackgroundResource(R.drawable.view_main_color_round_edge)
                        user_introduction_value = true


                    }
                    else if(bottom_dialog_add_user_info_input_introduction_edittext.length()<=0)
                    {
                        bottom_dialog_add_user_info_input_introduction_textview.setTextColor(Color.parseColor("#9f9f9f"))
                        bottom_dialog_add_user_info_input_introduction_linearlayout.setBackgroundResource(R.drawable.view_gray_color_round_edge)
                        user_introduction_value = false
                    }
                }
                else
                {
                    bottom_dialog_add_user_info_input_introduction_textview.setTextColor(Color.parseColor("#9f9f9f"))
                    bottom_dialog_add_user_info_input_introduction_linearlayout.setBackgroundResource(R.drawable.view_gray_color_round_edge)
                    user_introduction_value = false

                }

                user_info_check_value()
            }

            override fun afterTextChanged(arg0: Editable) {
                // 입력이 끝났을 때
            }

            override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {
                // 입력하기 전에
            }
        }
        //유저 키 입력
        var height_textWatcher: TextWatcher = object : TextWatcher {
            override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {

                if(s.length>0)
                {
                    if(bottom_dialog_add_user_info_input_height_edittext.length()>0)
                    {

                        bottom_dialog_add_user_info_input_height_textview.setTextColor(Color.parseColor("#3378fd"))
                        bottom_dialog_add_user_info_input_height_linearlayout.setBackgroundResource(R.drawable.view_main_color_round_edge)

                        user_height_value = true
                    }
                    else if(bottom_dialog_add_user_info_input_height_edittext.length()<=0)
                    {
                        bottom_dialog_add_user_info_input_height_textview.setTextColor(Color.parseColor("#9f9f9f"))
                        bottom_dialog_add_user_info_input_height_linearlayout.setBackgroundResource(R.drawable.view_gray_color_round_edge)

                        user_height_value = false
                    }
                }
                else
                {
                    bottom_dialog_add_user_info_input_height_textview.setTextColor(Color.parseColor("#9f9f9f"))
                    bottom_dialog_add_user_info_input_height_linearlayout.setBackgroundResource(R.drawable.view_gray_color_round_edge)

                    user_height_value = false
                }

                user_info_check_value()
            }

            override fun afterTextChanged(arg0: Editable) {
                // 입력이 끝났을 때
            }

            override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {
                // 입력하기 전에
            }
        }
        //유저 몸무게 입력
        var weight_textWatcher: TextWatcher = object : TextWatcher {
            override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {

                if(s.length>0)
                {
                    if(bottom_dialog_add_user_info_input_weight_edittext.length()>0)
                    {
                        bottom_dialog_add_user_info_input_weight_textview.setTextColor(Color.parseColor("#3378fd"))
                        bottom_dialog_add_user_info_input_weight_linearlayout.setBackgroundResource(R.drawable.view_main_color_round_edge)

                        user_weight_value = true
                    }
                    else if(bottom_dialog_add_user_info_input_weight_edittext.length()<=0)
                    {
                        bottom_dialog_add_user_info_input_weight_textview.setTextColor(Color.parseColor("#9f9f9f"))
                        bottom_dialog_add_user_info_input_weight_linearlayout.setBackgroundResource(R.drawable.view_gray_color_round_edge)

                        user_weight_value = false
                    }
                }
                else
                {
                    bottom_dialog_add_user_info_input_weight_textview.setTextColor(Color.parseColor("#9f9f9f"))
                    bottom_dialog_add_user_info_input_weight_linearlayout.setBackgroundResource(R.drawable.view_gray_color_round_edge)

                    user_weight_value = false
                }

                user_info_check_value()
            }

            override fun afterTextChanged(arg0: Editable) {
                // 입력이 끝났을 때
            }

            override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {
                // 입력하기 전에
            }
        }
        //유저 나이 입력
        var age_textWatcher: TextWatcher = object : TextWatcher {
            override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {

                if(s.length>0)
                {
                    if(bottom_dialog_add_user_info_input_age_edittext.length()>0)
                    {
                        bottom_dialog_add_user_info_input_age_textview.setTextColor(Color.parseColor("#3378fd"))
                        bottom_dialog_add_user_info_input_age_linearlayout.setBackgroundResource(R.drawable.view_main_color_round_edge)

                        user_age_value = true
                    }
                    else if(bottom_dialog_add_user_info_input_age_edittext.length()<=0)
                    {
                        bottom_dialog_add_user_info_input_age_textview.setTextColor(Color.parseColor("#9f9f9f"))
                        bottom_dialog_add_user_info_input_age_linearlayout.setBackgroundResource(R.drawable.view_gray_color_round_edge)

                        user_age_value = false

                    }
                }
                else
                {
                    bottom_dialog_add_user_info_input_age_textview.setTextColor(Color.parseColor("#9f9f9f"))
                    bottom_dialog_add_user_info_input_age_linearlayout.setBackgroundResource(R.drawable.view_gray_color_round_edge)

                    user_age_value = false
                }

                user_info_check_value()
            }

            override fun afterTextChanged(arg0: Editable) {
                // 입력이 끝났을 때
            }

            override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {
                // 입력하기 전에
            }
        }


        //자기소개 관련
        bottom_dialog_add_user_info_input_introduction_edittext.addTextChangedListener(introduction_textWatcher)
        //키
        bottom_dialog_add_user_info_input_height_edittext.addTextChangedListener(height_textWatcher)
        //몸무게
        bottom_dialog_add_user_info_input_weight_edittext.addTextChangedListener(weight_textWatcher)
        //나이
        bottom_dialog_add_user_info_input_age_edittext.addTextChangedListener(age_textWatcher)
    }

    //유저 정보 변경
    fun first_user_information_change(get_student_content: String?, get_student_tall: String?,
                                      get_student_weight : String?, get_student_age:String?, get_student_sex : String?) {


        serverConnectionSpec!!.first_user_information_change(set_User_info.student_id, set_User_info.access_token, get_student_content, get_student_tall,get_student_weight, get_student_age, get_student_sex)
                .enqueue(object : Callback<ResponseBody> {
                    override fun onResponse(call: Call<ResponseBody>, response: Response<ResponseBody>) {
                        try {
                            val result = JSONObject(response.body()!!.string())
                            var result_value = result.toString()

                            Log.d("학생정보 결과값", "onResponse:"+result_value)

                            var i : Iterator<String>
                            i =  result.keys()

                            Log.d("결과", "onResponse:"+result)
                            if(!i.next().equals("fail"))
                            {

                                var student_token = result.getString("student_token")

                                //토큰 재 갱신
                                set_User_info.access_token = student_token

                                SimpleSharedPreferences.saveAccessToken(context, student_token)

                                show(context, "정보가 등록되었습니다.")

                                student_content = get_student_content.toString()
                                student_tall =  get_student_tall.toString()
                                student_weight = get_student_weight.toString()
                                student_age = get_student_age.toString()
                                student_sex = get_student_sex.toString();

                                dismiss()
                            }
                            else{

                                show(context, "올바른 접근이 아닙니다. 다시 변경해주세요.")
                            }

                        } catch (e: JSONException) {
                            e.printStackTrace()
                        } catch (e: IOException) {
                            e.printStackTrace()
                        }
                    }

                    override fun onFailure(call: Call<ResponseBody>, t: Throwable) {


                        show(context, "인터넷 연결 상태를 다시 확인해주세요.")
                    }
                })
    }



    //버튼 활성화
    fun user_info_check_value()
    {

        if(!user_introduction_value||!user_height_value||!user_weight_value||!user_age_value)
        {
            bottom_dialog_join_page_confirm_textview.setBackgroundResource(R.drawable.view_dark_gray_color_round_edge)
        }
        else
        {
            bottom_dialog_join_page_confirm_textview.setBackgroundResource(R.drawable.view_main_color_round_button)


        }

    }
}
