package com.funidea.newonpe.page.pose

import android.content.Context
import android.graphics.Color
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.funidea.newonpe.R
import kotlinx.android.synthetic.main.pose_name_recyclerview_item.view.*

/** Pose Activity 에서
 *  운동 진행 시
 *  하단에서 현재 진행 중인 운동에 대한 위치를 나타내주는
 *  RecyclerView Adapter
 */

class pose_name_Adapter(context: Context, poseNameItem: ArrayList<pose_name_Item>?)
    : RecyclerView.Adapter<pose_name_Adapter.ViewHolder>() {

    private val poseNameItem: ArrayList<pose_name_Item>?

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
        this.poseNameItem = poseNameItem
        this.context = context
    }


    inner class ViewHolder(view: View?, mListener: onItemClickListener?) :
        RecyclerView.ViewHolder(view!!) {


        val pose_name_item_textview = itemView.pose_name_item_textview

        val pose_name_recyclerview_line_textview = itemView.pose_name_recyclerview_line_textview


        init {

        }
    }


    override fun onCreateViewHolder(viewGroup: ViewGroup, viewType: Int): ViewHolder {

        val view: View = LayoutInflater.from(viewGroup.context)
            .inflate(R.layout.pose_name_recyclerview_item, viewGroup, false)
        return ViewHolder(view, mListener)

    }


    override fun onBindViewHolder(viewHolder: ViewHolder, position: Int) {

        val position_item: pose_name_Item = poseNameItem!![position]

        viewHolder.pose_name_item_textview.setText(position_item.pose_name)

        //현재 운동 중
        if(position_item.pose_value==1)
        {

            viewHolder.pose_name_recyclerview_line_textview.setBackgroundColor(Color.parseColor("#FF0000"))
            viewHolder.pose_name_item_textview.setBackgroundResource(R.drawable.view_main_color_in_white_round_edge)
            viewHolder.pose_name_item_textview.setTextColor(Color.parseColor("#3378fd"))

        }
        //현재 운동 중 X
        else
        {
            viewHolder.pose_name_recyclerview_line_textview.setBackgroundColor(Color.parseColor("#d6d6d6"))
            viewHolder.pose_name_item_textview.setBackgroundResource(R.drawable.view_black_color_round_edge)
            viewHolder.pose_name_item_textview.setTextColor(Color.parseColor("#000000"))


        }






    }


    override fun getItemCount(): Int {
        return poseNameItem?.size ?: 0
    }
}