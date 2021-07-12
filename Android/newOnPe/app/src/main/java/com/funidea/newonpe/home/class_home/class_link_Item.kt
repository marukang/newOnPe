package com.funidea.newonpe.home.class_home

import android.os.Parcelable
import kotlinx.android.parcel.Parcelize


/** 클래스 과제 제출 링크 RecyclerView Item
 *
 * 클래스 Main Home 상단에 과제 제출 링크를 나타내 주는 RecyclerView 의  Item
 */
@Parcelize
class class_link_Item
    (

    //클래스 과제 제출 링크
    var class_link_title : String,
    //클래스 과제 제출 이메일
    var class_link_email : String

) : Parcelable