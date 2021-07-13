package com.funidea.newonpe.detector

import android.os.Parcelable
import kotlinx.android.parcel.Parcelize

@Parcelize
class Pose_ResultInformation
(


    val content_name : String,
    val content_category : String,
    val content_detail_name : String,
    val content_average_score : String,
    val content_count : String,
    val content_time : String

) : Parcelable