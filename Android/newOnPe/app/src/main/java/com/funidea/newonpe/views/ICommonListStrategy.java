package com.funidea.newonpe.views;

import android.view.View;
import android.view.ViewGroup;

public interface ICommonListStrategy
{
    View createItemView(ViewGroup parent, int viewType);

    void drawItemView(CompositeViewHolder holder, int position, int viewType, ICommonItem item);
}
