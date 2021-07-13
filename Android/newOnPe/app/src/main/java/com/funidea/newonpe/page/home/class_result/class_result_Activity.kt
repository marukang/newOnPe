package com.funidea.newonpe.page.home.class_result

import android.graphics.Color
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.view.View
import com.funidea.utils.CustomToast.Companion.show
import com.funidea.utils.save_SharedPreferences
import com.funidea.utils.set_User_info.Companion.access_token
import com.funidea.utils.set_User_info.Companion.student_id
import com.funidea.newonpe.R
import com.funidea.newonpe.page.login.SplashActivity.Companion.serverConnection
import kotlinx.android.synthetic.main.activity_class_result.class_result_recyclerview
import kotlinx.android.synthetic.main.activity_class_result_test.*
import okhttp3.ResponseBody
import org.json.JSONArray
import org.json.JSONException
import org.json.JSONObject
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.io.IOException

/** 내가 참여한 차시별(단원별) 클래스의 운동 기록을 확인 할 수 있는 페이지
 *
 * 차시별 클래스에서 진행한 운동 콘텐츠에 대한 운동 기록을 보여주는 페이지입니다.
 *
 * 운동 종류, 운동명, 운동시간, 운동 횟수 등을 확인할 수 있습니다.
 *
 */

class class_result_Activity : AppCompatActivity() {

    //상단 출석여부 및 수업 현황 보여주는 recyclerview Item
    lateinit var classResultStateAdapter: class_result_state_Adapter
    var classResultStateItem = ArrayList<class_result_state_Item>()

    //결과 페이지 하단 결과를 보여주는 recyclerview Item
    lateinit var classResultJsonarrayAdapter: class_result_JSONArray_Adapter
    var classResultJsonarrayItem = ArrayList<class_result_JSONArray_Item>()


    //lateinit var selfClassResultAdapter: self_class_result_Adapter

    //var practice_ResultItem = ArrayList<self_class_result_Item>()
    //var selfClassResultItem = ArrayList<self_class_result_Item>()

    var class_code : String = ""
    var class_unit_code : String = ""
    var class_title : String = ""

