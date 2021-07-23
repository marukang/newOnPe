package com.funidea.newonpe.page.main

import android.Manifest
import android.app.ActivityOptions
import android.app.AlertDialog
import android.content.Intent
import android.graphics.Color
import android.os.Bundle
import android.util.Log
import android.view.View
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.LinearSnapHelper
import androidx.recyclerview.widget.RecyclerView
import androidx.recyclerview.widget.SnapHelper
import com.bumptech.glide.Glide
import com.bumptech.glide.RequestManager
import com.bumptech.glide.load.engine.DiskCacheStrategy
import com.funidea.utils.CustomToast.Companion.show
import com.funidea.utils.change_class_name.Companion.input_change_class_name
import com.funidea.utils.change_date_value.Companion.change_time_include_second
import com.funidea.utils.save_SharedPreferences
import com.funidea.utils.set_User_info.Companion.access_token
import com.funidea.utils.set_User_info.Companion.news_state
import com.funidea.utils.set_User_info.Companion.select_class_code_str
import com.funidea.utils.set_User_info.Companion.select_class_name_str
import com.funidea.utils.set_User_info.Companion.student_class
import com.funidea.utils.set_User_info.Companion.student_class_code_key_Array
import com.funidea.utils.set_User_info.Companion.student_class_code_value_Array
import com.funidea.utils.set_User_info.Companion.student_content
import com.funidea.utils.set_User_info.Companion.student_id
import com.funidea.utils.set_User_info.Companion.student_image_url
import com.funidea.utils.set_User_info.Companion.student_level
import com.funidea.utils.set_User_info.Companion.student_name
import com.funidea.utils.set_User_info.Companion.student_number
import com.funidea.utils.set_User_info.Companion.student_recent_exercise_date
import com.funidea.utils.set_User_info.Companion.student_school
import com.funidea.utils.side_menu_layout.Companion.side_menu_setting_test
import com.funidea.newonpe.*
import com.funidea.newonpe.dialog.InputUserInfoDialog
import com.funidea.newonpe.dialog.RegisterNewClassDialog
import com.funidea.newonpe.page.youtube.after_school_content_Activity
import com.funidea.newonpe.page.home.VariableScrollSpeedLinearLayoutManager
import com.funidea.newonpe.page.home.class_community_menu_Activity
import com.funidea.newonpe.page.home.class_home.class_home_Activity
import com.funidea.newonpe.page.setting.my_page_Activity
import com.funidea.newonpe.page.setting.SettingPage
import com.funidea.newonpe.page.notice.notice_main_home_Activity
import com.funidea.newonpe.page.management.self_class_Activity
import com.funidea.newonpe.page.login.LoginPage.Companion.baseURL
import com.funidea.newonpe.page.login.LoginPage.Companion.serverConnectionSpec
import com.google.android.material.bottomsheet.BottomSheetBehavior.STATE_EXPANDED
import com.google.android.play.core.appupdate.AppUpdateManager
import com.google.android.play.core.appupdate.AppUpdateManagerFactory
import com.google.android.play.core.install.model.AppUpdateType
import com.google.android.play.core.install.model.UpdateAvailability
import com.gun0912.tedpermission.PermissionListener
import com.gun0912.tedpermission.TedPermission
import kotlinx.android.synthetic.main.activity_main_home_legacy.*
import okhttp3.ResponseBody
import org.json.JSONArray
import org.json.JSONException
import org.json.JSONObject
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.io.IOException
import java.util.*
import kotlin.collections.ArrayList

class MainHomeActivity : AppCompatActivity() {

    lateinit var appUpdateManager : AppUpdateManager
    var REQUEST_CODE_UPDATE = 10

    lateinit var mGlideRequestManager : RequestManager
    //사이드 메뉴
    lateinit var sideMenuClassAdapter: side_menu_class_Adapter

    //사이드 메뉴 클래스
    var side_menu_class_value : Int = 0

