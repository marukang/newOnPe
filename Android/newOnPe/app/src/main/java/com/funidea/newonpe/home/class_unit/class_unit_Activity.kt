package com.funidea.newonpe.home.class_unit

import android.content.Intent
import android.graphics.Color
import android.os.Bundle
import android.util.Log
import android.view.View
import androidx.appcompat.app.AppCompatActivity
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.LinearSnapHelper
import androidx.recyclerview.widget.SnapHelper
import com.funidea.utils.Custom_Toast.Companion.custom_toast
import com.funidea.utils.change_date_value.Companion.change_month_time
import com.funidea.utils.save_SharedPreferences
import com.funidea.utils.set_User_info.Companion.access_token
import com.funidea.utils.set_User_info.Companion.student_class
import com.funidea.utils.set_User_info.Companion.student_id
import com.funidea.utils.set_User_info.Companion.student_level
import com.funidea.utils.set_User_info.Companion.student_name
import com.funidea.utils.set_User_info.Companion.student_number
import com.funidea.utils.side_menu_layout.Companion.side_menu_setting_test
import com.funidea.newonpe.R
import com.funidea.newonpe.home.VariableScrollSpeedLinearLayoutManager
import com.funidea.newonpe.home.class_community_board.board_file_Adapter
import com.funidea.newonpe.home.class_community_board.board_file_Item
import com.funidea.newonpe.home.class_file_open_webview_Activity
import com.funidea.newonpe.home.class_result.class_result_Activity
import com.funidea.newonpe.home.class_unit.class_detail_unit.class_detail_unit_Activity
import com.funidea.newonpe.message.class_message_Activity
import com.funidea.newonpe.SplashActivity.Companion.serverConnection
import kotlinx.android.synthetic.main.activity_class_unit.*
import okhttp3.ResponseBody
import org.json.JSONArray
import org.json.JSONException
import org.json.JSONObject
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.io.IOException


/** 차시별(단원별) 수업에 대한 내용을 확인할 수 있는 Class
 *
 * 해당 화면에서는 선생님이 개설한 차시별 클래스의 정보를 확인할 수 있습니다.
 *
 * 정보는 수업 관련 링크, 참고자료, 유튜브 영상 등을 확인 및 시청 할 수 있습니다.
 *
 * 관련 링크나 참고자료, 유튜브 영상을 모두 시청해야만 다음 화면으로 이동해
 *
 * 운동 콘텐츠를 진행할 수 있습니다.
 *
 */

class class_unit_Activity : AppCompatActivity() {

    var file_button_value : Int = 0
    var youtube_button_value : Int = 0
    var link_button_value : Int = 0
    var youtube_isRunning = true
    //첨부파일
    lateinit var boardFileAdapter: board_file_Adapter
    var boardFileItem = ArrayList<board_file_Item>()
    //링크
    lateinit var classUnitLinkAdapter: class_unit_link_Adapter
    var classUnitLinkItem = ArrayList<class_unit_link_Item>()

    //유튜버 뷰
    lateinit var classUnitYoutubeAdapter: class_unit_youtube_Adapter
    var classUnitYoutubeItem = ArrayList<class_unit_youtube_Item>()
    var snapHelper: SnapHelper? = LinearSnapHelper()

    var class_code : String = ""
    var unit_class_code : String = ""

    //수업 타입
    var unit_class_type : String = ""
    //그룹명
    var unit_class_group_name : String =""

    //참고자료
    var class_file_open_value : Boolean = false
    //유튜브 영상
    var class_youtube_open_value : Boolean = false
    //수업링크
    var class_link_open_value : Boolean = false

    //콘텐츠 코드 리스트
    var content_code_list : String = ""

