package com.funidea.newonpe.page.home.subject

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.view.View
import com.funidea.utils.CustomToast.Companion.show
import com.funidea.utils.SimpleSharedPreferences
import com.funidea.utils.set_User_info
import com.funidea.utils.set_User_info.Companion.access_token
import com.funidea.utils.set_User_info.Companion.select_class_code_str
import com.funidea.utils.set_User_info.Companion.select_class_name_str
import com.funidea.utils.set_User_info.Companion.student_class_code_key_Array
import com.funidea.utils.set_User_info.Companion.student_class_code_value_Array
import com.funidea.utils.set_User_info.Companion.student_id
import com.funidea.utils.side_menu_layout.Companion.side_menu_setting_test
import com.funidea.newonpe.*
import com.funidea.newonpe.dialog.InsertClassCodeDialog
import com.funidea.newonpe.dialog.ClassCodeItem
import com.funidea.newonpe.page.home.class_community_board.class_community_Activity
import com.funidea.newonpe.page.home.class_result.class_result_Activity
import com.funidea.newonpe.page.home.class_unit.class_unit_page
import com.funidea.newonpe.page.login.LoginPage.Companion.serverConnectionSpec
import kotlinx.android.synthetic.main.activity_class_home.*
import okhttp3.ResponseBody
import org.json.JSONArray
import org.json.JSONException
import org.json.JSONObject
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.io.IOException
import java.text.SimpleDateFormat
import java.util.*
import kotlin.collections.ArrayList

/** 클래스 입장시 가잘 먼저 보여질 Class
 *
 * 클래스 코드(수업) 선택 후 입장하면 보여지는 클래스 화면 입니다.
 *
 * 해당 화면에서는 각 단원을 확인할 수 있으며 해당 단원별(차시별)클래스로 이동해서
 * 수업을 들을 수 있습니다.
 *
 */

class class_home_Activity : AppCompatActivity() {

    //링크
    lateinit var classUnitListAdapter: class_unit_list_Adapter
    var classUnitListItem = ArrayList<class_unit_list_Item>()

    //수업 제출할 곳의 대한 정보
    lateinit var classLinkAdapter: class_link_Adapter
    var classLinkItem = ArrayList<class_link_Item>()

    //현재 선택 포지션 값
    var select_class_code_position : Int = 0

    //시간 데이터
    // 현재시간을 msec 으로 구한다.
    val now = System.currentTimeMillis()
    // 현재시간을 date 변수에 저장한다.
    val date = Date(now)
    // 시간을 나타냇 포맷을 정한다 ( yyyy/MM/dd 같은 형태로 변형 가능 )
    val sdfNow = SimpleDateFormat("yyyyMMdd")
    // nowDate 변수에 값을 저장한다.
    val formatDate = sdfNow.format(date)

