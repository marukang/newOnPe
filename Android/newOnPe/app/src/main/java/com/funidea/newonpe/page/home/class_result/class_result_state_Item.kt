package com.funidea.newonpe.page.home.class_result

import android.os.Parcelable
import kotlinx.android.parcel.Parcelize


/** Class_result_Activity 에서 상단의 수업 참여 여부를 나타내주는 RecyclerView Item
 *
 *
 */

@Parcelize
class class_result_state_Item
    (

    var result_name : String,

    var result_value : String

) : Parcelable