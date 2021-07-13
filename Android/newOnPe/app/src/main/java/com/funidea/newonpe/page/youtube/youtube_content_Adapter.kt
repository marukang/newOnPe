package com.funidea.newonpe.page.youtube

import android.content.Context
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.funidea.utils.CustomToast.Companion.show
import com.funidea.newonpe.R
import com.pierfrancescosoffritti.androidyoutubeplayer.core.player.YouTubePlayer
import com.pierfrancescosoffritti.androidyoutubeplayer.core.player.listeners.AbstractYouTubePlayerListener
import kotlinx.android.synthetic.main.youtube_content_recyclerview_item.view.*
import org.jetbrains.annotations.NotNull

/**
 *  콘텐츠관의 유투브 영상을 보여줄 RecyclerView의 Adapter 클래스
 *
 */

class youtube_content_Adapter(context: Context, youtubeContentItem : ArrayList<youtube_content_Item>?)
    : RecyclerView.Adapter<youtube_content_Adapter.ViewHolder>() {

    private val youtubeContentItem: ArrayList<youtube_content_Item>?

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
        this.youtubeContentItem = youtubeContentItem
        this.context = context
    }


    inner class ViewHolder(view: View?, mListener: onItemClickListener?) :
        RecyclerView.ViewHolder(view!!) {

        //학급 커뮤니티 게시글 번호(혹은 공지사항 표시)
        val youtube_content_recyclerview_name_textview = itemView.youtube_content_recyclerview_name_textview

        val youtube_content_recyclerview_date_textview = itemView.youtube_content_recyclerview_date_textview

        val  youtube_content_recyclerview_youtube_view = itemView.youtube_content_recyclerview_youtube_view

        init {

         /*   //상품 넘기기
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
            .inflate(R.layout.youtube_content_recyclerview_item, viewGroup, false)
        return ViewHolder(view, mListener)

    }


    override fun onBindViewHolder(viewHolder: ViewHolder, position: Int) {

        val position_item: youtube_content_Item = youtubeContentItem!![position]

        viewHolder.youtube_content_recyclerview_name_textview.setText(position_item.content_id)
        viewHolder.youtube_content_recyclerview_date_textview.setText(position_item.content_date)


        viewHolder.youtube_content_recyclerview_youtube_view.addYouTubePlayerListener(object : AbstractYouTubePlayerListener() {
            override fun onReady(@NotNull youTubePlayer : YouTubePlayer) {


                try{

                var  get_youtube_url: String
                get_youtube_url = position_item.content_url

                Log.d("왜안나오지?", "onReady: "+get_youtube_url.length)

                if(get_youtube_url.length==43){

                youTubePlayer.cueVideo (get_youtube_url.substring(32, 43), 0f)
                //youTubePlayer.loadVideo(get_youtube_url.substring(32, 43), 0f)
                //youTubePlayer.play()
                }
                else if(get_youtube_url.length==28)
                {
                    youTubePlayer.cueVideo (get_youtube_url.substring(17, 28), 0f)
                }
                //0307 변경
                else if(get_youtube_url.length>43)
                {
                    youTubePlayer.cueVideo (get_youtube_url.substring(32, 43), 0f)
                }

                else
                {
                    show(context, "재생할 수 없는 영상입니다.")
                }

                }catch (t : StringIndexOutOfBoundsException)
                {
                    show(context, "재생할 수 없는 영상입니다.")

                }


            }

            override fun onVideoDuration(@NotNull youTubePlayer: YouTubePlayer, duration: Float) {
                //Log.d(TAG, "onVideoDuration: " + duration);
            }


        })




    }


    override fun getItemCount(): Int {
        return youtubeContentItem?.size ?: 0
    }
}