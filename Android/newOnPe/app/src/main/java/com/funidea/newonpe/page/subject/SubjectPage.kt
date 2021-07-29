package com.funidea.newonpe.page.subject

import android.annotation.SuppressLint
import android.content.Intent
import android.graphics.Rect
import android.os.Bundle
import android.text.TextUtils
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.cardview.widget.CardView
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.bumptech.glide.Glide
import com.bumptech.glide.RequestManager
import com.funidea.newonpe.R
import com.funidea.newonpe.model.Subject
import com.funidea.newonpe.model.SubjectRecord
import com.funidea.newonpe.model.SubjectUnit
import com.funidea.newonpe.network.ServerConnection
import com.funidea.newonpe.page.CommonActivity
import com.funidea.newonpe.page.home.class_unit.class_unit_page
import com.funidea.newonpe.page.main.ClassItemType.HEADER_ITEM
import com.funidea.newonpe.views.*
import com.funidea.utils.SimpleSharedPreferences
import com.funidea.utils.UtilityUI
import com.google.gson.Gson
import de.hdodenhof.circleimageview.CircleImageView
import org.json.JSONArray
import org.json.JSONObject
import java.lang.Exception
import java.text.SimpleDateFormat
import java.util.*
import kotlin.collections.ArrayList
import kotlin.collections.HashMap


class SubjectPage : CommonActivity(), ICommonListStrategy
{
    private lateinit var mSubjectUnitListView : CommonRecyclerView
    private lateinit var mSubjectUnitListViewAdapter : CommonRecyclerAdapter
    private lateinit var mSubjectUnitListViewManager : LinearLayoutManager
    private lateinit var mGlideRequestManager : RequestManager
    private var mSubjectUnitList : ArrayList<ICommonItem> = arrayListOf()
    private var mSubject : Subject? = null
    private var mSubjectRecordMap : HashMap<String, SubjectRecord> = hashMapOf()

    override fun init(savedInstanceState: Bundle?)
    {
        setContentView(R.layout.page_subject)

        mSubject = intent.getSerializableExtra("subject") as Subject?

        mSubjectUnitListViewManager = LinearLayoutManager(this)
        mSubjectUnitListViewManager.orientation = LinearLayoutManager.VERTICAL
        mSubjectUnitListView = findViewById(R.id.subjectItemListView)
        mSubjectUnitListView.setHasFixedSize(true)
        mSubjectUnitListView.layoutManager = mSubjectUnitListViewManager
        mSubjectUnitListViewAdapter = CommonRecyclerAdapter(this, this)
        mSubjectUnitList.add(ICommonItem { HEADER_ITEM })
        mSubjectUnitListViewAdapter.setItemList(mSubjectUnitList)
        mSubjectUnitListView.adapter = mSubjectUnitListViewAdapter
        mSubjectUnitListView.addItemDecoration(SubjectItemDecoration())

        mGlideRequestManager = Glide.with(this)

        val classCode = mSubject?.class_code ?: ""
        if (!TextUtils.isEmpty(classCode))
        {
            ServerConnection.getStudentSubjectUnitList(classCode) { isSuccess1, accessToken1, arrayList ->

                if (isSuccess1 && arrayList != null)
                {
                    if (accessToken1 != null) SimpleSharedPreferences.saveAccessToken(this@SubjectPage, accessToken1)

                    mSubjectUnitList.addAll(arrayList)
                    mSubjectUnitListViewAdapter.notifyDataSetChanged()

                    ServerConnection.getSubjectRecordList(mSubject?.class_code!!) { isSuccess2, accessToken2, map ->

                        if (isSuccess2 && map != null)
                        {
                            if (accessToken2 != null) SimpleSharedPreferences.saveAccessToken(this@SubjectPage, accessToken2)

                            mSubjectRecordMap = map
                            mSubjectUnitListViewAdapter.notifyDataSetChanged()
                        }
                    }
                }
            }
        }
    }

