package com.funidea.newonpe.page.main

import android.os.Bundle
import android.view.View
import androidx.drawerlayout.widget.DrawerLayout
import com.funidea.newonpe.R
import com.funidea.newonpe.page.CommonActivity

class MainHomePage : CommonActivity()
{
    private lateinit var mDrawerOpenButton : View
    private lateinit var mDrawer : DrawerLayout
    private lateinit var mSideBar : View

    override fun init(savedInstanceState: Bundle?)
    {
        setContentView(R.layout.activity_main_home)

        mDrawer = findViewById(R.id.drawerLayout)
        mDrawerOpenButton = findViewById(R.id.openDrawerButton)
        mDrawerOpenButton.setOnClickListener { mDrawer.openDrawer(mSideBar) }
        mSideBar = findViewById(R.id.sideBarLayout)
    }
}