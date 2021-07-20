package com.funidea.newonpe.page.message

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.text.TextUtils
import android.view.View
import com.funidea.utils.CustomToast.Companion.show
import com.funidea.utils.get_Time.Companion.formatDate
import com.funidea.utils.save_SharedPreferences
import com.funidea.utils.set_User_info.Companion.access_token
import com.funidea.utils.set_User_info.Companion.student_id
import com.funidea.utils.set_User_info.Companion.student_name
import com.funidea.newonpe.R
import com.funidea.newonpe.page.login.LoginPage.Companion.serverConnectionSpec
import kotlinx.android.synthetic.main.activity_class_message_write.*
import okhttp3.ResponseBody
import org.json.JSONException
import org.json.JSONObject
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.io.IOException

/** 선생님 문의 하기 Class
 *
 * 사용자가 선생님께 문의사항이 있는 경우 해당 페이지를 통해
 *
 * 질문을 남길 수 있다.
 *
 */


class class_message_write_Activity : AppCompatActivity() {

    var class_code_number : String =""

    var message_write_value : Int = 0

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_class_message_write)


        var get_intent = intent

        class_code_number = get_intent.getStringExtra("class_code_number").toString()

        //작성자 이름
        class_community_write_user_name_textview.setText(student_name)
        //작성 날짜
        class_message_write_user_date_textview.setText(formatDate)

        //뒤로 가기 버튼
        class_message_write_back_button.setOnClickListener(back_button)
        //메세지 작성버튼
        class_message_write_confirm_button.setOnClickListener(message_confirm_button)
    }



    //메세지 보내기 버튼
    val message_confirm_button = View.OnClickListener {

        if(TextUtils.isEmpty(class_message_write_input_title_edittext.text.toString())||
           TextUtils.isEmpty(class_message_write_input_content_edittext.text.toString()))
        {
           if(TextUtils.isEmpty(class_message_write_input_title_edittext.text.toString()))
           {
               class_message_write_input_title_edittext.requestFocus()
               show(this, "제목을 입력해주세요.")
           }
           else
           {
               class_message_write_input_content_edittext.requestFocus()
               show(this, "내용을 입력해주세요.")
           }


        }
        else
        {

            if(message_write_value==0)
            {
                message_write_value = 1
                var title : String  = class_message_write_input_title_edittext.text.toString()
                var content : String  = class_message_write_input_content_edittext.text.toString()

                send_student_message(class_code_number, title, content)
            }


        }


    }
    fun send_student_message(class_code : String, class_message_title : String, class_message_text : String)
    {
        serverConnectionSpec!!.send_student_message(student_id, access_token, student_name, class_code, class_message_title, class_message_text).enqueue(object : Callback<ResponseBody> {
            override fun onResponse(call: Call<ResponseBody>, response: Response<ResponseBody>)
            {
                try {
                    val result = JSONObject(response.body()!!.string())



                    var i : Iterator<String>
                    i =  result.keys()

                    if(!i.next().equals("fail"))
                    {
                        message_write_value = 0
                        //토큰 갱신
                        access_token = result.getString("student_token")

                        save_SharedPreferences.save_shard(this@class_message_write_Activity, access_token)

                        show(this@class_message_write_Activity, "정상적으로 등록 되었습니다.")

                        finish()
                        overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)


                    }
                    //실패 시
                    else
                    {
                        show(this@class_message_write_Activity, "인터넷 연결 상태를 확인해주세요.")
                    }

                } catch (e: JSONException) {
                    e.printStackTrace()
                } catch (e: IOException) {
                    e.printStackTrace()
                }
            }

            override fun onFailure(call: Call<ResponseBody>, t: Throwable) {


                show(this@class_message_write_Activity, "인터넷 연결 상태를 확인해주세요.")

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