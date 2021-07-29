package com.funidea.newonpe.page.main

import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.view.View
import androidx.appcompat.app.AppCompatActivity
import com.funidea.newonpe.R
import com.funidea.utils.CustomToast
import com.funidea.utils.SimpleSharedPreferences
import com.funidea.utils.set_User_info
import com.funidea.newonpe.page.home.class_result.class_result_JSONArray_Adapter
import com.funidea.newonpe.page.home.class_result.class_result_JSONArray_Item
import com.funidea.newonpe.page.home.class_result.class_result_state_Adapter
import com.funidea.newonpe.page.home.class_result.class_result_state_Item
import com.funidea.newonpe.detector.Pose_ResultInformation
import com.funidea.newonpe.page.login.LoginPage.Companion.serverConnectionSpec
import com.funidea.newonpe.page.pose.GetDateActivity_kt
import com.funidea.newonpe.page.pose.PoseActivity
import kotlinx.android.synthetic.main.activity_complete_exercise_record.*
import okhttp3.ResponseBody
import org.json.JSONArray
import org.json.JSONException
import org.json.JSONObject
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.io.IOException

class ExerciseRecordPage : AppCompatActivity() {

    //완료한 운동 기록을 확인하는 Page

    var class_code : String = ""
    var class_unit_code : String = ""
    var class_title : String = ""
    var arrayList = ArrayList<Pose_ResultInformation>()
    var position_number : Int = 0
    var array_size : Int = 0
    var content_title : String = ""

    var content_name_list : String = ""
    var content_cateogry_list : String = ""
    var content_type_list : String = ""
    var content_detail_name_list : String = ""
    var content_count_list : String = ""
    var content_time : String = ""
    var content_url : String = ""
    var content_level_list : String = ""
    var evaluation_value : String = ""

    //상단 출석여부 및 수업 현황 보여주는 recyclerview Item
    lateinit var classResultStateAdapter: class_result_state_Adapter
    var classResultStateItem_for_record = ArrayList<class_result_state_Item>()

