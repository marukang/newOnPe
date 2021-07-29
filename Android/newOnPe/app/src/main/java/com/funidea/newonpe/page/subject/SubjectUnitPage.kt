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
import android.widget.Button
import android.widget.LinearLayout
import android.widget.TextView
import androidx.cardview.widget.CardView
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.funidea.newonpe.R
import com.funidea.newonpe.model.Content
import com.funidea.newonpe.model.Subject
import com.funidea.newonpe.model.SubjectUnit
import com.funidea.newonpe.network.ServerConnection
import com.funidea.newonpe.page.CommonActivity
import com.funidea.newonpe.page.exercise.ExercisePage
import com.funidea.newonpe.page.home.class_file_open_webview_Activity
import com.funidea.newonpe.page.home.class_unit.class_detail_unit.class_detail_unit_Activity
import com.funidea.newonpe.page.main.ClassItemType
import com.funidea.newonpe.page.main.ClassItemType.SUBJECT_CONTENT_ITEM
import com.funidea.newonpe.page.pose.PoseActivity
import com.funidea.newonpe.views.*
import com.funidea.utils.CustomToast
import com.funidea.utils.UtilityUI
import com.funidea.utils.SimpleSharedPreferences
import com.google.gson.Gson
import com.google.gson.GsonBuilder
import com.google.gson.reflect.TypeToken
import com.pierfrancescosoffritti.androidyoutubeplayer.core.player.YouTubePlayer
import com.pierfrancescosoffritti.androidyoutubeplayer.core.player.listeners.AbstractYouTubePlayerListener
import com.pierfrancescosoffritti.androidyoutubeplayer.core.player.views.YouTubePlayerView
import kotlinx.android.synthetic.main.activity_class_unit.*
import org.json.JSONArray
import java.lang.Exception
import java.text.SimpleDateFormat
import java.util.*
import java.util.concurrent.TimeUnit
import kotlin.collections.ArrayList

class SubjectUnitPage : CommonActivity(), ICommonListStrategy
{
    private companion object
    {
        const val HEADER = 100
        const val REFERENCE_ITEM = 101
        const val YOUTUBE_ITEM = 102
        const val LINK_ITEM = 103
        const val HOMEWORK_ITEM = 104
        const val TEXT_HEADER = 105
    }

    private lateinit var mSelectedSubject : Subject
    private lateinit var mSelectedSubjectUnit : SubjectUnit
    private lateinit var mSelectedSubjectCode : String
    private lateinit var mSelectedSubjectUnitCode : String
    private lateinit var mSelectedSubjectUnitTitleView: TextView
    private lateinit var mSubjectUnitInformationView : CommonRecyclerView
    private lateinit var mSubjectUnitInformationViewAdapter : CommonRecyclerAdapter
    private lateinit var mSubjectUnitInformationViewManager : LinearLayoutManager
    private lateinit var mEnterButton : Button
    private var mSubjectUnitInformation : ArrayList<ICommonItem> = arrayListOf()
    private var mContentList : ArrayList<Content>? = arrayListOf()
    private var mYoutubePlayer : YouTubePlayer? = null