    val nowdate : Int = formatDate.toInt()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_class_home)



        //과제 제출 링크 정보
        classLinkAdapter = class_link_Adapter(this, classLinkItem)

        class_link_recyclerview.adapter = classLinkAdapter


        classUnitListAdapter = class_unit_list_Adapter(this,classUnitListItem)

        class_home_recyclerview.adapter = classUnitListAdapter

        classUnitListAdapter.setonItemClickListener(object : class_unit_list_Adapter.onItemClickListener
        {
            override fun item_click(position: Int) {

                var class_unit_end_date_change = classUnitListItem.get(position).class_unit_end_date

                var class_unit_start_date_change = classUnitListItem.get(position).class_unit_start_date

                class_unit_end_date_change = class_unit_end_date_change.substring(0, 8)
                class_unit_start_date_change = class_unit_start_date_change.substring(0, 8)

                if(nowdate<=class_unit_end_date_change.toInt()&&nowdate>=class_unit_start_date_change.toInt())
                {

                    val intent = Intent(this@class_home_Activity, class_unit_page::class.java)

                    intent.putExtra("unit_code", classUnitListItem.get(position).class_unit_code)
                    intent.putExtra("class_code", select_class_code_str)

                    //Log.d("멀까?", "item_click:"+classUnitListItem.get(position).class_unit_value)
                    startActivity(intent)

                    overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)
                }
                else if(nowdate<class_unit_start_date_change.toInt())
                {
                    show(this@class_home_Activity, "수업 기간이 아닙니다.")
                }
                else if(nowdate>class_unit_end_date_change.toInt())
                {
                    show(this@class_home_Activity, "기간이 만료 된 수업입니다.")
                }



            }
            //수업 현황 보기 버튼
            override fun state_click(position: Int) {

                get_student_class_record(select_class_code_str,classUnitListItem.get(position).class_unit_code,  classUnitListItem.get(position).class_unit_title)

            }


        })



        //뒤로 가기 버튼
        class_home_back_button.setOnClickListener(back_button)
        //메뉴 버튼
        class_menu_button.setOnClickListener(side_menu_button)
        //학급 커뮤니티 이동 버튼
        class_community_button_textview.setOnClickListener(move_community_button)
        //현재 선택 된 클래스 명
        class_home_select_class_name_textview.setText(select_class_name_str)

        //클래스 변경 다이어로그
        class_home_select_class_name_textview.setOnClickListener(change_class_code_button)

        //사이드 메뉴 셋팅
        var v : View = side_menu_layout_class_home
        side_menu_setting_test(class_home_drawerlayout,v, this)




        //수업 리스트 받아오기
        var get_Intent = intent
        get_class_unit_list(get_Intent.getStringExtra("unit_code_list").toString())

        get_class_project_submit_type(select_class_code_str)

    }



    //수업 리스트 보여주기
    fun get_class_unit_list(class_unit : String)
    {

        if(classUnitListItem.size!=0)
        {
            classUnitListItem.clear()
            classUnitListAdapter.notifyDataSetChanged()
        }

        var class_unit_list_JosnArray : JSONArray

        class_unit_list_JosnArray = JSONArray(class_unit)


        var class_unit_JSONObject : JSONObject


        for(i in 0 until class_unit_list_JosnArray.length())
        {

            class_unit_JSONObject = class_unit_list_JosnArray.getJSONObject(i)

            var class_name = class_unit_JSONObject.getString("unit_class_name")
            var class_unit_code = class_unit_JSONObject.getString("unit_code")
            var class_start_date = class_unit_JSONObject.getString("unit_start_date")
            var class_end_date = class_unit_JSONObject.getString("unit_end_date")

            classUnitListItem.add(class_unit_list_Item(class_start_date, class_end_date,
                    class_name, class_unit_code,0))


        }

        classUnitListAdapter.notifyDataSetChanged()


    }


    //클래스 코드 변경하기
    val change_class_code_button = View.OnClickListener {

        var classCodeDialogItem = ArrayList<ClassCodeItem>()

        for(i in student_class_code_key_Array.indices)
        {
            if(student_class_code_key_Array.get(i).equals(select_class_code_str))
            {
                classCodeDialogItem.add(ClassCodeItem(student_class_code_value_Array.get(i),student_class_code_key_Array.get(i),1))
                select_class_code_position = i

            }
            else
            {
                classCodeDialogItem.add(ClassCodeItem(student_class_code_value_Array.get(i),student_class_code_key_Array.get(i),0))
            }
        }


        val classCodeDialog = InsertClassCodeDialog(this, classCodeDialogItem)
        classCodeDialog.show()



        classCodeDialog.setclassCodeSelectListener(object  : InsertClassCodeDialog.classCodeSelectListener
        {
            override fun select_code_value(select_code_name: String, select_code: String, select_position: Int?) {


                classCodeDialogItem.set(select_position!!, classCodeDialogItem[select_position]).class_select_value = 1
                classCodeDialogItem.set(select_class_code_position, classCodeDialogItem[select_class_code_position]).class_select_value = 0
                select_class_code_position = select_position
                class_home_select_class_name_textview.setText(select_code_name)

                select_class_name_str = select_code_name
                select_class_code_str = select_code


                get_class_unit(select_class_code_str)

                if(classLinkItem.size!=0)
                {
                    classLinkItem.clear()
                    classLinkAdapter.notifyDataSetChanged()
                }


                get_class_project_submit_type(select_class_code_str)

            }
        }

        )

    }

    //사이드 메뉴(햄버거)버튼
    val side_menu_button = View.OnClickListener{
        class_home_drawerlayout.openDrawer(class_home_child_drawerlayout)
    }

    //커뮤니티 이동 버튼
    val move_community_button = View.OnClickListener {

        val intent = Intent(this, class_community_Activity::class.java)
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

    override fun onStop() {
        super.onStop()

        class_home_drawerlayout.closeDrawer(class_home_child_drawerlayout)
    }

    //클래스 유닛 리스트 가져오기
    fun get_class_unit(class_code : String)
    {
        serverConnectionSpec!!.get_class_list(student_id, access_token).enqueue(object : Callback<ResponseBody> {
            override fun onResponse(call: Call<ResponseBody>, response: Response<ResponseBody>)
            {
                try {
                    val result = JSONObject(response.body()!!.string())



                    var i : Iterator<String>
                    i =  result.keys()

                    //Log.d("결과", "onResponse:"+result)
                    if(!i.next().equals("fail"))
                    {

                        //토큰 갱신
                        access_token = result.getString("student_token")

                        SimpleSharedPreferences.saveAccessToken(this@class_home_Activity, set_User_info.access_token)

                        var unit_code_list : String = ""

                        unit_code_list = result.getString("success")

                        get_class_unit_list(unit_code_list)

                    }
                    //실패 시
                    else
                    {
                        show(this@class_home_Activity, "인터넷 연결 상태를 확인해주세요.")

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

    //클래스 과제 제출 링크 가져오기
    //클래스 유닛 리스트 가져오기
    fun get_class_project_submit_type(class_code : String)
    {
        serverConnectionSpec!!.get_class_project_submit_type(student_id, access_token, class_code).enqueue(object : Callback<ResponseBody> {
            override fun onResponse(call: Call<ResponseBody>, response: Response<ResponseBody>)
            {
                try {
                    val result = JSONObject(response.body()!!.string())



                    var i : Iterator<String>
                    i =  result.keys()

                    //Log.d("결과", "onResponse:"+result)
                    if(!i.next().equals("fail"))
                    {

                        //토큰 갱신
                        access_token = result.getString("student_token")

                        SimpleSharedPreferences.saveAccessToken(this@class_home_Activity, access_token)

                        var class_link_list : String = ""

                        class_link_list = result.getString("success")

                        var class_link_JSONArray = JSONArray(class_link_list)


                        if(class_link_JSONArray.length()!=0) {


                            for (i in 0 until class_link_JSONArray.length()) {

                                var get_link_date = class_link_JSONArray.get(i).toString()

                                var get_link_jsonObject = JSONObject(get_link_date)

                                var submit_type = get_link_jsonObject.getString("type")
                                var submit_link = get_link_jsonObject.getString("link")

                                classLinkItem.add(class_link_Item(submit_type, submit_link))

                            }

                            classLinkAdapter.notifyDataSetChanged()

                        }
                        else
                        {
                            class_link_recyclerview.visibility = View.GONE
                        }




                    }
                    //실패 시
                    else
                    {
                        show(this@class_home_Activity, "인터넷 연결 상태를 확인해주세요.")

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


    //결과 기록 가져오기
    fun get_student_class_record(class_code : String, class_unit_code : String, class_unit_title : String)
    {
        serverConnectionSpec!!.get_student_class_record(student_id,access_token, class_code).enqueue(object : Callback<ResponseBody> {
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

                        SimpleSharedPreferences.saveAccessToken(this@class_home_Activity, access_token)

                val intent = Intent(this@class_home_Activity, class_result_Activity::class.java)

                intent.putExtra("class_title", class_unit_title)
                intent.putExtra("unit_code", class_unit_code)
                intent.putExtra("class_code", class_code)

                startActivity(intent)
                overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)

                    }
                    //실패 시
                    else
                    {
                        show(this@class_home_Activity, "수업 참여 후 수업 현황을 조회해주세요.")

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


}