package com.funidea.newonpe

import android.app.Application
import com.kakao.sdk.common.KakaoSdk

class GlobalApplication : Application()
{
    override fun onCreate() {
        super.onCreate()

        KakaoSdk.init(this, "ae7f17bd4bbf675f593937ddae719269")
    }
}