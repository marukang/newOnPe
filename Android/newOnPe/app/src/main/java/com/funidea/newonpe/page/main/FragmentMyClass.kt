package com.funidea.newonpe.page.main

import android.content.Context
import android.os.Bundle
import android.text.Editable
import android.text.TextUtils
import android.text.TextWatcher
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.EditText
import com.funidea.newonpe.R
import com.funidea.newonpe.model.CurrentLoginStudent
import com.funidea.newonpe.network.ServerConnection
import com.funidea.newonpe.page.CommonFragment
import kotlinx.android.synthetic.main.view_my_class.*

class FragmentMyClass : CommonFragment(R.layout.view_my_class)
{
    private lateinit var mInputBoxClassCode : EditText
    private lateinit var mRegisterClassButton : Button
    private lateinit var mFrameView1 : ViewGroup
    private lateinit var mFrameView2 : ViewGroup

    override fun init(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?)
    {
        mFrameView1 = findViewById(R.id.codeInputFrame)
        mFrameView2 = findViewById(R.id.myClassListFrame)

        mInputBoxClassCode = findViewById(R.id.classCodeInputBox1)
        mInputBoxClassCode.addTextChangedListener(object : TextWatcher
        {
            override fun beforeTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int)
            {

            }

            override fun onTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int)
            {

            }

            override fun afterTextChanged(p0: Editable?)
            {

            }
        })
        mRegisterClassButton = findViewById(R.id.registerClassCodeButton1)
        mRegisterClassButton.setOnClickListener {

            val insertedClassCode = classCodeInputBox1.text.toString()
            if (!TextUtils.isEmpty(insertedClassCode))
            {
                registerNewClass(insertedClassCode)
            }
        }

        updateMyClassList()
    }

    private fun registerNewClass(classCode : String)
    {
        ServerConnection.updateClassCode(classCode) { isSuccess, accessToken ->

            if (isSuccess)
            {
                updateMyClassList()
            }
        }
    }

    private fun updateMyClassList()
    {
        ServerConnection.getStudentClassList { isSuccess, accessToken, arrayList ->

            val arrayListSize = arrayList?.size ?: 0
            if (arrayListSize > 0 && isSuccess)
            {
                val preferences = context?.getSharedPreferences("user_info", Context.MODE_PRIVATE)
                val editor = preferences?.edit()

                editor?.putString("user_access_token", accessToken)
                editor?.commit()

                mFrameView1.visibility = View.GONE
                mFrameView2.visibility = View.VISIBLE
            }
            else
            {
                mFrameView1.visibility = View.VISIBLE
                mFrameView2.visibility = View.GONE
            }
        }
    }
}