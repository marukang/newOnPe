package com.funidea.newonpe.page.login

import android.Manifest
import android.annotation.SuppressLint
import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.os.Environment
import android.provider.MediaStore
import android.text.Editable
import android.text.TextUtils
import android.text.TextWatcher
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.EditText
import android.widget.TextView
import android.widget.Toast
import androidx.core.content.FileProvider
import com.bumptech.glide.Glide
import com.bumptech.glide.load.engine.DiskCacheStrategy
import com.funidea.newonpe.R
import com.funidea.newonpe.dialog.CommonDialog
import com.funidea.newonpe.dialog.SelectPictureDialog
import com.funidea.newonpe.model.CurrentLoginStudent
import com.funidea.newonpe.network.ServerConnection
import com.funidea.newonpe.page.CommonActivity
import com.funidea.newonpe.views.SelfProfileImageView
import com.gun0912.tedpermission.PermissionListener
import com.gun0912.tedpermission.TedPermission
import kotlinx.android.synthetic.main.activity_join_page.*
import okhttp3.MediaType
import okhttp3.MultipartBody
import okhttp3.RequestBody
import java.io.File
import java.text.SimpleDateFormat
import java.util.*
import java.util.regex.Pattern
import kotlin.collections.ArrayList

class ProfileRegistrationPage : CommonActivity()
{
    companion object
    {
        const val CALL = 1001
    }

    private lateinit var mProfileImageView : SelfProfileImageView
    private lateinit var mNameInputBox : EditText
    private lateinit var mNameInputBoxFrame : ViewGroup
    private lateinit var mInsertedNameLengthView : TextView
    private lateinit var mClearInsertedNameView : View
    private lateinit var mCancelButton : View
    private lateinit var mConfirmButton : Button

    //이름 입력 확인을 위한 TextWatcher
    private val mTextWatcherInsertedName: TextWatcher = object : TextWatcher
    {
        override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int)
        {
            //아래와 같이 한글 외에 것이 포함된 경우
            if (!Pattern.matches("^[ㄱ-ㅎㅏ-ㅣ가-힣].{0,8}", s))
            {
                mNameInputBoxFrame.setBackgroundResource(if (s.length > 1)
                    R.drawable.view_red_color_round_edge else R.drawable.view_grey_color_round_edge)
            }
            else //자음만을 입력하는 것을 방지
            {
                //자음+모음으로 이루어진 글자로 2~8글자 사이가 아닐 경우
                if (!Pattern.matches("^[가-힣].{1,8}", s))
                {
                    mNameInputBoxFrame.setBackgroundResource(R.drawable.view_red_color_round_edge)
                }
                else
                {
                    mNameInputBoxFrame.setBackgroundResource(if (s.length > 1)
                        R.drawable.view_main_color_2_round_button else R.drawable.view_grey_color_round_edge)
                }
            }

            mInsertedNameLengthView.text = String.format(Locale.KOREA, "${s.length}/10")
        }

        override fun afterTextChanged(arg0: Editable) {
            // 입력이 끝났을 때
        }

