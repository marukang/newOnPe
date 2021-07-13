package com.funidea.newonpe.page.main

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.funidea.newonpe.R
import kotlinx.android.synthetic.main.side_menu_class_recyclerview_item.view.*

/** 햄버거 버튼(사이드 메뉴)를 클릭 했을 경우 보여지는 클래스 목록을 보여줄 RecyclerView의 Adapter
 *
 * 현재 사용 X
 */

class side_menu_class_Adapter(context: Context, sideMenuClassItem : ArrayList<side_menu_class_Item>?)
    : RecyclerView.Adapter<side_menu_class_Adapter.ViewHolder>() {

    private val sideMenuClassItem: ArrayList<side_menu_class_Item>?

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
        this.sideMenuClassItem = sideMenuClassItem
        this.context = context
    }


    inner class ViewHolder(view: View?, mListener: onItemClickListener?) :
        RecyclerView.ViewHolder(view!!) {

        //사이드 메뉴
        val side_menu_class_linearlayout = itemView.side_menu_class_linearlayout
        val side_menu_class_name_textview = itemView.side_menu_class_name_textview





        init {

            //상품 넘기기
            side_menu_class_linearlayout.setOnClickListener {
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
            .inflate(R.layout.side_menu_class_recyclerview_item, viewGroup, false)
        return ViewHolder(view, mListener)



    }


    override fun onBindViewHolder(viewHolder: ViewHolder, position: Int) {

        val position_item: side_menu_class_Item = sideMenuClassItem!![position]

       viewHolder.side_menu_class_name_textview.setText(position_item.class_name)

    }


    override fun getItemCount(): Int {
        return sideMenuClassItem?.size ?: 0
    }
}