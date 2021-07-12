package com.funidea.newonpe

import android.annotation.SuppressLint
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.text.TextUtils
import android.util.Log
import android.widget.Button
import android.widget.Toast
import com.funidea.utils.Custom_Toast
import com.funidea.utils.set_User_info
import com.funidea.newonpe.login.login_page_Activity
import com.funidea.newonpe.main_home.MainHomeActivity
import com.funidea.newonpe.retrofit2.ServerConnection
import com.funidea.newonpe.camearutils.DataUtils
import com.google.android.gms.auth.api.signin.GoogleSignIn
import com.google.android.gms.auth.api.signin.GoogleSignInClient
import com.google.android.gms.auth.api.signin.GoogleSignInOptions
import com.google.android.gms.common.api.ApiException
import com.google.firebase.auth.AuthCredential
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.GoogleAuthProvider
import com.kakao.sdk.auth.model.OAuthToken
import com.kakao.sdk.user.UserApiClient
import com.nhn.android.naverlogin.OAuthLogin
import com.nhn.android.naverlogin.OAuthLoginHandler
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
import java.util.concurrent.Executors
import kotlin.concurrent.thread

class SNSLoginPage : CommonActivity()
{
    private val GOOGLE_LOGIN_TRY = 10
    private val KAKAO_LOGIN_TRY = 12
    private val NAVER_LOGIN_TRY = 13

    private lateinit var mGLoginButton : Button
    private lateinit var mNLoginButton : Button
    private lateinit var mKLoginButton : Button
    private lateinit var mELoginButton : Button

    @SuppressLint("CutPasteId")
    override fun init(savedInstanceState: Bundle?)
    {
        setContentView(R.layout.activity_sns_login_page)

        mGLoginButton = findViewById(R.id.snsLoginButton1)
        mGLoginButton.setOnClickListener { onGoogleLoginTry() }
        mNLoginButton = findViewById(R.id.snsLoginButton2)
        mNLoginButton.setOnClickListener { onKaKaoLoginTry() }
        mKLoginButton = findViewById(R.id.snsLoginButton3)
        mKLoginButton.setOnClickListener { onNaverLoginTry() }
        mELoginButton = findViewById(R.id.snsLoginButton4)
        mELoginButton.setOnClickListener {  }
    }

    private fun onNaverLoginTry()
    {
        val loginAuthInstance = OAuthLogin.getInstance();
        loginAuthInstance.init(
                this
                ,getString(R.string.naver_client_id)
                ,getString(R.string.naver_client_secret)
                ,getString(R.string.app_name))

        loginAuthInstance.logout(applicationContext)

        val loginAuthResultHandler = @SuppressLint("HandlerLeak")
        object : OAuthLoginHandler()
        {
            override fun run(success: Boolean)
            {
                Log.d("debug", ">> [complexion] onNaverLoginTry OAuthLoginHandler success = $success")

                if (success)
                {
                    val accessToken = loginAuthInstance.getAccessToken(this@SNSLoginPage)
                    if (!TextUtils.isEmpty(accessToken))
                    {
                        val thread : Thread = thread {
                            val serverUrl : String = "https://openapi.naver.com/v1/nid/me"
                            val userInformation : String = loginAuthInstance.requestApi(this@SNSLoginPage, accessToken, serverUrl)
                            Log.d("debug", ">> [complexion] onNaverLoginTry OAuthLoginHandler accessToken = $accessToken")
                            Log.d("debug", ">> [complexion] onNaverLoginTry OAuthLoginHandler userInformation = $userInformation")
                            if (!TextUtils.isEmpty(userInformation))
                            {
                                try
                                {
                                    val resultObject : JSONObject = JSONObject(userInformation)
                                    val responseObject : JSONObject = resultObject.getJSONObject("response")
                                    val userUniqueId : String? = DataUtils.getStringFromJson(responseObject, "id")
                                    val userEmail : String? = DataUtils.getStringFromJson(responseObject, "email")
                                    val userPhoneNumber : String? = DataUtils.getStringFromJson(responseObject, "mobile")
                                    val userName : String? = DataUtils.getStringFromJson(responseObject, "name")
                                    val userPushAgreement : String = "Y";

                                    Log.d("debug", ">> [complexion] onNaverLoginTry OAuthLoginHandler userId = $userUniqueId")
                                    Log.d("debug", ">> [complexion] onNaverLoginTry OAuthLoginHandler userEmail = $userEmail")
                                    Log.d("debug", ">> [complexion] onNaverLoginTry OAuthLoginHandler userMobile = $userPhoneNumber")
                                    Log.d("debug", ">> [complexion] onNaverLoginTry OAuthLoginHandler userName = $userName")

                                    if (TextUtils.isEmpty(userEmail))
                                    {
                                        // TODO 네이버 프로필 재동의 동작 필요
//                                        val clientId = getString(R.string.naver_client_id)
//                                        var authorizeUrl : String = "https://nid.naver.com/oauth2.0/authorize?"
//                                        authorizeUrl += "response_type=code&"
//                                        authorizeUrl += "response_type=$clientId&"
//                                        authorizeUrl += "state=code&"
//                                        val authorizeInformation : String = loginAuthInstance.requestApi(this@SNSLoginPage, accessToken, authorizeUrl)
//                                        Log.d("debug", ">> [complexion] onNaverLoginTry OAuthLoginHandler authorizeInformation = $authorizeInformation")
                                        Toast.makeText(this@SNSLoginPage, "이메일 정보 제공 동의가 필요합니다", Toast.LENGTH_SHORT).show()
                                    }
                                    else
                                    {
                                        val userId : String = "naver" + userEmail!!.split("@")[0]

                                        var sharedPreferencesSavedToken: String? = ""
                                        val sharedPreferences = getSharedPreferences("user_info", Context.MODE_PRIVATE)
                                        if (sharedPreferences.contains("user_id"))
                                        {
                                            val sharedPreferencesSavedId: String = sharedPreferences.getString("user_id", "").toString()
                                            if (sharedPreferencesSavedId == userId)
                                            {
                                                sharedPreferencesSavedToken = sharedPreferences.getString("user_access_token", "").toString()
                                                Log.d("debug", ">> [complexion] onNaverLoginTry sharedPreferencesSavedId = $sharedPreferencesSavedId")
                                                Log.d("debug", ">> [complexion] onNaverLoginTry sharedPreferencesSavedToken = $sharedPreferencesSavedToken")
                                            }
                                        }

                                        snsLogin(userId, sharedPreferencesSavedToken, "N", userName, userEmail, userPushAgreement, userPhoneNumber)
                                    }

                                }
                                catch (e : Exception)
                                {
                                    e.printStackTrace()
                                }
                            }

                            runOnUiThread {

                            }
                        }

                        val executor = Executors.newFixedThreadPool(1)
                        executor.execute(thread)
                    }
                }
            }
        }

        loginAuthInstance.startOauthLoginActivity(this, loginAuthResultHandler)

    }

