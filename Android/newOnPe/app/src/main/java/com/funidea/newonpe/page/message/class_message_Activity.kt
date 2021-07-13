package com.funidea.newonpe.page.message

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.view.View
import com.funidea.utils.CustomToast
import com.funidea.utils.change_date_value.Companion.change_time_include_second
import com.funidea.utils.save_SharedPreferences
import com.funidea.utils.set_User_info
import com.funidea.utils.set_User_info.Companion.access_token
import com.funidea.utils.set_User_info.Companion.select_class_code_str
import com.funidea.utils.set_User_info.Companion.select_class_name_str
import com.funidea.utils.set_User_info.Companion.student_id
import com.funidea.utils.side_menu_layout.Companion.side_menu_setting_test
import com.funidea.newonpe.dialog.class_code_dialog
import com.funidea.newonpe.dialog.class_code_dialog_Utils.class_code_dialog_Item
import com.funidea.newonpe.R
import com.funidea.newonpe.page.login.SplashActivity.Companion.serverConnection
import kotlinx.android.synthetic.main.activity_message.*
import okhttp3.ResponseBody
import org.json.JSONArray
import org.json.JSONException
import org.json.JSONObject
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.io.IOException


/** 선생님께 문의내역 Class
 *
 * 선생님께 보낸 질문 내역을 확인하는 class
 *
 * 학생이 보낸 질문내역을 List 형태로 확인할 수 있다.
 *
 * 학생은 자신의 속한 클래스에서 선생님께 질문사항(문의사항)을 보내 답변을 받을 수 있다.
 *
 */
class class_message_Activity : AppCompatActivity() {

    lateinit var classMessageAdapter: class_message_Adapter
    var classMessageItem = ArrayList<class_message_Item>()
    var class_code_number : String =""

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_message)


        //메세지함 초기 선택값
        message_select_textview.setText(select_class_name_str)

        if(set_User_info.student_class_code_key_Array.size!=0)
        {
            for(i in set_User_info.student_class_code_key_Array.indices)
            {

                if(set_User_info.student_class_code_key_Array.get(i).equals(set_User_info.select_class_code_str))
                {
                    classCodeDialogItem.add(class_code_dialog_Item(set_User_info.student_class_code_value_Array.get(i), set_User_info.student_class_code_key_Array.get(i),1))
                    class_code_default_position = i
                    //임의 값
                    class_code_number = set_User_info.student_class_code_key_Array.get(i)

                }
                else
                {
                    classCodeDialogItem.add(class_code_dialog_Item(set_User_info.student_class_code_value_Array.get(i), set_User_info.student_class_code_key_Array.get(i),0))
                }


            }


        }



        classMessageAdapter = class_message_Adapter(this, classMessageItem)

        class_message_recyclerview.adapter = classMessageAdapter

        classMessageAdapter.setonItemClickListener(object : class_message_Adapter.onItemClickListener
        {
            override fun item_click(position: Int) {

                val intent = Intent(this@class_message_Activity, class_message_answer_Activity::class.java)

                //넘버
                intent.putExtra("number", classMessageItem.get(position).number)
                //제목
                intent.putExtra("title", classMessageItem.get(position).title)
                //작성일자
                intent.putExtra("write_date", classMessageItem.get(position).write_date)
                //내용
                intent.putExtra("sate_value", classMessageItem.get(position).message_state_value)

                startActivity(intent)
                overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)


            }

        })


        class_message_class_code_button_linearlayout.setOnClickListener(change_class_code)

        //뒤로 가기 버튼
        message_back_button.setOnClickListener(back_button)

        //메시지 작성 버튼
        message_write_button_textview.setOnClickListener(wirte_message_button)


        //사이드 메뉴버튼
        message_side_menu_button.setOnClickListener(side_menu_button)

        //사이드 메뉴
        var v : View = side_menu_layout_message
        side_menu_setting_test(message_drawerlayout ,v, this)



       // get_class_message(class_code_number)
    }

    override fun onResume()
    {   super.onResume()

        if(classMessageItem.size!=0)
        {
            classMessageItem.clear()
            classMessageAdapter.notifyDataSetChanged()
        }

        get_class_message(class_code_number)
    }


    var class_code_default_position : Int = 0
    var classCodeDialogItem = ArrayList<class_code_dialog_Item>()
    val change_class_code = View.OnClickListener {


        val classCodeDialog = class_code_dialog(this, classCodeDialogItem)

        classCodeDialog.show()

        classCodeDialog.setclassCodeSelectListener(object : class_code_dialog.classCodeSelectListener{
            override fun select_code_value(select_code_name: String, select_code: String, select_position: Int?) {

                classCodeDialog.dismiss()

                classCodeDialogItem.set(select_position!!, classCodeDialogItem[select_position]).class_select_value = 1
                classCodeDialogItem.set(class_code_default_position, classCodeDialogItem[class_code_default_position]).class_select_value = 0
                class_code_default_position = select_position
                message_select_textview.setText(select_code_name)


                class_code_number = select_code


                get_class_message(class_code_number)

            }

        })

    }



    fun get_class_message(get_student_class_code : String )
    {
        serverConnection!!.get_student_message_list(student_id,access_token,get_student_class_code).enqueue(object : Callback<ResponseBody> {
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

                        save_SharedPreferences.save_shard(this@class_message_Activity, set_User_info.access_token)


                        var message_jsonarray : JSONArray

                        message_jsonarray = result.getJSONArray("success")

                        var message_size = message_jsonarray.length()


                        if(classMessageItem.size!=0)
                        {
                            classMessageItem.clear()
                            classMessageAdapter.notifyDataSetChanged()
                        }

                        for(i in 0 until message_jsonarray.length())
                        {
                            var message_jsonObject : JSONObject

                            message_jsonObject = message_jsonarray.getJSONObject(i)

                            var message_number = message_jsonObject.getString("message_number")
                            var message_title = message_jsonObject.getString("message_title")
                            var message_date = change_time_include_second(message_jsonObject.getString("message_date"))
                            var message_comment_state = message_jsonObject.getInt("message_comment_state")

                            classMessageItem.add(class_message_Item(message_number, message_title, message_date, message_comment_state, message_size.toString()))

                            message_size = message_size - 1
                        }



                        classMessageAdapter.notifyDataSetChanged()

                    }
                    //실패 시
                    else
                    {
                        CustomToast.show(this@class_message_Activity, "인터넷 연결 상태를 확인해주세요.")

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



    //사이드 메뉴(햄버거)버튼
    val side_menu_button = View.OnClickListener{
        message_drawerlayout.openDrawer(message_child_drawerlayout)
    }
    override fun onStop() {
        super.onStop()

        message_drawerlayout.closeDrawer(message_child_drawerlayout)
    }


    //메시지 작성 버튼
    val wirte_message_button = View.OnClickListener {

        val intent = Intent(this, class_message_write_Activity::class.java)
        intent.putExtra("class_code_number", select_class_code_str)
        startActivity(intent)
        overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)
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