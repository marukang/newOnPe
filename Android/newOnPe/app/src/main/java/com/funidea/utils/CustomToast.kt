package com.funidea.utils

import android.content.Context
import android.widget.Toast

/**
 * 커스텀 토스트
 * Toast Class
 */

class CustomToast
{
    companion object {

        fun show(context: Context, string: String) {
            Toast.makeText(context, string, Toast.LENGTH_SHORT).show()
        }
    }
}