    //결과 페이지 하단 결과를 보여주는 recyclerview Item
    lateinit var classResultJsonarrayAdapter: class_result_JSONArray_Adapter
    var classResultJsonarrayItem_for_record = ArrayList<class_result_JSONArray_Item>()


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_complete_exercise_record)


        var get_intent = intent
        evaluation_value = get_intent.getStringExtra("evaluation_value").toString()
        class_code = get_intent.getStringExtra("class_code").toString()
        class_unit_code = get_intent.getStringExtra("unit_code").toString()
        class_title = get_intent.getStringExtra("class_title").toString()
        arrayList = (intent.getSerializableExtra("pose_result_Array") as ArrayList<Pose_ResultInformation>?)!!
        position_number = intent.getIntExtra("position_number", 0)
        array_size = intent.getIntExtra("array_size", 0)
        content_title = intent.getStringExtra("content_title").toString()

        content_name_list = intent.getStringExtra("content_name_list").toString()
        content_cateogry_list = intent.getStringExtra("content_cateogry_list").toString()
        content_type_list = intent.getStringExtra("content_type_list").toString()
        content_detail_name_list = intent.getStringExtra("content_detail_name_list").toString()
        content_count_list = intent.getStringExtra("content_count_list").toString()
        content_time = intent.getStringExtra("content_time").toString()
        content_url = intent.getStringExtra("content_url").toString()
        content_level_list = intent.getStringExtra("content_level_list").toString()





        //타이틀
        complete_exercise_title_textview.setText(class_title);

        //상단 결과
        classResultStateItem_for_record.add(class_result_state_Item("출석", "Y"))
        classResultStateAdapter = class_result_state_Adapter(this, classResultStateItem_for_record)
        complete_exercise_state_recyclerview.adapter = classResultStateAdapter

        
        //하단 결과
        classResultJsonarrayAdapter = class_result_JSONArray_Adapter(this, classResultJsonarrayItem_for_record)
        complete_exercise_recyclerview.adapter = classResultJsonarrayAdapter

        //뒤로가기버튼
        complete_exercise_back_button.setOnClickListener(back_button)




        complete_exercise_confirm_button_textview.setOnClickListener(complete_exercise)

        complete_exercise_again_button_textview.setOnClickListener(again_exercise)

        if(classResultJsonarrayItem_for_record.size!=0)
        {
            classResultJsonarrayItem_for_record.clear()
        }
        if(classResultStateItem_for_record.size!=0)
        {
            classResultStateItem_for_record.clear()
        }

        //상단 출석정보 가져오기
        get_unit_class(class_code,class_unit_code)
        //하단 결과 가져오기
        set_JSONArray(arrayList)


    }
    //운동완료
    val complete_exercise = View.OnClickListener {

        val intent = Intent(this, GetDateActivity_kt::class.java)


        intent.putExtra("class_code", class_code)
        intent.putExtra("unit_code", class_unit_code)
        intent.putExtra("pose_result_Array", arrayList)
        intent.putExtra("content_title", content_title)
        intent.putExtra("position_number", position_number)
        intent.putExtra("array_size", array_size)

        startActivity(intent)
        finish()
        overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)

    }

    //운동다시하기
    val again_exercise = View.OnClickListener {

        val intent = Intent(this, PoseActivity::class.java)
        intent.putExtra("evaluation_value", evaluation_value)
        intent.putExtra("class_code", class_code)
        intent.putExtra("unit_code", class_unit_code)
        intent.putExtra("class_title", class_title)
        intent.putExtra("array_size", array_size)
        intent.putExtra("position_number", position_number)
        intent.putExtra("content_title", content_title)

        intent.putExtra("content_name_list", content_name_list)
        intent.putExtra("content_cateogry_list", content_cateogry_list)
        intent.putExtra("content_type_list", content_type_list)
        intent.putExtra("content_detail_name_list", content_detail_name_list)
        intent.putExtra("content_count_list", content_count_list)
        intent.putExtra("content_time", content_time)
        intent.putExtra("content_url", content_url)
        intent.putExtra("content_level_list", content_level_list)

        startActivity(intent)
        finish()
        overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)

    }

    fun set_JSONArray(get_result_info : ArrayList<Pose_ResultInformation>)
    {
        var pose_result_JsonArray = JSONArray()

        if(get_result_info.size!=0)
        {
            for(i in get_result_info.indices)
            {

                var jsonObject = JSONObject()

                jsonObject.put("content_title", content_title)
                jsonObject.put("content_name", get_result_info.get(i).content_name)
                jsonObject.put("content_category", get_result_info.get(i).content_category)
                jsonObject.put("content_detail_name", get_result_info.get(i).content_detail_name)
                jsonObject.put("content_average_score", get_result_info.get(i).content_average_score)
                jsonObject.put("content_count", get_result_info.get(i).content_count)
                jsonObject.put("content_time", get_result_info.get(i).content_time)


                pose_result_JsonArray.put(jsonObject)

            }

            classResultJsonarrayItem_for_record.add(class_result_JSONArray_Item(content_title, pose_result_JsonArray))

        }

        classResultJsonarrayAdapter.notifyDataSetChanged()
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

    //클래스 정보 가져오기
    fun get_unit_class(class_code : String, unit_class_code : String)
    {
        serverConnectionSpec!!.student_get_curriculum(set_User_info.student_id, set_User_info.access_token, class_code, unit_class_code).enqueue(object : Callback<ResponseBody> {
            override fun onResponse(call: Call<ResponseBody>, response: Response<ResponseBody>)
            {
                try {
                    val result = JSONObject(response.body()!!.string())

                    var i : Iterator<String>
                    i =  result.keys()

                    //Log.d("결과", "onResponse:"+result)
                    if(!i.next().equals("fail"))
                    {
                        Log.d("student_get_curriculum", "onResponse:"+result)

                        //토큰 갱신
                        set_User_info.access_token = result.getString("student_token")

                        SimpleSharedPreferences.saveAccessToken(this@ExerciseRecordPage, set_User_info.access_token)


                        var class_unit_info_JSONArray : JSONArray

                        class_unit_info_JSONArray = result.getJSONArray("success")


                        var content_code_list = class_unit_info_JSONArray.get(0).toString()

                        var set_JSONObject = JSONObject(content_code_list)


                        var content_code_list_JSONArray = JSONArray(set_JSONObject.getString("content_code_list"))

                        for(i in 0 until content_code_list_JSONArray.length())
                        {
                            var class_value = JSONObject(content_code_list_JSONArray.get(i).toString()).getString("content_name").toString()

                            classResultStateItem_for_record.add(class_result_state_Item(class_value, "Y"))
                        }

                        classResultStateAdapter.notifyDataSetChanged()


                    }
                    //실패 시
                    else
                    {
                        CustomToast.show(this@ExerciseRecordPage, "수업 정보를 가져오지 못했습니다. 인터넷 연결 상태를 다시 확인해주세요.")
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