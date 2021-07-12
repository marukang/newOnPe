package com.funidea.utils

import android.content.Context


/**
 * 토큰 갱신 클래스
 * 서버로 부터 데이터를 받아오는 경우
 * 토큰을 갱신화 시켜 최신화 상태로 유지한다.
 *
 */

class save_SharedPreferences
{

    companion object {

        //받아온 Token 정보를 shard에 저장한다.
        fun save_shard(context: Context, access_token: String) {

            val prefs = context.getSharedPreferences("user_info", Context.MODE_PRIVATE)
            val editor = prefs.edit()

            editor.putString("user_access_token", access_token)

            editor.commit()
        }

    }
}