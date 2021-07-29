package com.funidea.newonpe.page.message

import android.app.AlertDialog
import android.content.Intent
import android.graphics.Color
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.view.View
import com.funidea.utils.CustomToast
import com.funidea.utils.change_date_value.Companion.change_time_include_second
import com.funidea.utils.SimpleSharedPreferences
import com.funidea.utils.set_User_info.Companion.access_token
import com.funidea.utils.set_User_info.Companion.student_id
import com.funidea.utils.set_User_info.Companion.student_name
import com.funidea.newonpe.R
import com.funidea.newonpe.page.login.LoginPage.Companion.serverConnectionSpec
import kotlinx.android.synthetic.main.activity_class_message_answer.*
import okhttp3.ResponseBody
import org.json.JSONException
import org.json.JSONObject
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.io.IOException

/** 선생님 문의 내역 답변 확인 Class
 *
 *  선생님이 사용자가 올린 질문에 대해서 답변을 달아주는 Class
 *
 *  내가 올린 질문에 대한 답변을 확인할 수 있다.
 */

class class_message_answer_Activity : AppCompatActivity() {

    var message_number : String=""
    var message_title : String =""
    var message_date : String =""
    var message_state_value : Int = 0
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_class_message_answer)

        var get_intent = intent

        message_number = get_intent.getStringExtra("number").toString()

        //작성자 명
        message_user_name_textview.setText(student_name)
        //목록 버튼
        message_answer_list_textview.setOnClickListener(back_button)
        //뒤로 가기 버튼
        message_answer_back_button.setOnClickListener(back_button)
        //메세지 수정 버튼
        message_answer_edit_textview.setOnClickListener(message_edit_button)
        //메세지 삭제 버튼
        message_answer_delete_textview.setOnClickListener(message_delete_button)



    }

    //메세지 수정 버튼
    val message_edit_button = View.OnClickListener {

        val intent = Intent(this, class_message_edit_Activity::class.java)
        intent.putExtra("number", message_number)
        intent.putExtra("title", class_message_title_textview.text.toString())
        intent.putExtra("content", message_write_textview.text.toString())
        intent.putExtra("date", message_write_date_textview.text.toString())
        startActivity(intent)
        overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)
    }


    //메세지 삭제 버튼
    val message_delete_button = View.OnClickListener {


        //정말 삭제하시겠습니까 라는 AlertDialog 생성
        val builder = AlertDialog.Builder(this)
        builder.setMessage("정말로 삭제하시겠습니까?")
        builder.setPositiveButton("확인") { dialogInterface, i ->

            //서버로 삭제 안내 해주기
            delete_student_message(message_number)

            dialogInterface.dismiss()
        }
        builder.setNegativeButton("취소") { dialogInterface, i ->
            dialogInterface.dismiss()
        }
        val dialog: AlertDialog = builder.create()
        dialog.show()





    }

    override fun onResume() {
        super.onResume()

        //메세지 상세 내용 가져오기
        get_class_message(message_number)
    }


    fun delete_student_message(message_number : String)
    {
        serverConnectionSpec!!.delete_student_message(student_id, access_token,message_number).enqueue(object : Callback<ResponseBody> {
            override fun onResponse(call: Call<ResponseBody>, response: Response<ResponseBody>)
            {
                try {
                    val result = JSONObject(response.body()!!.string())


                    var i : Iterator<String>
                    i =  result.keys()

                    if(!i.next().equals("fail"))
                    {

                        //토큰 갱신
                        access_token = result.getString("student_token")

                        SimpleSharedPreferences.saveAccessToken(this@class_message_answer_Activity, access_token)

                        CustomToast.show(this@class_message_answer_Activity, "정상적으로 삭제 되었습니다.")

                        finish()
                        overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)


                    }
                    //실패 시
                    else
                    {
                        CustomToast.show(this@class_message_answer_Activity, "인터넷 연결 상태를 확인해주세요.")
                    }

                } catch (e: JSONException) {
                    e.printStackTrace()
                } catch (e: IOException) {
                    e.printStackTrace()
                }
            }

            override fun onFailure(call: Call<ResponseBody>, t: Throwable) {


                CustomToast.show(this@class_message_answer_Activity, "인터넷 연결 상태를 확인해주세요.")

            }
        })
    }

    //메세지 가져오기
    fun get_class_message(message_number : String )
    {
        serverConnectionSpec!!.get_student_message(student_id, access_token,message_number).enqueue(object : Callback<ResponseBody> {
            override fun onResponse(call: Call<ResponseBody>, response: Response<ResponseBody>)
            {
                try {
                    val result = JSONObject(response.body()!!.string())

                    var i : Iterator<String>
                    i =  result.keys()


                    if(!i.next().equals("fail"))
                    {

                        //토큰 갱신
                        access_token = result.getString("student_token")

                        SimpleSharedPreferences.saveAccessToken(this@class_message_answer_Activity, access_token)


                        val success_JSONObject = result.getJSONObject("success")


                        //메세지 제목
                        class_message_title_textview.setText(success_JSONObject.getString("message_title"))
                        //메세지 작성자
                        message_user_name_textview.setText(success_JSONObject.getString("message_name"))
                        //작성일
                        message_write_date_textview.setText(change_time_include_second(success_JSONObject.getString("message_date")))

                        //메세지 상태
                        message_state_value = success_JSONObject.getInt("message_comment_state")
                        if(message_state_value==0)
                        {
                            message_answer_edit_textview.visibility  = View.VISIBLE
                            message_answer_delete_textview.visibility = View.VISIBLE
                            message_answer_title_textview.setText("답변을 준비 중입니다.")
                            message_answer_linear_layout.visibility = View.GONE
                            message_answer_content_textview.visibility = View.GONE

                            message_answer_value.setText("미답변")
                            message_answer_value.setTextColor(Color.parseColor("#777777"))
                            message_answer_value.setBackgroundResource(R.drawable.view_gray_color_round_edge)
                        }
                        else
                        {

                            message_answer_edit_textview.visibility  = View.GONE
                            message_answer_delete_textview.visibility = View.GONE
                            message_answer_value.setText("답변")
                            message_answer_value.setTextColor(Color.parseColor("#3378fd"))
                            message_answer_value.setBackgroundResource(R.drawable.view_main_color_2_round_button)
                        }

                        //작성한 메세지 내용
                        message_write_textview.setText(success_JSONObject.getString("message_text"))
                        //메세지 작성자 선생님 이름
                        message_answer_teacher_name_textview.setText(success_JSONObject.getString("message_teacher_name"))
                        //메시지 작성일
                        message_answer_date_textview.setText(change_time_include_second(success_JSONObject.getString("message_comment_date")))
                        //메세지 작성 내용
                        message_answer_content_textview.setText(success_JSONObject.getString("message_comment"))

                    }
                    //실패 시
                    else
                    {
                        CustomToast.show(this@class_message_answer_Activity, "인터넷 연결 상태를 확인해주세요.")

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