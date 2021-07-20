package com.funidea.newonpe.model

import android.net.Uri
import java.util.*

object CurrentLoginStudent : Observable()
{
    var root : Student? = null
        set(value) {
            field = value

            setChanged()

            notifyObservers()
        }

    var currentSelectedPhotoPath : Uri? = null
        set(value) {
            field = value

            setChanged()

            notifyObservers()
        }
}