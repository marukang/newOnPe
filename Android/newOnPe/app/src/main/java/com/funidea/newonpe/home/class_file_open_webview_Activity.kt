package com.funidea.newonpe.home

import android.os.Bundle
import android.view.View
import android.webkit.WebSettings
import androidx.appcompat.app.AppCompatActivity
import com.bumptech.glide.Glide
import com.bumptech.glide.RequestManager
import com.bumptech.glide.load.engine.DiskCacheStrategy
import com.funidea.newonpe.R
import com.funidea.newonpe.SplashActivity.Companion.baseURL
import kotlinx.android.synthetic.main.activity_class_file_open_webview.*

/** Class Unit Activity(차시별 클래스 Home) 에 있는
 *  첨부파일 혹은 관련 링크를 클릭 시 해당 사진 혹은 사이트를 띄어주는 Class
 *
 *  선생님이 등록한 파일 혹은 링크에 따라 사진의 경우 사진을 띄어주며(png, jpg, jpeg 확장자)
 *  PDF의 경우 구글 PDF를 통해 PDF를 모바일 환경에서 확일 할 수 있도록 해준다.
 *
 */

class class_file_open_webview_Activity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_class_file_open_webview)

        var get_Intent = intent

        var load_url = get_Intent.getStringExtra("get_URL").toString()


        //웹뷰 선언 & 첫 메인화면 Url
        //컨텐츠 사이즈 맞추기
        //1.구버전
        class_file_open_webview.getSettings().setLayoutAlgorithm(WebSettings.LayoutAlgorithm.SINGLE_COLUMN)
        //2.최신버전
        class_file_open_webview.getSettings().setLoadWithOverviewMode(true)
        //스크롤이 설정 - 스크롤이 bar가 보이지 않도록 해준다.



        //스크롤이 설정 - 스크롤이 bar가 보이지 않도록 해준다.
        class_file_open_webview.setVerticalScrollBarEnabled(false)
        class_file_open_webview.setHorizontalScrollBarEnabled(false)
        var webSettings : WebSettings
        webSettings = class_file_open_webview.getSettings()



        webSettings.setUseWideViewPort(true); // wide viewport를 사용하도록 설정
        webSettings.setLoadWithOverviewMode(true);// 컨텐츠가 웹뷰보다 클 경우 스크린 크기에 맞게 조정

        // 웹뷰 멀티 터치 가능하게 (줌기능)
        webSettings.setBuiltInZoomControls(true);   // 줌 아이콘 사용
        webSettings.setSupportZoom(true)    // 줌 기능
        webSettings.setDisplayZoomControls(true) // 줌 컨트롤 가능
        webSettings.setJavaScriptEnabled(true) // 자바스크립트 사용이 가능
        webSettings.setDomStorageEnabled(true) // localStorage 사용을 위해


        //해당 링크가 youtube 영상인 경우
        if(load_url.contains("https://")||load_url.contains("youtu.be")||load_url.contains("www.youtube.com"))
        {
            //링크 열기
            class_file_open_webview.loadUrl(load_url)
        }
        //해당 참고 자료 혹은 링크가 pdf 형식으로 되어 있는 경우
        else if(load_url.contains("pdf"))
        {

            var base_pdf_url = "docs.google.com/gview?embedded=true&url="
            //첨부파일 pdf 열기
            class_file_open_webview.loadUrl(base_pdf_url+baseURL+load_url)
        }
        //첨부파일이 jpg, jpeg, png 의 확장자를 가진 사진인 경우
        else if(load_url.contains("jpg")||load_url.contains("jpeg")||load_url.contains("png"))
        {
            class_file_open_imageview.visibility = View.VISIBLE

            var mGlideRequestManager : RequestManager
            mGlideRequestManager = Glide.with(this)
            mGlideRequestManager.load(baseURL+load_url)
                    .diskCacheStrategy(DiskCacheStrategy.NONE)
                    .skipMemoryCache(true)
                    .centerInside()
                    .placeholder(R.drawable.user_profile)
                    .into(class_file_open_imageview)


        }


        //뒤로 가기 버튼
        class_file_open_back_button.setOnClickListener(back_button)

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






}

