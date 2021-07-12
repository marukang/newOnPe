package com.funidea.newonpe.self_class


import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.funidea.newonpe.R

import kotlinx.android.synthetic.main.class_community_board_file_recyclerview_item.view.*
import kotlinx.android.synthetic.main.self_class_list_recyclerview_item.view.*


/** 셀프 체육 수업 화면에서
 * 내가 선택한 운동 목록이 보여질 RecyclerView Adapter
 *
 * 현재 사용 X
 */

class self_class_list_Adapter(context: Context, selfClassListItem : ArrayList<self_class_list_Item>?)
    : RecyclerView.Adapter<self_class_list_Adapter.ViewHolder>() {

    private val selfClassListItem: ArrayList<self_class_list_Item>?

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
        this.selfClassListItem = selfClassListItem
        this.context = context
    }


    inner class ViewHolder(view: View?, mListener: onItemClickListener?) :
        RecyclerView.ViewHolder(view!!) {

        //부모 레이아웃
        val self_class_parent_linearlayout = itemView.self_class_parent_linearlayout

        //운동 카테고리 1, 2
        val self_class_select_category_1_textview = itemView.self_class_select_category_1_textview
        val self_class_select_category_2_textview = itemView.self_class_select_category_2_textview

        //삭제 버튼
        val self_class_select_delete_textview = itemView.self_class_select_delete_textview

        //운동 분류 1, 2, 3
        val self_class_list_exercise_title_1_textview = itemView.self_class_list_exercise_title_1_textview
        val self_class_list_exercise_title_2_textview = itemView.self_class_list_exercise_title_2_textview
        val self_class_list_exercise_title_3_textview = itemView.self_class_list_exercise_title_3_textview





        init {

            //상품 넘기기
            self_class_parent_linearlayout.setOnClickListener {
                if (mListener != null) {
                    val position = adapterPosition
                    if (position != RecyclerView.NO_POSITION) {
                        mListener.item_click(position)
                    }

                }
            }

            //상품 삭제
            self_class_select_delete_textview.setOnClickListener {
                if (mListener != null) {
                    val position = adapterPosition
                    if (position != RecyclerView.NO_POSITION) {
                        mListener.item_delete(position)
                    }

                }
            }


        }
    }


    override fun onCreateViewHolder(viewGroup: ViewGroup, viewType: Int): ViewHolder {

        val view: View = LayoutInflater.from(viewGroup.context)
            .inflate(R.layout.self_class_list_recyclerview_item, viewGroup, false)
        return ViewHolder(view, mListener)

    }


    override fun onBindViewHolder(viewHolder: ViewHolder, position: Int) {

        val position_item: self_class_list_Item = selfClassListItem!![position]

        viewHolder.self_class_select_category_1_textview.setText(position_item.self_class_select_category_1)
        viewHolder.self_class_select_category_2_textview.setText(position_item.self_class_select_category_2)

        viewHolder.self_class_list_exercise_title_1_textview.setText(position_item.self_class_list_exercise_title_1)
        viewHolder.self_class_list_exercise_title_2_textview.setText(position_item.self_class_list_exercise_title_2)
        viewHolder.self_class_list_exercise_title_3_textview.setText(position_item.self_class_list_exercise_title_3)

    }


    override fun getItemCount(): Int {
        return selfClassListItem?.size ?: 0
    }
}