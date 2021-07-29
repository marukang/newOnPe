package com.dev.voltsoft.lib.db.query;

import com.dev.voltsoft.lib.model.BaseModel;

import java.util.ArrayList;
import java.util.Arrays;

public class DBQueryUpdate<M extends BaseModel> extends DBQuery
{
    public ArrayList<M>     mTargetInstanceList = new ArrayList<>();

    public DBQueryUpdate(String password)
    {
        super(DBQueryType.QUERY_UPDATE, password);
    }

    public void addInstance(M ... m)
    {
        if (mTargetInstanceList != null)
        {
            mTargetInstanceList.addAll(Arrays.asList(m));
        }
    }
}
