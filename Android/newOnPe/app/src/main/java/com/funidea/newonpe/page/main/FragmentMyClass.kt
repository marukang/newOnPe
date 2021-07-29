package com.funidea.newonpe.page.main

import android.annotation.SuppressLint
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.text.Editable
import android.text.TextUtils
import android.text.TextWatcher
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.EditText
import android.widget.TextView
import androidx.cardview.widget.CardView
import androidx.recyclerview.widget.LinearLayoutManager
import com.funidea.newonpe.R
import com.funidea.newonpe.model.Subject
import com.funidea.newonpe.network.ServerConnection
import com.funidea.newonpe.page.CommonFragment
import com.funidea.newonpe.page.main.ClassItemType.HEADER_ITEM
import com.funidea.newonpe.page.subject.SubjectPage
import com.funidea.newonpe.views.*
import com.funidea.utils.UtilityUI
import kotlinx.android.synthetic.main.view_my_class.*
import org.json.JSONArray
import org.json.JSONObject
import java.lang.Exception
import java.text.SimpleDateFormat
import java.util.*
import kotlin.collections.ArrayList

class FragmentMyClass : CommonFragment(R.layout.view_my_class), ICommonListStrategy
{
    private lateinit var mInputBoxClassCode : EditText
    private lateinit var mRegisterClassButton : Button
    private lateinit var mFrameView1 : ViewGroup
    private lateinit var mFrameView2 : ViewGroup

    private lateinit var mClassItemListView : CommonRecyclerView
    private lateinit var mClassItemListViewManager : LinearLayoutManager
    private var mClassItemListViewAdapter : CommonRecyclerAdapter? = null
    private var mClassItemList : ArrayList<ICommonItem> = arrayListOf()

    override fun init(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?)
    {
        mFrameView1 = findViewById(R.id.codeInputFrame)
        mFrameView2 = findViewById(R.id.myClassListFrame)

        mClassItemListViewManager = LinearLayoutManager(context)
        mClassItemListViewManager.orientation = LinearLayoutManager.VERTICAL
        mClassItemListView = findViewById(R.id.classItemListView)
        mClassItemListView.setHasFixedSize(true)
        mClassItemListView.layoutManager = mClassItemListViewManager
        mClassItemList = arrayListOf()
        mClassItemList.add(ICommonItem { HEADER_ITEM })
        mClassItemListViewAdapter = CommonRecyclerAdapter(context, this)
        mClassItemListViewAdapter!!.setItemList(mClassItemList)
        mClassItemListView.adapter = mClassItemListViewAdapter

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

    private fun registerNewClass(classCode : String, callBack : ((Boolean) -> Unit)? = null)
    {
        ServerConnection.updateClassCode(classCode) { isSuccess, accessToken, message ->

            UtilityUI.setForceKeyboardDown(context, mInputBoxClassCode)

            if (isSuccess)
            {

                if (callBack != null)
                {
                    callBack(isSuccess)
                }

                updateMyClassList()
            }
            else if (message == "none_class")
            {
                showDialog("알림", "존재하지 않는 학급입니다. 다시 한번 확인해주세요 ")
            }
        }
    }

    @SuppressLint("ApplySharedPref")
    private fun updateMyClassList()
    {
        ServerConnection.getStudentSubjectList { isSuccess, accessToken, arrayList ->

            val arrayListSize = arrayList?.size ?: 0
            if (arrayListSize > 0 && isSuccess)
            {
                val preferences = context?.getSharedPreferences("user_info", Context.MODE_PRIVATE)
                val editor = preferences?.edit()

                editor?.putString("user_access_token", accessToken)
                editor?.commit()

                mClassItemList.clear()
                mClassItemList.add(ICommonItem { HEADER_ITEM })
                mClassItemList.addAll(arrayList!!)
                mClassItemListViewAdapter?.notifyDataSetChanged()

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

    override fun createItemView(parent: ViewGroup?, viewType: Int): View
    {
        return when (viewType)
        {
            HEADER_ITEM ->
            {
                inflateView(R.layout.view_class_item_header, parent)
            }

            else ->
            {
                inflateView(R.layout.view_class_item, parent)
            }
        }
    }

    @SuppressLint("SetTextI18n")
    override fun drawItemView(holder: CompositeViewHolder, position: Int, viewType: Int, item: ICommonItem?)
    {
        when (viewType)
        {
            HEADER_ITEM ->
            {
                val insertCodeBox : EditText = holder.find(R.id.codeInsertBox)
                val registerCodeButton : Button = holder.find(R.id.registerCodeButton)
                registerCodeButton.setOnClickListener {

                    val insertedClassCode = insertCodeBox.text.toString()
                    if (!TextUtils.isEmpty(insertedClassCode))
                    {
                        registerNewClass(insertedClassCode) {

                            insertCodeBox.setText("")
                        }
                    }
                }
            }

            else ->
            {
                val titleView : TextView = holder.find(R.id.classTitle)
                val descriptionView : TextView = holder.find(R.id.classDescription)
                val durationView : TextView = holder.find(R.id.classDuration)
                val teacherView : TextView = holder.find(R.id.teacherName)

                val subject : Subject = item as Subject
                val subjectTypeJsonArray = JSONArray(subject.class_project_submit_type)
                var subjectDescription = ""
                for (i in 0 until subjectTypeJsonArray.length())
                {
                    val json : JSONObject = subjectTypeJsonArray.getJSONObject(i)
                    val type = json.getString("type")
                    if ("직접입력" == type)
                    {
                        subjectDescription = json.getString("link")
                    }
                }
                descriptionView.text = subjectDescription
                titleView.text = subject.class_name
                durationView.text = "${convertDateFormat(subject.class_start_date)} - ${convertDateFormat(subject.class_end_date)}"
                teacherView.text = subject.teacher_name

                val cardView : CardView = holder.find(R.id.cardItem)
                cardView.setOnClickListener {
                    val intent = Intent(context, SubjectPage::class.java)
                    intent.putExtra("subject", subject)
                    context?.startActivity(intent)
                }
            }
        }
    }

    @SuppressLint("SimpleDateFormat")
    private fun convertDateFormat(s : String?) : String
    {
        return try {
            val dataFormat1 : SimpleDateFormat = SimpleDateFormat("yyyymmdd")
            val date1 : Date = dataFormat1.parse(s)
            val dataFormat2 : SimpleDateFormat = SimpleDateFormat("yyyy-mm-dd")
            dataFormat2.format(date1)
        } catch (e : Exception) {
            e.printStackTrace()

            ""
        }
    }

}