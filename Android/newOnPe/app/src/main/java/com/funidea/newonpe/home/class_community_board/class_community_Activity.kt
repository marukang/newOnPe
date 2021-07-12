package com.funidea.newonpe.home.class_community_board

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.view.View
import com.funidea.utils.Custom_Toast
import com.funidea.utils.change_date_value.Companion.change_time
import com.funidea.utils.save_SharedPreferences
import com.funidea.utils.set_User_info.Companion.access_token
import com.funidea.utils.set_User_info.Companion.select_class_code_str
import com.funidea.utils.set_User_info.Companion.select_class_name_str
import com.funidea.utils.set_User_info.Companion.student_class_code_key_Array
import com.funidea.utils.set_User_info.Companion.student_class_code_value_Array
import com.funidea.utils.set_User_info.Companion.student_id
import com.funidea.utils.side_menu_layout.Companion.side_menu_setting_test
import com.funidea.newonpe.dialog.class_code_dialog
import com.funidea.newonpe.dialog.class_code_dialog_Utils.class_code_dialog_Item
import com.funidea.newonpe.R
import com.funidea.newonpe.SplashActivity.Companion.serverConnection
import kotlinx.android.synthetic.main.activity_class_community.*
import okhttp3.ResponseBody
import org.json.JSONArray
import org.json.JSONException
import org.json.JSONObject
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.io.IOException

/** 클래스 커뮤니티 Class
 *
 *  같은 클래스 사용자들의 작성한 글을 확인하고 글을 작성할 수 있는 Class 입니다.
 *
 *  사용자는 내가 속한 클래스 중에서 하나를 선택해 해당 클래스의  글을 확인하거나,
 *
 *  글을 작성할 수 있습니다.
 */

class class_community_Activity : AppCompatActivity() {


    lateinit var classCommunityAdapter: class_community_Adapter

    var classCommunityItem = ArrayList<class_community_Item>()

    var class_code_number : String =""

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_class_community)


        //내가 선택한 Class_code
        //클래스 커뮤니티 입장 시 내가 메인화면에서 선택한 Class_code를 기본값으로 해 입장합니다.
        class_community_class_code_name_textview.setText(select_class_name_str)

        if(student_class_code_key_Array.size!=0)
        {
            for(i in student_class_code_key_Array.indices)
            {

                if(student_class_code_key_Array.get(i).equals(select_class_code_str))
                {
                    classCodeDialogItem.add(class_code_dialog_Item(student_class_code_value_Array.get(i),student_class_code_key_Array.get(i),1))
                    class_code_default_position = i
                    class_code_number = student_class_code_key_Array.get(i)

                }
                else
                {
                    classCodeDialogItem.add(class_code_dialog_Item(student_class_code_value_Array.get(i),student_class_code_key_Array.get(i),0))
                }


            }


        }


        //사이드 메뉴 셋팅
        var v : View = side_menu_layout_class_community
        side_menu_setting_test(class_community_drawerlayout,v, this)

        classCommunityAdapter = class_community_Adapter(this, classCommunityItem)

        class_community_recyclerview.adapter = classCommunityAdapter


        classCommunityAdapter.setonItemClickListener(object : class_community_Adapter.onItemClickListener {
            override fun item_click(position: Int) {

                val intent = Intent(this@class_community_Activity, class_community_board_Activity::class.java)

                //넘버
                intent.putExtra("number", classCommunityItem.get(position).number)
                //유저 아이디
                intent.putExtra("user_id", classCommunityItem.get(position).user_id)
                //유저 이름
                intent.putExtra("user_name", classCommunityItem.get(position).user_name)
                //제목
                intent.putExtra("title", classCommunityItem.get(position).title)
                //날짜
                intent.putExtra("write_date", classCommunityItem.get(position).write_date)
                //댓글 수
                intent.putExtra("comment_count", classCommunityItem.get(position).comment_count)


                startActivity(intent)

                overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)


            }
        })

        //뒤로가기 버튼
        class_community_back_button.setOnClickListener(back_button)
        //메뉴 버튼
        class_community_menu_button.setOnClickListener(side_menu_button)
        //글쓰기 버튼
        class_community_write_button.setOnClickListener(board_write_button)
        //클래스 코드 변경
        class_community_class_code_button_linearlayout.setOnClickListener(change_class_code)

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
                class_community_class_code_name_textview.setText(select_code_name)


                class_code_number = select_code

                get_class_community_list(class_code_number)

            }

        })

    }

    override fun onResume() {
        super.onResume()



        get_class_community_list(class_code_number)
    }



    fun get_class_community_list(student_class_code : String )
    {
        serverConnection!!.get_student_community_list(student_id, access_token, student_class_code).enqueue(object : Callback<ResponseBody> {
            override fun onResponse(call: Call<ResponseBody>, response: Response<ResponseBody>)
            {
                try {
                    val result = JSONObject(response.body()!!.string())



                    var i : Iterator<String>
                    i =  result.keys()

                    Log.d("결과", "onResponse:"+result)
                    if(!i.next().equals("fail"))
                    {

                        //토큰 갱신
                        access_token = result.getString("student_token")

                        save_SharedPreferences.save_shard(this@class_community_Activity, access_token)

                        if(classCommunityItem.size!=0)
                        {
                            classCommunityItem.clear()
                            classCommunityAdapter.notifyDataSetChanged()

                        }


                        var community_jsonarray : JSONArray

                        community_jsonarray = result.getJSONArray("success")

                        var community_size = community_jsonarray.length()

                        for(i in 0 until community_jsonarray.length())
                        {
                            var community_jsonObject : JSONObject

                            community_jsonObject = community_jsonarray.getJSONObject(i)

                            var community_number = community_jsonObject.getString("community_number")
                            var community_id = community_jsonObject.getString("community_id")
                            var community_name = community_jsonObject.getString("community_name")
                            var community_title = community_jsonObject.getString("community_title")
                            var community_date = change_time(community_jsonObject.getString("community_date"))
                            var community_count = community_jsonObject.getInt("community_count")

                            classCommunityItem.add(class_community_Item(community_number, community_id, community_name, community_title, community_date, community_count, community_size.toString()))

                            community_size = community_size -1

                        }


                        classCommunityAdapter.notifyDataSetChanged()

                    }
                    //실패 시
                    else
                    {
                        Custom_Toast.custom_toast(this@class_community_Activity, "인터넷 연결 상태를 확인해주세요.")

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
        class_community_drawerlayout.openDrawer(class_community_child_drawerlayout)
    }
    override fun onStop() {
        super.onStop()

        class_community_drawerlayout.closeDrawer(class_community_child_drawerlayout)
    }

    //글쓰기 버튼
    val board_write_button = View.OnClickListener {

        val intent = Intent(this, class_community_write_Activity::class.java)
        intent.putExtra("class_code_number", class_code_number)
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