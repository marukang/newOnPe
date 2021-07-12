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

package com.funidea.newonpe.posedetector;

import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.PointF;
import android.util.Log;

import com.funidea.newonpe.R;
import com.funidea.newonpe.camearutils.GraphicOverlay;
import com.google.mlkit.vision.pose.Pose;
import com.google.mlkit.vision.pose.PoseLandmark;


import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import static com.funidea.newonpe.PoseActivity.get_pose_category_name;
import static com.funidea.newonpe.PoseActivity.pose_estimation_imageview;

/**
 * Draw the detected pose in preview.
 */
public class PoseGraphic extends GraphicOverlay.Graphic {

    //점 크기
    private static final float DOT_RADIUS = 20.0f;
    //좌표 정확도 숫자 표시
    private static final float IN_FRAME_LIKELIHOOD_TEXT_SIZE = 20.0f;

    private final Pose pose;
    private final boolean showInFrameLikelihood;

    private final Paint leftPaint;
    private final Paint rightPaint;
    private final Paint whitePaint;

    private PoseMeasureFunction posemeasurefunction;
    private String pose_name;

    public static String posename1;
    public static ArrayList<Float> mDrawPoint;
    public static drawViewListener mListener;

    public static int draw_value = 0;

    public interface drawViewListener {
        void detectSkeletonPoint(ArrayList<Float> mDrawPoint);

    }

    public void setDrawViewListener(drawViewListener listener) {
        mListener = listener;

    }



    public PoseGraphic(
            GraphicOverlay overlay,
            Pose pose,
            boolean showInFrameLikelihood) {
        super(overlay);

        this.pose = pose;
        this.showInFrameLikelihood = showInFrameLikelihood;


        //동작이름
        pose_name = "원레그데드리프트(왼)";
        //스쿼드 클래스
        posemeasurefunction = new PoseMeasureFunction();

        Log.d("자주실행?", "PoseGraphic:");

        //색상
        whitePaint = new Paint();
        leftPaint = new Paint();
        rightPaint = new Paint();

        if(get_pose_category_name.equals("홈트레이닝"))
        {
            whitePaint.setColor(Color.WHITE);
            whitePaint.setTextSize(IN_FRAME_LIKELIHOOD_TEXT_SIZE);
            leftPaint.setColor(Color.GREEN);
            rightPaint.setColor(Color.YELLOW);
        }
        else
        {
            whitePaint.setColor(Color.TRANSPARENT);
            whitePaint.setTextSize(IN_FRAME_LIKELIHOOD_TEXT_SIZE);
            leftPaint.setColor(Color.TRANSPARENT);
            rightPaint.setColor(Color.TRANSPARENT);
        }



    }

   /*public void get_state(ImageView imageview)
   {
       if(draw_value==0)
       {

           imageview.setBackgroundResource(R.drawable.red_circle);
       }
       else
       {
           imageview.setBackgroundResource(R.drawable.green_circle);
       }
   }*/




