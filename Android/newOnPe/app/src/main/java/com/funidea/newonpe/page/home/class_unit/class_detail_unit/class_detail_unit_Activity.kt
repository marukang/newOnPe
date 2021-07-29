package com.funidea.newonpe.page.home.class_unit.class_detail_unit

import android.app.AlertDialog
import android.content.Context
import android.content.Intent
import android.graphics.Color
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.view.View
import com.funidea.utils.CustomToast
import com.funidea.utils.CustomToast.Companion.show
import com.funidea.utils.SimpleSharedPreferences
import com.funidea.utils.set_User_info
import com.funidea.utils.set_User_info.Companion.access_token
import com.funidea.utils.set_User_info.Companion.class_unit_group_name
import com.funidea.utils.set_User_info.Companion.student_id
import com.funidea.utils.set_User_info.Companion.student_number
import com.funidea.utils.set_User_info.Companion.user_evaluation_JSONArray
import com.funidea.utils.set_User_info.Companion.user_practice_JSONArray
import com.funidea.utils.set_User_info.Companion.user_task_JSONArray
import com.funidea.utils.side_menu_layout
import com.funidea.newonpe.dialog.NotifyExerciseStartDialog
import com.funidea.newonpe.page.pose.PoseActivity
import com.funidea.newonpe.R
import com.funidea.newonpe.page.home.class_result.class_result_Activity
import com.funidea.newonpe.page.message.class_message_Activity
import com.funidea.newonpe.page.login.LoginPage.Companion.serverConnectionSpec
import com.google.android.material.bottomsheet.BottomSheetBehavior
import kotlinx.android.synthetic.main.activity_class_detail_unit.*
import okhttp3.ResponseBody
import org.json.JSONArray
import org.json.JSONException
import org.json.JSONObject
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.io.IOException

/** 차시별 클래스의 실습,평가,이론 등의 콘텐츠 List를 보여주는 Class
 *
 *  해당 화면에서는 차시별 수업의 Content 를 확인하고  해당 Content에서 원하는
 *
 *  평가수업 혹은 실습수업 을 선택해서 운동을 진행할 할 수 있으며,
 *
 *  자신이 진행한 운동에 대한 결과를 확인할 수 있습니다.
 *
 */

class class_detail_unit_Activity : AppCompatActivity() {


    lateinit var classDetailUnitClassListAdapter: class_detail_unit_class_list_Adapter
    var classDetailUnitClassListItem = ArrayList<class_detail_unit_class_list_Item>()

    var class_code : String = ""
    var unit_class_code : String = ""
    var unit_class_type : String = ""
    var unit_class_group_name : String = ""
    var content_code_list : String =""
    var class_tilte : String = ""


    var evaluation_value : Boolean = false
    var task_value : Boolean = false
    var class_value : Boolean = false

    var practice_array = ArrayList<class_unit_numbering_Array>()
    var task_array = ArrayList<class_unit_numbering_Array>()
    var evaluation_array = ArrayList<class_unit_numbering_Array>()

    var practice_Int : Int = 0
    var task_Int : Int = 0
    var evaluation_Int : Int = 0

    var student_practice_value : Int = 0

