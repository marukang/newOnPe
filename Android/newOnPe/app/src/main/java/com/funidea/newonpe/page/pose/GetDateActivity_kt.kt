package com.funidea.newonpe.page.pose

import android.os.Bundle
import android.util.Log
import android.view.View
import androidx.appcompat.app.AppCompatActivity
import com.funidea.newonpe.R
import com.funidea.utils.CustomToast
import com.funidea.utils.SimpleSharedPreferences
import com.funidea.utils.set_User_info
import com.funidea.utils.set_User_info.Companion.access_token
import com.funidea.utils.set_User_info.Companion.class_unit_group_name
import com.funidea.utils.set_User_info.Companion.student_id
import com.funidea.utils.set_User_info.Companion.user_evaluation_JSONArray
import com.funidea.utils.set_User_info.Companion.user_practice_JSONArray
import com.funidea.utils.set_User_info.Companion.user_task_JSONArray
import com.funidea.newonpe.detector.Pose_ResultInformation
import com.funidea.newonpe.detector.ResultInformation
import com.funidea.newonpe.page.login.LoginPage.Companion.serverConnectionSpec
import kotlinx.android.synthetic.main.activity_getdata.*
import okhttp3.ResponseBody
import org.json.JSONArray
import org.json.JSONException
import org.json.JSONObject
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.io.IOException
import kotlin.collections.ArrayList

class GetDateActivity_kt : AppCompatActivity() {