    @Override
    public void draw(Canvas canvas) {
        List<PoseLandmark> landmarks = pose.getAllPoseLandmarks();

        if(landmarks.size()==0)
        {
            draw_value =0;
            pose_estimation_imageview.setBackgroundResource(R.drawable.red_circle);
        }
        else
        {
            draw_value=1;
            pose_estimation_imageview.setBackgroundResource(R.drawable.green_circle);
        }

        Log.d("값확인", "draw:"+draw_value);
        //mListener.detectSkeletonPoint("포즈네임");

        if (landmarks.isEmpty()) {
            return;
        }

        //동작 인식하는 함수 (무한 반복)
        for (PoseLandmark landmark : landmarks) {


            //스켈레톤 좌표를 찍는 함수
            drawPoint(canvas, landmark, whitePaint);

            //해당 좌표가 일치할 가능성(ex 0.99)을 좌표와 함께 표시하는 함수
            //현재는 false로 되어있으며, true로 변경시 좌표 옆에 숫자도 함께 표시된다
            if (showInFrameLikelihood) {

                canvas.drawText(
                        String.format(Locale.US, "%.2f", landmark.getInFrameLikelihood()),
                        translateX(landmark.getPosition().x),
                        translateY(landmark.getPosition().y),
                        whitePaint);
            }

        }


        PoseLandmark leftShoulder = pose.getPoseLandmark(PoseLandmark.LEFT_SHOULDER);
        PoseLandmark rightShoulder = pose.getPoseLandmark(PoseLandmark.RIGHT_SHOULDER);
        PoseLandmark leftElbow = pose.getPoseLandmark(PoseLandmark.LEFT_ELBOW);
        PoseLandmark rightElbow = pose.getPoseLandmark(PoseLandmark.RIGHT_ELBOW);
        PoseLandmark leftWrist = pose.getPoseLandmark(PoseLandmark.LEFT_WRIST);
        PoseLandmark rightWrist = pose.getPoseLandmark(PoseLandmark.RIGHT_WRIST);
        PoseLandmark leftHip = pose.getPoseLandmark(PoseLandmark.LEFT_HIP);
        PoseLandmark rightHip = pose.getPoseLandmark(PoseLandmark.RIGHT_HIP);
        PoseLandmark leftKnee = pose.getPoseLandmark(PoseLandmark.LEFT_KNEE);
        PoseLandmark rightKnee = pose.getPoseLandmark(PoseLandmark.RIGHT_KNEE);
        PoseLandmark leftAnkle = pose.getPoseLandmark(PoseLandmark.LEFT_ANKLE);
        PoseLandmark rightAnkle = pose.getPoseLandmark(PoseLandmark.RIGHT_ANKLE);
        PoseLandmark leftPinky = pose.getPoseLandmark(PoseLandmark.LEFT_PINKY);
        PoseLandmark rightPinky = pose.getPoseLandmark(PoseLandmark.RIGHT_PINKY);
        PoseLandmark leftIndex = pose.getPoseLandmark(PoseLandmark.LEFT_INDEX);
        PoseLandmark rightIndex = pose.getPoseLandmark(PoseLandmark.RIGHT_INDEX);
        PoseLandmark leftThumb = pose.getPoseLandmark(PoseLandmark.LEFT_THUMB);
        PoseLandmark rightThumb = pose.getPoseLandmark(PoseLandmark.RIGHT_THUMB);
        PoseLandmark leftHeel = pose.getPoseLandmark(PoseLandmark.LEFT_HEEL);
        PoseLandmark rightHeel = pose.getPoseLandmark(PoseLandmark.RIGHT_HEEL);
        PoseLandmark leftFootIndex = pose.getPoseLandmark(PoseLandmark.LEFT_FOOT_INDEX);
        PoseLandmark rightFootIndex = pose.getPoseLandmark(PoseLandmark.RIGHT_FOOT_INDEX);
        PoseLandmark leftEar = pose.getPoseLandmark(PoseLandmark.LEFT_EAR);
        PoseLandmark rightEar = pose.getPoseLandmark(PoseLandmark.RIGHT_EAR);




        if(mListener==null){
            Log.d("동작인식123123 mListener: ", "null");
        }else{
            Log.d("동작인식123123 mListener: ", "not null");

            ArrayList<Float> mDrawPoint = new ArrayList<Float>();

            //클리어
            mDrawPoint.clear();

            mDrawPoint.add(leftShoulder.getPosition().x);
            mDrawPoint.add(leftShoulder.getPosition().y);
            mDrawPoint.add(rightShoulder.getPosition().x);
            mDrawPoint.add(rightShoulder.getPosition().y);
            mDrawPoint.add(leftElbow.getPosition().x);
            mDrawPoint.add(leftElbow.getPosition().y);
            mDrawPoint.add(rightElbow.getPosition().x);
            mDrawPoint.add(rightElbow.getPosition().y);
            mDrawPoint.add(leftWrist.getPosition().x);
            mDrawPoint.add(leftWrist.getPosition().y);
            mDrawPoint.add(rightWrist.getPosition().x);
            mDrawPoint.add(rightWrist.getPosition().y);
            mDrawPoint.add(leftHip.getPosition().x);
            mDrawPoint.add(leftHip.getPosition().y);
            mDrawPoint.add(rightHip.getPosition().x);
            mDrawPoint.add(rightHip.getPosition().y);
            mDrawPoint.add(leftKnee.getPosition().x);
            mDrawPoint.add(leftKnee.getPosition().y);
            mDrawPoint.add(rightKnee.getPosition().x);
            mDrawPoint.add(rightKnee.getPosition().y);
            mDrawPoint.add(leftAnkle.getPosition().x);
            mDrawPoint.add(leftAnkle.getPosition().y);
            mDrawPoint.add(rightAnkle.getPosition().x);
            mDrawPoint.add(rightAnkle.getPosition().y);
            mDrawPoint.add(leftPinky.getPosition().x);
            mDrawPoint.add(leftPinky.getPosition().y);
            mDrawPoint.add(rightPinky.getPosition().x);
            mDrawPoint.add(rightPinky.getPosition().y);
            mDrawPoint.add(leftIndex.getPosition().x);
            mDrawPoint.add(leftIndex.getPosition().y);
            mDrawPoint.add(rightIndex.getPosition().x);
            mDrawPoint.add(rightIndex.getPosition().y);
            mDrawPoint.add(leftThumb.getPosition().x);
            mDrawPoint.add(leftThumb.getPosition().y);
            mDrawPoint.add(rightThumb.getPosition().x);
            mDrawPoint.add(rightThumb.getPosition().y);
            mDrawPoint.add(leftHeel.getPosition().x);
            mDrawPoint.add(leftHeel.getPosition().y);
            mDrawPoint.add(rightHeel.getPosition().x);
            mDrawPoint.add(rightHeel.getPosition().y);
            mDrawPoint.add(leftFootIndex.getPosition().x);
            mDrawPoint.add(leftFootIndex.getPosition().y);
            mDrawPoint.add(rightFootIndex.getPosition().x);
            mDrawPoint.add(rightFootIndex.getPosition().y);
            mDrawPoint.add(leftEar.getPosition().x);
            mDrawPoint.add(leftEar.getPosition().y);
            mDrawPoint.add(rightEar.getPosition().x);
            mDrawPoint.add(rightEar.getPosition().y);


            mListener.detectSkeletonPoint(mDrawPoint);
        }

//        /////////////////PoseActivity에서 PoseMeasure()를 사용중일 떄는 밑의 함수를 주석처리해야한다///////////////////////////////////
//
//        if(pose_name=="원레그데드리프트(왼)"){
//            // 왼발을 딛고 원레그데드리프트를 할 경우 (거울모드)
//            // 원레그데드리프트(왼) 경우 - 각도1(머리, 왼쪽엉덩이, 왼쪽무릎) / 각도2 (머리, 오른쪽엉덩이, 오른쪽무릎)
//            posemeasurefunction.oneleg_data(PoseInformation.pose_count,PoseInformation.pose_status,
//                    leftEar.getPosition().x, leftEar.getPosition().y, rightHip.getPosition().x, rightHip.getPosition().y, rightKnee.getPosition().x, rightKnee.getPosition().y,
//                    leftEar.getPosition().x, leftEar.getPosition().y, leftHip.getPosition().x, leftHip.getPosition().y, leftKnee.getPosition().x, leftKnee.getPosition().y);
//            Log.d("동작인식: ", "원레그데드리프트(왼) 측정 중");
//        }


        drawLine(canvas, leftShoulder, rightShoulder, whitePaint);
        drawLine(canvas, leftHip, rightHip, whitePaint);

        // Left body
        drawLine(canvas, leftShoulder, leftElbow, leftPaint);
        drawLine(canvas, leftElbow, leftWrist, leftPaint);
        drawLine(canvas, leftShoulder, leftHip, leftPaint);
        drawLine(canvas, leftHip, leftKnee, leftPaint);
        drawLine(canvas, leftKnee, leftAnkle, leftPaint);
        drawLine(canvas, leftWrist, leftThumb, leftPaint);
        drawLine(canvas, leftWrist, leftPinky, leftPaint);
        drawLine(canvas, leftWrist, leftIndex, leftPaint);
        drawLine(canvas, leftAnkle, leftHeel, leftPaint);
        drawLine(canvas, leftHeel, leftFootIndex, leftPaint);

        // Right body
        drawLine(canvas, rightShoulder, rightElbow, rightPaint);
        drawLine(canvas, rightElbow, rightWrist, rightPaint);
        drawLine(canvas, rightShoulder, rightHip, rightPaint);
        drawLine(canvas, rightHip, rightKnee, rightPaint);
        drawLine(canvas, rightKnee, rightAnkle, rightPaint);
        drawLine(canvas, rightWrist, rightThumb, rightPaint);
        drawLine(canvas, rightWrist, rightPinky, rightPaint);
        drawLine(canvas, rightWrist, rightIndex, rightPaint);
        drawLine(canvas, rightAnkle, rightHeel, rightPaint);
        drawLine(canvas, rightHeel, rightFootIndex, rightPaint);



    }

    //좌표 찍기
    void drawPoint(Canvas canvas, PoseLandmark landmark, Paint paint) {
        PointF point = landmark.getPosition();
        canvas.drawCircle(translateX(point.x), translateY(point.y), DOT_RADIUS, paint);
    }

    //좌표 잇기
    void drawLine(Canvas canvas, PoseLandmark startLandmark, PoseLandmark endLandmark, Paint paint) {
        PointF start = startLandmark.getPosition();
        PointF end = endLandmark.getPosition();
        canvas.drawLine(
                translateX(start.x), translateY(start.y), translateX(end.x), translateY(end.y), paint);
    }



}