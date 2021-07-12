package com.funidea.newonpe.my_page

import android.app.Activity
import android.app.ActivityOptions
import android.app.AlertDialog
import android.content.Context
import android.content.Intent
import android.content.IntentSender
import android.content.SharedPreferences
import android.content.pm.PackageInfo
import android.os.Bundle
import android.util.Log
import android.view.View
import android.widget.CompoundButton
import androidx.appcompat.app.AppCompatActivity
import com.funidea.utils.Custom_Toast.Companion.custom_toast
import com.funidea.utils.save_SharedPreferences.Companion.save_shard
import com.funidea.utils.set_User_info.Companion.access_token
import com.funidea.utils.set_User_info.Companion.set_clear
import com.funidea.utils.set_User_info.Companion.student_id
import com.funidea.utils.set_User_info.Companion.student_push_agreement
import com.funidea.newonpe.dialog.input_password_for_resign_bottom_dialog
import com.funidea.newonpe.R
import com.funidea.newonpe.my_page.agreement.agreement_main_Activity
import com.funidea.newonpe.SplashActivity
import com.funidea.newonpe.SplashActivity.Companion.serverConnection
import com.google.android.play.core.appupdate.AppUpdateManager
import com.google.android.play.core.appupdate.AppUpdateManagerFactory
import com.google.android.play.core.install.model.AppUpdateType
import com.google.android.play.core.install.model.UpdateAvailability
import kotlinx.android.synthetic.main.activity_setting.*
import okhttp3.ResponseBody
import org.json.JSONException
import org.json.JSONObject
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.io.IOException

/** Setting Class
 *
 * 약관보기, 푸시 알림, 로그아웃 등 앱 관련 셋팅을 할 수 있는 페이지
 *
 */


class setting_Activity : AppCompatActivity() {

