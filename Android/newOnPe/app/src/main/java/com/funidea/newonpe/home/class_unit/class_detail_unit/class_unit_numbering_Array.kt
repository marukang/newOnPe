package com.funidea.newonpe.home.class_unit.class_detail_unit

import android.os.Parcelable
import kotlinx.android.parcel.Parcelize


/** 차시별 운동 콘텐츠의 실행여부를 보여줄 수 있도록 해주는 Array Class
 *
 *  차시별 운동의 실습과 평가 수와 해당 앱 사용자가 Content를 진행했는지를 판단해서
 *  운동 완료 여부를 Array 저장 및 보여줄 수 있도록 해준다.
 */

@Parcelize
class class_unit_numbering_Array
(
    var size : Int,
    var position_number : Int,
    var title : String

) : Parcelable