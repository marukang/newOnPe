package com.funidea.newonpe.home.class_unit

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.funidea.newonpe.R
import kotlinx.android.synthetic.main.class_unit_link_recyclerview_item.view.*

/** Class Unit Activty (차시별 수업 정보)에서 수업 관련 링크 Recyclerview 의 Adapter
 *
 *
 */

class class_unit_link_Adapter(context: Context, classUnitLinkItem : ArrayList<class_unit_link_Item>?)
    : RecyclerView.Adapter<class_unit_link_Adapter.ViewHolder>() {

    private val classUnitLinkItem: ArrayList<class_unit_link_Item>?

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
        this.classUnitLinkItem = classUnitLinkItem
        this.context = context
    }


    inner class ViewHolder(view: View?, mListener: onItemClickListener?) :
        RecyclerView.ViewHolder(view!!) {


        val link_parent_linearlayout = itemView.link_parent_linearlayout

        //링크 명 Adapter
        val link_name_textview = itemView.link_name_textview



        init {

            //상품 넘기기
            link_parent_linearlayout.setOnClickListener {
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
            .inflate(R.layout.class_unit_link_recyclerview_item, viewGroup, false)
        return ViewHolder(view, mListener)

    }


    override fun onBindViewHolder(viewHolder: ViewHolder, position: Int) {

        val position_item: class_unit_link_Item = classUnitLinkItem!![position]

        viewHolder.link_name_textview.setText(position_item.file_name)



    }


    override fun getItemCount(): Int {
        return classUnitLinkItem?.size ?: 0
    }
}