    var class_practice_JSONArray  = JSONArray()
    var evaluation_practice_JSONArray = JSONArray()
    var task_practice_JSONArray = JSONArray()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_class_result_test)

        var get_intent = intent

        class_code = get_intent.getStringExtra("class_code").toString()
        class_unit_code = get_intent.getStringExtra("unit_code").toString()
        class_title = get_intent.getStringExtra("class_title").toString()

        get_unit_class(class_code,class_unit_code)


        class_result_title_textview.setText(class_title)

        classResultJsonarrayAdapter = class_result_JSONArray_Adapter(this, classResultJsonarrayItem)

        class_result_recyclerview.adapter = classResultJsonarrayAdapter
        get_student_class_record(class_code, class_unit_code)

        //뒤로가기 버튼
        class_result_back_button.setOnClickListener(back_button)

        //실습기록 보기 버튼
        class_result_practice_textview.setOnClickListener(get_practice_Array_button)
        //과제기록 보기 버튼
        class_result_task_practice_textview.setOnClickListener(get_task_practice_Array_button)
        //평과기록 보기 버튼
        class_result_evaluation_practice_textview.setOnClickListener(get_evaluation_practice_Array_button)
        //다시하기 버튼
        class_result_again_button_textview.setOnClickListener(again_button)
        //완료하기 버튼
        class_result_confirm_button_textview.setOnClickListener(confirm_button)


        //상단 결과
        classResultStateItem.add(class_result_state_Item("출석", "Y"))
        classResultStateAdapter = class_result_state_Adapter(this, classResultStateItem)
        class_result_state_recyclerview.adapter = classResultStateAdapter

    }

    //실습 기록 가져오기
    val get_practice_Array_button = View.OnClickListener {

        class_result_practice_textview.setTextColor(Color.parseColor("#3378fd"))
        class_result_task_practice_textview.setTextColor(Color.parseColor("#9f9f9f"))
        class_result_evaluation_practice_textview.setTextColor(Color.parseColor("#9f9f9f"))
        classResultJsonarrayItem.clear()
        classResultJsonarrayAdapter.notifyDataSetChanged()
        //실습 기록
        get_class_practice_Array(class_practice_JSONArray)
    }
    //과제 기록 가져오기
    val get_task_practice_Array_button = View.OnClickListener {
        class_result_practice_textview.setTextColor(Color.parseColor("#9f9f9f"))
        class_result_task_practice_textview.setTextColor(Color.parseColor("#3378fd"))
        class_result_evaluation_practice_textview.setTextColor(Color.parseColor("#9f9f9f"))
        classResultJsonarrayItem.clear()
        classResultJsonarrayAdapter.notifyDataSetChanged()
        //과제 기록
        get_task_practice_Array(task_practice_JSONArray)
    }

    //평가 기록 가져오기
    val get_evaluation_practice_Array_button = View.OnClickListener {
        class_result_practice_textview.setTextColor(Color.parseColor("#9f9f9f"))
        class_result_task_practice_textview.setTextColor(Color.parseColor("#9f9f9f"))
        class_result_evaluation_practice_textview.setTextColor(Color.parseColor("#3378fd"))
        classResultJsonarrayItem.clear()
        classResultJsonarrayAdapter.notifyDataSetChanged()

        //평가 기록
        get_evaluation_practice_Array(evaluation_practice_JSONArray)
    }

    //재도전 하기
    val again_button = View.OnClickListener {

    }
    //완료하기 버튼
    val confirm_button = View.OnClickListener {

        //make_json_array(selfClassResultItem)

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

  /*  //기록하기
    fun update_student_record_class_practice(class_code : String, class_unit_code : String, class_practice: String)
    {
        serverConnection!!.update_student_record_class_practice(student_id,access_token, class_code, class_unit_code, class_practice).enqueue(object : Callback<ResponseBody> {
            override fun onResponse(call: Call<ResponseBody>, response: Response<ResponseBody>)
            {
                try {
                    val result = JSONObject(response.body()!!.string())

                    var i : Iterator<String>
                    i =  result.keys()

                    //Log.d("결과", "onResponse:"+result)
                    if(!i.next().equals("fail"))
                    {

                        Log.d("결과", "onResponse:"+result)
                        //토큰 갱신
                        access_token = result.getString("student_token")

                        save_SharedPreferences.save_shard(this@class_result_Activity, access_token)



                    }
                    //실패 시
                    else
                    {
                        Custom_Toast.custom_toast(this@class_result_Activity, "인터넷 연결 상태를 확인해주세요.")

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
    }*/


    //결과 기록 가져오기
    fun get_student_class_record(class_code : String, class_unit_code : String)
    {
        serverConnection!!.get_student_class_record(student_id,access_token, class_code, class_unit_code).enqueue(object : Callback<ResponseBody> {
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

                        save_SharedPreferences.save_shard(this@class_result_Activity, access_token)


                        var class_result_score_list = result.getString("success")

                        var class_result_score_JOSNObject = JSONObject(class_result_score_list)


                        if(!class_result_score_JOSNObject.isNull("class_practice")) class_practice_JSONArray =  JSONArray(class_result_score_JOSNObject.getString("class_practice"))
                        if(!class_result_score_JOSNObject.isNull("task_practice")) task_practice_JSONArray = JSONArray(class_result_score_JOSNObject.getString("task_practice"))
                        if(!class_result_score_JOSNObject.isNull("evaluation_practice"))  evaluation_practice_JSONArray = JSONArray(class_result_score_JOSNObject.getString("evaluation_practice"))



                        get_class_practice_Array(class_practice_JSONArray)

                    }
                    //실패 시
                    else
                    {
                        show(this@class_result_Activity, "인터넷 연결 상태를 확인해주세요.")

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

    //실습 기록 가져오기
    fun get_class_practice_Array(get_class_practice_JSONArray : JSONArray)
    {
        if(get_class_practice_JSONArray.length()!=0) {

            for (i in 0 until get_class_practice_JSONArray.length()) {

                if(get_class_practice_JSONArray.getJSONArray(i).length()!=0) {

                    var get_json_array = get_class_practice_JSONArray.getJSONArray(i)

                    var class_practice_JSONObject = get_json_array.getJSONObject(i)

                    var content_title = class_practice_JSONObject.getString("content_title")

                    classResultJsonarrayItem.add(class_result_JSONArray_Item(content_title, get_json_array))
                }
            }

            classResultJsonarrayAdapter.notifyDataSetChanged()
        }
        else
        {
            show(this, "실습 기록이 없습니다.")
        }
    }
    //평가 기록 가져오기
    fun get_evaluation_practice_Array(get_class_evaluation_practice_JSONArray : JSONArray)
    {

        if(get_class_evaluation_practice_JSONArray.length()!=0){

        for(i in 0 until get_class_evaluation_practice_JSONArray.length())
        {
            if(get_class_evaluation_practice_JSONArray.getJSONArray(i).length()!=0) {

            try {

                var get_json_array = get_class_evaluation_practice_JSONArray.getJSONArray(i)

                var class_practice_JSONObject = get_json_array.getJSONObject(i)

                var content_title = class_practice_JSONObject.getString("content_title")

                classResultJsonarrayItem.add(class_result_JSONArray_Item(content_title, get_json_array))
            }
            catch (j : JSONException)
            {

            }
            }

        }

        classResultJsonarrayAdapter.notifyDataSetChanged()
        }
        else
        {
            show(this, "평가 기록이 없습니다.")
        }
    }
    //과제 기록 가져오기
    fun get_task_practice_Array(get_class_task_practice_JSONArray : JSONArray)
    {

        if(get_class_task_practice_JSONArray.length()!=0){
        for(i in 0 until get_class_task_practice_JSONArray.length())
        {

            if(get_class_task_practice_JSONArray.getJSONArray(i).length()!=0) {

            var get_json_array = get_class_task_practice_JSONArray.getJSONArray(i)

            var class_practice_JSONObject = get_json_array.getJSONObject(i)

            var content_title = class_practice_JSONObject.getString("content_title")

            classResultJsonarrayItem.add(class_result_JSONArray_Item(content_title, get_json_array))

            }
        }

        classResultJsonarrayAdapter.notifyDataSetChanged()
        }
        else
        {
            show(this, "과제 기록이 없습니다.")
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


                    if(!i.next().equals("fail"))
                    {
                        Log.d("student_get_curriculum", "onResponse:"+result)

                        //토큰 갱신
                        access_token = result.getString("student_token")

                        save_SharedPreferences.save_shard(this@class_result_Activity, access_token)


                        var class_unit_info_JSONArray : JSONArray

                        class_unit_info_JSONArray = result.getJSONArray("success")


                        var content_code_list = class_unit_info_JSONArray.get(0).toString()

                        var set_JSONObject = JSONObject(content_code_list)

                        var content_code_list_JSONArray = JSONArray(set_JSONObject.getString("content_code_list"))

                        for(i in 0 until content_code_list_JSONArray.length())
                        {
                          var class_value = JSONObject(content_code_list_JSONArray.get(i).toString()).getString("content_name").toString()

                            classResultStateItem.add(class_result_state_Item(class_value, "Y"))
                        }

                        classResultStateAdapter.notifyDataSetChanged()


                    }
                    //실패 시
                    else
                    {
                        show(this@class_result_Activity, "수업 정보를 가져오지 못했습니다. 인터넷 연결 상태를 다시 확인해주세요.")

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