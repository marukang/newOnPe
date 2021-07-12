package com.funidea.newonpe.home.class_home

import android.content.Context
import android.graphics.Color
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.funidea.utils.change_date_value.Companion.change_month_time
import com.funidea.newonpe.R
import kotlinx.android.synthetic.main.class_unit_list_recyclerview_item.view.*
import java.text.SimpleDateFormat
import java.util.*
import kotlin.collections.ArrayList

/** 클래스 차시(단원)별 리스트를 나타내주는 RecyclerView Adapter
 *
 */

class class_unit_list_Adapter(context: Context, classUnitListItem : ArrayList<class_unit_list_Item>?)
    : RecyclerView.Adapter<class_unit_list_Adapter.ViewHolder>() {

    private val classUnitListItem: ArrayList<class_unit_list_Item>?

    private val context: Context

    private var mListener: onItemClickListener? = null

    //시간 데이터
    // 현재시간을 msec 으로 구한다.
    val now = System.currentTimeMillis()
    // 현재시간을 date 변수에 저장한다.
    val date = Date(now)
    // 시간을 나타냇 포맷을 정한다 ( yyyy/MM/dd 같은 형태로 변형 가능 )
    val sdfNow = SimpleDateFormat("yyyyMMdd")
    // nowDate 변수에 값을 저장한다.
    val formatDate = sdfNow.format(date)

    val nowdate : Int = formatDate.toInt()

    interface onItemClickListener {
        fun item_click(position: Int)
        fun state_click(position: Int)
    }

    fun setonItemClickListener(listener: onItemClickListener?) {
        mListener = listener
    }


    init {
        this.classUnitListItem = classUnitListItem
        this.context = context
    }


    inner class ViewHolder(view: View?, mListener: onItemClickListener?) :
            RecyclerView.ViewHolder(view!!) {

        //클래스 시차(단원) 부모 linearlayout
        val class_unit_list_parent_linearlayout = itemView.class_unit_list_parent_linearlayout

        //클래스 생성일 textview
        val class_unit_list_date_textview = itemView.class_unit_list_date_textview

        //클래스 시차(단원) 제목 textview
        val class_unit_list_title_textview = itemView.class_unit_list_title_textview

        //클래스 수업현황 linearlayout
        val class_unit_list_state_linearlayout = itemView.class_unit_list_state_linearlayout
        //클래스 수업현황 search ImageView
        val class_unit_list_state_search_imageview = itemView.class_unit_list_state_search_imageview
        //클래스 수업 현황 텍스트
        val class_unit_list_state_textview = itemView.class_unit_list_state_textview
        //클래스 화살표
        val class_unit_list_right_arrow_imagview = itemView.class_unit_list_right_arrow_imagview



        init {

            //차시별 수업 입장하기 버튼
            class_unit_list_parent_linearlayout.setOnClickListener {
                if (mListener != null) {
                    val position = adapterPosition
                    if (position != RecyclerView.NO_POSITION) {
                        mListener.item_click(position)
                    }

                }
            }
            //수업 현황 보기 버튼
            class_unit_list_state_linearlayout.setOnClickListener {
                if (mListener != null) {
                    val position = adapterPosition
                    if (position != RecyclerView.NO_POSITION) {
                        mListener.state_click(position)
                    }

                }
            }
        }
    }


    override fun onCreateViewHolder(viewGroup: ViewGroup, viewType: Int): ViewHolder {

        val view: View = LayoutInflater.from(viewGroup.context)
                .inflate(R.layout.class_unit_list_recyclerview_item, viewGroup, false)
        return ViewHolder(view, mListener)

    }


    override fun onBindViewHolder(viewHolder: ViewHolder, position: Int) {

        val position_item: class_unit_list_Item = classUnitListItem!![position]



        var class_change_start_date = change_month_time(position_item.class_unit_start_date)
        var class_change_end_date = change_month_time(position_item.class_unit_end_date)

        viewHolder.class_unit_list_date_textview.setText(class_change_start_date +" ~ "+class_change_end_date)
        viewHolder.class_unit_list_title_textview.setText(position_item.class_unit_title)

        var class_end_date = position_item.class_unit_end_date
        var class_start_date = position_item.class_unit_start_date

        if(class_end_date.length>0){

            Log.d("date_check", "onBindViewHolder: "+class_end_date.toString())

            class_end_date = class_end_date.substring(0,8)

        }
        if(class_start_date.length>0){

            class_start_date = class_start_date.substring(0,8)

        }

        if(class_start_date.length<1||class_end_date.length<1)
        {
            viewHolder.class_unit_list_parent_linearlayout.setBackgroundResource(R.drawable.view_gray_color_2_round_edge)
            viewHolder.class_unit_list_title_textview.setTextColor(Color.parseColor("#9f9f9f"))
            viewHolder.class_unit_list_right_arrow_imagview.visibility = View.GONE
            position_item.class_unit_value = 0
        }
        else if(class_start_date.toInt()>nowdate)
        {
            viewHolder.class_unit_list_parent_linearlayout.setBackgroundResource(R.drawable.view_gray_color_2_round_edge)
            viewHolder.class_unit_list_title_textview.setTextColor(Color.parseColor("#9f9f9f"))
            viewHolder.class_unit_list_right_arrow_imagview.visibility = View.GONE
            position_item.class_unit_value = 0
        }
        else if(class_end_date.toInt()<nowdate)
        {
            viewHolder.class_unit_list_parent_linearlayout.setBackgroundResource(R.drawable.view_gray_color_2_round_edge)
            viewHolder.class_unit_list_title_textview.setTextColor(Color.parseColor("#9f9f9f"))
            viewHolder.class_unit_list_right_arrow_imagview.visibility = View.GONE
            position_item.class_unit_value = 0
        }
        else
        {
            viewHolder.class_unit_list_parent_linearlayout.setBackgroundResource(R.drawable.view_main_color_round_edge)
            viewHolder.class_unit_list_title_textview.setTextColor(Color.parseColor("#3378fd"))
            viewHolder.class_unit_list_right_arrow_imagview.visibility = View.VISIBLE
            position_item.class_unit_value = 1
        }



    }


    override fun getItemCount(): Int {
        return classUnitListItem?.size ?: 0
    }
}