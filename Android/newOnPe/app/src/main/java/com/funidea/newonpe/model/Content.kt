package com.funidea.newonpe.model

import com.funidea.newonpe.page.main.ClassItemType.SUBJECT_CONTENT_ITEM
import com.funidea.newonpe.views.ICommonItem
import java.io.Serializable

class Content : ICommonItem, Serializable
{
    val content_code: String? = null
    val content_value: String? = null
    val content_title: String? = null
    val content_name: String? = null
    val content_category: String? = null
    val content_user: String? = null
    val content_class_level: String? = null
    val content_class_grade: String? = null
    val content_write_date: String? = null
    val content_number_list: String? = null
    val content_name_list: String? = null
    val content_cateogry_list: String? = null
    val content_type_list: String? = null
    val content_area_list: String? = null
    val content_detail_name_list: String? = null
    val content_count_list: String? = null
    val content_time: String? = null
    val content_url: String? = null
    val content_level_list: String? = null

    override fun listItemType(): Int
    {
        return SUBJECT_CONTENT_ITEM
    }
}