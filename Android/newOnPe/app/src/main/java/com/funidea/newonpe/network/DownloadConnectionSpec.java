package com.funidea.newonpe.network;

import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.http.GET;
import retrofit2.http.Url;

public interface DownloadConnectionSpec
{
    @GET
    Call<ResponseBody> downloadVideo(@Url String downloadPath);
}
