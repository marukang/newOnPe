package com.dev.voltsoft.lib.db;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.os.Handler;
import android.text.TextUtils;
import android.util.Log;
import com.dev.voltsoft.lib.IRequestHandler;
import com.dev.voltsoft.lib.IResponseListener;
import com.dev.voltsoft.lib.component.CommonApplication;
import com.dev.voltsoft.lib.constatns.ValueType;
import com.dev.voltsoft.lib.db.query.*;
import com.dev.voltsoft.lib.model.BaseModel;
import com.dev.voltsoft.lib.network.base.INetworkProgressView;
import com.dev.voltsoft.lib.utility.EasyLog;

import net.sqlcipher.database.SQLiteDatabase;
import net.sqlcipher.database.SQLiteDatabaseHook;

import java.io.File;
import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.Locale;

public class DBQueryHandler<R extends DBQuery> implements IRequestHandler<R>
{
    private String DB = "application.db";
    private int    DB_VERSION = 50;
    private static Class<? extends BaseModel>[] DB_TABLE_LIST;

    private static class LazyHolder
    {
        private static DBQueryHandler mInstance = new DBQueryHandler();
    }

    public static DBQueryHandler getInstance()
    {
        return LazyHolder.mInstance;
    }

    public void init(CommonApplication application)
    {
        DB_VERSION = application.getApplicationDBVersion();

        DB = String.format(Locale.ENGLISH, "application%d.db", DB_VERSION);

        DB_TABLE_LIST = application.getApplicationTableList();
    }

    @Override
    public void handle(final R r)
    {
        INetworkProgressView progressView = r.getProgressView();

        if (progressView != null)
        {
            progressView.onLoading();
        }

        Context c = r.getContext();

        DBQueryHelper DBQueryHelper = new DBQueryHelper();

        DBQueryHelper.open(c, r.dbPassword);

        DBQueryType dbQueryType = r.getDbRequestType();

        try
        {
            switch (dbQueryType)
            {
                case QUERY_DELETE:
                {
                    queryDelete(DBQueryHelper, (DBQueryDelete) r);

                    break;
                }

                case QUERY_INSERT:
                {
                    queryInsert(DBQueryHelper, (DBQueryInsert) r);

                    break;
                }

                case QUERY_UPDATE:
                {
                    queryUpdate(DBQueryHelper, (DBQueryUpdate) r);

                    break;
                }

                case QUERY_SELECT:
                {
                    querySelect(DBQueryHelper, (DBQuerySelect) r);

                    break;
                }

                case BIND:
                {
                    queryBind(DBQueryHelper, (DBQueryBind) r);

                    break;
                }
            }
        }
        catch (Exception e)
        {
            e.printStackTrace();

            if (progressView != null)
            {
                progressView.onLoadingEnd();
            }

            final IResponseListener responseListener = r.getResponseListener();

            if (responseListener != null && r.getContext() != null)
            {

                new Handler(r.getContext().getMainLooper()).post(new Runnable()
                {
                    @Override
                    public void run()
                    {
                        DBQueryResponse dbQueryResponse = new DBQueryResponse();
                        dbQueryResponse.setResponseCode(-1);
                        dbQueryResponse.setSourceRequest(r);

                        responseListener.onResponseListen(dbQueryResponse);
                    }
                });
            }
        }

        DBQueryHelper.close();
    }

