package com.funidea.newonpe.page.home.class_community_board

import android.os.Parcelable
import kotlinx.android.parcel.Parcelize


/** 커뮤니티의 게시글 및 클래스의 첨부파일의 RecyclerView Item
 *
 * 관련 Class - class_community_board_Activity , class_unit_Activity
 */

@Parcelize
class board_file_Item
    (

    var file_name : String,

    var file_url : String

) : Parcelable