    //클래스 이름 리사이클러뷰
    lateinit var classNameAdapter: class_name_Adapter
    var classNameItem = ArrayList<class_name_Item>()
    var snapHelper: SnapHelper? = LinearSnapHelper()
    var class_name_recyclerview_position : Int = 0;

    private var isPermission = true

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main_home_legacy)



       //처음 혹은 사용자 정보를 완벽히 입력하지 않을 경우 보여질 user_info_bottom_dialog
        //2021-06-06 다이어로그가 나오지 않도록 주석 처리.
        //input_user_info(student_sex)

        //권한 설정
        tedPermission()

        if(student_class_code_value_Array.size!=0)
        {

        main_home_class_list_linearlayout.visibility = View.VISIBLE
        main_home_first_add_new_class_linearlayout.visibility = View.GONE

        if(classNameItem.size!=0)
        {
            classNameItem.clear()
            sideMenuClassItem.clear()
        }


        for(i in student_class_code_value_Array.indices)
        {
         /*   Log.d("값보기", "onCreate:"+ student_class_code_value_Array.size +"+"+i)

            var size_value = student_class_code_value_Array.size-1 -i
            Log.d("값보기", "onCreate:"+ size_value)*/
            classNameItem.add(class_name_Item(student_class_code_key_Array.get(i), student_class_code_value_Array.get(i)))
            sideMenuClassItem.add(side_menu_class_Item(student_class_code_key_Array.get(i), student_class_code_value_Array.get(i)))

        }

        }
        else
        {

            main_home_class_list_linearlayout.visibility = View.GONE
            main_home_first_add_new_class_linearlayout.visibility = View.VISIBLE
            main_home_menu_linearlayout_1.visibility = View.INVISIBLE
            main_home_menu_linearlayout_2.visibility = View.INVISIBLE
        }

        Collections.reverse(classNameItem);

        //클래스 네임 리사이클러뷰
        classNameAdapter = class_name_Adapter(this, classNameItem)


        snapHelper!!.attachToRecyclerView(main_home_class_name_recyclerview)
        //레이아웃 매니저
        var linearLayoutManager : VariableScrollSpeedLinearLayoutManager
        linearLayoutManager = VariableScrollSpeedLinearLayoutManager(this, 4F)
        linearLayoutManager.orientation = LinearLayoutManager.HORIZONTAL
        linearLayoutManager.scrollToPosition(0)
        main_home_class_name_recyclerview.layoutManager = linearLayoutManager
        circleindicator.attachToRecyclerView(main_home_class_name_recyclerview, snapHelper!!)
        circleindicator.createIndicators(classNameItem.size,classNameItem.size)

        classNameAdapter.registerAdapterDataObserver(circleindicator.adapterDataObserver)
        main_home_class_name_recyclerview.adapter = classNameAdapter


        //선택 클래스 change_listener
        main_home_class_name_recyclerview.addOnScrollListener(object : RecyclerView.OnScrollListener() {
            override fun onScrolled(recyclerView: RecyclerView, dx: Int, dy: Int) {
                super.onScrolled(recyclerView, dx, dy)

                //현재 리사이클러뷰 위치
                class_name_recyclerview_position = (recyclerView.layoutManager as LinearLayoutManager?)!!.findLastCompletelyVisibleItemPosition()

                if(class_name_recyclerview_position!=-1)
                {

                select_class_code_str = classNameItem.get(class_name_recyclerview_position).class_code_name
                select_class_name_str = classNameItem.get(class_name_recyclerview_position).class_name

                }
                    val itemTotalCount = recyclerView.adapter!!.itemCount - 1


            }
        })


        //리사이클러뷰 좌우 이동 버튼
        main_home_class_move_left_imageview.setOnClickListener(move_left)
        main_home_class_move_right_imageview.setOnClickListener(move_right)


        //클래스 입장하기
        main_home_class_enter_textview_button.setOnClickListener(class_enter_button)
        //새소식 버튼
        //main_home_notice_button_textview.setOnClickListener(notice_button)
        //햄버거 버튼
        main_home_side_menu_button_imageview.setOnClickListener(side_menu_button)
        //셋팅 페이지 이동 버튼
        main_home_setting_button_imageview.setOnClickListener(setting_button)
        //마이 페이지 이동 버튼
        main_home_mypage_button_textview.setOnClickListener(mypage_button)
        //커뮤니티 이동 버튼
        main_home_community_button_linearlayout.setOnClickListener(community_button)
        //메인 홈 컨텐츠
        main_home_content_button_textview.setOnClickListener(content_button)
        //온라인 체육 수업 버튼
        main_home_self_class_button_textview.setOnClickListener(self_class_button)

        //신규 수업 추가 버튼
        main_home_add_new_class_linearlayout.setOnClickListener(add_new_class)

        //첫번쨰 수업 추가 버튼
        main_home_first_add_new_class_linearlayout.setOnClickListener(add_new_class)

        //유저이름
        main_home_student_name_textview.setText(student_name)

        //사이드 메뉴 세팅
        val sideMenuView : View = findViewById(R.id.main_home_child_drawerview)

        side_menu_setting_test(main_home_drawerview, sideMenuView,this)



        appUpdateManager = AppUpdateManagerFactory.create(this)

        appUpdateManager?.let {
            it.appUpdateInfo.addOnSuccessListener { appUpdateInfo ->

                if (appUpdateInfo.updateAvailability() == UpdateAvailability.UPDATE_AVAILABLE
                        && appUpdateInfo.isUpdateTypeAllowed(AppUpdateType.IMMEDIATE)) {
                    // or AppUpdateType.FLEXIBLE
                    appUpdateManager?.startUpdateFlowForResult(
                            appUpdateInfo,
                            AppUpdateType.IMMEDIATE, // or AppUpdateType.FLEXIBLE
                            this,
                            REQUEST_CODE_UPDATE
                    )
                }
            }
        }



    }

    override fun onResume() {
        super.onResume()

        mGlideRequestManager = Glide.with(this)
        mGlideRequestManager.load(baseURL+student_image_url)
                .diskCacheStrategy(DiskCacheStrategy.NONE)
                .skipMemoryCache(true)
                .centerCrop()
                .placeholder(R.drawable.user_profile)
                .into(main_home_student_profile_imageview)

        //유저최근운동일
        student_recent_excercise_date_textview.setText(change_time_include_second(student_recent_exercise_date))


        if(!student_school.equals("")&&!student_school.isEmpty())
        {
            main_home_school_name_textview.setText(student_school+"학교")
        }
        else
        {
            main_home_school_name_textview.setText("-")
        }

        if(!student_level.equals("")&&!student_level.isEmpty()){ main_home_school_grade_textview.setText(student_level)}
        else { main_home_school_grade_textview.setText("-")}
        if(!student_class.equals("")&&!student_class.isEmpty()){ main_home_school_class_textview.setText(student_class)}
        else { main_home_school_class_textview.setText("-")}
        if(!student_content.equals("")&&!student_content.isEmpty()){ main_home_studnet_comment_textview.setText(student_content)}
        else { main_home_studnet_comment_textview.setText("좌우명을 입력해주세요.")}

        //새소식 버튼
        news_state_button_class()
    }

    //초기 신체 정보 입력을 위한 bottom dialog
    fun input_user_info(user_sex : String)
    {

        if(user_sex.equals("null")){

        val inputUserInfoBottomDialog = InputUserInfoDialog(this)

        inputUserInfoBottomDialog.behavior.state  = STATE_EXPANDED

        inputUserInfoBottomDialog.show()
        }
    }


    val add_new_class = View.OnClickListener {

        val newClassAddBottomDialog = RegisterNewClassDialog(this)

        newClassAddBottomDialog.show()

        newClassAddBottomDialog.setInputNewClassCodeListener(object : RegisterNewClassDialog.InputNewClassCodeListener
        {
            override fun input_code(input_code: String?) {

                //custom_toast(this@main_home_Activity, input_code.toString())

                if(student_class_code_key_Array.contains(input_code))
                {
                    show(this@MainHomeActivity, "이미 등록 된 수업코드입니다.")
                }
                else{


                student_class_code_key_Array.add(input_code.toString())
                student_class_code_value_Array.add(input_change_class_name(this@MainHomeActivity, input_code.toString()))

                var class_JSONArray = JSONArray()

                for( i in 0 until  student_class_code_key_Array.size)
                {
                    var jsonObject = JSONObject()
                    jsonObject.put(student_class_code_key_Array.get(i), student_class_code_value_Array.get(i))
                    class_JSONArray.put(jsonObject)
                }

                add_new_class(input_code.toString(),class_JSONArray.toString())


            }

            }


        }
        )
    }


    private fun tedPermission() {
        val permissionListener: PermissionListener = object : PermissionListener {
            override fun onPermissionGranted() {
                // 권한 요청 성공
                isPermission = true
            }

            override fun onPermissionDenied(deniedPermissions: List<String>) {

                // 권한 요청 거절
                isPermission = false
                show(this@MainHomeActivity, "권한 거부로 인해 앱이 정상적으로 동작하지 않을 수 있습니다.")
            }
        }
        TedPermission.with(this)
                .setPermissionListener(permissionListener)
                .setRationaleMessage(resources.getString(R.string.permission_2))
                .setDeniedMessage(resources.getString(R.string.permission_1))
                .setPermissions(Manifest.permission.WRITE_EXTERNAL_STORAGE, Manifest.permission.CAMERA, Manifest.permission.RECORD_AUDIO)
                .check()
    }



    //셀프 클래스 버튼
    val self_class_button = View.OnClickListener {
        val intent = Intent(this, self_class_Activity::class.java)
        startActivity(intent)
        overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)
    }

    val content_button = View.OnClickListener {
        val intent = Intent(this, after_school_content_Activity::class.java)
        startActivity(intent)
        overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)
    }

    //클래스 입장 버튼
    val class_enter_button = View.OnClickListener {

        if(student_level.equals("null")||student_level.isEmpty()||
           student_class.equals("null")|| student_class.isEmpty()||
           student_number.equals("null")|| student_number.isEmpty()|| student_number.equals("0")
           )
        {
            show(this, "수업을 듣기 위해서 마이페이지에서 학년, 반, 번호를 입력해주세요.")
            val intent = Intent(this, my_page_Activity::class.java)
            val bundle = ActivityOptions.makeCustomAnimation(this, R.anim.anim_slide_in_right, R.anim.anim_slide_out_left).toBundle()
            startActivity(intent, bundle)
        }
        else
        {
            select_class_code_str =  classNameItem.get(class_name_recyclerview_position).class_code_name
            enter_class(select_class_code_str)
        }



    }


    val move_left = View.OnClickListener {


        if(class_name_recyclerview_position!=0)
        {
            main_home_class_name_recyclerview.smoothScrollToPosition(class_name_recyclerview_position-1)
            class_name_recyclerview_position = class_name_recyclerview_position-1
        }
        else
        {
            Toast.makeText(this,"첫번 째 수업입니다.", Toast.LENGTH_SHORT).show()
        }

    }
    val move_right = View.OnClickListener {

        if(class_name_recyclerview_position==classNameItem.size-1)
        {
            Toast.makeText(this,"마지막 수업입니다.", Toast.LENGTH_SHORT).show()
        }
        else
        {
            main_home_class_name_recyclerview.smoothScrollToPosition(class_name_recyclerview_position+1)
            class_name_recyclerview_position = class_name_recyclerview_position+1
        }

    }

   /* //새소식 이동버튼
    val notice_button = View.OnClickListener {

        val intent = Intent(this, notice_Activity::class.java)
        startActivity(intent)
        overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)
    }*/

    //사이드 메뉴(햄버거)버튼
    val side_menu_button = View.OnClickListener {

        main_home_drawerview.openDrawer(main_home_child_drawerview)
    }


    override fun onStop() {
        super.onStop()

        main_home_drawerview.closeDrawer(main_home_child_drawerview)
    }


    //셋팅 버튼
    val setting_button = View.OnClickListener {

        val intent = Intent(this, SettingPage::class.java)
        startActivity(intent)
        overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)
    }

    //마이 페이지 버튼
    val mypage_button = View.OnClickListener {

        val intent = Intent(this, my_page_Activity::class.java)
        startActivity(intent)
        overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)

    }

    //커뮤니티 이동 버튼
    val community_button = View.OnClickListener {

        val intent = Intent(this, class_community_menu_Activity::class.java)
        startActivity(intent)
        overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)


    }

    //클래스 추가하기
    fun add_new_class(class_code : String, class_code_list : String)
    {

        serverConnectionSpec!!.student_class_update(student_id,access_token, class_code).enqueue(object : Callback<ResponseBody> {
            override fun onResponse(call: Call<ResponseBody>, response: Response<ResponseBody>)
            {
                try {
                    val result = JSONObject(response.body()!!.string())

                    Log.d("보내기결과", "onResponse:"+result)

                    var i : Iterator<String>
                    i =  result.keys()

                    //Log.d("결과", "onResponse:"+result)
                    if(!i.next().equals("fail"))
                    {
                        //토큰 갱신
                        access_token = result.getString("student_token")

                        save_SharedPreferences.save_shard(this@MainHomeActivity, access_token)

                        Collections.reverse(classNameItem)

                        classNameItem.add(class_name_Item(student_class_code_key_Array.get(student_class_code_key_Array.size - 1), student_class_code_value_Array.get(student_class_code_value_Array.size - 1)))

                        Collections.reverse(classNameItem)

                        classNameAdapter.notifyDataSetChanged()

                        main_home_class_name_recyclerview.smoothScrollToPosition(0)

                        select_class_code_str = classNameItem.get(student_class_code_key_Array.size-1).class_code_name
                        select_class_name_str = classNameItem.get(student_class_code_value_Array.size-1).class_name

                        if(main_home_class_list_linearlayout.visibility!=View.VISIBLE)
                        {
                            main_home_class_list_linearlayout.visibility = View.VISIBLE
                            main_home_first_add_new_class_linearlayout.visibility = View.GONE
                            main_home_menu_linearlayout_1.visibility = View.VISIBLE
                            main_home_menu_linearlayout_2.visibility = View.VISIBLE
                        }

                        val split_class_code = class_code.split("_")

                        var school_name = split_class_code[0]

                        student_school = school_name

                        if(!student_school.equals("")&&!student_school.isEmpty()){main_home_school_name_textview.setText(student_school+"학교")}
                        else { main_home_school_name_textview.setText("-")}

                    }
                    //실패 시
                    else
                    {
                        var fail_result_value = result.getString("fail")

                        if(fail_result_value.equals("none_class"))
                        {
                            show(this@MainHomeActivity, "존재 하는 않는 수업코드입니다. 수업코드를 다시 확인해주세요.")
                        }
                        else{
                            show(this@MainHomeActivity, "인터넷 연결 상태를 확인해주세요.")
                        }

                        student_class_code_key_Array.removeAt(student_class_code_key_Array.size-1)
                        student_class_code_value_Array.removeAt(student_class_code_value_Array.size-1)

                        classNameAdapter.notifyDataSetChanged()



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



    //수업 입장하기
    fun enter_class(class_code : String)
    {
        serverConnectionSpec!!.get_class_unit_list(student_id,access_token).enqueue(object : Callback<ResponseBody> {
            override fun onResponse(call: Call<ResponseBody>, response: Response<ResponseBody>)
            {
                try {
                    val result = JSONObject(response.body()!!.string())

                    Log.d("결과", "onResponse:"+result)

                    var i : Iterator<String>
                    i =  result.keys()

                    if(!i.next().equals("fail"))
                    {
                        //토큰 갱신
                        access_token = result.getString("student_token")

                        save_SharedPreferences.save_shard(this@MainHomeActivity, access_token)

                        var unit_code_list : String = ""

                        unit_code_list = result.getString("success")

                        val intent = Intent(this@MainHomeActivity, class_home_Activity::class.java)
                        intent.putExtra("unit_code_list",unit_code_list)
                        startActivity(intent)
                        overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)


                    }
                    //실패 시
                    else
                    {

                        var fail_result_value = result.getString("fail")

                        if(fail_result_value.equals("none_class_unit_list")) {

                            //정말 삭제하시겠습니까 라는 AlertDialog 생성
                            val builder = AlertDialog.Builder(this@MainHomeActivity)
                            builder.setTitle("온체육")
                            builder.setMessage("수업 준비중입니다.")
                            builder.setPositiveButton("확인") { dialogInterface, i ->

                                //서버로 삭제 안내 해주기
                                //delete_student_community_comment_list(get_board_number, boardCommentItem.get(position).comment_number, position)
                                dialogInterface.dismiss()
                            }
                            val dialog: AlertDialog = builder.create()
                            dialog.show()


                        }else
                        {
                            show(this@MainHomeActivity, "인터넷 연결 상태를 확인해주세요.")
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

    fun news_state_button_class()
    {
        if(news_state.equals("0"))
        {
            main_home_notice_button_textview.setBackgroundResource(R.drawable.view_main_color_round_edge)
            main_home_notice_button_textview.setTextColor(Color.parseColor("#4286f4"))

        }
        else
        {

            main_home_notice_button_textview.setBackgroundResource(R.drawable.view_main_color_round_button)
            main_home_notice_button_textview.setTextColor(Color.parseColor("#FFFFFF"))
        }

        main_home_notice_button_textview.setOnClickListener {

            val intent = Intent(this@MainHomeActivity, notice_main_home_Activity::class.java)
            startActivity(intent)
            overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)
            news_state = "0"

        }



    }




    companion object {

        var sideMenuClassItem = ArrayList<side_menu_class_Item>()


    }

       private var toast: Toast? = null
    private var backKeyPressedTime: Long = 0
    override fun onBackPressed() {

        // 기존 뒤로가기 버튼의 기능을 막기위해 주석처리 또는 삭제
        // super.onBackPressed();
        // main_home_drawerview.closeDrawer
        //햄버거 버튼을 통해 메뉴가 열려있다면 닫아준다.
        if (main_home_drawerview.isDrawerOpen(main_home_child_drawerview))
        {
            main_home_drawerview.closeDrawer(main_home_child_drawerview)
        }
        else{
        // 마지막으로 뒤로가기 버튼을 눌렀던 시간에 2초를 더해 현재시간과 비교 후
        // 마지막으로 뒤로가기 버튼을 눌렀던 시간이 2초가 지났으면 Toast Show
        // 2000 milliseconds = 2 seconds
        if (System.currentTimeMillis() > backKeyPressedTime + 2000) {
            backKeyPressedTime = System.currentTimeMillis();
            toast = Toast.makeText(this, "\'뒤로\' 버튼을 한번 더 누르시면 종료됩니다.", Toast.LENGTH_SHORT);
            toast!!.show()
            return;
        }
        // 마지막으로 뒤로가기 버튼을 눌렀던 시간에 2초를 더해 현재시간과 비교 후
        // 마지막으로 뒤로가기 버튼을 눌렀던 시간이 2초가 지나지 않았으면 종료
        // 현재 표시된 Toast 취소
        if (System.currentTimeMillis() <= backKeyPressedTime + 2000) {
            finish();
            toast!!.cancel();
        }

        }
    }

}