    @SuppressWarnings("unchecked")
    private <M extends BaseModel> void queryBind(DBQueryHelper helper, final DBQuerySelect r) throws Exception
    {
        String strQuery = r.DBQuery;

        Class<M> c = r.TargetClass;

        if (!helper.isTableExist(c))
        {
            helper.execCreateQuery(c);
        }

        if (TextUtils.isEmpty(strQuery))
        {
            strQuery = helper.querySelectDBSchema(c, r.WhereClause, r.OrderClause);
        }

        Log.d("woozie", ">> queryBind strQuery = " + strQuery);

        Cursor cursor = helper.query(strQuery);

        Log.d("woozie", ">> queryBind exist? = " + cursor.moveToFirst());

        if (cursor.moveToFirst())
        {
            final IResponseListener responseListener = r.getResponseListener();

            final DBQueryResponse dbQueryResponse = new DBQueryResponse();
            dbQueryResponse.setResponseCode(1);
            dbQueryResponse.setSourceRequest(r);
            dbQueryResponse.setResponseModel(cursor);

            if (responseListener != null && r.getContext() != null)
            {
                new Handler(r.getContext().getMainLooper()).post(new Runnable()
                {
                    @Override
                    public void run()
                    {
                        if (r.getProgressView() != null)
                        {
                            r.getProgressView().onLoadingEnd();
                        }

                        responseListener.onResponseListen(dbQueryResponse);
                    }
                });
            }
        }
        else
        {
            throw new Exception();
        }
    }

    @SuppressWarnings("unchecked")
    private <M extends BaseModel> void querySelect(DBQueryHelper helper, final DBQuerySelect r) throws Exception
    {
        String strQuery = r.DBQuery;

        Class<M> c = r.TargetClass;

        if (!helper.isTableExist(c))
        {
            helper.execCreateQuery(c);
        }

        if (TextUtils.isEmpty(strQuery))
        {
            strQuery = helper.querySelectDBSchema(c, r.WhereClause, r.OrderClause);
        }

        Log.d("woozie", ">> querySelect strQuery = " + strQuery);

        Cursor cursor = helper.query(strQuery);

        Log.d("woozie", ">> querySelect exist? = " + cursor.moveToFirst());

        if (cursor.moveToFirst())
        {
            Log.d("woozie", ">> querySelect getCount ? = " + cursor.getCount());

            ArrayList<M> mArrayList = new ArrayList<>();

            do
            {
                M m = c.newInstance();

                m.matchingCursor(cursor);

                mArrayList.add(m);
            }
            while (cursor.moveToNext());

            final IResponseListener responseListener = r.getResponseListener();

            final DBQueryResponse dbQueryResponse = new DBQueryResponse();
            dbQueryResponse.setResponseCode(1);
            dbQueryResponse.setSourceRequest(r);
            dbQueryResponse.setResponseModel(mArrayList);

            if (responseListener != null && r.getContext() != null)
            {
                new Handler(r.getContext().getMainLooper()).post(new Runnable()
                {
                    @Override
                    public void run()
                    {
                        if (r.getProgressView() != null)
                        {
                            r.getProgressView().onLoadingEnd();
                        }

                        responseListener.onResponseListen(dbQueryResponse);
                    }
                });
            }
        }
        else
        {
            throw new Exception();
        }
    }

    private void queryUpdate(DBQueryHelper DBQueryHelper, final DBQueryUpdate r) throws Exception
    {
        boolean bUpdated = DBQueryHelper.updateDBDataList(r.mTargetInstanceList);

        if (r.getResponseListener() != null && r.getContext() != null)
        {
            final DBQueryResponse dbQueryResponse = new DBQueryResponse();

            dbQueryResponse.setResponseCode((bUpdated ? 1 : -1));
            dbQueryResponse.setSourceRequest(r);
            dbQueryResponse.setUpdated(bUpdated);

            new Handler(r.getContext().getMainLooper()).post(new Runnable()
            {
                @Override
                public void run()
                {
                    if (r.getProgressView() != null)
                    {
                        r.getProgressView().onLoadingEnd();
                    }

                    r.getResponseListener().onResponseListen(dbQueryResponse);
                }
            });
        }
    }

