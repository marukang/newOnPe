package com.funidea.newonpe.model

import com.funidea.newonpe.page.main.ClassItemType.BODY_ITEM
import com.funidea.newonpe.views.ICommonItem
import java.io.Serializable

class Subject : ICommonItem, Serializable
{
    val teacher_id: String? = null
    val teacher_name: String? = null
    val class_code: String? = null
    val class_year: String? = null
    val class_semester: String? = null
    val class_grade: String? = null
    val class_group: String? = null
    val class_people_count: String? = null
    val class_people_max_count: String? = null
    val class_name: String? = null
    val class_start_date: String? = null
    val class_end_date: String? = null
    val class_project_submit_type: String? = null
    val class_state: String? = null
    val class_unit_list: String? = null

    override fun listItemType(): Int
    {
        return BODY_ITEM
    }
}