    var content_test_value : String = "-"



    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_class_unit)

        //클래스 코드, 차시별 유닛 코드 가져오기
        var get_intent = intent

        class_code = get_intent.getStringExtra("class_code").toString()
        unit_class_code = get_intent.getStringExtra("unit_code").toString()




        //클래스 수업현황 가져오기
        class_unit_class_state_linearlayout.setOnClickListener(get_state_value)

        //사이드 메뉴 셋팅
        //사이드 메뉴 셋팅
        var v : View = side_menu_layout_class_unit
        side_menu_setting_test(class_unit_drawerlayout, v, this)

        //차시별 클래스 참고자료 버튼
        class_unit_file_button.setOnClickListener(file_button)
        //차시별 참고자료 리사이클러뷰 셋팅
        boardFileAdapter = board_file_Adapter(this, boardFileItem)
        class_unit_file_recyclerview.adapter = boardFileAdapter
        boardFileAdapter.setonItemClickListener(object : board_file_Adapter.onItemClickListener
        {
            override fun item_click(position: Int) {
                val intent = Intent(this@class_unit_Activity, class_file_open_webview_Activity::class.java)
                intent.putExtra("get_URL", boardFileItem.get(position).file_url)
                startActivity(intent)
                overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)
            }

        })

        //클래스 유닛 링크
        classUnitLinkAdapter = class_unit_link_Adapter(this, classUnitLinkItem)
        class_unit_link_recyclerview.adapter = classUnitLinkAdapter
        classUnitLinkAdapter.setonItemClickListener(object  : class_unit_link_Adapter.onItemClickListener
        {
            override fun item_click(position: Int) {

                val intent = Intent(this@class_unit_Activity, class_file_open_webview_Activity::class.java)
                intent.putExtra("get_URL", classUnitLinkItem.get(position).file_url)
                startActivity(intent)
                overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)
            }

            override fun item_delete(position: Int) {

            }

        }
        )
        //유투브 영상보기
        class_unit_youtube_button.setOnClickListener(youtube_button)
        //수업 관련 링크 보기
        class_unit_link_button.setOnClickListener(link_button)

        //클래스 레이아웃 닫아놓기
        class_unit_file_recyclerview.visibility = View.GONE
        class_unit_youtube_linearlayout.visibility = View.GONE
        class_unit_link_recyclerview.visibility = View.GONE

        //클래스 유투버 뷰
        classUnitYoutubeAdapter = class_unit_youtube_Adapter(this, classUnitYoutubeItem)
        class_unit_youtube_view_recyclerview.adapter = classUnitYoutubeAdapter
        snapHelper!!.attachToRecyclerView(class_unit_youtube_view_recyclerview)
        //레이아웃 매니저
        var linearLayoutManager : VariableScrollSpeedLinearLayoutManager
        linearLayoutManager = VariableScrollSpeedLinearLayoutManager(this, 4F)
        linearLayoutManager.orientation = LinearLayoutManager.HORIZONTAL
        class_unit_youtube_view_recyclerview.layoutManager = linearLayoutManager


        class_unit_youtube_circleindicator.attachToRecyclerView(class_unit_youtube_view_recyclerview, snapHelper!!)
        class_unit_youtube_circleindicator.createIndicators(classUnitYoutubeItem.size,0)
        classUnitYoutubeAdapter.registerAdapterDataObserver(class_unit_youtube_circleindicator.adapterDataObserver)
        class_unit_youtube_view_recyclerview.adapter = classUnitYoutubeAdapter

        class_unit_youtube_circleindicator.visibility = View.GONE

        //뒤로가기 버튼
        class_unit_back_button.setOnClickListener(back_button)
        //메뉴버튼
        class_unit_menu_button.setOnClickListener(side_menu_button)
        //시작하기 버튼
        class_unit_start_button_textview.setOnClickListener(start_button)

        //메세지함 이동
        class_unit_message_linearlayout.setOnClickListener(message_button)

        //수업 내용 가져오기
        get_unit_class(class_code, unit_class_code)
    }

    //메세지함 이동
    val message_button = View.OnClickListener {


        val intent = Intent(this, class_message_Activity::class.java)

        startActivity(intent)

        overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)
    }


    //수업 현황 보기 버튼
    val get_state_value = View.OnClickListener {

        val intent = Intent(this, class_result_Activity::class.java)

        intent.putExtra("class_title", class_unit_title_textview.text.toString())
        intent.putExtra("unit_code", unit_class_code)
        intent.putExtra("class_code", class_code)
        startActivity(intent)

        overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)
    }


    //사이드 메뉴(햄버거)버튼
    val side_menu_button = View.OnClickListener{
        class_unit_drawerlayout.openDrawer(class_unit_child_drawerlayout)
    }
    override fun onStop() {
        super.onStop()

        class_unit_drawerlayout.closeDrawer(class_unit_child_drawerlayout)
    }


    //시작하기 버튼
    val start_button = View.OnClickListener {

        if(class_file_open_value&&class_youtube_open_value&&class_link_open_value){

        //unit_class_group_name = ""


        //학생 출석
        student_update_participation(class_code, unit_class_code, unit_class_type, unit_class_group_name)

        }
        else
        {
            custom_toast(this, "참고자료, 수업링크, 유투브 영상을 확인 후 시작해주세요.")
        }
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


    val file_button = View.OnClickListener {

        if(boardFileItem.size!=0){

        class_file_open_value = true
        start_check_value()
        if(file_button_value==0)
        {
            file_button_value=1
            class_unit_file_imageview.setImageResource(R.drawable.ic_main_color_up_button)
            class_unit_file_recyclerview.visibility = View.VISIBLE
        }
        else
        {
            file_button_value=0
            class_unit_file_imageview.setImageResource(R.drawable.main_color_down_button)
            class_unit_file_recyclerview.visibility = View.GONE

        }
        }
        else
        {
            custom_toast(this, "첨부파일이 없습니다.")
        }
    }

    val youtube_button = View.OnClickListener {

        if(classUnitYoutubeItem.size!=0)
        {

            class_youtube_open_value = true
            start_check_value()
            if (youtube_button_value == 0) {
                youtube_button_value = 1
                class_unit_youtube_imageview.setImageResource(R.drawable.ic_main_color_up_button)
                class_unit_youtube_linearlayout.visibility = View.VISIBLE
                class_unit_youtube_circleindicator.visibility = View.VISIBLE
            } else {
                youtube_button_value = 0
                class_unit_youtube_imageview.setImageResource(R.drawable.main_color_down_button)
                class_unit_youtube_linearlayout.visibility = View.GONE
                class_unit_youtube_circleindicator.visibility = View.GONE

            }

        }
        else{
            custom_toast(this, "유튜브 영상이 없습니다.")
        }
    }

    val link_button = View.OnClickListener {


        if(classUnitLinkItem.size!=0){
        class_link_open_value = true
        start_check_value()
        if(link_button_value==0)
        {
            link_button_value=1
            class_unit_link_imageview.setImageResource(R.drawable.ic_main_color_up_button)
            class_unit_link_recyclerview.visibility = View.VISIBLE
        }
        else
        {
            link_button_value=0
            class_unit_link_imageview.setImageResource(R.drawable.main_color_down_button)
            class_unit_link_recyclerview.visibility = View.GONE

        }
        }
        else
        {
            custom_toast(this, "수업 관련 링크가 없습니다.")
        }
    }


    //클래스 정보 가져오기
    fun get_unit_class(class_code : String, unit_class_code : String)
    {
        serverConnection!!.student_get_curriculum(student_id, access_token, class_code, unit_class_code).enqueue(object : Callback<ResponseBody> {
            override fun onResponse(call: Call<ResponseBody>, response: Response<ResponseBody>)
            {
                try {
                    val result = JSONObject(response.body()!!.string())



                    var i : Iterator<String>
                    i =  result.keys()

                    Log.d("결과!!?", "onResponse:"+result)
                    if(!i.next().equals("fail"))
                    {

                        //토큰 갱신
                        access_token = result.getString("student_token")

                        save_SharedPreferences.save_shard(this@class_unit_Activity, access_token)


                        lateinit var get_unit_info_JSONObject : JSONObject

                        var class_unit_info_JSONArray : JSONArray

                        class_unit_info_JSONArray = result.getJSONArray("success")

                        Log.d("되려나", "onResponse: "+class_unit_info_JSONArray.length())



                        if(class_unit_info_JSONArray.length()>1)
                        {
                            for(i in 0 until class_unit_info_JSONArray.length())
                            {

                                var get_unit_info = JSONObject(class_unit_info_JSONArray.get(i).toString())

                                //Log.d("머징?", "onResponse:"+get_unit_info.getString("unit_class_type"))

                                var class_unit_group_id_list_str : String
                                class_unit_group_id_list_str = get_unit_info.getString("unit_group_id_list")

                                var class_unit_group_id_JSONArray : JSONArray

                                class_unit_group_id_JSONArray = JSONArray(class_unit_group_id_list_str)

                                if(class_unit_group_id_JSONArray.length()!=0)
                                {
                                    for(j in 0 until  class_unit_group_id_JSONArray.length())
                                    {
                                        if(class_unit_group_id_JSONArray.getString(j).equals(student_id))
                                        {
                                            unit_class_group_name = get_unit_info.getString("unit_group_name")
                                            get_unit_info_JSONObject = JSONObject(class_unit_info_JSONArray.get(i).toString())

                                            break
                                        }

                                    }
                                }


                                //break
                            }


                        }
                        else
                        {
                             get_unit_info_JSONObject = JSONObject(class_unit_info_JSONArray.get(0).toString())
                        }



                        class_unit_date_textview.setText(
                                change_month_time(get_unit_info_JSONObject.getString("unit_start_date"))+
                                " ~ "
                        +change_month_time(get_unit_info_JSONObject.getString("unit_end_date")))
                        class_unit_title_textview.setText(get_unit_info_JSONObject.getString("unit_class_name"))
                        class_unit_content_textview.setText(get_unit_info_JSONObject.getString("unit_class_text"))

                        var home_work_JSONArray = JSONArray(get_unit_info_JSONObject.getString("content_home_work"))

                        var content_test_JSONArray = JSONArray(get_unit_info_JSONObject.getString("content_test"))



                        if(home_work_JSONArray.length()!=0)
                        {
                            for(i in 0 until home_work_JSONArray.length())
                            {
                                if(home_work_JSONArray.getString(i).equals("1"))
                                {
                                  class_unit_content_home_work_value.setText("O")
                                  break
                                }
                                else
                                {
                                    class_unit_content_home_work_value.setText("X")
                                }
                            }

                        }

                        if(content_test_JSONArray.length()!=0)
                        {
                            for(i in 0 until content_test_JSONArray.length())
                            {
                                if(content_test_JSONArray.getString(i).equals("1"))
                                {
                                    class_unit_content_test_value.setText("O")
                                    content_test_value = "0"
                                    break
                                }
                                else
                                {
                                    class_unit_content_test_value.setText("X")
                                    content_test_value = "-"
                                }
                            }

                        }


                        //수업 타입
                        unit_class_type = get_unit_info_JSONObject.getString("unit_class_type")

                        //수업 그룹 네임
                        unit_class_group_name = get_unit_info_JSONObject.getString("unit_group_name")


                        //콘텐츠 리스트
                        content_code_list = get_unit_info_JSONObject.getString("content_code_list")

                        if(!get_unit_info_JSONObject.isNull("unit_youtube_url"))
                        {
                        var unit_youtube_url_JSONArray = JSONArray(get_unit_info_JSONObject.getString("unit_youtube_url"))


                            for (i in 0 until unit_youtube_url_JSONArray.length()) {


                                var youtube_url_object = unit_youtube_url_JSONArray.getJSONObject(i)

                                var youtube_link_str = youtube_url_object.getString("link")
                                var youtube_title_str = youtube_url_object.getString("title")


                                classUnitYoutubeItem.add(class_unit_youtube_Item(youtube_link_str))
                            }
                        }
                        else
                        {
                            class_unit_youtube_imageview.setImageResource(R.drawable.unit_down_arrow_gray_button)
                            class_youtube_open_value = true
                            start_check_value()
                        }

                        classUnitYoutubeAdapter.notifyDataSetChanged()

                        if(!get_unit_info_JSONObject.isNull("unit_content_url")) {
                        var unit_content_url_JSONArray = JSONArray(get_unit_info_JSONObject.getString("unit_content_url"))



                            for (i in 0 until unit_content_url_JSONArray.length()) {
                                var unit_content_url_object = unit_content_url_JSONArray.getJSONObject(i)

                                var unit_content_link_str = unit_content_url_object.getString("link")
                                var unit_content_title_str = unit_content_url_object.getString("title")


                                classUnitLinkItem.add(class_unit_link_Item(unit_content_title_str, unit_content_link_str))
                            }
                        }
                        else
                        {
                            class_unit_link_imageview.setImageResource(R.drawable.unit_down_arrow_gray_button)
                            class_link_open_value = true
                            start_check_value()
                        }

                        classUnitLinkAdapter.notifyDataSetChanged()

                        if(!get_unit_info_JSONObject.isNull("unit_attached_file")){

                        var unit_attached_file_JSONArray = JSONArray(get_unit_info_JSONObject.getString("unit_attached_file"))

                        for(i in 0 until unit_attached_file_JSONArray.length())
                        {
                            boardFileItem.add(board_file_Item("첨부자료 "+(i+1).toString(),unit_attached_file_JSONArray.get(i).toString()))
                        }

                        }
                        else
                        {

                            class_unit_file_imageview.setImageResource(R.drawable.unit_down_arrow_gray_button)
                            class_file_open_value = true
                            start_check_value()
                        }
                        boardFileAdapter.notifyDataSetChanged()


                    }
                    //실패 시
                    else
                    {
                        custom_toast(this@class_unit_Activity, "인터넷 연결 상태를 확인해주세요.")

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

    //클래스 수업 참여 확인하기
    fun student_update_participation(class_code: String, unit_class_code: String, unit_class_type : String, unit_group_name:String)
    {
        serverConnection!!.student_update_participation(student_id, access_token, class_code, unit_class_code, student_number, unit_class_type, unit_group_name).enqueue(object : Callback<ResponseBody>
        {
            override fun onResponse(call: Call<ResponseBody>, response: Response<ResponseBody>)
            {
                try {


                    val result = JSONObject(response.body()!!.string())

                    Log.d("결과", "onResponse:"+result)

                    var i : Iterator<String>
                    i =  result.keys()

                    //Log.d("결과", "onResponse:"+result)
                    if(!i.next().equals("fail"))
                    {
                        //토큰 갱신
                        access_token = result.getString("student_token")

                        save_SharedPreferences.save_shard(this@class_unit_Activity, access_token)

                        //수업현황 최초 생성하기
                        create_student_class_record(class_code, unit_class_code)



                    }
                    //실패 시
                    else
                    {
                        //custom_toast(this@class_unit_Activity, "인터넷 연결 상태를 확인해주세요.")
                        var fail_result_value = result.getString("fail")
                        Log.d("확인점", "onResponse: "+fail_result_value)
                        if(fail_result_value.equals("already_exist"))
                        {
                            //토큰 갱신
                            //access_token = result.getString("student_token")

                            //save_SharedPreferences.save_shard(this@class_unit_Activity, access_token)

                            //수업현황 최초 생성하기
                            create_student_class_record(class_code, unit_class_code)

                        }
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

    //수업 현황 최초 생성
    fun create_student_class_record(class_code: String, unit_class_code: String)
    {

        serverConnection!!.create_student_class_record(student_id, access_token, class_code, unit_class_code, student_name, student_level, student_class, student_number,"1", content_test_value).enqueue(object : Callback<ResponseBody>
        {
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
                       // access_token = result.getString("student_token")
                        //save_SharedPreferences.save_shard(this@class_unit_Activity, access_token)

                        var jsonArray_content_code_list = JSONArray(content_code_list)

                        var class_ArrayList = ArrayList<String>()

                        for(i in 0 until jsonArray_content_code_list.length())
                        {
                            var jsonObject_content_name = jsonArray_content_code_list.getJSONObject(i)
                            var name_type = jsonObject_content_name.getString("content_name")

                            class_ArrayList.add(name_type)
                        }

                        //2021-03-07 변경 전
                        //if(jsonArray_content_code_list.length()==1&&name_type.equals("수업(이론)"))
                        //변경 후
                        if(!class_ArrayList.contains("실습수업")&&!class_ArrayList.contains("평가수업"))
                        {
                            custom_toast(this@class_unit_Activity, "이론 수업만 있는 단원입니다.\n 수업 참석이 완료되었습니다.")
                        }
                        else {

                            val intent = Intent(this@class_unit_Activity, class_detail_unit_Activity::class.java)

                            intent.putExtra("class_title", class_unit_title_textview.text.toString())
                            intent.putExtra("class_code", class_code)
                            intent.putExtra("unit_class_code", unit_class_code)
                            intent.putExtra("unit_class_type", unit_class_type)
                            intent.putExtra("unit_class_group_name", unit_class_group_name)
                            intent.putExtra("content_code_list", content_code_list)
                            intent.putExtra("class_home_work_value", class_unit_content_home_work_value.text.toString())
                            intent.putExtra("class_test_value", class_unit_content_test_value.text.toString())
                            intent.putExtra("class_unit_date", class_unit_date_textview.text.toString())

                            startActivity(intent)
                            overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)
                        }

                    }
                    //실패 시
                    else
                    {

                        var fail_result_value = result.getString("fail")

                        if(fail_result_value.equals("overlap_record"))
                        {
                            //토큰 갱신
                            //access_token = result.getString("student_token")
                            //save_SharedPreferences.save_shard(this@class_unit_Activity, access_token)
                            var jsonArray_content_code_list = JSONArray(content_code_list)

                            var class_ArrayList = ArrayList<String>()

                            for(i in 0 until jsonArray_content_code_list.length())
                            {
                                var jsonObject_content_name = jsonArray_content_code_list.getJSONObject(i)
                                var name_type = jsonObject_content_name.getString("content_name")

                                class_ArrayList.add(name_type)
                            }

                            //2021-03-07 변경 전
                            //if(jsonArray_content_code_list.length()==1&&name_type.equals("수업(이론)"))
                            //변경 후
                            if(!class_ArrayList.contains("실습수업")&&!class_ArrayList.contains("평가수업"))
                            {
                                custom_toast(this@class_unit_Activity, "이론 수업만 있는 단원입니다.\n 수업 참석이 완료되었습니다.")
                            }
                            else {

                                val intent = Intent(this@class_unit_Activity, class_detail_unit_Activity::class.java)
                                intent.putExtra("class_title", class_unit_title_textview.text.toString())
                                intent.putExtra("class_code", class_code)
                                intent.putExtra("unit_class_code", unit_class_code)
                                intent.putExtra("unit_class_type", unit_class_type)
                                intent.putExtra("unit_class_group_name", unit_class_group_name)
                                intent.putExtra("content_code_list", content_code_list)
                                intent.putExtra("class_home_work_value", class_unit_content_home_work_value.text.toString())
                                intent.putExtra("class_test_value", class_unit_content_test_value.text.toString())
                                intent.putExtra("class_unit_date", class_unit_date_textview.text.toString())

                                startActivity(intent)
                                overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)
                            }

                        }
                        //custom_toast(this@class_unit_Activity, "인터넷 연결 상태를 확인해주세요.")

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


    fun start_check_value()
    {
        if(class_file_open_value&&class_youtube_open_value&&class_link_open_value)
        {
            class_unit_start_button_textview.setBackgroundColor(Color.parseColor("#3378fd"))

        }
        else
        {
            class_unit_start_button_textview.setBackgroundColor(Color.parseColor("#9f9f9f"))
        }

    }
}