    private void queryDelete(DBQueryHelper DBQueryHelper, final DBQueryDelete r) throws Exception
    {
        boolean bDeleted = DBQueryHelper.dropRecordList(r.mTargetInstanceList);

        if (r.getResponseListener() != null && r.getContext() != null)
        {
            final DBQueryResponse dbQueryResponse = new DBQueryResponse();
            dbQueryResponse.setResponseCode((bDeleted ? 1 : -1));
            dbQueryResponse.setSourceRequest(r);
            dbQueryResponse.setInserted(bDeleted);

            new Handler(r.getContext().getMainLooper()).post(new Runnable()
            {
                @Override
                public void run()
                {
                    if (r.getProgressView() != null)
                    {
                        r.getProgressView().onLoadingEnd();
                    }

                    r.getResponseListener().onResponseListen(dbQueryResponse);
                }
            });
        }
    }

    private void queryInsert(DBQueryHelper DBQueryHelper, final DBQueryInsert r) throws Exception
    {
        boolean bInserted = DBQueryHelper.insertDBDataBulk(r.mTargetInstanceList);

        if (r.getResponseListener() != null && r.getContext() != null)
        {
            final DBQueryResponse dbQueryResponse = new DBQueryResponse();
            dbQueryResponse.setResponseCode((bInserted ? 1 : -1));
            dbQueryResponse.setSourceRequest(r);
            dbQueryResponse.setInserted(bInserted);

            new Handler(r.getContext().getMainLooper()).post(new Runnable()
            {
                @Override
                public void run()
                {
                    if (r.getProgressView() != null)
                    {
                        r.getProgressView().onLoadingEnd();
                    }

                    r.getResponseListener().onResponseListen(dbQueryResponse);
                }
            });
        }
    }

    private class DBQueryHelper
    {
        private SQLiteDatabase mSqLiteDatabase;

        synchronized public SQLiteDatabase open(Context context, String password)
        {
            File file = context.getDatabasePath(DB);

            mSqLiteDatabase = SQLiteDatabase.openOrCreateDatabase(file, password, null);

            for (Class<? extends BaseModel> c : DB_TABLE_LIST)
            {
                if (!isTableExist(c))
                {
                    execCreateQuery(c);
                }
            }

            return mSqLiteDatabase;
        }

        synchronized public void close()
        {
            if (mSqLiteDatabase != null)
            {
                mSqLiteDatabase.close();
            }
        }

        private  <M extends BaseModel> boolean insertDBDataBulk(ArrayList<M> instances)
        {
            boolean result = false;

            for (M t : instances)
            {
                result = insertDBData(t);
            }

            return result;
        }

        @SuppressWarnings("unchecked")
        private <M extends BaseModel> boolean insertDBData(M instance)
        {

            if (!isTableExist(instance.getClass()))
            {
                execCreateQuery(instance.getClass());
            }

            ContentValues contentValues = new ContentValues();

            for (Field field : instance.fieldList())
            {
                if (isValidField(field))
                {
                    Object value = instance.fieldValue(field);

                    if (value != null)
                    {
                        if (value instanceof BaseModel)
                        {
                            insertDBData((BaseModel) value);
                        }
                        else if (value instanceof ArrayList)
                        {
                            ArrayList arrayList = (ArrayList) value;

                            for (Object o : arrayList)
                            {
                                //TODO
                            }
                        }
                        else if (isValidDataType(field))
                        {
                            contentValues.put(field.getName(), String.valueOf(value));
                        }
                    }
                }
            }

            if (contentValues.size() > 0)
            {
                String tableName = instance.getClass().getSimpleName();

                return (queryExist(instance) ? updateDBData(tableName, createWhereClause(instance), contentValues) : insertDBData(tableName, contentValues));
            }
            else
            {
                return false;
            }
        }

        private boolean insertDBData(String tableName, ContentValues contentValues)
        {
            try
            {
                return (mSqLiteDatabase.insert(tableName , null , contentValues) != -1);
            }
            catch (Exception e)
            {
                e.printStackTrace();

                close();

                return false;
            }
        }

        private <M extends BaseModel> boolean dropRecordList(ArrayList<M> instances)
        {
            boolean result = false;

            for (M t : instances)
            {
                result = dropRecord(t);
            }

            return result;
        }

