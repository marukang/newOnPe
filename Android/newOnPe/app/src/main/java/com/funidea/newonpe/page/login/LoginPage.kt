package com.funidea.newonpe.page.login

import android.animation.Animator
import android.animation.AnimatorListenerAdapter
import android.animation.AnimatorSet
import android.animation.ObjectAnimator
import android.annotation.SuppressLint
import android.content.Context
import android.content.Intent
import android.graphics.drawable.AnimationDrawable
import android.os.Bundle
import android.text.TextUtils
import android.util.*
import android.view.View
import android.view.ViewGroup
import android.view.animation.AnimationUtils
import android.widget.*
import androidx.annotation.NonNull
import com.funidea.newonpe.R
import com.funidea.newonpe.camera.DataUtils
import com.funidea.newonpe.dialog.CommonDialog
import com.funidea.newonpe.model.CurrentLoginStudent
import com.funidea.newonpe.model.Student
import com.funidea.newonpe.network.ServerConnection
import com.funidea.utils.set_User_info
import com.funidea.utils.set_User_info.Companion.fcm_token
import com.funidea.newonpe.page.main.MainHomeActivity
import com.funidea.newonpe.network.ServerConnectionSpec
import com.funidea.newonpe.page.CommonActivity
import com.funidea.newonpe.page.main.MainHomePage
import com.funidea.newonpe.services.MyFirebaseMessagingService
import com.funidea.utils.UtilityUI
import com.google.android.gms.auth.api.signin.GoogleSignIn
import com.google.android.gms.auth.api.signin.GoogleSignInClient
import com.google.android.gms.auth.api.signin.GoogleSignInOptions
import com.google.android.gms.common.api.ApiException
import com.google.android.gms.tasks.OnCompleteListener
import com.google.android.gms.tasks.Task
import com.google.firebase.auth.AuthCredential
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.GoogleAuthProvider
import com.google.firebase.iid.FirebaseInstanceId
import com.google.firebase.iid.InstanceIdResult
import com.kakao.sdk.auth.model.OAuthToken
import com.kakao.sdk.user.UserApiClient
import com.nhn.android.naverlogin.OAuthLogin
import com.nhn.android.naverlogin.OAuthLoginHandler
import kotlinx.android.synthetic.main.activity_splash.*
import org.json.JSONObject
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import java.lang.Exception
import java.util.concurrent.Executors
import kotlin.concurrent.thread

/** 스플래시 화면
 *  첫 로그인시 보여질 스플래쉬 화면
 */

class LoginPage : CommonActivity() {

    var mAnimationDrawable: AnimationDrawable? = null

    private val GOOGLE_LOGIN_TRY = 10
    private val CHANGE_PROFILE_NAME_PICTURE = 20

    private lateinit var mTitleView1 : TextView
    private lateinit var mTitleView2 : TextView
    private lateinit var mGLoginButton : View
    private lateinit var mNLoginButton : View
    private lateinit var mKLoginButton : View
    private lateinit var mELoginButton : View
    private lateinit var mLogoImageView : View

    override fun init(savedInstanceState: Bundle?)
    {
        setContentView(R.layout.activity_splash)

        mAnimationDrawable = splash_image.drawable as AnimationDrawable
        mAnimationDrawable?.start()

        mTitleView1 = findViewById(R.id.splashTitle1)
        mTitleView2 = findViewById(R.id.splashTitle2)
        mGLoginButton = findViewById(R.id.snsLoginButton1)
        mGLoginButton.setOnClickListener { onGoogleLoginTry() }
        mNLoginButton = findViewById(R.id.snsLoginButton2)
        mNLoginButton.setOnClickListener { onKaKaoLoginTry() }
        mKLoginButton = findViewById(R.id.snsLoginButton3)
        mKLoginButton.setOnClickListener { onNaverLoginTry() }
        mELoginButton = findViewById(R.id.snsLoginButton4)
        mELoginButton.setOnClickListener {
            val intent = Intent(this@LoginPage, EmailLoginPage::class.java)
            startActivity(intent)
            overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)
        }
        mLogoImageView = findViewById(R.id.splash_image)

        val anim = AnimationUtils.loadAnimation(applicationContext, R.anim.fade_in)
        activity_splash.startAnimation(anim)