    override fun init(savedInstanceState: Bundle?)
    {
        setContentView(R.layout.page_subject_unit)

        mSelectedSubject = intent.getSerializableExtra("subject") as Subject? ?: Subject()
        mSelectedSubjectCode = intent.getStringExtra("unit_code") ?: ""
        mSelectedSubjectUnitCode = intent.getStringExtra("class_code") ?: ""

        mSelectedSubjectUnitTitleView = findViewById(R.id.titleView)
        mSubjectUnitInformationViewManager = LinearLayoutManager(this)
        mSubjectUnitInformationViewManager.orientation = LinearLayoutManager.VERTICAL
        mSubjectUnitInformationView = findViewById(R.id.subjectUnitInformationListView)
        mSubjectUnitInformationView.setHasFixedSize(true)
        mSubjectUnitInformationView.layoutManager = mSubjectUnitInformationViewManager
        mSubjectUnitInformationViewAdapter = CommonRecyclerAdapter(this, this)

        mSubjectUnitInformationView.addItemDecoration(SubjectItemDecoration())

        if (savedInstanceState == null)
        {
            ServerConnection.getSubjectUnitDetailedInformation(mSelectedSubjectCode, mSelectedSubjectUnitCode) { isSuccess1, json ->

                if (isSuccess1)
                {
                    val gson = Gson()

                    mSelectedSubjectUnit = gson.fromJson(json.toString(), SubjectUnit::class.java)
                    mSubjectUnitInformation.add(ICommonItem { HEADER })

                    if (!TextUtils.isEmpty(mSelectedSubjectUnit.unit_attached_file))
                    {
                        mSubjectUnitInformation.add(ICommonItem { REFERENCE_ITEM })
                    }
                    if (!TextUtils.isEmpty(mSelectedSubjectUnit.unit_youtube_url))
                    {
                        mSubjectUnitInformation.add(ICommonItem { YOUTUBE_ITEM })
                    }
                    if (!TextUtils.isEmpty(mSelectedSubjectUnit.unit_content_url))
                    {
                        mSubjectUnitInformation.add(ICommonItem { LINK_ITEM })
                    }
                    // 2021-07-26 차후 버전에서 업데이트 예정
                    // mSubjectUnitInformation.add(ICommonItem { HOMEWORK_ITEM })
                    mSubjectUnitInformationViewAdapter.setItemList(mSubjectUnitInformation)
                    mSubjectUnitInformationView.adapter = mSubjectUnitInformationViewAdapter

                    mSelectedSubjectUnitTitleView.text = mSelectedSubjectUnit.unit_class_name

                    ServerConnection.getSubjectUnitContentGroup(mSelectedSubjectCode, mSelectedSubjectUnitCode) { isSuccess2, accessToken, contentList ->

                        if (isSuccess2)
                        {
                            mContentList = contentList

                            mSubjectUnitInformation.add(ICommonItem { TEXT_HEADER })
                            mSubjectUnitInformation.addAll(mContentList!!)
                            mSubjectUnitInformationViewAdapter.notifyDataSetChanged()
                        }
                    }
                }
            }
        }
    }

    private inner class SubjectItemDecoration : RecyclerView.ItemDecoration()
    {
        override fun getItemOffsets(outRect: Rect, view: View, parent: RecyclerView, state: RecyclerView.State)
        {
            super.getItemOffsets(outRect, view, parent, state)

            val position : Int = parent.getChildAdapterPosition(view)
            val viewType : Int = parent.adapter?.getItemViewType(position) ?: 0
            val itemCount = state.itemCount

            // val topMargin = if (position != 0) UtilityUI.dpToPx(this@SubjectUnitPage, 5) else 0
            val topMargin = if (viewType == SUBJECT_CONTENT_ITEM) {
                val item = mSubjectUnitInformation[position]
                val contentIndex = mContentList?.indexOf(item) ?: -1
                if (contentIndex == 0) UtilityUI.dpToPx(this@SubjectUnitPage, 15) else 0
            }
            else
            {
                if (position != 0) UtilityUI.dpToPx(this@SubjectUnitPage, 5) else 0
            }

            val bottomMargin = if (position == (itemCount - 1)) UtilityUI.dpToPx(this@SubjectUnitPage, 20) else 0

            outRect.top = topMargin
            outRect.bottom = bottomMargin
        }
    }

    override fun createItemView(parent: ViewGroup?, viewType: Int): View
    {
        return when (viewType)
        {
            HEADER ->
            {
                LayoutInflater.from(this).inflate(R.layout.view_class_unit_item_header, parent, false)
            }

            SUBJECT_CONTENT_ITEM ->
            {
                LayoutInflater.from(this).inflate(R.layout.view_subject_content, parent, false)
            }

            TEXT_HEADER ->
            {
                LayoutInflater.from(this).inflate(R.layout.view_class_unit_item_text, parent, false)
            }

            else ->
            {
                LayoutInflater.from(this).inflate(R.layout.view_class_unit_item, parent, false)
            }
        }
    }

