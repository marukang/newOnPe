package com.funidea.newonpe.page.home.class_result

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.funidea.newonpe.R
import kotlinx.android.synthetic.main.class_result_jsonarray_recyclerview_item.view.*

/** Class_result_Activity 에서 하단의 운동 기록을 나타내주는 RecyclerView Adapter
 *
 *
 */

class class_result_JSONArray_Adapter(context: Context, classResultJsonarrayItem : ArrayList<class_result_JSONArray_Item>?)
    : RecyclerView.Adapter<class_result_JSONArray_Adapter.ViewHolder>() {

    private val classResultJsonarrayItem: ArrayList<class_result_JSONArray_Item>?

    private val context: Context

    private var mListener: onItemClickListener? = null

    interface onItemClickListener {
        fun item_click(position: Int)
        fun item_delete(position: Int)
    }

    fun setonItemClickListener(listener: onItemClickListener?) {
        mListener = listener
    }


    init {
        this.classResultJsonarrayItem = classResultJsonarrayItem
        this.context = context
    }


    inner class ViewHolder(view: View?, mListener: onItemClickListener?) :
        RecyclerView.ViewHolder(view!!) {

        //날짜
        val result_jsonarray_recyclerview_item_title_textview = itemView.result_jsonarray_recyclerview_item_title_textview

        val result_jsonarray_recyclerview_item = itemView.result_jsonarray_recyclerview_item


        init {

           /* //상품 넘기기
            board_file_parent_linearlayout.setOnClickListener {
                if (mListener != null) {
                    val position = adapterPosition
                    if (position != RecyclerView.NO_POSITION) {
                        mListener.item_click(position)
                    }

                }
            }*/


        }
    }


    override fun onCreateViewHolder(viewGroup: ViewGroup, viewType: Int): ViewHolder {

        val view: View = LayoutInflater.from(viewGroup.context)
            .inflate(R.layout.class_result_jsonarray_recyclerview_item, viewGroup, false)
        return ViewHolder(view, mListener)

    }


    override fun onBindViewHolder(viewHolder: ViewHolder, position: Int) {

        val position_item: class_result_JSONArray_Item = classResultJsonarrayItem!![position]

        var title_str = position_item.result_title

        title_str = title_str.replace("& #40;", "(")
        title_str = title_str.replace("& #41;", ")")

        viewHolder.result_jsonarray_recyclerview_item_title_textview.setText(title_str)

        var allClassResultAdapter : all_class_result_Adapter

        var classResultItem = ArrayList<all_class_result_Item>()

        classResultItem.add(all_class_result_Item("순서", "종목", "대분류", "동작명", "평균점수", "갯수", "이용시간(초)"))

        for(i in 0 until position_item.result_recyclerview_item.length())
        {
            var class_practice_JSONObject = position_item.result_recyclerview_item.getJSONObject(i)

            var content_name = class_practice_JSONObject.getString("content_name")
            var content_category = class_practice_JSONObject.getString("content_category")
            var content_detail_name = class_practice_JSONObject.getString("content_detail_name")
            var content_average_score = class_practice_JSONObject.getString("content_average_score")
            var content_count = class_practice_JSONObject.getString("content_count")
            var content_time = class_practice_JSONObject.getString("content_time")
            //var class_change_start_date = change_month_time(class_start_date)
            //var class_change_end_date = change_month_time(class_end_date)

            //Log.d("시작전", "get_evaluation_practice_Array:"+selfClassResultItem.size)

            classResultItem.add(all_class_result_Item((i + 1).toString(), content_name, content_category, content_detail_name, content_average_score, content_count, content_time))

        }

        //classResultItem = position_item.result_recyclerview_item


        allClassResultAdapter = all_class_result_Adapter(context, classResultItem)
        allClassResultAdapter.notifyDataSetChanged()
        viewHolder.result_jsonarray_recyclerview_item.adapter = allClassResultAdapter


    }


    override fun getItemCount(): Int {
        return classResultJsonarrayItem?.size ?: 0
    }
}