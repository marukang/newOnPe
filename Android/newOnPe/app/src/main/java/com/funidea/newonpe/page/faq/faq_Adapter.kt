package com.funidea.newonpe.page.faq

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.funidea.newonpe.R
import kotlinx.android.synthetic.main.faq_recyclerview_item.view.*

/** FAQ [자주 묻는 질문]
 *
 * 자주 묻는 질문 화면의 RecyclerView의 Adapter 클래스
 *
 */

class faq_Adapter(context: Context, faqItem: ArrayList<faq_Item>?)
    : RecyclerView.Adapter<faq_Adapter.ViewHolder>()
{

    private val faqItem : ArrayList<faq_Item>?

    private val context : Context

    private var mListener: onItemClickListener? = null

    interface onItemClickListener {
        fun item_click(position: Int)

    }

    fun setonItemClickListener(listener: onItemClickListener?) {
        mListener = listener
    }


    init
    {
        this.faqItem = faqItem
        this.context = context
    }


    inner class ViewHolder(view: View?, mListener: onItemClickListener?) :
        RecyclerView.ViewHolder(view!!)
    {

        //faq 번호
        val faq_recyclerview_number_textview = itemView.faq_recyclerview_number_textview
        //faq 타이틀
        val faq_recyclerview_title_textview = itemView.faq_recyclerview_title_textview
        //faq 카테고리
        val faq_recyclerview_category_textview = itemView.faq_recyclerview_category_textview

        //아이템 View
        val faq_recyclerview_parent_linearlayout =  itemView.faq_recyclerview_parent_linearlayout

         init {

            //상품 넘기기
             faq_recyclerview_parent_linearlayout.setOnClickListener {
                if(mListener!=null)
                {
                    val position = adapterPosition
                    if (position != RecyclerView.NO_POSITION) {
                        mListener.item_click(position)
                    }

                }
            }



        }
    }


    override fun onCreateViewHolder(viewGroup: ViewGroup, viewType: Int): ViewHolder
    {

        val view: View = LayoutInflater.from(viewGroup.context)
            .inflate(R.layout.faq_recyclerview_item, viewGroup, false)
        return ViewHolder(view, mListener)

    }



    override fun onBindViewHolder(viewHolder: ViewHolder, position: Int)
    {

        val  position_item : faq_Item = faqItem!![position]

        //넘버
        viewHolder.faq_recyclerview_number_textview.setText(position_item.number)
        //제목
        viewHolder.faq_recyclerview_title_textview.setText(position_item.title)
        //카테고리
        viewHolder.faq_recyclerview_category_textview.setText(position_item.category)

    }


    override fun getItemCount(): Int {
        return faqItem?.size ?: 0
    }




}