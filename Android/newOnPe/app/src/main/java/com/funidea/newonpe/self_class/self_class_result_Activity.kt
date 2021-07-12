package com.funidea.newonpe.self_class

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.funidea.newonpe.R
import com.funidea.newonpe.home.class_result.all_class_result_Adapter
import com.funidea.newonpe.home.class_result.all_class_result_Item
import kotlinx.android.synthetic.main.activity_self_class_result.*


class self_class_result_Activity : AppCompatActivity() {


    lateinit var allClassResultAdapter: all_class_result_Adapter

    var selfClassResultItem = ArrayList<all_class_result_Item>()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_self_class_result)

        allClassResultAdapter = all_class_result_Adapter(this, selfClassResultItem)

        self_class_result_recyclerview.adapter = allClassResultAdapter


    }
}