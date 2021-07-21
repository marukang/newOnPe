package com.funidea.newonpe.page.main

import android.os.Bundle
import android.view.View
import android.widget.ImageView
import android.widget.TextView
import androidx.drawerlayout.widget.DrawerLayout
import com.funidea.newonpe.R
import com.funidea.newonpe.page.CommonActivity
import kotlinx.android.synthetic.main.activity_main_home.*

class MainHomePage : CommonActivity()
{
    private lateinit var mDrawerOpenButton : View
    private lateinit var mDrawer : DrawerLayout
    private lateinit var mSideBar : View

    private var mClickActionOfBottomMenu : View.OnClickListener = View.OnClickListener { v ->

        val tag : Int = (v?.tag) as Int

        selectBottomMenu(tag)
        showSelectedMenuPage(tag)
    }

    override fun init(savedInstanceState: Bundle?)
    {
        setContentView(R.layout.activity_main_home)

        mDrawer = findViewById(R.id.drawerLayout)
        mDrawerOpenButton = findViewById(R.id.openDrawerButton)
        mDrawerOpenButton.setOnClickListener { mDrawer.openDrawer(mSideBar) }
        mSideBar = findViewById(R.id.sideBarLayout)

        mainBottomButton1.tag = 1
        mainBottomButton1.setOnClickListener(mClickActionOfBottomMenu)
        mainBottomButton2.tag = 2
        mainBottomButton2.setOnClickListener(mClickActionOfBottomMenu)
        mainBottomButton3.tag = 3
        mainBottomButton3.setOnClickListener(mClickActionOfBottomMenu)
        mainBottomButton4.tag = 4
        mainBottomButton4.setOnClickListener(mClickActionOfBottomMenu)

        selectBottomMenu(1)
        showSelectedMenuPage(1)
    }

    private fun selectBottomMenu(index : Int)
    {
        for (i in 1 .. 4)
        {
            val bottomMenuTextViewId = resources.getIdentifier("mainBottomButtonText$i", "id" ,packageName)
            val bottomMenuImageViewId = resources.getIdentifier("mainBottomButtonImage${i}", "id" ,packageName)

            val bottomMenuTextView : TextView = findViewById(bottomMenuTextViewId)
            val bottomMenuImageView : ImageView = findViewById(bottomMenuImageViewId)

            val textColor = if (i == index) R.color.main_color else R.color.black
            bottomMenuTextView.setTextColor(resources.getColor(textColor, null))
            bottomMenuImageView.isSelected = (i == index)
        }
    }

    private fun showSelectedMenuPage(index : Int)
    {
        popBackFragmentStack()

        when (index)
        {
            1 -> { replaceFragment(R.id.fragmentContainer, FragmentTodayClass()) }
            2 -> { replaceFragment(R.id.fragmentContainer, FragmentMyClass()) }
            3 -> {  }
            4 -> {  }
        }
    }
}