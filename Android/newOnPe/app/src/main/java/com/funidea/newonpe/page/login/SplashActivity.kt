package com.funidea.newonpe.page.login

import android.content.Context
import android.content.Intent
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.graphics.drawable.AnimationDrawable
import android.os.Bundle
import android.text.TextUtils
import android.util.Base64
import android.util.Log
import android.view.animation.Animation
import android.view.animation.AnimationUtils
import androidx.annotation.NonNull
import androidx.appcompat.app.AppCompatActivity
import com.funidea.newonpe.R
import com.funidea.utils.CustomToast
import com.funidea.utils.set_User_info
import com.funidea.utils.set_User_info.Companion.access_token
import com.funidea.utils.set_User_info.Companion.fcm_token
import com.funidea.utils.set_User_info.Companion.student_id
import com.funidea.newonpe.page.main.MainHomeActivity
import com.funidea.newonpe.network.ServerConnection
import com.google.android.gms.tasks.OnCompleteListener
import com.google.android.gms.tasks.Task
import com.google.firebase.iid.FirebaseInstanceId
import com.google.firebase.iid.InstanceIdResult
import com.kakao.sdk.common.util.Utility
import kotlinx.android.synthetic.main.activity_splash.*
import okhttp3.ResponseBody
import org.json.JSONException
import org.json.JSONObject
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import java.io.IOException
import java.lang.Exception
import java.security.MessageDigest

/** 스플래시 화면
 *  첫 로그인시 보여질 스플래쉬 화면
 */

class SplashActivity : AppCompatActivity() {