    var student_evaluation_submit_possible_value : Int = 0

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_class_detail_unit)


        var get_intent = intent
        class_tilte = get_intent.getStringExtra("class_title").toString()
        class_code = get_intent.getStringExtra("class_code").toString()
        unit_class_code = get_intent.getStringExtra("unit_class_code").toString()

        unit_class_type = get_intent.getStringExtra("unit_class_type").toString()
        unit_class_group_name = get_intent.getStringExtra("unit_class_group_name").toString()
        content_code_list = get_intent.getStringExtra("content_code_list").toString()

        var class_homework_value = get_intent.getStringExtra("class_home_work_value").toString()
        var class_test_value = get_intent.getStringExtra("class_test_value").toString()
        var class_unit_date = get_intent.getStringExtra("class_unit_date").toString()



        //과제 여부
        class_detail_unit_homework_value_textview.setText(class_homework_value)
        //평가 여부
        class_detail_unit_test_value_textview.setText(class_test_value)
        //클래스 기간
        class_detail_unit_date_textview.setText(class_unit_date)

        var jsonArray_content_code_list = JSONArray(content_code_list)

        for( i in 0 until  jsonArray_content_code_list.length())
        {
            var jsonObject_content_name = jsonArray_content_code_list.getJSONObject(i)

            var name_type = jsonObject_content_name.getString("content_name")

            //변경 후
            if(name_type.contains("실습"))
            {
                    practice_Int = practice_Int + 1
                    practice_array.add(class_unit_numbering_Array(practice_Int, i, name_type))

            }
            else if(name_type.contains("과제"))
            {
                task_Int = task_Int+1
                task_array.add(class_unit_numbering_Array(task_Int, i, name_type))

            }
            else if(name_type.contains("평가"))
            {
                evaluation_Int = evaluation_Int+1
                evaluation_array.add(class_unit_numbering_Array(evaluation_Int, i, name_type))
                class_detail_unit_submit_button_textview.visibility = View.VISIBLE
            }


        }

        //수업명
        class_detail_unit_title_textview.setText(class_tilte)

        //사이드 메뉴 셋팅
        var v : View = side_menu_layout_class_detail_unit
        side_menu_layout.side_menu_setting_test(class_detail_unit_drawerlayout, v, this)
        //사이드 메뉴 버튼
        class_detail_unit_menu_button.setOnClickListener(side_menu_button)
        //뒤로 가기 버튼
        class_detail_unit_back_button.setOnClickListener(back_button)
        //최종 제출 버튼
        class_detail_unit_submit_button_textview.setOnClickListener(submit_button)
        //수업현황 버튼
        class_detail_unit_state_linearlayout.setOnClickListener(class_state_value)
        //결과보기 버튼
        class_detail_unit_show_result_button_textview.setOnClickListener(class_state_value)


        classDetailUnitClassListAdapter = class_detail_unit_class_list_Adapter(this, classDetailUnitClassListItem)
        class_detail_unit_recyclerview.adapter = classDetailUnitClassListAdapter
        classDetailUnitClassListAdapter.setonItemClickListener(object : class_detail_unit_class_list_Adapter.onItemClickListener
        {
            override fun item_click(position: Int)
            {

                val class_unit_info_shard = getSharedPreferences("class_unit_code", Context.MODE_PRIVATE)

                if(!class_unit_info_shard.contains(unit_class_code))
                {
                    val poseExerciseStartBottomDialog = NotifyExerciseStartDialog(this@class_detail_unit_Activity)

                    poseExerciseStartBottomDialog.behavior.state  = BottomSheetBehavior.STATE_EXPANDED

                    poseExerciseStartBottomDialog.show()

                    poseExerciseStartBottomDialog.setExerciseConfirmListener(object : NotifyExerciseStartDialog.ExerciseConfirmListener{
                        override fun select_confirm(select: String?) {

                            if(select.equals("1"))
                            {
                                val editor = class_unit_info_shard.edit()
                                editor.putString(unit_class_code, unit_class_code)
                                editor.commit()
                                poseExerciseStartBottomDialog.dismiss()

                                if(classDetailUnitClassListItem.get(position).class_unit_title.contains("평가"))
                                {

                                    val builder = AlertDialog.Builder(this@class_detail_unit_Activity)
                                    builder.setMessage("운동을 시작하시겠습니까?")
                                    builder.setPositiveButton("확인") { dialogInterface, i ->

                                        var content_title : String =""
                                        var position_number : Int = 0
                                        var array_size : Int = 0
                                        for(i in evaluation_array.indices)
                                        {
                                            if(evaluation_array.get(i).position_number.equals(position))
                                            {

                                                content_title = evaluation_array.get(i).title
                                                position_number = i
                                                array_size = evaluation_array.size
                                                break
                                            }

                                        }
                                        get_content_list(classDetailUnitClassListItem.get(position).class_content_code, content_title, position_number, array_size)
                                        dialogInterface.dismiss()
                                    }
                                    builder.setNegativeButton("취소") { dialogInterface, i ->
                                        dialogInterface.dismiss()
                                    }
                                    val dialog: AlertDialog = builder.create()
                                    dialog.show()

                                }
                                else if(classDetailUnitClassListItem.get(position).class_unit_title.contains("과제"))
                                {


                                    //평가 시작 문의
                                    val builder = AlertDialog.Builder(this@class_detail_unit_Activity)
                                    builder.setMessage("운동을 시작하시겠습니까?")
                                    builder.setPositiveButton("확인") { dialogInterface, i ->

                                        var content_title : String =""
                                        var position_number : Int = 0
                                        var array_size : Int = 0

                                        for(i in task_array.indices)
                                        {
                                            if(task_array.get(i).position_number.equals(position))
                                            {

                                                content_title = task_array.get(i).title
                                                position_number = i
                                                array_size = task_array.size
                                                break
                                            }

                                        }
                                        get_content_list(classDetailUnitClassListItem.get(position).class_content_code, content_title, position_number, array_size)
                                        dialogInterface.dismiss()
                                    }
                                    builder.setNegativeButton("취소") { dialogInterface, i ->
                                        dialogInterface.dismiss()
                                    }
                                    val dialog: AlertDialog = builder.create()
                                    dialog.show()



                                }
                                //2021-03-07 변겅전
                                //else if(classDetailUnitClassListItem.get(position).class_unit_title.contains("수업(실습)"))
                                //변경 후
                                else if(classDetailUnitClassListItem.get(position).class_unit_title.contains("실습"))
                                {
                                    val builder = AlertDialog.Builder(this@class_detail_unit_Activity)
                                    builder.setMessage("운동을 시작하시겠습니까?")
                                    builder.setPositiveButton("확인") { dialogInterface, i ->

                                        var content_title : String =""
                                        var position_number : Int = 0
                                        var array_size : Int = 0

                                        for(i in practice_array.indices)
                                        {
                                            if(practice_array.get(i).position_number.equals(position))
                                            {
                                                content_title = practice_array.get(i).title
                                                position_number = i
                                                array_size = practice_array.size
                                                break
                                            }

                                        }

                                        get_content_list(classDetailUnitClassListItem.get(position).class_content_code, content_title, position_number, array_size)

                                        dialogInterface.dismiss()
                                    }
                                    builder.setNegativeButton("취소") { dialogInterface, i ->
                                        dialogInterface.dismiss()
                                    }
                                    val dialog: AlertDialog = builder.create()
                                    dialog.show()


                                }
                                //2021-03-07 수정 전
                                //else if(classDetailUnitClassListItem.get(position).class_unit_title.contains("수업(이론)"))
                                //수정 후
                                else if(classDetailUnitClassListItem.get(position).class_unit_title.contains("이론"))
                                {
                                    show(this@class_detail_unit_Activity, "이론수업은 운동 콘텐츠가 있지 않습니다.")
                                }

                            }

                        }

                    })

                }
                else{


                if(classDetailUnitClassListItem.get(position).class_unit_title.contains("평가"))
                {
                    if(student_practice_value==0){
                    val builder = AlertDialog.Builder(this@class_detail_unit_Activity)
                    builder.setMessage("운동을 시작하시겠습니까?")
                    builder.setPositiveButton("확인") { dialogInterface, i ->

                        var content_title : String =""
                        var position_number : Int = 0
                        var array_size : Int = 0
                        for(i in evaluation_array.indices)
                        {
                            if(evaluation_array.get(i).position_number.equals(position))
                            {

                                content_title = evaluation_array.get(i).title
                                position_number = i
                                array_size = evaluation_array.size
                                break
                            }

                        }
                        get_content_list(classDetailUnitClassListItem.get(position).class_content_code, content_title, position_number, array_size)
                        dialogInterface.dismiss()
                    }
                    builder.setNegativeButton("취소") { dialogInterface, i ->
                        dialogInterface.dismiss()
                    }
                    val dialog: AlertDialog = builder.create()
                    dialog.show()
                    }
                    else
                    {
                        show(this@class_detail_unit_Activity, "최종 제출 완료 된 평가입니다.")
                    }

                }
                else if(classDetailUnitClassListItem.get(position).class_unit_title.contains("과제"))
                {


                   //평가 시작 문의
                        val builder = AlertDialog.Builder(this@class_detail_unit_Activity)
                        builder.setMessage("운동을 시작하시겠습니까?")
                        builder.setPositiveButton("확인") { dialogInterface, i ->

                            var content_title : String =""
                            var position_number : Int = 0
                            var array_size : Int = 0

                            for(i in task_array.indices)
                            {
                                if(task_array.get(i).position_number.equals(position))
                                {

                                    content_title = task_array.get(i).title
                                    position_number = i
                                    array_size = task_array.size
                                    break
                                }

                            }
                            get_content_list(classDetailUnitClassListItem.get(position).class_content_code, content_title, position_number, array_size)
                            dialogInterface.dismiss()
                        }
                        builder.setNegativeButton("취소") { dialogInterface, i ->
                            dialogInterface.dismiss()
                        }
                        val dialog: AlertDialog = builder.create()
                        dialog.show()



                }
                //2021-03-07 변경 전
                //else if(classDetailUnitClassListItem.get(position).class_unit_title.contains("수업"))
                //변경 후
                else if(classDetailUnitClassListItem.get(position).class_unit_title.contains("실습"))
                {
                    val builder = AlertDialog.Builder(this@class_detail_unit_Activity)
                    builder.setMessage("운동을 시작하시겠습니까?")
                    builder.setPositiveButton("확인") { dialogInterface, i ->

                        var content_title : String =""
                        var position_number : Int = 0
                        var array_size : Int = 0

                        for(i in practice_array.indices)
                        {
                            if(practice_array.get(i).position_number.equals(position))
                            {
                                content_title = practice_array.get(i).title
                                position_number = i
                                array_size = practice_array.size
                                break
                            }

                        }

                        get_content_list(classDetailUnitClassListItem.get(position).class_content_code, content_title, position_number, array_size)

                        dialogInterface.dismiss()
                    }
                    builder.setNegativeButton("취소") { dialogInterface, i ->
                        dialogInterface.dismiss()
                    }
                    val dialog: AlertDialog = builder.create()
                    dialog.show()


                }

                }


            }

            override fun state_click(position: Int) {


            }


        }
        )

        //메세지함 이동 버튼
        class_detail_unit_message_linearlayout.setOnClickListener(message_button)

    }

    override fun onResume() {
        super.onResume()

        if(classDetailUnitClassListItem.size!=0)
        {
            classDetailUnitClassListItem.clear()
            classDetailUnitClassListAdapter.notifyDataSetChanged()

        }

        //결과보기 가져오기
        get_student_class_record(class_code,unit_class_code)
    }

    //메세지함 이동
    val message_button = View.OnClickListener {

        val intent = Intent(this, class_message_Activity::class.java)

        startActivity(intent)

        overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)
    }




    val class_state_value = View.OnClickListener {

        val intent = Intent(this, class_result_Activity::class.java)
        intent.putExtra("class_title", class_tilte)
        intent.putExtra("unit_code", unit_class_code)
        intent.putExtra("class_code", class_code)
        startActivity(intent)

        overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)
    }

    //최종과제 제출하기
    val submit_button = View.OnClickListener {

        if(student_practice_value==1)
        {
            //custom_toast(this,"제출완료")

            val builder = AlertDialog.Builder(this)
            builder.setMessage("최종 제출 하셨습니다.\n(선생님이 요청한 방법으로 운동영상을 전송해주세요.)")
            builder.setPositiveButton("확인") { dialogInterface, i ->

                //서버로 삭제 안내 해주기
                //student_update_submit_task(class_code, unit_class_code, unit_class_type, unit_class_group_name)
                dialogInterface.dismiss()
            }

            val dialog: AlertDialog = builder.create()
            dialog.show()

        }
        else if(student_evaluation_submit_possible_value==1&&student_practice_value==0)
        {
            //정말 삭제하시겠습니까 라는 AlertDialog 생성
            val builder = AlertDialog.Builder(this)
            builder.setMessage("제출할 경우 더 이상 평가를 수정할 수 없습니다.\n최종 제출 하시겠습니까?")
            builder.setPositiveButton("확인") { dialogInterface, i ->

                //서버로 삭제 안내 해주기
                student_update_submit_task(class_code, unit_class_code, unit_class_type, unit_class_group_name)
                dialogInterface.dismiss()
            }
            builder.setNegativeButton("취소") { dialogInterface, i ->
                dialogInterface.dismiss()
            }
            val dialog: AlertDialog = builder.create()
            dialog.show()


        }
        else
        {

            val builder = AlertDialog.Builder(this)
            builder.setMessage("모든 평가를 진행 후 최종 제출 버튼을 눌러주세요.")
            builder.setPositiveButton("확인") { dialogInterface, i ->

                //서버로 삭제 안내 해주기
                student_update_submit_task(class_code, unit_class_code, unit_class_type, unit_class_group_name)
                dialogInterface.dismiss()
            }

            val dialog: AlertDialog = builder.create()
            dialog.show()

        }



    }

    //콘텐츠 리스트 셋팅
    fun set_content_code_list(content_code_list : String)
    {


        var content_code_JSONArray = JSONArray(content_code_list)


        for(i in 0 until content_code_JSONArray.length())
        {
            var content_code_jsonObject : JSONObject
            var content_code : String
            content_code_jsonObject = content_code_JSONArray.getJSONObject(i)
            var content_title : String

            var content_name = content_code_jsonObject.getString("content_name")
            if(content_code_jsonObject.has("content_code"))
            {
                content_code = content_code_jsonObject.getString("content_code")
            }
            else
            {
                content_code = ""
            }


            if(content_code_jsonObject.has("content_title"))
            {
                content_title = content_code_jsonObject.getString("content_title")
            }
            else
            {
                content_title = ""
            }


            if(content_name.equals("평가"))
            {
                if(evaluation_value)
                {
                    classDetailUnitClassListItem.add(class_detail_unit_class_list_Item(content_title,content_name,content_code,1))
                }
                else
                {
                    classDetailUnitClassListItem.add(class_detail_unit_class_list_Item(content_title,content_name,content_code,0))
                }

            }

            else
            {
                classDetailUnitClassListItem.add(class_detail_unit_class_list_Item(content_title,content_name,content_code,0))
            }



            classDetailUnitClassListAdapter.notifyDataSetChanged()


            if(user_evaluation_JSONArray.toString().length>50|| user_practice_JSONArray.toString().length>50)
            {
                //완료 여부도 체크해주기
                set_update_class_list_value()
            }


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

    //사이드 메뉴 버튼
    //사이드 메뉴(햄버거)버튼
    val side_menu_button = View.OnClickListener{
        class_detail_unit_drawerlayout.openDrawer(class_detail_unit_child_drawerlayout)
    }
    override fun onStop() {
        super.onStop()

        class_detail_unit_drawerlayout.closeDrawer(class_detail_unit_child_drawerlayout)
    }

    //수업 콘텐츠 가져오기
    fun get_content_list(content_code : String, content_title : String, position_number : Int, array_size : Int)
    {
        serverConnectionSpec!!.get_content_list(student_id, access_token, content_code).enqueue(object : Callback<ResponseBody>
        {


            override fun onResponse(call: Call<ResponseBody>, response: Response<ResponseBody>)
            {


                try {
                    val result = JSONObject(response.body()!!.string())


                    var i : Iterator<String>
                    i =  result.keys()

                    Log.d("결과!!!", "onResponse:"+result)
                    if(!i.next().equals("fail"))
                    {
                        //토큰 갱신
                        access_token = result.getString("student_token")

                        SimpleSharedPreferences.saveAccessToken(this@class_detail_unit_Activity, access_token)


                        val content_JOSNObject = JSONObject(result.getString("success"))


                        val content_name_list = content_JOSNObject.getString("content_name_list")
                        val content_cateogry_list = content_JOSNObject.getString("content_cateogry_list")
                        val content_type_list = content_JOSNObject.getString("content_type_list")
                        val content_detail_name_list = content_JOSNObject.getString("content_detail_name_list")
                        val content_count_list = content_JOSNObject.getString("content_count_list")
                        val content_time = content_JOSNObject.getString("content_time")
                        val content_url = content_JOSNObject.getString("content_url")
                        val content_level_list = content_JOSNObject.getString("content_level_list")


                        if(content_title.contains("평가")||content_title.contains("과제"))
                        {
                            val intent = Intent(this@class_detail_unit_Activity, PoseActivity::class.java)

                            intent.putExtra("evaluation_value", "1")
                            intent.putExtra("class_title", class_tilte)
                            intent.putExtra("unit_code", unit_class_code)
                            intent.putExtra("class_code", class_code)
                            intent.putExtra("content_title", content_title)
                            intent.putExtra("position_number", position_number)
                            intent.putExtra("array_size", array_size)
                            intent.putExtra("content_name_list", content_name_list)
                            intent.putExtra("content_cateogry_list", content_cateogry_list)
                            intent.putExtra("content_type_list", content_type_list)
                            intent.putExtra("content_detail_name_list", content_detail_name_list)
                            intent.putExtra("content_count_list", content_count_list)
                            intent.putExtra("content_time", content_time)
                            intent.putExtra("content_url", content_url)
                            intent.putExtra("content_level_list", content_level_list)

                            startActivity(intent)

                            overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)

                        }
                        else{

                        val intent = Intent(this@class_detail_unit_Activity, PoseActivity::class.java)

                        intent.putExtra("evaluation_value", "0")
                        intent.putExtra("class_title", class_tilte)
                        intent.putExtra("unit_code", unit_class_code)
                        intent.putExtra("class_code", class_code)
                        intent.putExtra("content_title", content_title)
                        intent.putExtra("position_number", position_number)
                        intent.putExtra("array_size", array_size)
                        intent.putExtra("content_name_list", content_name_list)
                        intent.putExtra("content_cateogry_list", content_cateogry_list)
                        intent.putExtra("content_type_list", content_type_list)
                        intent.putExtra("content_detail_name_list", content_detail_name_list)
                        intent.putExtra("content_count_list", content_count_list)
                        intent.putExtra("content_time", content_time)
                        intent.putExtra("content_url", content_url)
                        intent.putExtra("content_level_list", content_level_list)

                        startActivity(intent)
                        overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)

                        }


                    }
                    //실패 시
                    else
                    {
                        show(this@class_detail_unit_Activity, "인터넷 연결 상태를 확인해주세요.")

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


    //클래스 최종 과제 제출하기
    fun student_update_submit_task(class_code: String, unit_class_code: String, unit_class_type : String, unit_group_name:String)
    {
        serverConnectionSpec!!.student_update_submit_task(student_id, access_token, class_code, unit_class_code, student_number, unit_class_type, unit_group_name).enqueue(object : Callback<ResponseBody>
        {
            override fun onResponse(call: Call<ResponseBody>, response: Response<ResponseBody>)
            {
                try {
                    val result = JSONObject(response.body()!!.string())

                    Log.d("결과!!", "onResponse:"+result)

                    var i : Iterator<String>
                    i =  result.keys()

                    //Log.d("결과", "onResponse:"+result)
                    if(!i.next().equals("fail"))
                    {
                        //토큰 갱신
                        access_token = result.getString("student_token")

                        SimpleSharedPreferences.saveAccessToken(this@class_detail_unit_Activity, access_token)

                        show(this@class_detail_unit_Activity, "최종 제출 되었습니다.\n선생님이 요청한 제출방식에 맞추어 제출해주시길 바랍니다.")

                        student_practice_value = 1
                        class_detail_unit_submit_button_textview.setBackgroundResource(R.drawable.view_gray_color_2_round_edge)
                        class_detail_unit_submit_button_textview.setTextColor(Color.parseColor("#404040"))



                    }
                    //실패 시
                    else
                    {
                        CustomToast.show(this@class_detail_unit_Activity, "인터넷 연결 상태를 확인해주세요.")

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


    //수업 현황 가져오기
    fun get_student_class_record(class_code: String, unit_class_code: String )
    {
        serverConnectionSpec!!.get_student_class_record(student_id, access_token, class_code).enqueue(object : Callback<ResponseBody>
        {
            override fun onResponse(call: Call<ResponseBody>, response: Response<ResponseBody>)
            {

                try {
                    val result = JSONObject(response.body()!!.string())


                    var i : Iterator<String>
                    i =  result.keys()

                    Log.d("결과~~!!~~!!1234", "onResponse:"+result)
                    if(!i.next().equals("fail"))
                    {
                        //토큰 갱신
                        access_token = result.getString("student_token")

                        SimpleSharedPreferences.saveAccessToken(this@class_detail_unit_Activity, access_token)

                        var class_detail_unit_list = result.getString("success")

                        var class_detail_unit_JOSNObject = JSONObject(class_detail_unit_list)

                        //최종 과제 제출 여부
                        if(!class_detail_unit_JOSNObject.isNull("student_practice")&&
                                !class_detail_unit_JOSNObject.getString("student_practice").isEmpty()
                                &&!class_detail_unit_JOSNObject.getString("student_practice").equals("-"))
                        {
                        student_practice_value = class_detail_unit_JOSNObject.getInt("student_practice")
                        }
                        //이미 제출한 경우
                        if(student_practice_value==1)
                        {
                            class_detail_unit_submit_button_textview.setBackgroundResource(R.drawable.view_gray_color_2_round_edge)
                            class_detail_unit_submit_button_textview.setTextColor(Color.parseColor("#404040"))
                        }


                        if(class_detail_unit_JOSNObject.isNull("evaluation_practice"))
                        {
                            evaluation_value = false

                            if(evaluation_array.size!=0)
                            {
                                var set_JSONArray = JSONArray()
                                var final_JSONArray = JSONArray()
                                for(i in evaluation_array.indices)
                                {

                                    final_JSONArray.put(set_JSONArray)
                                }

                                user_evaluation_JSONArray = final_JSONArray



                                update_student_record_evaluation_practice(class_code, unit_class_code, user_evaluation_JSONArray.toString(),"0")


                            }



                        }
                        else
                        {
                            evaluation_value = true
                            var wow = class_detail_unit_JOSNObject.getString("evaluation_practice")
                            var get_evaluation_jsonArray = JSONArray(wow)

                            //제이슨 데이터 넣기
                            user_evaluation_JSONArray = get_evaluation_jsonArray

                            for(i in evaluation_array.indices)
                            {
                                var evaluation_JSONArray_str = user_evaluation_JSONArray.getJSONArray(i).toString()

                                var evaluation_JSONArray = JSONArray(evaluation_JSONArray_str)

                                if(evaluation_JSONArray.length()!=0)
                                {
                                    student_evaluation_submit_possible_value = 1
                                }
                                else
                                {
                                    student_evaluation_submit_possible_value = 0

                                    break

                                }
                            }

                            if(student_evaluation_submit_possible_value==1&&student_practice_value==0)
                            {
                                class_detail_unit_submit_button_textview.setBackgroundResource(R.drawable.view_main_color_round_button)
                                class_detail_unit_submit_button_textview.setTextColor(Color.parseColor("#ffffff"))

                            }




                        }

                        if(class_detail_unit_JOSNObject.isNull("task_practice"))
                        {
                            task_value = false

                            if(task_array.size!=0)
                            {
                                var set_JSONArray = JSONArray()
                                var final_JSONArray = JSONArray()
                                for(i in evaluation_array.indices)
                                {

                                    final_JSONArray.put(set_JSONArray)
                                }

                                user_task_JSONArray = final_JSONArray

                                Log.d("데이터보기3", "onResponse:"+final_JSONArray.toString())
                                update_student_record_task_practice(class_code, unit_class_code, user_task_JSONArray.toString(), "0")


                            }
                        }
                        else
                        {
                            task_value = true


                            var get_jsonArray = class_detail_unit_JOSNObject.getString("task_practice")

                             var get_task_jsonArray = JSONArray(get_jsonArray)

                            //제이슨 데이터 넣기
                            user_task_JSONArray = get_task_jsonArray




                        }

                        if(class_detail_unit_JOSNObject.isNull("class_practice"))
                        {
                            class_value = false

                            if(practice_array.size!=0)
                            {
                                var set_JSONArray = JSONArray()
                                var final_JSONArray = JSONArray()
                                for(i in practice_array.indices)
                                {

                                    final_JSONArray.put(set_JSONArray)
                                }

                                user_practice_JSONArray = final_JSONArray

                                update_student_record_class_practice(class_code, unit_class_code, user_practice_JSONArray.toString(),"0")


                            }
                        }
                        else
                        {
                            class_value = true


                            var get_jsonArray = class_detail_unit_JOSNObject.getString("class_practice")

                            var get_practice_jsonArray = JSONArray(get_jsonArray)



                            //제이슨 데이터 넣기
                            user_practice_JSONArray = get_practice_jsonArray




                        }




                        set_content_code_list(content_code_list)

                    }
                    //실패 시
                    else
                    {
                        show(this@class_detail_unit_Activity, "인터넷 연결 상태를 확인해주세요.")

                    }


                } catch (e: JSONException) {
                    e.printStackTrace()
                } catch (e: IOException) {
                    e.printStackTrace()
                }
            }

            override fun onFailure(call: Call<ResponseBody>, t: Throwable) {




            }
        })



    }

    //실습 업데이트
    fun update_student_record_class_practice(class_code : String, class_unit_code : String, class_practice: String, class_content_use_time : String)
    {
        serverConnectionSpec!!.update_student_record_class_practice(student_id, access_token, class_code, class_unit_code, class_practice, class_content_use_time, class_unit_group_name).enqueue(object : Callback<ResponseBody> {
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
                        access_token = result.getString("student_token")

                        SimpleSharedPreferences.saveAccessToken(this@class_detail_unit_Activity, set_User_info.access_token)





                    }
                    //실패 시
                    else
                    {
                        show(this@class_detail_unit_Activity, "인터넷 연결 상태를 확인해주세요.")

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
                        access_token = result.getString("student_token")

                        SimpleSharedPreferences.saveAccessToken(this@class_detail_unit_Activity, set_User_info.access_token)



                    }
                    //실패 시
                    else
                    {
                        show(this@class_detail_unit_Activity, "인터넷 연결 상태를 확인해주세요.")

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
    fun update_student_record_evaluation_practice(class_code : String, class_unit_code : String, class_practice: String, class_content_use_time: String)
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

                        Log.d("결과", "onResponse:"+result)
                        //토큰 갱신
                        access_token = result.getString("student_token")

                        SimpleSharedPreferences.saveAccessToken(this@class_detail_unit_Activity, set_User_info.access_token)



                    }
                    //실패 시
                    else
                    {
                        CustomToast.show(this@class_detail_unit_Activity, "인터넷 연결 상태를 확인해주세요.")

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

    fun set_update_class_list_value()
    {
        var class_practice_Int : Int = 0
        var class_task_Int : Int = 0
        var class_evaluation_Int : Int = 0
        //유저 평가 기록
        user_evaluation_JSONArray
        //유저 과제 기록
        user_task_JSONArray
        //유저 실습 기록
        user_practice_JSONArray

        if(classDetailUnitClassListItem.size!=0)
        {
            for(i in classDetailUnitClassListItem.indices)
            {
                if(classDetailUnitClassListItem.get(i).class_unit_title.equals("실습수업"))
                {
                    if(user_practice_JSONArray.length()!=0)
                    {

                        if(user_practice_JSONArray.get(class_practice_Int).toString().length > 10)
                        {

                            classDetailUnitClassListItem.set(i, classDetailUnitClassListItem.get(i)).class_value = 1
                            class_practice_Int = class_practice_Int+1
                        }
                        else
                        {
                            class_practice_Int = class_practice_Int+1
                        }

                    }


                }
                else if(classDetailUnitClassListItem.get(i).class_unit_title.equals("평가수업"))
                {
                    if(user_evaluation_JSONArray.length()!=0)
                    {
                        if(user_evaluation_JSONArray.get(class_evaluation_Int).toString().length>10)
                        {
                            classDetailUnitClassListItem.set(i, classDetailUnitClassListItem.get(i)).class_value = 1
                            class_evaluation_Int = class_evaluation_Int+1
                        }else
                        {
                            class_evaluation_Int = class_evaluation_Int+1
                        }

                    }

                }

            }


            classDetailUnitClassListAdapter.notifyDataSetChanged()
        }


    }

}