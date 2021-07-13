package com.funidea.newonpe.page.home.class_result

import android.content.Context
import android.graphics.Color
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.funidea.newonpe.R
import kotlinx.android.synthetic.main.self_class_result_score_recyclerview.view.*


class all_class_result_Adapter(context: Context, allClassResultItem : ArrayList<all_class_result_Item>?)
    : RecyclerView.Adapter<all_class_result_Adapter.ViewHolder>() {

    private val allClassResultItem: ArrayList<all_class_result_Item>?

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
        this.allClassResultItem = allClassResultItem
        this.context = context
    }


    inner class ViewHolder(view: View?, mListener: onItemClickListener?) :
        RecyclerView.ViewHolder(view!!) {

        //날짜
        val result_score_time_exercise_date = itemView.result_score_time_exercise_date
        //종목
        val result_score_time_exercise_category_textview = itemView.result_score_time_exercise_category_textview
        //대분류
        val result_score_time_exercise_title_textview = itemView.result_score_time_exercise_title_textview
        //동작명
        val result_score_time_exercise_name_textview = itemView.result_score_time_exercise_name_textview
        //평균 점수
        val result_score_average_score_textview = itemView.result_score_average_score_textview
        //횟수
        val result_score_time_count_textview = itemView.result_score_time_count_textview
        //이용 시간
        val result_score_time_textview = itemView.result_score_time_textview


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
            .inflate(R.layout.self_class_result_score_recyclerview, viewGroup, false)
        return ViewHolder(view, mListener)

    }


    override fun onBindViewHolder(viewHolder: ViewHolder, position: Int) {

        val position_item: all_class_result_Item = allClassResultItem!![position]


        if(position==0)
        {
            viewHolder.result_score_time_exercise_date.setBackgroundColor(Color.parseColor("#f1f1f1"))
            viewHolder.result_score_time_exercise_title_textview.setBackgroundColor(Color.parseColor("#f1f1f1"))
            viewHolder.result_score_time_exercise_category_textview.setBackgroundColor(Color.parseColor("#f1f1f1"))
            viewHolder.result_score_time_exercise_name_textview.setBackgroundColor(Color.parseColor("#f1f1f1"))
            viewHolder.result_score_average_score_textview.setBackgroundColor(Color.parseColor("#f1f1f1"))
            viewHolder.result_score_time_count_textview.setBackgroundColor(Color.parseColor("#f1f1f1"))
            viewHolder.result_score_time_textview.setBackgroundColor(Color.parseColor("#f1f1f1"))
        }
        else
        {
            viewHolder.result_score_time_exercise_date.setBackgroundColor(Color.parseColor("#FFFFFF"))
            viewHolder.result_score_time_exercise_title_textview.setBackgroundColor(Color.parseColor("#FFFFFF"))
            viewHolder.result_score_time_exercise_category_textview.setBackgroundColor(Color.parseColor("#FFFFFF"))
            viewHolder.result_score_time_exercise_name_textview.setBackgroundColor(Color.parseColor("#FFFFFF"))
            viewHolder.result_score_average_score_textview.setBackgroundColor(Color.parseColor("#FFFFFF"))
            viewHolder.result_score_time_count_textview.setBackgroundColor(Color.parseColor("#FFFFFF"))
            viewHolder.result_score_time_textview.setBackgroundColor(Color.parseColor("#FFFFFF"))
        }

        viewHolder.result_score_time_exercise_date.setText(position_item.date)
        viewHolder.result_score_time_exercise_title_textview.setText(position_item.content_category)
        viewHolder.result_score_time_exercise_category_textview.setText(position_item.content_name)
        viewHolder.result_score_time_exercise_name_textview.setText(position_item.content_detail_name)
        viewHolder.result_score_average_score_textview.setText(position_item.content_average_score)
        viewHolder.result_score_time_count_textview.setText(position_item.content_count)
        viewHolder.result_score_time_textview.setText(position_item.content_time)

    }


    override fun getItemCount(): Int {
        return allClassResultItem?.size ?: 0
    }
}