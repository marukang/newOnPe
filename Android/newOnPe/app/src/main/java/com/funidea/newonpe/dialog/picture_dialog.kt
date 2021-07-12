package com.funidea.newonpe.dialog


import android.content.Context
import android.view.View
import com.funidea.newonpe.R
import com.google.android.material.bottomsheet.BottomSheetDialog
import kotlinx.android.synthetic.main.picture_bottom_dialog.*

/** 사진 사용 시 보여질 Bottom Dialog
 *
 *  프로필 사진 변경, 커뮤니티 사진 등록 시 보여질 Bottom Dialog
 */

class picture_dialog(context: Context) : BottomSheetDialog(context) {


    var get_image_select_Listener : ImageSelectListener? =null
    val place_type_array = ArrayList<String>()

    

    interface ImageSelectListener
    {
        fun select_image_value(select : String?)
    }

    fun setImageSelectListener(get_image_select_Listener : ImageSelectListener)
    {
        this.get_image_select_Listener = get_image_select_Listener
    }

    init {
        val view: View = layoutInflater.inflate(R.layout.picture_bottom_dialog, null)
        setContentView(view)

        //사진 가져오기
        //현재 사용 불가
        take_photo_button_textview.setOnClickListener {

            get_image_select_Listener?.select_image_value("0")
        }

        //앨범에서 사진 가져오기 버튼
        get_album_textview.setOnClickListener {

            get_image_select_Listener?.select_image_value("1")
        }
     

     
        }


    }


   

