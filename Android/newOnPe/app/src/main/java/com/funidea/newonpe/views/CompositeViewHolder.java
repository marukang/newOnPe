package com.funidea.newonpe.views;

import android.util.SparseArray;
import android.view.View;

import androidx.recyclerview.widget.RecyclerView;

/**
 * @author voltsofteware (신우진)
 *
 */
public class CompositeViewHolder extends RecyclerView.ViewHolder {

    private final SparseArray<View> mChildViewArray;

    public CompositeViewHolder(View itemView)
    {
        super(itemView);

        mChildViewArray = new SparseArray<>();
    }

    @SuppressWarnings("unchecked")
    public <V extends View> V find(int viewResId) {

        View view = mChildViewArray.get(viewResId);

        if (view == null)
        {
            view = itemView.findViewById(viewResId);

            mChildViewArray.put(viewResId , view);
        }

        return (V) view;
    }
}