        @SuppressWarnings("unchecked")
        private <M extends BaseModel> boolean dropTableRecord(Class<M> mClass)
        {
            try
            {
                String tableName = mClass.getSimpleName();

                int result = mSqLiteDatabase.delete(tableName , null , null);

                return (result > 0);
            }
            catch (Exception e)
            {
                e.printStackTrace();

                return false;
            }
        }

        @SuppressWarnings("unchecked")
        private <M extends BaseModel> boolean dropRecord(M instance)
        {
            try
            {
                String tableName = instance.getClass().getSimpleName();

                // String strWhereClause = createWhereClause(instance);

                ArrayList<String> valueArrayList = new ArrayList<>();

                StringBuilder stringBuilder = new StringBuilder();

                boolean b = false;

                for (Field field : instance.fieldList())
                {

                    if (isPrimaryField(field))
                    {
                        Object dbColumnData = instance.fieldValue(field);

                        if (dbColumnData != null)
                        {

                            if (dbColumnData instanceof Integer)
                            {
                                int data = (int) dbColumnData;
                                if (data == 0)
                                {
                                    continue;
                                }
                            }

                            if (b)
                            {
                                stringBuilder.append(" AND ");
                            }

                            stringBuilder.append(field.getName());
                            stringBuilder.append(" = ? ");

                            valueArrayList.add(String.valueOf(dbColumnData));

                            b = true;
                        }
                    }
                }

                String[] whereArgs = new String[valueArrayList.size()];

                int size = 0;

                for (String temp : valueArrayList)
                {
                    whereArgs[size++] = temp;
                }

                int result = mSqLiteDatabase.delete(tableName , stringBuilder.toString() , whereArgs);

                return (result > 0);
            }
            catch (Exception e)
            {
                e.printStackTrace();

                return false;
            }
        }

        private <M extends BaseModel> boolean updateDBDataList(ArrayList<M> instances)
        {
            boolean result = false;

            for (M t : instances)
            {
                result = updateDBData(t);
            }

            return result;
        }

        @SuppressWarnings("unchecked")
        private <M extends BaseModel> boolean updateDBData(M instance)
        {
            try
            {
                String tableName = instance.getClass().getSimpleName();

                String strWhereClause = createWhereClause(instance);

                ContentValues contentValues = createUpdateValues(instance);

                return updateDBData(tableName, strWhereClause , contentValues);
            }
            catch (Exception e)
            {
                e.printStackTrace();

                return false;
            }
        }

        private <M extends BaseModel> boolean updateDBData(String tableName , String whereClause , ContentValues contentValues)
        {
            return (mSqLiteDatabase.update(tableName , contentValues , whereClause , null) > 0);
        }

        @SuppressWarnings("unchecked")
        private <M extends BaseModel> boolean queryExist(M instance)
        {
            try
            {
                String tableName = instance.getClass().getSimpleName();

                String whereClause = createWhereClause(instance);

                Cursor cursor = queryWithWhereClause(tableName , whereClause);

                return cursor.moveToFirst();
            }
            catch (Exception e)
            {
                e.printStackTrace();

                return false;
            }
        }

        private Cursor queryWithWhereClause(String tableName , String whereClause)
        {
            if (TextUtils.isEmpty(whereClause))
            {
                whereClause = null;
            }

            return mSqLiteDatabase.query(tableName , null , whereClause , null, null, null, null);
        }

        private Cursor query(String strQuery)
        {
            return mSqLiteDatabase.rawQuery(strQuery , null);
        }

        @SuppressWarnings("unchecked")
        private <M extends BaseModel> String createWhereClause(M instance)
        {
            StringBuilder stringBuilder = new StringBuilder();

            boolean b = false;

            for (Field field : instance.fieldList())
            {

                if (isPrimaryField(field))
                {
                    Object dbColumnData = instance.fieldValue(field);

                    if (dbColumnData != null)
                    {

                        if (dbColumnData instanceof Integer)
                        {
                            int data = (int) dbColumnData;
                            if (data == 0)
                            {
                                continue;
                            }
                        }

                        if (b)
                        {
                            stringBuilder.append(" AND ");
                        }

                        stringBuilder.append(field.getName());
                        stringBuilder.append(" = '");
                        stringBuilder.append(String.valueOf(dbColumnData));
                        stringBuilder.append("'");

                        b = true;
                    }
                }
            }
            return stringBuilder.toString();
        }