    var content_title : String = ""
    var position_number : Int = 0
    var array_size : Int = 0
    var get_class_code : String =""
    var get_class_unit_code : String =""

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_getdata)

        val intent = intent
        val arrayList = intent.getSerializableExtra("pose_result_Array") as ArrayList<Pose_ResultInformation>?

        content_title = intent.getStringExtra("content_title").toString()
        position_number = intent.getIntExtra("position_number", 0)
        array_size = intent.getIntExtra("array_size", 0)

        get_class_code = intent.getStringExtra("class_code").toString()
        get_class_unit_code = intent.getStringExtra("unit_code").toString()

        set_JSONArray(arrayList!!)

        poseresult_textview.setText(ResultInformation.result_list.toString())
        getdate_confirm_button_textview.setOnClickListener(confirm_button)
    }

    val confirm_button = View.OnClickListener {

        finish()
        overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)
    }


    fun set_JSONArray(get_result_info : ArrayList<Pose_ResultInformation>)
    {
        var pose_result_JsonArray = JSONArray()

        var pose_user_time : Int =0

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


                pose_user_time = pose_user_time +  get_result_info.get(i).content_time.toInt()

                pose_result_JsonArray.put(jsonObject)

            }

        }

        Log.d("결과보기", "set_JSONArray:"+pose_user_time)

        //2021-03-07 수업에서 실습으로 변경
        if(content_title.contains("실습"))
        {
            Log.d("결과보기(수업)전", "set_JSONArray: "+user_practice_JSONArray.toString())
            user_practice_JSONArray.put(position_number, pose_result_JsonArray)
            Log.d("결과보기(수업)후", "set_JSONArray: "+user_practice_JSONArray.toString())
            update_student_record_class_practice(get_class_code,get_class_unit_code, user_practice_JSONArray.toString(), pose_user_time.toString())
        }
        else if(content_title.contains("과제"))
        {
            Log.d("결과보기(과제)전", "set_JSONArray: "+user_task_JSONArray.toString())
            user_task_JSONArray.put(position_number, pose_result_JsonArray)
            Log.d("결과보기(과제)후", "set_JSONArray: "+user_task_JSONArray.toString())
            update_student_record_task_practice(get_class_code,get_class_unit_code, user_task_JSONArray.toString(),pose_user_time.toString())

        }
        else if(content_title.contains("평가"))
        {
            Log.d("결과보기(평가)전", "set_JSONArray: "+user_evaluation_JSONArray.toString())
            user_evaluation_JSONArray.put(position_number, pose_result_JsonArray)
            Log.d("결과보기(평가)전", "set_JSONArray: "+user_evaluation_JSONArray.toString())
            update_student_record_evaluation_practice(get_class_code,get_class_unit_code, user_evaluation_JSONArray.toString(),pose_user_time.toString())
        }

    }

    //수업 기록하기
    fun update_student_record_class_practice(class_code : String, class_unit_code : String, class_practice: String, class_content_use_time : String)
    {
        serverConnectionSpec!!.update_student_record_class_practice(student_id, access_token, class_code, class_unit_code, class_practice, class_content_use_time, class_unit_group_name).enqueue(object : Callback<ResponseBody> {
            override fun onResponse(call: Call<ResponseBody>, response: Response<ResponseBody>)
            {
                try
                {
                    val result = JSONObject(response.body()!!.string())

                    var i : Iterator<String>
                    i =  result.keys()

                    Log.d("결과", "onResponse:"+result)
                    if(!i.next().equals("fail"))
                    {

                        Log.d("결과", "onResponse:"+result)
                        //토큰 갱신
                        set_User_info.access_token = result.getString("student_token")

                        SimpleSharedPreferences.saveAccessToken(this@GetDateActivity_kt, set_User_info.access_token)



                    }
                    //실패 시
                    else
                    {
                        CustomToast.show(this@GetDateActivity_kt, "인터넷 연결 상태를 확인해주세요.")

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
    //과제 기록하기
    fun update_student_record_task_practice(class_code : String, class_unit_code : String, class_practice: String, class_content_use_time : String)
    {
        serverConnectionSpec!!.update_student_record_task_practice(student_id, access_token, class_code, class_unit_code, class_practice, class_content_use_time, class_unit_group_name).enqueue(object : Callback<ResponseBody> {
            override fun onResponse(call: Call<ResponseBody>, response: Response<ResponseBody>)
            {
                try {
                    val result = JSONObject(response.body()!!.string())

                    var i : Iterator<String>
                    i =  result.keys()

                    Log.d("결과", "onResponse:"+result)
                    if(!i.next().equals("fail"))
                    {

                        Log.d("결과", "onResponse:"+result)
                        //토큰 갱신
                        set_User_info.access_token = result.getString("student_token")

                        SimpleSharedPreferences.saveAccessToken(this@GetDateActivity_kt, set_User_info.access_token)



                    }
                    //실패 시
                    else
                    {
                        CustomToast.show(this@GetDateActivity_kt, "인터넷 연결 상태를 확인해주세요.")

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
    //평가 기록하기
    fun update_student_record_evaluation_practice(class_code : String, class_unit_code : String, class_practice: String, class_content_use_time : String)
    {
        serverConnectionSpec!!.update_student_record_evaluation_practice(student_id, access_token, class_code, class_unit_code, class_practice, class_content_use_time, class_unit_group_name).enqueue(object : Callback<ResponseBody> {
            override fun onResponse(call: Call<ResponseBody>, response: Response<ResponseBody>)
            {
                try {
                    val result = JSONObject(response.body()!!.string())

                    var i : Iterator<String>
                    i =  result.keys()

                    Log.d("결과", "onResponse:"+result)
                    if(!i.next().equals("fail"))
                    {

                        //Log.d("결과", "onResponse:"+result)
                        //토큰 갱신
                        access_token = result.getString("student_token")

                        SimpleSharedPreferences.saveAccessToken(this@GetDateActivity_kt, access_token)



                    }
                    //실패 시
                    else
                    {
                        CustomToast.show(this@GetDateActivity_kt, "인터넷 연결 상태를 확인해주세요.")
                    }

                }
                catch (e: JSONException)
                {
                    e.printStackTrace()
                }
                catch (e: IOException)
                {
                    e.printStackTrace()
                }
            }

            override fun onFailure(call: Call<ResponseBody>, t: Throwable)
            {
                Log.d("실패", "onResponse: "+t)
                Log.d("실패", "onResponse: "+call)
            }
        })
    }
    override fun onPause() {
        super.onPause()
        ResultInformation.result_list.clear()
    }
}
