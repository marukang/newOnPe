package com.funidea.newonpe.page.message

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.text.TextUtils
import android.util.Log
import android.view.View
import com.funidea.utils.CustomToast
import com.funidea.utils.save_SharedPreferences
import com.funidea.utils.set_User_info
import com.funidea.utils.set_User_info.Companion.student_name
import com.funidea.newonpe.R
import com.funidea.newonpe.page.login.SplashActivity.Companion.serverConnection
import kotlinx.android.synthetic.main.activity_class_message_edit.*
import kotlinx.android.synthetic.main.activity_class_message_write.*
import okhttp3.ResponseBody
import org.json.JSONException
import org.json.JSONObject
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.io.IOException

/** 선생님 문의 내역 답변 수정 Class
 *
 *  선생님이 사용자가 올린 질문에 대해서 수정을 진행하는  Class
 *
 *  내가 올린 질문에 대해 수정해서 재등록할 수 있다.
 */


class class_message_edit_Activity : AppCompatActivity() {

     var class_message_number : String = ""
     var class_message_title : String = ""
     var class_message_content : String = ""
     var class_message_date : String = ""

     var message_edit_value = 0

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_class_message_edit)

        var get_intent = intent

        class_message_number = get_intent.getStringExtra("number").toString()
        class_message_title = get_intent.getStringExtra("title").toString()
        class_message_content = get_intent.getStringExtra("content").toString()
        class_message_date = get_intent.getStringExtra("date").toString()

        //작성자 이름
        class_community_edit_user_name_textview.setText(student_name)

        //제목
        class_message_edit_input_title_edittext.setText(class_message_title)
        //내용
        class_message_edit_input_content_edittext.setText(class_message_content)
        //날짜
        class_message_edit_user_date_textview.setText(class_message_date)
        //수정 버튼
        class_message_edit_confirm_button.setOnClickListener(message_edit_confirm_button)


        //뒤로가기
        class_message_edit_back_button.setOnClickListener(back_button)
    }


    //메세지 보내기 버튼
    val message_edit_confirm_button = View.OnClickListener {

        if(TextUtils.isEmpty(class_message_edit_input_title_edittext.text.toString())||
                TextUtils.isEmpty(class_message_edit_input_content_edittext.text.toString()))
        {
            if(TextUtils.isEmpty(class_message_edit_input_title_edittext.text.toString()))
            {
                class_message_write_input_title_edittext.requestFocus()
                CustomToast.show(this, "제목을 입력해주세요.")
            }
            else
            {
                class_message_edit_input_content_edittext.requestFocus()
                CustomToast.show(this, "내용을 입력해주세요.")
            }


        }
        else
        {
            if(message_edit_value==0) {

                message_edit_value = 1
                var title: String = class_message_edit_input_title_edittext.text.toString()
                var content: String = class_message_edit_input_content_edittext.text.toString()

                update_student_message(title, content, class_message_number)
            }
        }


    }

    fun update_student_message(class_message_title : String, class_message_text : String, class_message_number : String)
    {
        serverConnection!!.update_student_message(set_User_info.student_id, set_User_info.access_token,class_message_title, class_message_text, class_message_number).enqueue(object : Callback<ResponseBody> {
            override fun onResponse(call: Call<ResponseBody>, response: Response<ResponseBody>)
            {
                try {
                    val result = JSONObject(response.body()!!.string())

                    Log.d("결과", "onResponse:"+result)

                    var i : Iterator<String>
                    i =  result.keys()

                    if(!i.next().equals("fail"))
                    {
                        message_edit_value = 0
                        //토큰 갱신
                        set_User_info.access_token = result.getString("student_token")

                        save_SharedPreferences.save_shard(this@class_message_edit_Activity, set_User_info.access_token)

                        CustomToast.show(this@class_message_edit_Activity, "정상적으로 수정 되었습니다.")

                        finish()
                        overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)


                    }
                    //실패 시
                    else
                    {
                        CustomToast.show(this@class_message_edit_Activity, "인터넷 연결 상태를 확인해주세요.")
                    }

                } catch (e: JSONException) {
                    e.printStackTrace()
                } catch (e: IOException) {
                    e.printStackTrace()
                }
            }

            override fun onFailure(call: Call<ResponseBody>, t: Throwable) {


                CustomToast.show(this@class_message_edit_Activity, "인터넷 연결 상태를 확인해주세요.")

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



}