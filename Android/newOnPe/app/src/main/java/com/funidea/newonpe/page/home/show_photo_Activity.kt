package com.funidea.newonpe.page.home

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import com.bumptech.glide.Glide
import com.bumptech.glide.RequestManager
import com.bumptech.glide.load.engine.DiskCacheStrategy
import com.funidea.newonpe.R
import com.funidea.newonpe.page.login.LoginPage.Companion.baseURL
import kotlinx.android.synthetic.main.activity_show_photo.*

/** 게시판에 첨부 된 사진 이미지를 보여줄 View
 *
 * 추후 변경 예정
 */
class show_photo_Activity : AppCompatActivity() {

    lateinit var mGlideRequestManager : RequestManager

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_show_photo)

        show_photo_back_button.setOnClickListener(back_button)

        var get_Intent = intent

        var photo_url = get_Intent.getStringExtra("community_file")

        mGlideRequestManager = Glide.with(this)
        mGlideRequestManager.load(baseURL + photo_url)
                .diskCacheStrategy(DiskCacheStrategy.NONE)
                .skipMemoryCache(true)
                .centerCrop()
                .into(show_photo_imageview)


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