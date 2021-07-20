package com.funidea.newonpe.dialog

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.funidea.newonpe.R
import kotlinx.android.synthetic.main.self_class_bottom_dialog_recyclerview_item.view.*

/** 셀프 체육 수업 Bottom Dialog의 Recycelrview Adapter
 * 현재 사용 X
 */
class SelfClassItemAdapter(context: Context, selfClassBottomDialogItem : ArrayList<SelfClassItem>?)
    : RecyclerView.Adapter<SelfClassItemAdapter.ViewHolder>() {

    private val selfClassBottomDialogItem: ArrayList<SelfClassItem>?

    private val context: Context

    private var mListener: onItemClickListener? = null

    interface onItemClickListener {
        fun item_click(position: Int)
    }

    fun setonItemClickListener(listener: onItemClickListener?) {
        mListener = listener
    }


    init {
        this.selfClassBottomDialogItem = selfClassBottomDialogItem
        this.context = context
    }


    inner class ViewHolder(view: View?, mListener: onItemClickListener?) :
        RecyclerView.ViewHolder(view!!) {

        //학급 커뮤니티 게시글 번호(혹은 공지사항 표시)
        val self_class_textview = itemView.self_class_textview




        init {

            //상품 넘기기
            self_class_textview.setOnClickListener {
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
            .inflate(R.layout.self_class_bottom_dialog_recyclerview_item, viewGroup, false)
        return ViewHolder(view, mListener)

    }


    override fun onBindViewHolder(viewHolder: ViewHolder, position: Int) {

        val position_item: SelfClassItem = selfClassBottomDialogItem!![position]

        viewHolder.self_class_textview.setText(position_item.self_class_string)

    }


    override fun getItemCount(): Int {
        return selfClassBottomDialogItem?.size ?: 0
    }
}