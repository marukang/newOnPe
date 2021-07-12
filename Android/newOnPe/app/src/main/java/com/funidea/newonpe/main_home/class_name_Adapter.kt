package com.funidea.newonpe.main_home

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.funidea.newonpe.R
import kotlinx.android.synthetic.main.class_name_recyclerview_item.view.*


/** 메인 홈 화면에서 사용자가 보유한 Class List를 보여주는 RecyclerView Adapter
 *
 */

class class_name_Adapter(context: Context, classNameItem : ArrayList<class_name_Item>?)
    : RecyclerView.Adapter<class_name_Adapter.ViewHolder>() {

    private val classNameItem: ArrayList<class_name_Item>?

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
        this.classNameItem = classNameItem
        this.context = context
    }


    inner class ViewHolder(view: View?, mListener: onItemClickListener?) :
        RecyclerView.ViewHolder(view!!) {

        //학급 커뮤니티 게시글 번호(혹은 공지사항 표시)
        //val link_parent_linearlayout = itemView.link_parent_linearlayout

        val class_name_textview = itemView.class_name_textview



        init {

            //상품 넘기기
            class_name_textview.setOnClickListener {
                if (mListener != null) {
                    val position = adapterPosition
                    if (position != RecyclerView.NO_POSITION) {
                        mListener.item_click(position)
                    }

                }
            }


        }
    }


    override fun onCreateViewHolder(viewGroup: ViewGroup, viewType: Int): ViewHolder {

        val view: View = LayoutInflater.from(viewGroup.context)
            .inflate(R.layout.class_name_recyclerview_item, viewGroup, false)
        return ViewHolder(view, mListener)

    }


    override fun onBindViewHolder(viewHolder: ViewHolder, position: Int) {

        val position_item: class_name_Item = classNameItem!![position]

        viewHolder.class_name_textview.setText(position_item.class_name)



    }


    override fun getItemCount(): Int {
        return classNameItem?.size ?: 0
    }
}