    private fun onGoogleLoginTry()
    {
        Log.d("debug", ">> [complexion] onGoogleLoginTry ")

        val googleSignInOptions = GoogleSignInOptions.Builder(GoogleSignInOptions.DEFAULT_SIGN_IN)
                .requestIdToken(getString(R.string.default_web_client_id))
                .requestEmail()
                .build()

        val googleSignInClient : GoogleSignInClient = GoogleSignIn.getClient(this, googleSignInOptions)
        googleSignInClient.signOut()

        val googleSignInIntent = googleSignInClient.signInIntent
        startActivityForResult(googleSignInIntent, GOOGLE_LOGIN_TRY)
    }

    private fun onKaKaoLoginTry()
    {
        UserApiClient.instance.logout {  }

        val callBack : (OAuthToken?, Throwable?) -> Unit = { token, error ->

            if (token != null && error == null)
            {
                Log.d("debug", ">> [complexion] onKaKaoLoginTry token accessToken = " + token.accessToken)

                UserApiClient.instance.me { user, userInfoError ->

                    if (user != null && userInfoError == null)
                    {
                        Log.d("debug", ">> [complexion] onKaKaoLoginTry user id = " + user.id)
                        Log.d("debug", ">> [complexion] onKaKaoLoginTry user email = " + (user.kakaoAccount?.email ?: ""))
                        Log.d("debug", ">> [complexion] onKaKaoLoginTry user nickname = " + (user.kakaoAccount?.profile?.nickname ?: ""))

                        val userId : String = user.id.toString()
                        val userEmail : String = (user.kakaoAccount?.email ?: "N/A")
                        val userName : String = (user.kakaoAccount?.profile?.nickname ?: "N/A")
                        val userPushAgreement : String = "Y";
                        val userPhoneNumber : String = (user.kakaoAccount?.phoneNumber ?: "N/A")

                        var sharedPreferencesSavedToken: String? = ""
                        val sharedPreferences = getSharedPreferences("user_info", Context.MODE_PRIVATE)
                        if (sharedPreferences.contains("user_id"))
                        {
                            val sharedPreferencesSavedId: String = sharedPreferences.getString("user_id", "").toString()
                            if (sharedPreferencesSavedId == userId)
                            {
                                sharedPreferencesSavedToken = sharedPreferences.getString("user_access_token", "").toString()
                                Log.d("debug", ">> [complexion] onKaKaoLoginTry sharedPreferencesSavedId = $sharedPreferencesSavedId")
                                Log.d("debug", ">> [complexion] onKaKaoLoginTry sharedPreferencesSavedToken = $sharedPreferencesSavedToken")
                            }
                        }

                        snsLogin(userId, sharedPreferencesSavedToken, "K", userName, userEmail, userPushAgreement, userPhoneNumber)
                    }
                }
            }
        }

        if (UserApiClient.instance.isKakaoTalkLoginAvailable(this))
        {
            UserApiClient.instance.loginWithKakaoTalk(this, callback = callBack)
        }
        else
        {
            UserApiClient.instance.loginWithKakaoAccount(this, callback = callBack)
        }
    }