        if (TextUtils.isEmpty(fcm_token))
        {
            // FCM토큰 검증
            FirebaseInstanceId.getInstance().instanceId.addOnCompleteListener(object : OnCompleteListener<InstanceIdResult?>
            {
                override fun onComplete(@NonNull task: Task<InstanceIdResult?>)
                {
                    if (!task.isSuccessful)
                    {
                        Log.w("debug", "-- [complexion] onComplete failed exception = ", task.exception)
                        return
                    }
                    //토큰생성
                    MyFirebaseMessagingService.mDeviceToken = task.result!!.token

                    val sharedPreferences = getSharedPreferences("user_info", Context.MODE_PRIVATE)
                    val userid: String = sharedPreferences.getString("user_id", "").toString()
                    val userAccessToken: String = sharedPreferences.getString("user_access_token", "").toString()

                    if (!TextUtils.isEmpty(userid) && !TextUtils.isEmpty(userAccessToken))
                    {
                        ServerConnection.autoLogin(userid, userAccessToken) { code, response ->

                            if (code > 0)
                            {
                                showMainPage(response as Student)
                            }
                            else
                            {
                                showSNSLoginButtonFrame()
                            }
                        }
                    }
                    else
                    {
                        showSNSLoginButtonFrame()
                    }
                }
            })
        }
        else
        {
            showSNSLoginButtonFrame()
        }
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
        @JvmStatic var serverConnectionSpec: ServerConnectionSpec? =  retrofit.create(
            ServerConnectionSpec::class.java)
    }

    private fun showMainPage(student : Student)
    {
        CurrentLoginStudent.root = student

        val preferences = getSharedPreferences("user_info", Context.MODE_PRIVATE)
        val editor = preferences.edit()

        editor.putString("user_id", CurrentLoginStudent.root!!.student_id)
        editor.putString("user_access_token", CurrentLoginStudent.root!!.access_token)
        editor.commit()

        UtilityUI.setAnimationEffectBounce(mLogoImageView, 1000) {

            if (TextUtils.isEmpty(CurrentLoginStudent.root!!.student_name))
            {
                val intent = Intent(this@LoginPage, ProfileRegistrationPage::class.java)
                startActivityForResult(intent, CHANGE_PROFILE_NAME_PICTURE)
                overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)
            }
            else
            {
                mAnimationDrawable?.stop()
                mAnimationDrawable = null

                val intent = Intent(this@LoginPage, MainHomePage::class.java)
                startActivity(intent)
                finish()
                overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)
            }
        }
    }

    @SuppressLint("Recycle")
    private fun showSNSLoginButtonFrame()
    {
        val property1 : Property<TextView, Float> = object : FloatProperty<TextView>("textSize")
        {
            override fun setValue(p0: TextView?, p1: Float)
            {
                p0?.setTextSize(TypedValue.COMPLEX_UNIT_DIP, p1)
            }

            override fun get(p0: TextView?): Float
            {
                return p0?.textSize ?: 0f
            }
        }
        val property2 : Property<View, Int> = object : IntProperty<View>("topMargin")
        {
            var savedMargin = 0

            override fun get(p0: View?): Int
            {
                return savedMargin
            }

            override fun setValue(v: View?, p1: Int)
            {
                if (v?.layoutParams is LinearLayout.LayoutParams)
                {
                    (v.layoutParams as LinearLayout.LayoutParams).topMargin = p1
                }
            }
        }
        val property3 : Property<ViewGroup, Int> = object : IntProperty<ViewGroup>("padding")
        {
            var savedMargin = 0

            override fun get(p0: ViewGroup?): Int
            {
                return savedMargin
            }

            override fun setValue(v: ViewGroup?, p1: Int)
            {
                v?.setPadding(p1, 0, p1, 0)
            }
        }

        val objectAnimator1 : ObjectAnimator = ObjectAnimator.ofFloat(splashTitle1, property1, 30f, 20.8f)
        objectAnimator1.duration = 1000
        val objectAnimator2 : ObjectAnimator = ObjectAnimator.ofFloat(splashTitle2, property1, 40f, 28.6f)
        objectAnimator2.duration = 1000
        val objectAnimator3 : ObjectAnimator = ObjectAnimator.ofInt(splashTitle1, property2,
            TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 100f, resources.displayMetrics).toInt(),
            TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 60f, resources.displayMetrics).toInt())
        objectAnimator3.duration = 1000
        val objectAnimator4 : ObjectAnimator = ObjectAnimator.ofInt(splash_image, property2,
            TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 60f, resources.displayMetrics).toInt(),
            TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 15f, resources.displayMetrics).toInt())
        objectAnimator4.duration = 1000
        val objectAnimator5 : ObjectAnimator = ObjectAnimator.ofInt(contentFrame, property3,
            TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 40f, resources.displayMetrics).toInt(),
            TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 23.4f, resources.displayMetrics).toInt())
        objectAnimator5.duration = 1000

        val animatorSet = AnimatorSet()
        animatorSet.playTogether(objectAnimator1, objectAnimator2, objectAnimator3, objectAnimator4, objectAnimator5)
        animatorSet.startDelay = 1000
        animatorSet.addListener(object : AnimatorListenerAdapter()
        {
            override fun onAnimationEnd(animation: Animator?) {
                super.onAnimationEnd(animation)

                snsLoginFrame.visibility = View.VISIBLE
                snsLoginFrame.animate().alpha(1.0f)
            }
        })
        animatorSet.start()
    }

    private fun rollbackSNSLoginButtonFrame()
    {
        val property1 : Property<TextView, Float> = object : FloatProperty<TextView>("textSize")
        {
            override fun setValue(p0: TextView?, p1: Float)
            {
                p0?.setTextSize(TypedValue.COMPLEX_UNIT_DIP, p1)
            }

            override fun get(p0: TextView?): Float
            {
                return p0?.textSize ?: 0f
            }
        }
        val property2 : Property<View, Int> = object : IntProperty<View>("topMargin")
        {
            var savedMargin = 0

            override fun get(p0: View?): Int
            {
                return savedMargin
            }

            override fun setValue(v: View?, p1: Int)
            {
                if (v?.layoutParams is LinearLayout.LayoutParams)
                {
                    (v.layoutParams as LinearLayout.LayoutParams).topMargin = p1
                }
            }
        }
        val property3 : Property<ViewGroup, Int> = object : IntProperty<ViewGroup>("padding")
        {
            var savedMargin = 0

            override fun get(p0: ViewGroup?): Int
            {
                return savedMargin
            }

            override fun setValue(v: ViewGroup?, p1: Int)
            {
                v?.setPadding(p1, 0, p1, 0)
            }
        }

        val objectAnimator0 : ObjectAnimator = ObjectAnimator.ofFloat(snsLoginFrame, "Alpha", 1.0f, 0.0f)
        objectAnimator0.duration = 500
        val objectAnimator1 : ObjectAnimator = ObjectAnimator.ofFloat(splashTitle1, property1, 20.8f, 30f)
        objectAnimator1.duration = 1000
        val objectAnimator2 : ObjectAnimator = ObjectAnimator.ofFloat(splashTitle2, property1, 28.6f, 40f)
        objectAnimator2.duration = 1000
        val objectAnimator3 : ObjectAnimator = ObjectAnimator.ofInt(splashTitle1, property2,
            TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 60f, resources.displayMetrics).toInt(),
            TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 100f, resources.displayMetrics).toInt())
        objectAnimator3.duration = 1000
        val objectAnimator4 : ObjectAnimator = ObjectAnimator.ofInt(splash_image, property2,
            TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 15f, resources.displayMetrics).toInt(),
            TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 60f, resources.displayMetrics).toInt())
        objectAnimator4.duration = 1000
        val objectAnimator5 : ObjectAnimator = ObjectAnimator.ofInt(contentFrame, property3,
            TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 23.4f, resources.displayMetrics).toInt(),
            TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 40f, resources.displayMetrics).toInt())
        objectAnimator5.duration = 1000

        val animatorSet = AnimatorSet()
        animatorSet.playTogether(objectAnimator0, objectAnimator1, objectAnimator2, objectAnimator3, objectAnimator4, objectAnimator5)
        animatorSet.startDelay = 1000
        animatorSet.addListener(object : AnimatorListenerAdapter()
        {
            override fun onAnimationEnd(animation: Animator?) {
                super.onAnimationEnd(animation)

                UtilityUI.setAnimationEffectBounce(mLogoImageView, 1000) {

                    mAnimationDrawable?.stop()
                    mAnimationDrawable = null

                    val intent = Intent(this@LoginPage, MainHomePage::class.java)
                    startActivity(intent)
                    finish()
                    overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)
                }
            }
        })
        animatorSet.start()
    }

    override fun onStop()
    {
        super.onStop()

        mAnimationDrawable?.stop()
        mAnimationDrawable = null
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
                if (success)
                {
                    val accessToken = loginAuthInstance.getAccessToken(this@LoginPage)
                    if (!TextUtils.isEmpty(accessToken))
                    {
                        val thread : Thread = thread {
                            val serverUrl : String = "https://openapi.naver.com/v1/nid/me"
                            val userInformation : String = loginAuthInstance.requestApi(this@LoginPage, accessToken, serverUrl)

                            if (!TextUtils.isEmpty(userInformation))
                            {
                                try
                                {
                                    val resultObject = JSONObject(userInformation)
                                    val responseObject : JSONObject = resultObject.getJSONObject("response")
                                    val userUniqueId : String? = DataUtils.getStringFromJson(responseObject, "id")
                                    val userEmail : String? = DataUtils.getStringFromJson(responseObject, "email")
                                    val userPhoneNumber : String? = DataUtils.getStringFromJson(responseObject, "mobile")
                                    val userPushAgreement = "Y";

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
                                        Toast.makeText(this@LoginPage, "이메일 정보 제공 동의가 필요합니다", Toast.LENGTH_SHORT).show()
                                    }
                                    else
                                    {
                                        val userId : String = "naver" + userEmail!!.split("@")[0]

                                        var sharedPreferencesSavedToken: String? = ""
                                        val sharedPreferences = getSharedPreferences("user_info", MODE_PRIVATE)
                                        if (sharedPreferences.contains("user_id"))
                                        {
                                            val sharedPreferencesSavedId: String = sharedPreferences.getString("user_id", "").toString()
                                            if (sharedPreferencesSavedId == userId)
                                            {
                                                sharedPreferencesSavedToken = sharedPreferences.getString("user_access_token", "").toString()
                                            }
                                        }
                                        snsLogin(userId, "N", userEmail, userPushAgreement, userPhoneNumber)
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
                UserApiClient.instance.me { user, userInfoError ->

                    if (user != null && userInfoError == null)
                    {
                        val userId : String = user.id.toString()
                        val userEmail : String = (user.kakaoAccount?.email ?: "N/A")
                        val userPushAgreement : String = "Y";
                        val userPhoneNumber : String = (user.kakaoAccount?.phoneNumber ?: "N/A")

                        snsLogin(userId, "K", userEmail, userPushAgreement, userPhoneNumber)
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
        val googleSignInTask = GoogleSignIn.getSignedInAccountFromIntent(data)

        try
        {
            val googleAccount = googleSignInTask.getResult(ApiException::class.java)
            val googleAccountIdToken : String? = googleAccount.idToken
            val googleCredential : AuthCredential = GoogleAuthProvider.getCredential(googleAccountIdToken, null)

            val firebaseAuth : FirebaseAuth = FirebaseAuth.getInstance()
            firebaseAuth.signInWithCredential(googleCredential).addOnCompleteListener(this) { task ->

                if (task.isSuccessful)
                {
                    val user = firebaseAuth.currentUser

                    val userEmail : String = (user?.email ?: "")
                    if (!TextUtils.isEmpty(userEmail))
                    {
                        val userId : String = "google" + userEmail.split("@")[0]
                        val userPushAgreement : String = "Y";
                        val userPhoneNumber : String = (user?.phoneNumber ?: "N/A")

                        snsLogin(userId, "G", userEmail, userPushAgreement, userPhoneNumber)
                    }
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

            CHANGE_PROFILE_NAME_PICTURE ->
            {
                val alpha = snsLoginFrame.alpha
                if (alpha != 0.0f)
                {
                    rollbackSNSLoginButtonFrame()
                }
                else
                {
                    UtilityUI.setAnimationEffectBounce(mLogoImageView, 1000) {

                        mAnimationDrawable?.stop()
                        mAnimationDrawable = null

                        val intent = Intent(this@LoginPage, MainHomePage::class.java)
                        startActivity(intent)
                        finish()
                        overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)
                    }
                }
            }
        }
    }

    fun snsLogin(userId: String?, loginType : String?, student_email : String?, student_push_agreement : String?, student_phone_number : String?)
    {
        val fcmToken = MyFirebaseMessagingService.mDeviceToken

        var sharedPreferencesSavedToken: String? = ""
        val sharedPreferences = getSharedPreferences("user_info", Context.MODE_PRIVATE)
        if (sharedPreferences.contains("user_id"))
        {
            val sharedPreferencesSavedId : String = sharedPreferences.getString("user_id", "").toString()
            if (sharedPreferencesSavedId == userId && !TextUtils.isEmpty(sharedPreferencesSavedId))
            {
                sharedPreferencesSavedToken = sharedPreferences.getString("user_access_token", "").toString()
            }
        }

        val callBack : (Int?, Any?) -> Unit = { code, response ->

            when {
                code!! > -1 -> {
                    showMainPage(response as Student)
                }
                code == -1 -> {
                    showDialog("알림", "입력한 아이디 및 패스워드를 다시 확인해주세요", buttonCount = CommonDialog.ButtonCount.ONE)
                }
                else -> {
                    showDialog("알림", "서버와 통신중에 오류가 발생하였습니다. 다시 시도하여 주세요", buttonCount = CommonDialog.ButtonCount.ONE)
                }
            }
        }

        ServerConnection.snsLogin(userId, sharedPreferencesSavedToken, fcmToken, loginType, student_email, student_push_agreement, student_phone_number, callback = callBack)
    }
}