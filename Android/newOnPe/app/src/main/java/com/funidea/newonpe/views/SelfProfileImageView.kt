package com.funidea.newonpe.views

import android.content.Context
import android.content.res.TypedArray
import android.text.TextUtils
import android.util.AttributeSet
import android.view.LayoutInflater
import android.widget.FrameLayout
import com.bumptech.glide.Glide
import com.bumptech.glide.RequestManager
import com.bumptech.glide.load.engine.DiskCacheStrategy
import com.funidea.newonpe.R
import com.funidea.newonpe.model.CurrentLoginStudent
import de.hdodenhof.circleimageview.CircleImageView

class SelfProfileImageView : FrameLayout
{
    companion object {
        const val IMAGE_SERVER_BASE_PATH : String = "https://onpe.co.kr/"
    }

    lateinit var mImageView : CircleImageView
    lateinit var mGlideRequestManager : RequestManager

    constructor(context: Context) : super(context)
    {
        init(context, null, -1)
    }

    constructor(context: Context, attrs : AttributeSet) : super(context, attrs)
    {
        init(context, attrs, -1)
    }

    constructor(context: Context, attrs: AttributeSet, defStyleAttr : Int) : super(context, attrs, defStyleAttr)
    {
        init(context, attrs, defStyleAttr)
    }

    fun init(context: Context, attrs: AttributeSet?, defStyle : Int)
    {
        val typeArray : TypedArray = context.obtainStyledAttributes(attrs, R.styleable.SelfProfileImageView, defStyle, 0)
        val type = typeArray.getInt(R.styleable.SelfProfileImageView_type, 0)
        val resource = if (type == 0) R.layout.view_profile_pic_big else R.layout.view_profile_pic_small
        LayoutInflater.from(context).inflate(resource, this, true)

        mImageView = findViewById(R.id.selectedPicView)

        updateProfileImage()

        CurrentLoginStudent.addObserver { _, _ -> updateProfileImage() }

        typeArray.recycle()
    }

    private fun updateProfileImage()
    {
        if (!TextUtils.isEmpty(CurrentLoginStudent.root?.student_image_url))
        {
            val profileImagePath = IMAGE_SERVER_BASE_PATH + CurrentLoginStudent.root?.student_image_url

            mGlideRequestManager = Glide.with(this)
            mGlideRequestManager.load(profileImagePath)
                .diskCacheStrategy(DiskCacheStrategy.NONE)
                .skipMemoryCache(true)
                .centerCrop()
                .placeholder(R.drawable.icon_profile)
                .into(mImageView)
        }
    }
}