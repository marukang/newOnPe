package com.funidea.newonpe.home.class_unit.class_detail_unit

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.funidea.newonpe.R
import kotlinx.android.synthetic.main.class_detail_unit_list_recyclerview_item.view.*


/** Class_detail_unit_Activity 에서 차시별 운동 콘텐츠의 목록을 보여주는 RecyclerView 의 Adapter
 *
 *
 */

class class_detail_unit_class_list_Adapter(context: Context, classDetailUnitClassListItem : ArrayList<class_detail_unit_class_list_Item>?)
    : RecyclerView.Adapter<class_detail_unit_class_list_Adapter.ViewHolder>() {

    private val classDetailUnitClassListItem: ArrayList<class_detail_unit_class_list_Item>?

    private val context: Context

    private var mListener: onItemClickListener? = null

    interface onItemClickListener {
        fun item_click(position: Int)
        fun state_click(position: Int)
    }

    fun setonItemClickListener(listener: onItemClickListener?) {
        mListener = listener
    }


    init {
        this.classDetailUnitClassListItem = classDetailUnitClassListItem
        this.context = context
    }


    inner class ViewHolder(view: View?, mListener: onItemClickListener?) :
        RecyclerView.ViewHolder(view!!) {

        //클래스 시차(단원) 부모 linearlayout
        val class_detail_unit_list_parent_linearlayout = itemView.class_detail_unit_list_parent_linearlayout

        //서브
        val class_detail_unit_list_child_linearlayout = itemView.class_detail_unit_list_child_linearlayout

        //클래스 서브 제목
        val class_detail_unit_list_sub_textview = itemView.class_detail_unit_list_sub_textview

        //클래스 제목
        val class_detail_unit_list_title_textview = itemView.class_detail_unit_list_title_textview

        //화살표 버튼
        val class_detail_unit_list_right_arrow_imagview = itemView.class_detail_unit_list_right_arrow_imagview

        //완료TextView
        val class_detail_unit_list_complete_textview = itemView.class_detail_unit_list_complete_textview

        init {

            //상품 넘기기
            class_detail_unit_list_parent_linearlayout.setOnClickListener {
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
            .inflate(R.layout.class_detail_unit_list_recyclerview_item, viewGroup, false)
        return ViewHolder(view, mListener)

    }


    override fun onBindViewHolder(viewHolder: ViewHolder, position: Int) {

        val position_item: class_detail_unit_class_list_Item = classDetailUnitClassListItem!![position]

        viewHolder.class_detail_unit_list_sub_textview.setText(position_item.class_unit_sub)
        viewHolder.class_detail_unit_list_title_textview.setText(position_item.class_unit_title)

        //이론 수업을 경우 화면에 보이지 않도록 해준다.
        // GONE - 보이지 않게 처리
        if(position_item.class_unit_title.equals("이론수업"))
        {
            viewHolder.class_detail_unit_list_parent_linearlayout.visibility = View.GONE
        }
        else
        {
            viewHolder.class_detail_unit_list_parent_linearlayout.visibility = View.VISIBLE
        }

        if(position_item.class_value==0)
        {
            viewHolder.class_detail_unit_list_complete_textview.visibility = View.GONE
        }
        else
        {
            viewHolder.class_detail_unit_list_complete_textview.visibility = View.VISIBLE
        }




    }


    override fun getItemCount(): Int {
        return classDetailUnitClassListItem?.size ?: 0
    }
}