        @SuppressWarnings("unchecked")
        private <M extends BaseModel> ContentValues createUpdateValues(M m)
        {
            ContentValues contentValues = new ContentValues();

            for (Field field : m.fieldList())
            {
                if (isValidField(field))
                {
                    Object dbColumnData = m.fieldValue(field);

                    if (dbColumnData != null)
                    {
                        if (ValueType.INTEGER.isEqualType(field.getType()))
                        {
                            int data = (int) dbColumnData;
                            if (data > 0)
                            {
                                contentValues.put(field.getName(), String.valueOf(data));
                            }
                        }
                        else
                        {
                            contentValues.put(field.getName(), String.valueOf(dbColumnData));
                        }
                    }

                }

            }
            return contentValues;
        }

        private <M extends BaseModel> void execCreateQuery(Class<M> mClass)
        {
            try
            {
                M m = mClass.newInstance();

                execCreateQuery(m);
            }
            catch (Exception e)
            {
                e.printStackTrace();
            }
        }

        private <M extends BaseModel> void execCreateQuery(M instance)
        {

            try
            {
                String strQuery = queryCreateDBSchema(instance);

                Log.d("woozie", ">> execCreateQuery strQuery = " + strQuery);

                execSQLQuery(mSqLiteDatabase , strQuery);
            }
            catch (Exception e)
            {
                e.printStackTrace();
            }
        }

        private <M extends BaseModel> void execUpdateQuery(Class<? extends M> mClass)
        {
            try
            {
                M m = mClass.newInstance();

                execUpdateQuery(m);
            }
            catch (Exception e)
            {
                e.printStackTrace();
            }
        }

        private <M extends BaseModel> void execUpdateQuery(M instance)
        {
            try
            {
                String strQuery = queryUpdateDBSchema(instance);

                Log.d("woozie", ">> execUpdateQuery strQuery = " + strQuery);

                execSQLQuery(mSqLiteDatabase , strQuery);
            }
            catch (Exception e)
            {
                e.printStackTrace();
            }
        }

        private void execSQLQuery(net.sqlcipher.database.SQLiteDatabase db , String query)
        {
            try
            {
                if (db != null)
                {
                    db.execSQL(query);
                }
            }
            catch (Exception e)
            {
                e.printStackTrace();
            }
        }

        @SuppressWarnings("unchecked")
        private <M extends BaseModel> String queryCreateDBSchema(M instance)
        {
            boolean b = false;

            StringBuilder primaryKeySet = new StringBuilder();
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.append(" CREATE TABLE IF NOT EXISTS ");
            stringBuilder.append(instance.getClass().getSimpleName());
            stringBuilder.append(" ( ");

            for (Field field : instance.fieldList())
            {

                if (isValidField(field))
                {
                    String fieldName = field.getName();

                    if (b)
                    {
                        stringBuilder.append(",");
                    }
                    stringBuilder.append(fieldName);
                    stringBuilder.append(" TEXT ");

                    if (field.isAnnotationPresent(Unique.class))
                    {
                        if (primaryKeySet.toString().length() != 0)
                        {
                            primaryKeySet.append(",");
                        }

                        primaryKeySet.append(fieldName);
                    }

                    b = true;
                }
            }

            if (!TextUtils.isEmpty(primaryKeySet.toString()))
            {
                stringBuilder.append(",");
                stringBuilder.append("PRIMARY KEY (");
                stringBuilder.append(primaryKeySet.toString());
                stringBuilder.append(")");
            }
            stringBuilder.append(" )");

            return stringBuilder.toString();
        }

