/*
 * Copyright 2020 Google LLC. All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.funidea.newonpe.camearutils;

import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Matrix;
import android.net.Uri;
import android.os.Environment;
import android.util.Log;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import static com.funidea.utils.set_User_info.getStudent_id;
import static com.funidea.utils.set_User_info.getStudent_name;
import static com.funidea.newonpe.PoseActivity.bitmap_height;
import static com.funidea.newonpe.PoseActivity.bitmap_width;
import static com.funidea.newonpe.PoseActivity.getBitMapList;
import static com.funidea.newonpe.PoseActivity.imageView;
import static com.funidea.newonpe.PoseActivity.photo_value;
import static com.funidea.newonpe.PoseActivity.pose_class_code;
import static com.funidea.newonpe.PoseActivity.pose_unit_code;
import static com.funidea.newonpe.PoseActivity.recordBool;
import static com.funidea.newonpe.PoseActivity.side_image_value;

/** Draw camera image to background. */
public class CameraImageGraphic extends GraphicOverlay.Graphic {

  private final Bitmap bitmap;
  private final String TAG = "CameraImageGraphic";

  public List<Uri> uriList = new ArrayList<Uri>();

  public CameraImageGraphic(GraphicOverlay overlay, Bitmap bitmap) {
    super(overlay);
    this.bitmap = bitmap;

  }
  Bitmap sideInversionImg;
  @Override
  public void draw(Canvas canvas) {


    if (recordBool){
      getBitMapList.add(bitmap);
    }


    canvas.drawBitmap(bitmap, getTransformationMatrix(), null);
    //Canvas c = new Canvas(convertBitMap);

    bitmap_width = bitmap.getWidth();
    bitmap_height = bitmap.getHeight();

    if(side_image_value==1)
    {
    Matrix sideInversion = new Matrix();
    //sideInversion.setScale(1, -1);  // 상하반전
    sideInversion.setScale(-1, 1);  // 좌우반전
    sideInversionImg = Bitmap.createBitmap(bitmap, 0, 0,
            bitmap.getWidth(), bitmap.getHeight(), sideInversion, false);

    imageView.setImageBitmap(sideInversionImg);



    }

    if(photo_value == true)
    {
      photo_value  = false;
      saveBitmaptoJpeg(bitmap, pose_unit_code+getStudent_id()+getStudent_name());


    }

  }

  public static void saveBitmaptoJpeg(Bitmap bitmap, String name){
    String ex_storage = Environment.getExternalStorageDirectory().getAbsolutePath()+"/DCIM/Camera/";
    // Get Absolute Path in External Sdcard
    //String foler_name = "/"+folder+"/";
    String file_name = name+".jpg";
    String string_path = ex_storage;

    File file_path;
    try{
      file_path = new File(string_path);
      if(!file_path.isDirectory()){
        file_path.mkdirs();
      }
      FileOutputStream out = new FileOutputStream(string_path+file_name);

      bitmap.compress(Bitmap.CompressFormat.JPEG, 50, out);
      out.close();


      upload_check_user_photo.Companion.get_file(string_path, file_name, pose_class_code, pose_unit_code, name);



    }catch(FileNotFoundException exception){
      Log.e("FileNotFoundException", exception.getMessage());
    }catch(IOException exception){
      Log.e("IOException", exception.getMessage());
    }
  }






}