        override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {
            // 입력하기 전에
        }
    }

    val REQUEST_IMAGE_CAPTURE = 1  //카메라 사진 촬영 요청 코드 *임의로 값 입력
    val REQUEST_IMAGE_PICK = 10

    private var isPermissionGranted : Boolean = false
    private var mSelectedPictureArray : ArrayList<Uri> = ArrayList() //문자열 형태의 사진 경로값 (초기값을 null로 시작하고 싶을 때 - lateinti var)

    override fun init(savedInstanceState: Bundle?)
    {
        setContentView(R.layout.activity_profile_registration)

        requestCameraPermission()

        mProfileImageView = findViewById(R.id.profilePicView)
        mProfileImageView.setOnClickListener { openPhotoGallery() }

        mNameInputBox = findViewById(R.id.name_inputBox)
        mNameInputBox.addTextChangedListener(mTextWatcherInsertedName)
        mNameInputBoxFrame = findViewById(R.id.profileNameInputBox)
        mInsertedNameLengthView = findViewById(R.id.insertedNameLengthView)
        mClearInsertedNameView = findViewById(R.id.clearInsertedName)
        mClearInsertedNameView.setOnClickListener {
            mNameInputBox.setText("")
        }
        mCancelButton = findViewById(R.id.cancelButton)
        mCancelButton.setOnClickListener {
            setResult(RESULT_CANCELED)
            onBackPressed()
        }
        mConfirmButton = findViewById(R.id.confirmButton)
        mConfirmButton.setOnClickListener {
            updateProfileInformation()
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        when
        {
            (requestCode == REQUEST_IMAGE_CAPTURE && resultCode == Activity.RESULT_OK) ->
            {

            }

            (requestCode == REQUEST_IMAGE_PICK && resultCode == Activity.RESULT_OK) ->
            {
                CurrentLoginStudent.currentSelectedPhotoPath = data?.data

                val requestManager = Glide.with(this)
                requestManager.load(CurrentLoginStudent.currentSelectedPhotoPath)
                    .diskCacheStrategy(DiskCacheStrategy.NONE)
                    .skipMemoryCache(true)
                    .centerCrop()
                    .placeholder(R.drawable.user_profile)
                    .into(mProfileImageView.mImageView)
                
                mSelectedPictureArray.clear()
                mSelectedPictureArray.add(Uri.parse(readRealPathFromURI(data?.data)))
            }
        }
    }

    override fun onBackPressed()
    {
        super.onBackPressed()
        overridePendingTransition(R.anim.anim_slide_in_left, R.anim.anim_slide_out_right)
    }

    private fun updateProfileInformation()
    {
        if (CurrentLoginStudent.root != null)
        {
            val studentName = mNameInputBox.text.toString()
            if (TextUtils.isEmpty(studentName))
            {
                showDialog("알림", "이름을 입력해주세요", buttonCount = CommonDialog.ButtonCount.ONE) {

                    mNameInputBox.requestFocus()
                }
                return
            }

            val list : MutableList<MultipartBody.Part> = ArrayList()
            for (uri in mSelectedPictureArray)
            {
                val imageRequest = convertFilePart("file", uri)
                list.add(imageRequest)
            }

            ServerConnection.uploadProfileImage(
                CurrentLoginStudent.root!!.student_id, studentName,
                CurrentLoginStudent.root!!.access_token, list) { isSuccess ->

                if (isSuccess)
                {
                    showDialog("알림", "프로필 이미지가 변경되었습니다")
                    {
                        setResult(RESULT_OK)
                        onBackPressed()
                    }
                }
                else
                {
                    Toast.makeText(this@ProfileRegistrationPage,"변경에 실패하였습니다.\n인터넷 상태를 다시 확인해주세요.", Toast.LENGTH_SHORT).show()
                }
            }
        }
    }

    private fun openPhotoGallery()
    {
        val pictureDialog = SelectPictureDialog(this)
        pictureDialog.show()
        pictureDialog.setImageSelectListener(object : SelectPictureDialog.ImageSelectListener{
            override fun select_image_value(select: String?)
            {
                pictureDialog.dismiss()

                if (select.equals("0"))
                {
                    if (isPermissionGranted)
                    {
                        takeCapture()
                    }
                    else
                    {
                        Toast.makeText(applicationContext, resources.getString(R.string.permission_2), Toast.LENGTH_LONG).show()
                    }
                }
                else
                {
                    if (isPermissionGranted)
                    {
                        Intent(Intent.ACTION_PICK).apply{
                            type = "image/*"
                            startActivityForResult(this, REQUEST_IMAGE_PICK)
                        }
                    }
                    else
                    {
                        Toast.makeText(applicationContext, resources.getString(R.string.permission_2), Toast.LENGTH_LONG).show()
                    }
                }
            }
        })
    }

    private fun requestCameraPermission()
    {
        val permissionListener: PermissionListener = object : PermissionListener {
            override fun onPermissionGranted() {
                // 권한 요청 성공
                isPermissionGranted = true
            }

            override fun onPermissionDenied(deniedPermissions: List<String>) {

                // 권한 요청 거절
                isPermissionGranted = false
            }
        }
        TedPermission.with(this)
            .setPermissionListener(permissionListener)
            .setRationaleMessage(resources.getString(R.string.permission_2))
            .setDeniedMessage(resources.getString(R.string.permission_1))
            .setPermissions(Manifest.permission.WRITE_EXTERNAL_STORAGE, Manifest.permission.CAMERA, Manifest.permission.RECORD_AUDIO)
            .check()
    }

    private fun readRealPathFromURI(contentUri: Uri?): String?
    {
        val proj = arrayOf(MediaStore.Images.Media.DATA)
        val cursor = contentResolver.query(contentUri!!, proj, null, null, null)
        cursor!!.moveToNext()
        val path = cursor.getString(cursor.getColumnIndex(MediaStore.MediaColumns.DATA))
        val uri = Uri.fromFile(File(path))

        cursor.close()
        return path
    }

    //이미지 전환
    private fun convertFilePart(partName: String, fileUri: Uri): MultipartBody.Part
    {
        // https://github.com/iPaulPro/aFileChooser/blob/master/aFileChooser/src/com/ipaulpro/afilechooser/utils/FileUtils.java
        // use the FileUtils to get the actual file by uri
        val file = File(fileUri.toString())
        //compress the image using Compressor lib

        // create RequestBody instance from file
        val requestFile = RequestBody.create(
            MediaType.parse("image/*"),
            file)

        // MultipartBody.Part is used to send also the actual file name
        return MultipartBody.Part.createFormData(partName, file.name, requestFile)
    }

    //기본 카메라 앱을 사용해서 사진 촬영
    private fun takeCapture() {
        //기본 카메라 앱 실행
        Intent(MediaStore.ACTION_IMAGE_CAPTURE).also { takePictureIntent ->

            takePictureIntent.resolveActivity(packageManager)?.also {
                val photoFile : File? = try
                {
                    createImageFile()
                }
                catch (e:Exception)
                {
                    e.printStackTrace()
                    null
                }
                photoFile?.also {
                    val photoURI : Uri = FileProvider.getUriForFile(this, "com.funidea.newonpe.provider", it)
                    takePictureIntent.putExtra(MediaStore.EXTRA_OUTPUT, photoURI)
                    startActivityForResult(takePictureIntent, REQUEST_IMAGE_CAPTURE)
                }
            }
        }
    }

    @SuppressLint("SimpleDateFormat")
    private fun createImageFile(): File
    {
        val timestamp : String = SimpleDateFormat("yyyyMMdd_HHmmss").format(Date())
        val storageDir : File? = getExternalFilesDir(Environment.DIRECTORY_PICTURES)
        return File.createTempFile("JPEG_${timestamp}_",".jpeg",storageDir).apply {
            // CurrentLoginStudent.currentSelectedPhotoPath = absolutePath
        }
    }
}