    private fun onReceiveGoogleLoginResult(requestCode: Int, resultCode: Int, data: Intent?)
    {
        Log.d("debug", "++ [complexion] onReceiveGoogleLoginResult requestCode : $requestCode resultCode = $resultCode")

        val googleSignInTask = GoogleSignIn.getSignedInAccountFromIntent(data)

        try
        {
            val googleAccount = googleSignInTask.getResult(ApiException::class.java)
            val googleAccountIdToken : String? = googleAccount.idToken
            val googleCredential : AuthCredential = GoogleAuthProvider.getCredential(googleAccountIdToken, null)

            val firebaseAuth : FirebaseAuth = FirebaseAuth.getInstance()
            firebaseAuth.signInWithCredential(googleCredential).addOnCompleteListener(this) { task ->

                Log.d("debug", "++ [complexion] onReceiveGoogleLoginResult task.isSuccessful : " + task.isSuccessful)

                if (task.isSuccessful)
                {
                    val user = firebaseAuth.currentUser

                    Log.d("debug", "++ [complexion] onReceiveGoogleLoginResult email = " + (user?.email ?: ""))
                    Log.d("debug", "++ [complexion] onReceiveGoogleLoginResult tenantId = " + (user?.tenantId ?: ""))
                    Log.d("debug", "++ [complexion] onReceiveGoogleLoginResult phoneNumber = " + (user?.phoneNumber ?: ""))
                    Log.d("debug", "++ [complexion] onReceiveGoogleLoginResult displayName = " + (user?.displayName ?: ""))

                    val userEmail : String = (user?.email ?: "")
                    if (!TextUtils.isEmpty(userEmail))
                    {
                        val userId : String = "google" + userEmail.split("@")[0]
                        val userName : String = (user?.displayName ?: "N/A")
                        val userPushAgreement : String = "Y";
                        val userPhoneNumber : String = (user?.phoneNumber ?: "N/A")

                        var sharedPreferencesSavedToken: String? = ""
                        val sharedPreferences = getSharedPreferences("user_info", Context.MODE_PRIVATE)
                        if (sharedPreferences.contains("user_id"))
                        {
                            val sharedPreferencesSavedId: String = sharedPreferences.getString("user_id", "").toString()
                            if (sharedPreferencesSavedId == userId)
                            {
                                sharedPreferencesSavedToken = sharedPreferences.getString("user_access_token", "").toString()
                                Log.d("debug", ">> [complexion] onReceiveGoogleLoginResult sharedPreferencesSavedId = $sharedPreferencesSavedId")
                                Log.d("debug", ">> [complexion] onReceiveGoogleLoginResult sharedPreferencesSavedToken = $sharedPreferencesSavedToken")
                            }
                        }

                        snsLogin(userId, sharedPreferencesSavedToken, "G", userName, userEmail, userPushAgreement, userPhoneNumber)
                    }
                }
                else
                {
                    Log.d("debug", "++ [complexion] onReceiveGoogleLoginResult exception = " + task.exception)
                }
            }
        }
        catch (e : Exception)
        {
            e.printStackTrace()
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?)
    {
        super.onActivityResult(requestCode, resultCode, data)

        when (requestCode)
        {
            GOOGLE_LOGIN_TRY ->
            {
                onReceiveGoogleLoginResult(requestCode, resultCode, data)
            }
        }
    }


    fun snsLogin(user_id: String?, access_token_1: String?, loginType : String?, student_name : String?, student_email : String?, student_push_agreement : String?, student_phone_number : String?)
    {
        val localRetrofit : Retrofit = Retrofit.Builder().baseUrl("https://onpe.co.kr/staging/").addConverterFactory(GsonConverterFactory.create()).build()
        val localServerConnection : ServerConnection = localRetrofit.create(ServerConnection::class.java)
        localServerConnection.auto_sns_login(user_id, access_token_1, set_User_info.fcm_token, loginType, student_name, student_email, student_push_agreement, student_phone_number).enqueue(object : Callback<ResponseBody> {
            override fun onResponse(call: Call<ResponseBody>, response: Response<ResponseBody>) {
                try {

                    val result = JSONObject(response.body()!!.string())
                    val result_value = result.toString()

                    Log.d("debug", "++ [complexion] snsLogin onResponse result_value = $result_value")
                    val iterator : Iterator<String> = result.keys()
                    if (iterator.next() != "fail")
                    {
                        var setUserInfo = set_User_info()
                        setUserInfo.set_user_info(result)

                        Custom_Toast.custom_toast(this@SNSLoginPage, "자동 로그인이 되었습니다.")

                        val prefs = getSharedPreferences("user_info", Context.MODE_PRIVATE)
                        val editor = prefs.edit()

                        editor.putString("user_id", set_User_info.student_id)
                        editor.putString("user_access_token", set_User_info.access_token)
                        editor.commit()

                        val intent = Intent(this@SNSLoginPage, MainHomeActivity::class.java)
                        startActivity(intent)
                        finish()
                        overridePendingTransition(R.anim.fade_in, R.anim.fade_out)
                    }
                    else
                    {

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
                val intent = Intent(this@SNSLoginPage, login_page_Activity::class.java)
                startActivity(intent)
                finish()
                overridePendingTransition(R.anim.fade_in, R.anim.fade_out)
            }
        })
    }
}