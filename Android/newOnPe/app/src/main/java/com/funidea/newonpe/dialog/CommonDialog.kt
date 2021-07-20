package com.funidea.newonpe.dialog

import android.annotation.SuppressLint
import android.app.Dialog
import android.content.Context
import android.graphics.Color
import android.graphics.drawable.ColorDrawable
import android.os.Bundle
import android.text.TextUtils
import android.view.View
import android.view.Window
import android.view.WindowManager
import android.widget.Button
import android.widget.ScrollView
import android.widget.TextView
import com.funidea.newonpe.R
import com.funidea.utils.UtilityUI

class CommonDialog(context: Context, vararg messages : String?, buttonCount : ButtonCount) : Dialog(context), View.OnClickListener
{
    var mStrTitle : String? = ""
    var mStrMessage : String? = ""
    var mStrSubMessage : String? = ""
    var mConfirmed : Boolean = false
    var mButtonCount : ButtonCount = ButtonCount.TWO

    lateinit var mScrollView : ScrollView
    lateinit var mTitleView : TextView
    lateinit var mMessageView1 : TextView
    lateinit var mMessageView2 : TextView
    lateinit var mCancelButton : Button
    lateinit var mConfirmButton : Button

    enum class ButtonCount { ONE , TWO }

    init {
        val paramsLength = messages.size

        mStrTitle = (if (paramsLength > 0) messages[0] else null)
        mStrMessage = (if (paramsLength > 1) messages[1] else null)
        mStrSubMessage = (if (paramsLength > 2) messages[2] else null)

        mButtonCount = buttonCount
    }

    @SuppressLint("CutPasteId")
    override fun onCreate(savedInstanceState: Bundle?)
    {
        super.onCreate(savedInstanceState)

        window?.requestFeature(Window.FEATURE_NO_TITLE)
        window?.setBackgroundDrawable(ColorDrawable(Color.TRANSPARENT))
        window?.addFlags(WindowManager.LayoutParams.FLAG_DIM_BEHIND)
        val layoutParams = window?.attributes
        layoutParams?.width = WindowManager.LayoutParams.MATCH_PARENT
        layoutParams?.height = WindowManager.LayoutParams.MATCH_PARENT
        window?.attributes = layoutParams

        setContentView(R.layout.view_basedialog)

        mScrollView = findViewById(R.id.resizeableFrame)
        mScrollView.layoutParams.width = UtilityUI.getScreenWidth(context)

        mTitleView = findViewById(R.id.dialogTitleView)
        mTitleView.visibility = if (!TextUtils.isEmpty(mStrTitle)) View.VISIBLE else View.GONE
        mTitleView.text = mStrTitle
        mMessageView1 = findViewById(R.id.dialogMessageView1)
        mMessageView1.visibility = if (!TextUtils.isEmpty(mStrMessage)) View.VISIBLE else View.GONE
        mMessageView1.text = mStrMessage
        mMessageView2 = findViewById(R.id.dialogMessageView2)
        mMessageView2.visibility = if (!TextUtils.isEmpty(mStrSubMessage)) View.VISIBLE else View.GONE
        mMessageView2.text = mStrSubMessage

        mCancelButton = findViewById(R.id.cancelButton)
        mCancelButton.setOnClickListener(this)
        mConfirmButton = findViewById(R.id.confirmButton)
        mConfirmButton.setOnClickListener(this)

        if (mButtonCount == ButtonCount.TWO)
        {
            mCancelButton.visibility = View.VISIBLE
            mConfirmButton.visibility = View.VISIBLE
        }
        else
        {
            mCancelButton.visibility = View.GONE
            mConfirmButton.visibility = View.VISIBLE
        }
    }

    override fun onClick(v: View?)
    {
        when (v?.id)
        {
            R.id.cancelButton ->
            {
                mConfirmed = false

                dismiss()
            }

            R.id.confirmButton ->
            {
                mConfirmed = true

                dismiss()
            }
        }
    }
}