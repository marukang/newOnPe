package com.funidea.newonpe.dialog.class_code_dialog_Utils

import android.os.Parcelable
import kotlinx.android.parcel.Parcelize

/* class_code_dialog의 Recyclerview Itme Class
*
*/
@Parcelize
class class_code_dialog_Item
    (
    //클래스 이름
    var class_name : String,
    //클래스 코드
    var class_code : String,
    //현재 클래스 선택 여부
    var class_select_value : Int

) : Parcelable