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

package com.funidea.newonpe.camera;

import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.util.Log;

import androidx.annotation.Nullable;

/** Graphic instance for rendering inference info (latency, FPS, resolution) in an overlay view. */
public class InferenceInfoGraphic extends GraphicOverlay.Graphic {

  private static final int TEXT_COLOR = Color.WHITE;
  private static final float TEXT_SIZE = 60.0f;

  private final Paint textPaint;
  private final GraphicOverlay overlay;
  private final long frameLatency;
  private final long detectorLatency;

  // Only valid when a stream of input images is being processed. Null for single image mode.
  @Nullable private final Integer framesPerSecond;

  public InferenceInfoGraphic(
      GraphicOverlay overlay,
      long frameLatency,
      long detectorLatency,
      @Nullable Integer framesPerSecond) {
    super(overlay);
    this.overlay = overlay;
    this.frameLatency = frameLatency;
    this.detectorLatency = detectorLatency;
    this.framesPerSecond = framesPerSecond;
    textPaint = new Paint();
    textPaint.setColor(TEXT_COLOR);
    textPaint.setTextSize(TEXT_SIZE);
    postInvalidate();
  }

  @Override
  public synchronized void draw(Canvas canvas) {
    float x = TEXT_SIZE * 0.5f;
    float y = TEXT_SIZE * 1.5f;

//    Paint MyPaint = new Paint();
//    MyPaint.setStrokeWidth(15f);
//    MyPaint.setStyle(Paint.Style.FILL);
//    MyPaint.setColor(Color.WHITE);
//
//    //가로
//    canvas.drawLine(translateX(200),translateY(600),translateX(1080),translateY(600),MyPaint);
//    //세로
//    canvas.drawLine(translateX(640),translateY(500),translateX(640),translateY(600),MyPaint);

//    canvas.drawText(
//            "동작 개수 - " + PoseInformation.pose_count + "회"+" / "+"정확도 - "+ PoseInformation.pose_score,
//            x,
//            y + TEXT_SIZE*2,
//            textPaint);

    // Log.d("동작 개수 텍스트 x좌표", String.valueOf(x));
    // Log.d("동작 개수 텍스트 y좌표", String.valueOf(y));

//    canvas.drawText(
//        "InputImage size: " + overlay.getImageWidth() + "x" + overlay.getImageHeight(),
//        x,
//        y + TEXT_SIZE,
//        textPaint);
//
//    Log.d("InputImage 텍스트 x좌표", String.valueOf(x));
//    Log.d("InputImage 텍스트 y좌표", String.valueOf(y+ TEXT_SIZE));
//
//    // Draw FPS (if valid) and inference latency
//    if (framesPerSecond != null) {
//      canvas.drawText(
//              "FPS: " + framesPerSecond + ", Frame latency: " + frameLatency + " ms",
//              x,
//              y + TEXT_SIZE * 2,
//              textPaint);
//
//
//      canvas.drawText(
//              "Detector latency: " + detectorLatency + " ms", x, y + TEXT_SIZE * 3, textPaint);
//    } else {
//      canvas.drawText("Frame latency: " + frameLatency + " ms", x, y + TEXT_SIZE * 2, textPaint);
//      canvas.drawText(
//              "Detector latency: " + detectorLatency + " ms", x, y + TEXT_SIZE * 3, textPaint);
//    }
  }
}