        @SuppressWarnings("unchecked")
        private <M extends BaseModel> String querySelectDBSchema(Class<M> mClass)
        {
            StringBuilder idBuilder = new StringBuilder();

            Field[] fieldList = mClass.getDeclaredFields();

            for (Field field : fieldList)
            {
                if (isValidField(field))
                {
                    String fieldName = field.getName();

                    if (field.isAnnotationPresent(Unique.class))
                    {
                        idBuilder.append(fieldName);
                        idBuilder.append(" || ");
                    }
                }
            }

            idBuilder.append(" \"\" ");
            idBuilder.append(" AS _id ,");

            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.append("SELECT ");
            stringBuilder.append(idBuilder);

            int size = fieldList.length;

            String prefix = "";

            for (int i = 0 ; i < size ; i++)
            {
                Field field = fieldList[i];

                if (isValidField(field))
                {
                    String fieldName = field.getName();

                    stringBuilder.append(prefix);
                    stringBuilder.append(fieldName);

                    prefix = ",";
                }

                stringBuilder.append(" ");
            }

            stringBuilder.append("FROM ");
            stringBuilder.append(mClass.getSimpleName());
            stringBuilder.append(" WHERE 1=1 ");


            return stringBuilder.toString();
        }

        @SuppressWarnings("unchecked")
        private <M extends BaseModel> String querySelectDBSchema(Class<M> mClass, ContentValues conditionClause, ContentValues orderClause)
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.append(querySelectDBSchema(mClass));

            if (conditionClause != null)
            {
                for (String key : conditionClause.keySet())
                {
                    Object o = conditionClause.get(key);

                    if (o != null)
                    {
                        stringBuilder.append(" AND ");
                        stringBuilder.append(key);
                        stringBuilder.append(" = '");
                        stringBuilder.append(o);
                        stringBuilder.append("'");
                    }
                }
            }

            int orderClauseSize = (orderClause != null ? orderClause.size() : 0);

            if (orderClauseSize > 0)
            {
                stringBuilder.append(" ORDER BY ");

                String prefix = "";

                for (String key : orderClause.keySet())
                {
                    Object o = orderClause.get(key);

                    if (o != null)
                    {
                        stringBuilder.append(prefix);
                        stringBuilder.append(key);
                        stringBuilder.append(" ");
                        stringBuilder.append(o);
                        stringBuilder.append(" ");

                        prefix = " , ";
                    }
                }
            }

            return stringBuilder.toString();
        }

        private <M extends BaseModel> String queryUpdateDBSchema(M instance)
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.append(String.valueOf("DROP TABLE IF EXISTS "));
            stringBuilder.append(instance.getClass().getSimpleName());
            return stringBuilder.toString();
        }

        private boolean isValidDataType(Field field)
        {
            for (ValueType v : ValueType.values())
            {
                if (v.isEqualType(field.getType()))
                {
                    return true;
                }
            }

            return false;
        }

        private boolean isValidField(Field field)
        {
            return (!field.isSynthetic() && !"serialVersionUID".equalsIgnoreCase(field.getName()));
        }

        private boolean isPrimaryField(Field field)
        {
            return (isValidField(field) && field.isAnnotationPresent(Unique.class));
        }

        private <M extends BaseModel> boolean isTableExist(Class<M> mClass)
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.append("SELECT DISTINCT tbl_name FROM sqlite_master WHERE tbl_name = '");
            stringBuilder.append(mClass.getSimpleName());
            stringBuilder.append("'");

            Cursor cursor = query(stringBuilder.toString());

            try
            {
                if (cursor!=null)
                {
                    if (cursor.getCount() > 0)
                    {
                        return true;
                    }
                }
                return false;
            }
            catch (Exception e)
            {
                e.printStackTrace();

                return false;
            }
            finally
            {
                if (cursor != null)
                {
                    cursor.close();
                }
            }
        }
    }
}