    lateinit var ani: AnimationDrawable
    lateinit var anim : Animation //애니메이션 함수

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_splash)

        ani = splash_image.getDrawable() as AnimationDrawable
        ani.start()


        //애니메이션 함수
        //val anim: Animation
        anim = AnimationUtils.loadAnimation(applicationContext, R.anim.fade_in)

        //화면이 보여지는 애니메이션 시작
        activity_splash.startAnimation(anim)

        Log.d("debug", ">> [complexion] splash_Activity onCreate fcm_token = " + fcm_token)

        if (TextUtils.isEmpty(fcm_token))
        {
            // FCM토큰 검증
            FirebaseInstanceId.getInstance().instanceId.addOnCompleteListener(object : OnCompleteListener<InstanceIdResult?>
            {
                override fun onComplete(@NonNull task: Task<InstanceIdResult?>)
                {
                    if (!task.isSuccessful)
                    {
                        Log.w("토큰", "getInstanceId failed", task.getException())
                        return
                    }
                    //토큰생성
                    fcm_token = task.result!!.token

                    val sharedPreferences = getSharedPreferences("user_info", Context.MODE_PRIVATE)
                    Log.d("debug", ">> [complexion] splash_Activity onCreate sharedPreferences.contains(\"user_id\") ?  = " + sharedPreferences.contains("user_id"))
                    if (sharedPreferences.contains("user_id"))
                    {
                        val user_id: String = sharedPreferences.getString("user_id", "").toString()
                        val user_access_token: String = sharedPreferences.getString("user_access_token", "").toString()
                        Log.d("debug", "++ [complexion] addOnCompleteListener fcm_token = " + fcm_token)
                        login(user_id, user_access_token)
                    }
                    else
                    {
                        anim.setAnimationListener(object : Animation.AnimationListener {
                            override fun onAnimationStart(animation: Animation)
                            {

                            }
                            override fun onAnimationEnd(animation: Animation)
                            {
                                // startActivity(Intent(this@splash_Activity, login_page_Activity::class.java))
                                startActivity(Intent(this@SplashActivity, SNSLoginPage::class.java))
                                finish()
                                overridePendingTransition(R.anim.fade_in, R.anim.fade_out)
                            }
                            override fun onAnimationRepeat(animation: Animation)
                            {

                            }
                        })
                    }
                }
            })
        }
        else
        {
            val intent : Intent = Intent(this, SNSLoginPage::class.java)
            startActivity(intent)
        }

        Log.d("debug", "++ [complexion] onReceiveGoogleLoginResult getKeyHashBase64 = " + getKeyHashBase64())
        Log.d("debug", "++ [complexion] onReceiveGoogleLoginResult getKeyHash = " + Utility.getKeyHash(this))
    }

    companion object {
        // @JvmStatic val baseURL = "https://onpe.co.kr"
        @JvmStatic val baseURL = "https://onpe.co.kr/staging/"
        //@JvmStatic val baseURL = "https://lllloooo.shop"
        @JvmStatic val retrofit: Retrofit = Retrofit.Builder()
                .baseUrl(baseURL)
                .addConverterFactory(GsonConverterFactory.create())
                .build()
        //서버 커넥션
        @JvmStatic var serverConnection: ServerConnection? =  retrofit.create(ServerConnection::class.java)
    }

    fun login(user_id: String?, access_token_1: String?)
    {
        val localRetrofit : Retrofit = Retrofit.Builder().baseUrl("https://onpe.co.kr/staging/").addConverterFactory(GsonConverterFactory.create()).build()
        val localServerConnection : ServerConnection = localRetrofit.create(ServerConnection::class.java)
        localServerConnection.auto_login(user_id, access_token_1, fcm_token).enqueue(object : Callback<ResponseBody> {
            override fun onResponse(call: Call<ResponseBody>, response: Response<ResponseBody>) {
                try {

                    val result = JSONObject(response.body()!!.string())
                    val result_value = result.toString()


                    val iterator : Iterator<String> = result.keys()
                    if (!iterator.next().equals("fail"))
                    {
                        //Toast.makeText(this@login_page_Activity, "아이디와 비밀번호를 다시 확인해주세요.", Toast.LENGTH_SHORT).show()

                        var setUserInfo = set_User_info()
                        setUserInfo.set_user_info(result)

                        CustomToast.show(this@SplashActivity, "자동 로그인이 되었습니다.")

                        val prefs = getSharedPreferences("user_info", Context.MODE_PRIVATE)
                        val editor = prefs.edit()

                        editor.putString("user_id", student_id)
                        editor.putString("user_access_token", access_token)
                        editor.commit()

                        anim.setAnimationListener(object : Animation.AnimationListener
                        {
                            override fun onAnimationStart(animation: Animation)
                            {

                            }
                            override fun onAnimationEnd(animation: Animation)
                            {
                                val intent = Intent(this@SplashActivity, MainHomeActivity::class.java)
                                startActivity(intent)
                                finish()
                                overridePendingTransition(R.anim.fade_in, R.anim.fade_out)
                            }

                            override fun onAnimationRepeat(animation: Animation)
                            {

                            }
                        })
                    }
                    else
                    {
                        //Toast.makeText(this@login_page_Activity, "로그인이 되었습니다.", Toast.LENGTH_SHORT).show()


                        CustomToast.show(this@SplashActivity, "아이디와 비밀번호를 확인해주세요.")
                        anim.setAnimationListener(object : Animation.AnimationListener {
                            override fun onAnimationStart(animation: Animation) {

                            }
                            override fun onAnimationEnd(animation: Animation) {

                                val intent = Intent(this@SplashActivity, EmailLoginPage::class.java)
                                startActivity(intent)
                                finish()
                                overridePendingTransition(R.anim.fade_in, R.anim.fade_out)

                            }

                            override fun onAnimationRepeat(animation: Animation)
                            {


                            }

                        })
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
                Log.d("결과값", "onResponse: "+t)
                Log.d("결과값", "onResponse: "+call)
                val intent = Intent(this@SplashActivity, EmailLoginPage::class.java)
                startActivity(intent)
                finish()
                overridePendingTransition(R.anim.fade_in, R.anim.fade_out)
            }
        })
    }

    override fun onStop()
    {
        super.onStop()
        ani.stop()
    }

    fun getKeyHashBase64(): String?
    {
        var packageInfo : PackageInfo? = null

        try
        {
            packageInfo = packageManager.getPackageInfo(packageName, PackageManager.GET_SIGNATURES)
        }
        catch (e : Exception)
        {
            e.printStackTrace()
        }

        if (packageInfo != null)
        {
            for (signature in packageInfo.signatures)
            {
                try
                {
                    var messageDigest : MessageDigest = MessageDigest.getInstance("SHA")

                    messageDigest.update(signature.toByteArray())
                    return Base64.encodeToString(messageDigest.digest(), Base64.DEFAULT)
                }
                catch (e : Exception)
                {
                    e.printStackTrace()
                }
            }
        }

        return null
    }
}