    @SuppressLint("SetTextI18n")
    override fun drawItemView(holder: CompositeViewHolder, position: Int, viewType: Int, item: ICommonItem?)
    {
        when (viewType)
        {
            HEADER ->
            {
                val durationView : TextView = holder.find(R.id.durationView)
                val descriptionView : TextView = holder.find(R.id.descriptionView)

                durationView.text = "${convertDateFormatAsSubjectUnitDate(mSelectedSubjectUnit.unit_start_date)} - ${convertDateFormatAsSubjectUnitDate(mSelectedSubjectUnit.unit_end_date)}"
                descriptionView.text = mSelectedSubjectUnit.unit_class_text
            }

            REFERENCE_ITEM ->
            {
                val titleView : TextView = holder.find(R.id.itemTitle)
                val titleFrame : View = holder.find(R.id.titleFrame)
                val expandableFrame : ViewGroup = holder.find(R.id.expandableFrame)
                val arrowImageView : View = holder.find(R.id.class_unit_file_imageview)
                titleView.text = "참고자료"
                titleFrame.setOnClickListener {

                    if (expandableFrame.visibility == View.VISIBLE)
                    {
                        expandableFrame.visibility = View.GONE
                        arrowImageView.isSelected = false
                    }
                    else
                    {
                        expandableFrame.visibility = View.VISIBLE
                        arrowImageView.isSelected = true
                    }
                }
                expandableFrame.visibility = View.GONE
                expandableFrame.removeAllViews()
                arrowImageView.isSelected = false

                val attachedFile = mSelectedSubjectUnit.unit_attached_file
                var jsonArray : JSONArray = JSONArray(attachedFile)
                if (jsonArray.length() > 0)
                {
                    for (i in 0 until jsonArray.length())
                    {
                        val json = jsonArray.getJSONObject(i)

                        val view = LayoutInflater.from(this).inflate(R.layout.view_class_unit_item_reference, expandableFrame, true)
                        val fileNameView : TextView = view.findViewById(R.id.fileName)
                        fileNameView.text = "첨부자료 $json"

                        view.setOnClickListener {
                            val intent = Intent(this@SubjectUnitPage, class_file_open_webview_Activity::class.java)
                            intent.putExtra("get_URL", json.toString())
                            startActivity(intent)
                            overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)
                        }
                    }
                }
            }

            YOUTUBE_ITEM ->
            {
                val titleView : TextView = holder.find(R.id.itemTitle)
                val titleFrame : View = holder.find(R.id.titleFrame)
                val expandableFrame : ViewGroup = holder.find(R.id.expandableFrame)
                val arrowImageView : View = holder.find(R.id.class_unit_file_imageview)
                titleView.text = "유튜브 영상"
                titleFrame.setOnClickListener {
                    if (expandableFrame.visibility == View.VISIBLE)
                    {
                        mYoutubePlayer?.pause()

                        expandableFrame.visibility = View.GONE
                        arrowImageView.isSelected = false
                    }
                    else
                    {
                        expandableFrame.visibility = View.VISIBLE
                        arrowImageView.isSelected = true
                    }
                }
                expandableFrame.visibility = View.GONE
                // expandableFrame.removeAllViews()
                arrowImageView.isSelected = false

                val linkUrl = mSelectedSubjectUnit.unit_youtube_url
                var jsonArray : JSONArray = JSONArray(linkUrl)
                if (jsonArray.length() > 0 && expandableFrame.childCount == 0)
                {
                    val json = jsonArray.getJSONObject(0)

                    val link = json.getString("link")
                    val title = json.getString("title")

                    LayoutInflater.from(this).inflate(R.layout.view_class_unit_item_youtube, expandableFrame, true)

                    val youtubePlayerView : YouTubePlayerView = holder.find(R.id.class_unit_youtubeview)
                    youtubePlayerView.addYouTubePlayerListener(object : AbstractYouTubePlayerListener() {

                        override fun onReady(youTubePlayer: YouTubePlayer)
                        {
                            super.onReady(youTubePlayer)

                            mYoutubePlayer = youTubePlayer

                            try {

                                when {
                                    link.length==43 -> {
                                        youTubePlayer.cueVideo (link.substring(32, 43), 0f)
                                    }

                                    link.length==28 -> {
                                        youTubePlayer.cueVideo (link.substring(17, 28), 0f)
                                    }

                                    link.length>43 -> {
                                        youTubePlayer.cueVideo (link.substring(32, 43), 0f)
                                    }

                                    else -> {
                                        CustomToast.show(this@SubjectUnitPage, "재생할 수 없는 영상입니다.")
                                    }
                                }


                            }
                            catch (t : StringIndexOutOfBoundsException )
                            {
                                CustomToast.show(this@SubjectUnitPage, "재생할 수 없는 영상입니다.")
                            }
                        }
                    })
                }
            }

            LINK_ITEM ->
            {
                val titleView : TextView = holder.find(R.id.itemTitle)
                val titleFrame : View = holder.find(R.id.titleFrame)
                val expandableFrame : ViewGroup = holder.find(R.id.expandableFrame)
                val arrowImageView : View = holder.find(R.id.class_unit_file_imageview)
                titleView.text = "수업 관련 링크"
                titleFrame.setOnClickListener {
                    if (expandableFrame.visibility == View.VISIBLE)
                    {
                        expandableFrame.visibility = View.GONE
                        arrowImageView.isSelected = false
                    }
                    else
                    {
                        expandableFrame.visibility = View.VISIBLE
                        arrowImageView.isSelected = true
                    }
                }
                expandableFrame.visibility = View.GONE
                expandableFrame.removeAllViews()
                arrowImageView.isSelected = false

                val linkUrl = mSelectedSubjectUnit.unit_content_url
                var jsonArray : JSONArray = JSONArray(linkUrl)
                if (jsonArray.length() > 0)
                {
                    for (i in 0 until jsonArray.length())
                    {
                        val json = jsonArray.getJSONObject(i)

                        val link = json.getString("link")
                        val title = json.getString("title")

                        val view = LayoutInflater.from(this).inflate(R.layout.view_class_unit_item_link, expandableFrame, true)
                        val fileNameView : TextView = view.findViewById(R.id.fileName)
                        fileNameView.text = title

                        view.setOnClickListener {
                            val intent = Intent(this@SubjectUnitPage, class_file_open_webview_Activity::class.java)
                            intent.putExtra("get_URL", link)
                            startActivity(intent)
                            overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)
                        }
                    }
                }
            }
// MARK: 실습 운동 항목 아이템
            SUBJECT_CONTENT_ITEM ->
            {
                val content : Content = item as Content

                var cardView : CardView = holder.find(R.id.itemCardFrame)
                val setNumberView : TextView = holder.find(R.id.setNumberView)
                val setDurationView : TextView = holder.find(R.id.setDurationView)
                val contentContainer : LinearLayout = holder.find(R.id.unitContainer)

                contentContainer.removeAllViews()

                var totalDuration = 0

                val gson = GsonBuilder().create()
                val contentCountList = gson.fromJson<ArrayList<String>>(content.content_count_list, object : TypeToken<ArrayList<String>>(){}.type)
                val contentDurationList = gson.fromJson<ArrayList<String>>(content.content_time, object : TypeToken<ArrayList<String>>(){}.type)
                val contentNameList = gson.fromJson<ArrayList<String>>(content.content_name_list, object : TypeToken<ArrayList<String>>(){}.type)
                for (i in 0 until contentNameList.size)
                {
                    val view = LayoutInflater.from(this@SubjectUnitPage).inflate(R.layout.view_subject_content_unit, contentContainer, true)
                    val contentNameView : TextView = view.findViewById(R.id.titleView)
                    val contentDurationView : TextView = view.findViewById(R.id.durationView)

                    val contentName = contentNameList[i]
                    val contentCount = contentCountList[i].toInt()
                    val contentDuration = contentDurationList[i].toInt()
                    val contentDurationMinutes = "%02d".format((contentDuration / 60))
                    val contentDurationSeconds = "%02d".format((contentDuration % 60))

                    contentNameView.text = contentName
                    contentDurationView.text = "${contentCount}회 ${contentDurationMinutes}:${contentDurationSeconds}"

                    totalDuration += (contentDuration * contentCount)
                }

                val setIndex = (mContentList?.indexOf(item) ?: -1) + 1
                val totalDurationMinutes = "%02d".format((totalDuration / 60))
                val totalDurationSeconds = "%02d".format((totalDuration % 60))

                setNumberView.text = "$setIndex set"
                setDurationView.text = "${totalDurationMinutes}:${totalDurationSeconds}"

                cardView.setOnClickListener { participateSubjectUnit(setIndex, content) }
            }
        }
    }

    private fun participateSubjectUnit(position: Int, content : Content)
    {
        val classType = mSelectedSubjectUnit.unit_class_type
        val classGroupName = mSelectedSubjectUnit.unit_group_name

        ServerConnection.participateSubjectUnit(mSelectedSubjectCode, mSelectedSubjectUnitCode, classType, classGroupName) { isSuccess1, errorMessage, accessToken ->

            if (isSuccess1 || "already_exist" == errorMessage?.trim())
            {
                if (accessToken != null)
                {
                    SimpleSharedPreferences.saveAccessToken(this@SubjectUnitPage, accessToken)
                }

                val classCode = mSelectedSubject.class_code
                val classUnitCode = mSelectedSubjectUnit.unit_code
                val contentValue = mSelectedSubjectUnit.content_test

                ServerConnection.createStudentClassRecord(classCode!!, classUnitCode!!, contentValue) { isSuccess2, errorMessage ->

                    if (isSuccess2 || "overlap_record" == errorMessage)
                    {
                        // val intent = Intent(this@SubjectUnitPage, PoseActivity::class.java)
                        val intent = Intent(this@SubjectUnitPage, ExercisePage::class.java)
                        intent.putExtra("evaluation_value", "1")
                        intent.putExtra("class_title", mSelectedSubjectUnit.unit_class_name)
                        intent.putExtra("unit_code", mSelectedSubjectUnitCode)
                        intent.putExtra("class_code", mSelectedSubjectCode)
                        intent.putExtra("content_title", content.content_name)
                        intent.putExtra("position_number", position)
                        intent.putExtra("array_size", 3)
                        intent.putExtra("content_name_list", content.content_name_list)
                        intent.putExtra("content_cateogry_list", content.content_cateogry_list)
                        intent.putExtra("content_type_list", content.content_type_list)
                        intent.putExtra("content_detail_name_list", content.content_detail_name_list)
                        intent.putExtra("content_count_list", content.content_count_list)
                        intent.putExtra("content_time", content.content_time)
                        intent.putExtra("content_url", content.content_url)
                        intent.putExtra("content_level_list", content.content_level_list)

                        startActivity(intent)

                        overridePendingTransition(R.anim.anim_slide_in_right, R.anim.anim_slide_out_left)
                    }
                    else
                    {
                        showDialog("알림", "수업 참여중 에러가 발생하였습니다 잠시후에 다시 시도해주세요 ")
                    }
                }
            }
            else
            {
                showDialog("알림", "수업 참여중 에러가 발생하였습니다 잠시후에 다시 시도해주세요 ")
            }
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
        } catch (e : Exception) {
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
        } catch (e : Exception) {
            e.printStackTrace()

            ""
        }
    }
}