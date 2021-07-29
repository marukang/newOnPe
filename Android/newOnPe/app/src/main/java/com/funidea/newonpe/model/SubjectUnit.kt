package com.funidea.newonpe.model

import com.funidea.newonpe.page.main.ClassItemType.BODY_ITEM
import com.funidea.newonpe.views.ICommonItem

class SubjectUnit : ICommonItem
{
    val unit_code: String? = null
    val class_code: String? = null
    val unit_class_type: String? = null
    val unit_group_name: String? = null
    val unit_group_id_list: String? = null
    val unit_class_name: String? = null
    val unit_class_text: String? = null
    val unit_start_date: String? = null
    val unit_end_date: String? = null
    val unit_youtube_url: String? = null
    val unit_content_url: String? = null
    val unit_attached_file: String? = null
    val content_code_list: String? = null
    val content_participation: String? = null
    val content_submit_task: String? = null
    val content_use_time: String? = null
    val content_home_work: String? = null
    val content_test: String? = null
    val content_evaluation_type: String? = null
    
    override fun listItemType(): Int
    {
        return BODY_ITEM
    }
}