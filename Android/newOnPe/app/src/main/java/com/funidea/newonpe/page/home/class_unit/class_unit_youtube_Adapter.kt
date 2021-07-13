package com.funidea.newonpe.page.home.class_unit

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.funidea.utils.CustomToast.Companion.show
import com.funidea.newonpe.R
import com.pierfrancescosoffritti.androidyoutubeplayer.core.player.YouTubePlayer
import com.pierfrancescosoffritti.androidyoutubeplayer.core.player.listeners.AbstractYouTubePlayerListener
import kotlinx.android.synthetic.main.class_unit_youtube_recyclerview_item.view.*
import org.jetbrains.annotations.NotNull


/** Class Unit Activty (차시별 수업 정보)에서 유투브 영상이 재생되는 Recyclerview 의 Adapter
 *
 *
 */

class class_unit_youtube_Adapter(context: Context, classUnitYoutubeItem: ArrayList<class_unit_youtube_Item>?)
    : RecyclerView.Adapter<class_unit_youtube_Adapter.ViewHolder>() {

    private val classUnitYoutubeItem: ArrayList<class_unit_youtube_Item>?

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
        this.classUnitYoutubeItem = classUnitYoutubeItem
        this.context = context
    }


    inner class ViewHolder(view: View?, mListener: onItemClickListener?) :
        RecyclerView.ViewHolder(view!!) {

        val  class_unit_youtubeview = itemView.class_unit_youtubeview

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
            .inflate(R.layout.class_unit_youtube_recyclerview_item, viewGroup, false)
        return ViewHolder(view, mListener)

    }


    override fun onBindViewHolder(viewHolder: ViewHolder, position: Int) {

        val position_item: class_unit_youtube_Item = classUnitYoutubeItem!![position]


        viewHolder.class_unit_youtubeview.addYouTubePlayerListener(object : AbstractYouTubePlayerListener() {
            override fun onReady(@NotNull youTubePlayer : YouTubePlayer) {

                try {

                var  get_youtube_url: String
                get_youtube_url = position_item.youtube_id

                if(get_youtube_url.length==43)
                {
                    youTubePlayer.cueVideo (get_youtube_url.substring(32, 43), 0f)
                }
                else if(get_youtube_url.length==28)
                {

                    youTubePlayer.cueVideo (get_youtube_url.substring(17, 28), 0f)

                }
                else if(get_youtube_url.length>43)
                {
                    youTubePlayer.cueVideo (get_youtube_url.substring(32, 43), 0f)
                }

                else
               {
                   show(context, "재생할 수 없는 영상입니다.")
               }


                }
                catch (t : StringIndexOutOfBoundsException )
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
        return classUnitYoutubeItem?.size ?: 0
    }
}