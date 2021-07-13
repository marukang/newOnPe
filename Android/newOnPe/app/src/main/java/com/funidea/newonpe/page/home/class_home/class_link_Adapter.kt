package com.funidea.newonpe.page.home.class_home

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.funidea.newonpe.R
import kotlinx.android.synthetic.main.class_link_recyclerview_item.view.*

/** 클래스 과제 제출 링크 RecyclerView Adapter
 *
 * 클래스 Main Home 상단에 과제 제출 링크를 나타내 주는 RecyclerView 의 Adapter
 */
class class_link_Adapter(context: Context, classLinkItem : ArrayList<class_link_Item>?)
    : RecyclerView.Adapter<class_link_Adapter.ViewHolder>() {

    private val classLinkItem: ArrayList<class_link_Item>?

    private val context: Context

    private var mListener: onItemClickListener? = null

    interface onItemClickListener {
        fun item_click(position: Int)
        //fun item_delete(position: Int)
    }

    fun setonItemClickListener(listener: onItemClickListener?) {
        mListener = listener
    }


    init {
        this.classLinkItem = classLinkItem
        this.context = context
    }


    inner class ViewHolder(view: View?, mListener: onItemClickListener?) :
        RecyclerView.ViewHolder(view!!) {

        //과제 제출방식 TextView
        val class_link_title_Textview = itemView.class_link_title_Textview
        //과제 제출 링크 TextView
        val class_link_email_textview = itemView.class_link_email_textview



        init {


        }
    }


    override fun onCreateViewHolder(viewGroup: ViewGroup, viewType: Int): ViewHolder {

        val view: View = LayoutInflater.from(viewGroup.context)
            .inflate(R.layout.class_link_recyclerview_item, viewGroup, false)
        return ViewHolder(view, mListener)

    }


    override fun onBindViewHolder(viewHolder: ViewHolder, position: Int) {

        val position_item: class_link_Item = classLinkItem!![position]

        viewHolder.class_link_title_Textview.setText(position_item.class_link_title)
        viewHolder.class_link_email_textview.setText(position_item.class_link_email)

    }


    override fun getItemCount(): Int {
        return classLinkItem?.size ?: 0
    }
}