    lateinit var appUpdateManager : AppUpdateManager
    private val MY_REQUEST_CODE = 100
    var switch_value : Int = 0

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_setting)

        val info: PackageInfo = this.packageManager.getPackageInfo(this.packageName, 0)
        val version = info.versionName



        appUpdateManager = AppUpdateManagerFactory.create(this)
        //현재 버전
        setting_page_version_textview.setText(version.toString())
        //업데이트 버튼
        setting_page_update_button_textview.setOnClickListener(update_button)
        //약관보기 버튼
        setting_page_regulation_button_textview.setOnClickListener(regulation_button)
        //스위치 버튼
        setting_page_switch_button.setOnCheckedChangeListener(push_switch)
        //탈퇴하기 버튼
        setting_page_withdraw_button_textview.setOnClickListener(withdraw_button)
        //뒤로 가기 버튼
        setting_page_back_button.setOnClickListener(back_button)
        //메뉴 버튼
        setting_side_menu_button.setOnClickListener(side_menu_button)
        //로그아웃 버튼
        setting_page_logout_button_textview.setOnClickListener(logout_button)


        //사이드 메뉴
        var v : View = side_menu_layout_setting
        com.funidea.utils.side_menu_layout.side_menu_setting_test(setting_drawerlayout, v, this)

        if(student_push_agreement.equals("1"))
        {
            setting_page_switch_button.isChecked = true
        }
        else
        {
            setting_page_switch_button.isChecked = false
        }







    }


    //사이드 메뉴(햄버거)버튼
    val side_menu_button = View.OnClickListener{
        setting_drawerlayout.openDrawer(setting_child_drawerlayout)
    }
    //사이드 메뉴 스탑
    override fun onStop() {
        super.onStop()

        setting_drawerlayout.closeDrawer(setting_child_drawerlayout)
    }

    //로그아웃 버튼
    val logout_button = View.OnClickListener {


        //정말 삭제하시겠습니까 라는 AlertDialog 생성
        val builder = AlertDialog.Builder(this)
        builder.setMessage("로그아웃 하시겠습니까?")
        builder.setPositiveButton("확인") { dialogInterface, i ->


            val prefs: SharedPreferences = getSharedPreferences("user_info", Context.MODE_PRIVATE)
            val edit = prefs.edit()
            edit.clear()
            edit.commit()

            //기존 static value 삭제
            set_clear()

            val intent = Intent(this, SplashActivity::class.java)
            intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_NEW_TASK)
            val bundle = ActivityOptions.makeCustomAnimation(this, R.anim.anim_slide_in_right, R.anim.anim_slide_out_left).toBundle()
            startActivity(intent, bundle)

            dialogInterface.dismiss()
        }
        builder.setNegativeButton("취소") { dialogInterface, i ->
            dialogInterface.dismiss()
        }
        val dialog: AlertDialog = builder.create()
        dialog.show()



    }


    //탈퇴하기 버튼
    val withdraw_button = View.OnClickListener {

        val inputPasswordForResignBottomDialog = input_password_for_resign_bottom_dialog(this)

        inputPasswordForResignBottomDialog.show()


        inputPasswordForResignBottomDialog.setInputPasswordListener(object : input_password_for_resign_bottom_dialog.InputPasswordListener
        {
            override fun input_password(input_password: String?) {

                Log.d("머지?", "input_password:"+input_password)

                student_resign(input_password.toString())
            }


        }
        )




    }

    override fun onResume() {
        super.onResume()

        appUpdateManager.appUpdateInfo
                .addOnSuccessListener {
                    if (it.updateAvailability() == UpdateAvailability.DEVELOPER_TRIGGERED_UPDATE_IN_PROGRESS) {
                        appUpdateManager.startUpdateFlowForResult(
                                it,
                                AppUpdateType.IMMEDIATE,
                                this,
                                MY_REQUEST_CODE)
                    }
                }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        if (requestCode == MY_REQUEST_CODE) {
            if (resultCode != Activity.RESULT_OK) {
                custom_toast(this,"업데이트가 취소 되었습니다.")
            }
        }
    }

    //업데이트 버튼
    val update_button = View.OnClickListener {


        appUpdateManager = AppUpdateManagerFactory.create(this)
        // Returns an intent object that you use to check for an update.
        val appUpdateInfoTask = appUpdateManager.appUpdateInfo



        // Checks that the platform will allow the specified type of update.
        appUpdateInfoTask.addOnSuccessListener { appUpdateInfo ->
            if (appUpdateInfo.updateAvailability() == UpdateAvailability.UPDATE_AVAILABLE
                    // For a flexible update, use AppUpdateType.FLEXIBLE
                    && appUpdateInfo.isUpdateTypeAllowed(AppUpdateType.IMMEDIATE)
            ) {


                try {
                    appUpdateManager.startUpdateFlowForResult(
                            appUpdateInfo,  // 유연한 업데이트 사용 시 (AppUpdateType.FLEXIBLE) 사용
                            AppUpdateType.IMMEDIATE,  // 현재 Activity
                            this,  // 전역변수로 선언해준 Code
                            MY_REQUEST_CODE)
                } catch (e: IntentSender.SendIntentException) {
                    Log.e("AppUpdater", "AppUpdateManager Error", e)
                    e.printStackTrace()
                }

             }
            else
            {
                //Log.d("먼데", ": "+appUpdateInfo.updateAvailability())

                custom_toast(this, "이미 최신 버전입니다.")
            }
        }

    }

    //약관 보기 버튼
    val regulation_button = View.OnClickListener {


        val intent = Intent(this, agreement_main_Activity::class.java)
        startActivity(intent)
        overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)


    }
    //푸시 알림 스위치 버튼
    var push_switch =
        CompoundButton.OnCheckedChangeListener { buttonView, isChecked ->
            if (isChecked) {


                push_agreement_change(student_id, access_token, "1")
                 // Toast.makeText(getApplicationContext(), "푸시 알림 설", Toast.LENGTH_SHORT).show();
                //custom_toast(this@setting_Activity, "푸시 알림 설정이 변경 되었습니다.")

            } else {


                push_agreement_change(student_id, access_token, "0")
                // Toast.makeText(getApplicationContext(), "이벤트 알림 비활성화", Toast.LENGTH_SHORT).show();
                //custom_toast(this@setting_Activity, "푸시 알림 설정이 변경 되었습니다.")
            }
        }


    //faq 목록 가져오기
    fun push_agreement_change(student_id : String, student_token : String, student_push_agreement : String)
    {
        serverConnection!!.push_agreement_change(student_id,student_token, student_push_agreement).enqueue(object : Callback<ResponseBody> {
            override fun onResponse(call: Call<ResponseBody>, response: Response<ResponseBody>)
            {
                try {
                    val result = JSONObject(response.body()!!.string())

                    Log.d("결과값", "onResponse:"+result)

                    var i : Iterator<String>
                    i =  result.keys()

                    if(!i.next().equals("fail"))
                    {
                        access_token = result.getString("student_token")

                        save_shard(this@setting_Activity, access_token)

                        switch_value = switch_value+1;

                        if(switch_value>1)
                        {

                        custom_toast(this@setting_Activity, "푸시 알림 설정이 변경 되었습니다.")
                        }
                    }

                    else{
                        custom_toast(this@setting_Activity, "인터넷 연결 상태를 다시 확인해주세요.")
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

    //클래스 추가하기
    fun student_resign(student_password : String)
    {

        serverConnection!!.student_resign(student_id, access_token, student_password).enqueue(object : Callback<ResponseBody> {
            override fun onResponse(call: Call<ResponseBody>, response: Response<ResponseBody>)
            {
                try {
                    Log.d("흠?", "onResponse:"+ student_id)
                    Log.d("흠?", "onResponse:"+ access_token)
                    Log.d("흠?", "onResponse:"+ student_password)
                    Log.d("흠?", "onResponse:"+call.request().toString())

                    val result = JSONObject(response.body()!!.string())


                    var i : Iterator<String>
                    i =  result.keys()

                    Log.d("결과", "onResponse:"+result)
                    if(!i.next().equals("fail"))
                    {

                        custom_toast(this@setting_Activity, "성공적으로 탈퇴가 완료되었습니다.")

                        val prefs: SharedPreferences = getSharedPreferences("user_info", Context.MODE_PRIVATE)
                        val edit = prefs.edit()
                        edit.clear()
                        edit.commit()

                        //기존 static value 삭제
                        set_clear()

                        val intent = Intent(this@setting_Activity, SplashActivity::class.java)
                        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_NEW_TASK)
                        val bundle = ActivityOptions.makeCustomAnimation(this@setting_Activity, R.anim.anim_slide_in_right, R.anim.anim_slide_out_left).toBundle()
                        startActivity(intent, bundle)

                    }
                    //실패 시
                    else
                    {
                        var fail_result_value = result.getString("fail")


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