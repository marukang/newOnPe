package com.funidea.newonpe.page.login

import android.annotation.SuppressLint
import android.net.http.SslError
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.view.View
import android.webkit.*
import com.funidea.newonpe.R
import com.funidea.newonpe.dialog.CommonDialog
import com.funidea.newonpe.network.NetworkConstants
import com.funidea.newonpe.network.ServerConnectionSpec
import com.funidea.newonpe.page.CommonActivity
import com.google.android.gms.common.util.DataUtils
import okhttp3.MediaType
import okhttp3.RequestBody
import okhttp3.ResponseBody
import org.json.JSONObject
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

class SMSAuthPage : CommonActivity()
{
    companion object
    {
        const val CALL : Int = 1000
    }

    lateinit var mAuthWebView : WebView

    @SuppressLint("SetJavaScriptEnabled", "ObsoleteSdkInt", "JavascriptInterface")
    override fun init(savedInstanceState: Bundle?)
    {
        setContentView(R.layout.activity_sms_auth_page)

        val webUrlLocal = "file:///android_asset/auth.html"
        mAuthWebView = findViewById(R.id.authWebView)
        mAuthWebView.apply {

            settings.javaScriptEnabled = true
            settings.javaScriptCanOpenWindowsAutomatically = true
            settings.setRenderPriority(WebSettings.RenderPriority.HIGH)
            settings.cacheMode = WebSettings.LOAD_NO_CACHE

            webChromeClient = CustomChromeClient()
            webViewClient = CustomWebViewClient()

            setLayerType(View.LAYER_TYPE_HARDWARE, null)

            scrollBarStyle = WebView.SCROLLBARS_OUTSIDE_OVERLAY
            isScrollbarFadingEnabled = true

            addJavascriptInterface(WebViewBridge(), "Bridge")

            if (Build.VERSION.SDK_INT >= 19)
            {
                setLayerType(View.LAYER_TYPE_HARDWARE, null)
            }
            else
            {
                setLayerType(View.LAYER_TYPE_SOFTWARE, null)
            }
            loadUrl(webUrlLocal)
        }
    }

    override fun onBackPressed() {
        super.onBackPressed()
        overridePendingTransition(R.anim.anim_slide_in_left, R.anim.anim_slide_out_right)
    }

    private fun readUserCertification(impUid : String?, accessToken : String)
    {
        val headerMap : HashMap<String, String> = hashMapOf()
        headerMap["Authorization"] = accessToken

        val targetUrl = "certifications/$impUid"
        val retrofit : Retrofit = Retrofit.Builder()
            .baseUrl("https://api.iamport.kr/")
            .addConverterFactory(GsonConverterFactory.create())
            .build()
        val serverConnectionSpec : ServerConnectionSpec = retrofit.create(ServerConnectionSpec::class.java)
        serverConnectionSpec.get_import_certification(targetUrl, headerMap).enqueue(object : Callback<ResponseBody>
        {
            override fun onResponse(call: Call<ResponseBody>, response: Response<ResponseBody>) {
                val result = JSONObject(response.body()!!.string())
                val body = result.getJSONObject("response")

                showDialog("알림", "본인 인증이 완료 되었습니다", buttonCount = CommonDialog.ButtonCount.ONE) {

                    intent.putExtra("user", body.toString())

                    setResult(RESULT_OK, intent)

                    onBackPressed()
                    finish()
                }
            }

            override fun onFailure(call: Call<ResponseBody>, response: Throwable)
            {
                showDialog("알림", "인증 처리중에 에러가 발생하였습니다 잠시후에 다시 시도해주세요", buttonCount = CommonDialog.ButtonCount.ONE) {
                    onBackPressed()
                    finish()
                }
            }
        })
    }


    private open inner class WebViewBridge
    {
        @JavascriptInterface
        fun onReceiveResult(impUid : String?)
        {
            val impApiKey = "2276808630618829"
            val impApiSecret = "1s3PGT7T7SzZXpFjrjskaFhtVUB9jRmlkpb0jjUqctq9T5skpUFAAX3vRFFbw1xRrISK1MbdgBn9HPu6"

            val retrofit : Retrofit = Retrofit.Builder()
                .baseUrl("https://api.iamport.kr/")
                .addConverterFactory(GsonConverterFactory.create())
                .build()
            val serverConnectionSpec : ServerConnectionSpec = retrofit.create(ServerConnectionSpec::class.java)
            serverConnectionSpec.get_import_token(impApiKey, impApiSecret).enqueue(object : Callback<ResponseBody> {
                override fun onResponse(call: Call<ResponseBody>, response : Response<ResponseBody>)
                {
                    val result = JSONObject(response.body()!!.string())
                    val body = result.getJSONObject("response")
                    val accessToken = body.getString("access_token")

                    readUserCertification(impUid, accessToken)
                }

                override fun onFailure(call: Call<ResponseBody>, response: Throwable)
                {
                    showDialog("알림", "인증 처리중에 에러가 발생하였습니다 잠시후에 다시 시도해주세요", buttonCount = CommonDialog.ButtonCount.ONE) {
                        onBackPressed()
                        finish()
                    }
                }
            })
        }

        @JavascriptInterface
        fun onReceiveErrorMessage(result : Any?)
        {
            showDialog("알림", " 에러발생  =[$result]", buttonCount = CommonDialog.ButtonCount.ONE) {
                onBackPressed()
                finish()
            }
        }
    }

    private inner class CustomChromeClient : WebChromeClient()
    {
        override fun onProgressChanged(view: WebView?, newProgress: Int)
        {
            super.onProgressChanged(view, newProgress)
        }
    }

    private class CustomWebViewClient : WebViewClient()
    {

        override fun shouldOverrideUrlLoading(view: WebView?, request: WebResourceRequest?): Boolean
        {
            val url: String = request?.url.toString()
            view?.loadUrl(url)

            return super.shouldOverrideUrlLoading(view, request)
        }

        override fun onReceivedSslError(view: WebView?, handler: SslErrorHandler?, error: SslError?)
        {

            handler?.proceed()
        }
    }
}