    override fun createItemView(parent: ViewGroup?, viewType: Int): View
    {
        return when (viewType)
        {
            HEADER_ITEM ->
            {
                LayoutInflater.from(this).inflate(R.layout.view_subject_header, parent, false)
            }

            else ->
            {
                LayoutInflater.from(this).inflate(R.layout.view_subject_item, parent, false)
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
                val subjectNameView : TextView = holder.find(R.id.classTitle)
                val subjectDescriptionView : TextView = holder.find(R.id.classDescription)
                val subjectDurationView : TextView = holder.find(R.id.classDuration)
                val teacherNameView : TextView = holder.find(R.id.teacherName)
                val teacherThumbnailView : CircleImageView = holder.find(R.id.teacherThumbnailView)
                val headerButton1 : View = holder.find(R.id.headerButton1)
                val headerButton2 : View = holder.find(R.id.headerButton2)

                subjectNameView.text = mSubject?.class_name
                subjectDurationView.text = "${convertDateFormatAsSubjectDate(mSubject?.class_start_date)} - ${convertDateFormatAsSubjectDate(mSubject?.class_end_date)}"
                teacherNameView.text = "${mSubject?.teacher_name} (${mSubject?.teacher_id})"

                val subjectTypeJsonArray = JSONArray(mSubject?.class_project_submit_type)
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
                subjectDescriptionView.text = subjectDescription
            }

            else ->
            {
                val subjectUnit : SubjectUnit = item as SubjectUnit
                val subjectRecord : SubjectRecord? = mSubjectRecordMap[subjectUnit.unit_code]

                val itemView : CardView = holder.find(R.id.cardItem)
                val unitNameView : TextView = holder.find(R.id.classTitle)
                val durationView : TextView = holder.find(R.id.duration)
                val teacherNameView : TextView = holder.find(R.id.teacherName)
                val typeView : TextView = holder.find(R.id.typeView)
                val doneCover : View = holder.find(R.id.doneCover)
                doneCover.visibility = if (subjectRecord != null) {

                    if ("Y".equals(subjectRecord.completion_yn, ignoreCase = false))
                    {
                        View.VISIBLE
                    }
                    else
                    {
                        View.GONE
                    }
                }
                else View.GONE

                typeView.text = "이론"
                if (!TextUtils.isEmpty(subjectUnit.content_code_list))
                {
                    val contentCodeArray = JSONArray(subjectUnit.content_code_list)
                    for (i in 0 until contentCodeArray.length())
                    {
                        val contentCode : JSONObject = contentCodeArray.getJSONObject(i)
                        val contentName = contentCode.getString("content_name")
                        if ("실습수업" == contentName)
                        {
                            typeView.text = "실습"
                            break;
                        }
                    }
                }

                unitNameView.text = subjectUnit.unit_class_name
                durationView.text = "${convertDateFormatAsSubjectUnitDate(subjectUnit.unit_start_date)} ~ ${convertDateFormatAsSubjectUnitDate(subjectUnit.unit_end_date)}"
                teacherNameView.text = mSubject?.teacher_name

                itemView.setOnClickListener {
                    val intent = Intent(this, SubjectUnitPage::class.java)
                    intent.putExtra("subject", mSubject)
                    intent.putExtra("unit_code", subjectUnit.unit_code)
                    intent.putExtra("class_code", mSubject?.class_code)

                    startActivity(intent)
                    overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)
                }
            }
        }
    }

    private inner class SubjectItemDecoration : RecyclerView.ItemDecoration()
    {
        override fun getItemOffsets(outRect: Rect, view: View, parent: RecyclerView, state: RecyclerView.State)
        {
            super.getItemOffsets(outRect, view, parent, state)

            val position: Int = parent.getChildAdapterPosition(view)
            val itemCount = state.itemCount

            val topMargin = if (position == 1) UtilityUI.dpToPx(this@SubjectPage, 15) else 0
            val bottomMargin = if (position == (itemCount - 1)) UtilityUI.dpToPx(this@SubjectPage, 20) else 0

            outRect.top = topMargin
            outRect.bottom = bottomMargin
        }
    }

    @SuppressLint("SimpleDateFormat")
    private fun convertDateFormatAsSubjectDate(s : String?) : String
    {
        return try {
            val dataFormat1 : SimpleDateFormat = SimpleDateFormat("yyyyMMdd")
            val date1 : Date = dataFormat1.parse(s)
            val dataFormat2 : SimpleDateFormat = SimpleDateFormat("yyyy-MM-dd")
            dataFormat2.format(date1)
        }
        catch (e : Exception)
        {
            e.printStackTrace()

            ""
        }
    }

    @SuppressLint("SimpleDateFormat")
    private fun convertDateFormatAsSubjectUnitDate(s : String?) : String
    {
        return try {
            val dataFormat1 : SimpleDateFormat = SimpleDateFormat("yyyyMMddHHmmss")
            val date1 : Date = dataFormat1.parse(s)
            val dataFormat2 : SimpleDateFormat = SimpleDateFormat("yyyy-MM-dd")
            dataFormat2.format(date1)
        }
        catch (e : Exception)
        {
            e.printStackTrace()

            ""
        }
    }
}