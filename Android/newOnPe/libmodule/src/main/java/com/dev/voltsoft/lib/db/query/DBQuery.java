package com.dev.voltsoft.lib.db.query;

import android.content.Context;
import com.dev.voltsoft.lib.db.DBQueryHandler;
import com.dev.voltsoft.lib.model.BaseRequest;
import com.dev.voltsoft.lib.network.base.INetworkProgressView;

public abstract class DBQuery extends BaseRequest implements Runnable {

    protected Context             mContext;

    protected DBQueryType         mDBQueryType;

    protected INetworkProgressView ProgressView;

    public String dbPassword;

    public DBQuery(DBQueryType queryType, String password)
    {
        mDBQueryType = queryType;

        dbPassword = password;
    }

    public Context getContext()
    {
        return mContext;
    }

    public void setContext(Context c)
    {
        this.mContext = c;
    }

    @SuppressWarnings("unchecked")
    @Override
    public void run()
    {
        if (mContext != null && mDBQueryType != null)
        {
            DBQueryHandler.getInstance().handle(this);
        }
    }

    public DBQueryType getDbRequestType()
    {
        return mDBQueryType;
    }

    public INetworkProgressView getProgressView()
    {
        return ProgressView;
    }

    public void setProgressView(INetworkProgressView progressView)
    {
        ProgressView = progressView;
    }
}
