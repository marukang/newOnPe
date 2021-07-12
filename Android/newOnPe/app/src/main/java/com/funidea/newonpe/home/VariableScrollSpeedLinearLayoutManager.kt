package com.funidea.newonpe.home

import android.content.Context
import android.graphics.PointF
import android.util.DisplayMetrics
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.LinearSmoothScroller
import androidx.recyclerview.widget.RecyclerView

/** 가로형 RecyclerView 에서 리사이클러뷰 좌우로 스와프 시 속도를 조절해주는 Class
 *
 *  기본 RecyclerView 의 경우 좌우 스와프 시 빠른 속도로 인해 원하는 Position에 위치 시키가 매우 까다로움
 *
 *  해당 속도를 느리게 or 빠르게 조절 할 수 있는 LayoutManager Class
 *
 */
class VariableScrollSpeedLinearLayoutManager(context: Context?, private val factor: Float) :
    LinearLayoutManager(context) {
    override fun smoothScrollToPosition(
        recyclerView: RecyclerView,
        state: RecyclerView.State,
        position: Int
    ) {
        val linearSmoothScroller: LinearSmoothScroller = object : LinearSmoothScroller(recyclerView.context) {
            override fun computeScrollVectorForPosition(targetPosition: Int): PointF? {

                return this@VariableScrollSpeedLinearLayoutManager.computeScrollVectorForPosition(targetPosition)
            }

            override fun calculateSpeedPerPixel(displayMetrics: DisplayMetrics): Float {
                return super.calculateSpeedPerPixel(displayMetrics) * factor
            }
        }
        linearSmoothScroller.targetPosition = position
        startSmoothScroll(linearSmoothScroller)
    }

}