package com.dev.voltsoft.lib.db.query;

import com.dev.voltsoft.lib.model.BaseModel;
import com.dev.voltsoft.lib.view.menudrawer.Position;

public class DBQueryBind<M extends BaseModel> extends DBQuerySelect<M>
{
    public DBQueryBind(String password)
    {
        super(password);

        mDBQueryType = DBQueryType.BIND;
    }
}
