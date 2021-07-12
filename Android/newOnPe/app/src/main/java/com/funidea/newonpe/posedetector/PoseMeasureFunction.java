
package com.funidea.newonpe.posedetector;

import android.util.Log;

import java.util.ArrayList;

public class PoseMeasureFunction {


    public void squat_data(int pose_count, boolean pose_status,
                           double a1, double a2, double b1, double b2, double c1, double c2,
                           double d1, double d2, double e1, double e2, double f1, double f2,
                           double g1, double g2, double h1, double h2, double i1, double i2,
                           double j1, double j2, double k1, double k2, double l1, double l2, double m1, double m2, double n1, double n2, double o1, double o2) {

        Log.d("스쿼드변수", String.valueOf(pose_status));
        Log.d("스쿼드개수", String.valueOf(pose_count));


        // 개수 측정 -  (엉덩이 - 무릎 - 발목) - 각도가 110 이하일 경우 카운트
        double line_ab = Math.sqrt(Math.pow(a1 - b1, 2) + Math.pow(a2 - b2, 2));
        double line_bc = Math.sqrt(Math.pow(b1 - c1, 2) + Math.pow(b2 - c2, 2));
        double line_ca = Math.sqrt(Math.pow(c1 - a1, 2) + Math.pow(c2 - a2, 2));
        double result_up = (line_ab * line_ab + line_bc * line_bc - line_ca * line_ca);
        double result_down = 2 * line_ab * line_bc;
        double result = result_up / result_down;
        double cosX = Math.acos(result);
        double degree = Math.toDegrees(cosX);
        // 60도 ~ 170도
        Log.d("스쿼트 다리 각도모음", String.valueOf(degree));
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 예외처리 1 - (머리 > 엉덩이 > 발목) - 누워서 스쿼트할 경우 대비
        // 기립 여부
        boolean stand_up = false;
        if(d2+10<e2 && e2+10<f2){
            stand_up = true;
        }else{
            stand_up = false;
        }
        Log.d("스쿼트 머리 좌표", String.valueOf(d1) + "/" + String.valueOf(d2));
        Log.d("스쿼트 엉덩이 좌표", String.valueOf(e1) + "/" + String.valueOf(e2));
        Log.d("스쿼트 발목 좌표", String.valueOf(f1) + "/" + String.valueOf(f2));
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 예외처리 2 - (손목 - 어깨 - 발목) - 스쿼트 시 손모아서
        double line_gh = Math.sqrt(Math.pow(g1 - h1, 2) + Math.pow(g2 - h2, 2));
        double line_hi = Math.sqrt(Math.pow(h1 - i1, 2) + Math.pow(h2 - i2, 2));
        double line_ig = Math.sqrt(Math.pow(i1 - g1, 2) + Math.pow(i2 - g2, 2));
        double result_up_hand = (line_gh * line_gh + line_hi * line_hi - line_ig * line_ig);
        double result_down_hand = 2 * line_gh * line_hi;
        double result_hand = result_up_hand / result_down_hand;
        double cosX_hand = Math.acos(result_hand);
        double degree_hand = Math.toDegrees(cosX_hand);
        // 80도 ~ 110도
        Log.d("스쿼트 손 각도모음", String.valueOf(degree_hand));
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 예외처리 3 - (좌우 어깨, 무릎, 발목 좌표 동일)
        //좌우 어깨/무릎/발목 간의 거리
        //30보다 작을 경우 겹쳐있다고 판단
        //30보다 클경우 겹쳐있지 않다고 판단
        double squat_shoulder_status_x = Math.abs(j1 - k1);
        double squat_shoulder_status_y = Math.abs(j2 - k2);
        double squat_knee_status_x = Math.abs(l1 - m1);
        double squat_knee_status_y = Math.abs(l2 - m2);
        double squat_ankle_status_x = Math.abs(n1 - o1);
        double squat_ankle_status_y = Math.abs(n2 - o2);
        boolean squat_both = false;
        if(squat_shoulder_status_x<30 && squat_shoulder_status_y<30 && squat_knee_status_x<30 && squat_knee_status_y<30 && squat_ankle_status_x<30 && squat_ankle_status_y<30){
            squat_both = true;
        }else{
            squat_both = false;
        }
        Log.d("스쿼트 왼쪽어깨 좌표", String.valueOf(j1) + "/" + String.valueOf(j2));
        Log.d("스쿼트 오른쪽어깨 좌표", String.valueOf(k1) + "/" + String.valueOf(k2));
        Log.d("스쿼트 왼쪽무릎 좌표", String.valueOf(l1)  + "/" + String.valueOf(l2));
        Log.d("스쿼트 오른쪽무릎 좌표", String.valueOf(m1) + "/" + String.valueOf(m2));
        Log.d("스쿼트 왼쪽발목 좌표", String.valueOf(n1) + "/" + String.valueOf(n2));
        Log.d("스쿼트 오른쪽발목 좌표", String.valueOf(o1) + "/" + String.valueOf(o2));
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        if(stand_up){
            // 예외처리 1 - (머리 > 엉덩이 > 발목) - 누워서 스쿼트할 경우 대비
            Log.d("스쿼트 예외처리1", "측정가능 - 서 있는 중 O");


            if(squat_both){
                Log.d("스쿼트 예외처리3", "측정가능 - 스쿼트 자세 O");

                if (degree >= 160 && pose_status == false) {
                    // 1단계
                    // 준비 중, 인식 X
                    Log.d("동작인식 각도 순서", "1단계");
                    Log.d("동작인식 각도 결과값", "준비 중, 인식 X");
                    PoseInformation.pose_status = false;
                    PoseInformation.pose_degree = 160.0;
                } else if (degree < 120 && 60 < degree && pose_status == false) {
                    // 2단계
                    //스쿼트 중, 인식 X
                    Log.d("동작인식 각도 순서", "2단계");
                    Log.d("동작인식 각도 결과값", "스쿼트 중, 인식 X");
                    PoseInformation.pose_status = true;
                    if (degree < PoseInformation.pose_degree) {
                        PoseInformation.pose_degree = degree;
                    }
                } else if (degree < 120 && 60 < degree && pose_status == true) {
                    // 3단계
                    //스쿼트 중, 인식 O
                    Log.d("동작인식 각도 순서", "3단계");
                    Log.d("동작인식 각도 결과값", "스쿼트 중, 인식 O");
                    PoseInformation.pose_status = true;
                    if (degree < PoseInformation.pose_degree) {
                        PoseInformation.pose_degree = degree;
                    }
                } else if (degree >= 160 && pose_status == true) {
                    // 4단계
                    // 준비 중, 인식 O
                    Log.d("동작인식 각도 순서", "4단계");
                    Log.d("동작인식 각도 결과값", "준비 중, 인식 O");
                    Log.d("동작인식 각도 결과값", "==============");
                    Log.d("동작인식 각도 결과값", "카운트하기");
                    Log.d("동작인식 각도 결과값", "==============");
                    PoseInformation.pose_status = false;
                    PoseInformation.pose_count = PoseInformation.pose_count + 1;
                }

            }else{
                Log.d("스쿼트 예외처리3", "측정불가 - 스쿼트 자세 X");
            }

        }else{
            Log.d("스쿼트 예외처리1", "측정불가 - 서 있는 중 X");

        }

//      손모으기 예외처리
//        if(70<degree_hand && degree_hand<120){
//            // 예외처리 2 - (손목 - 어깨 - 발목) - 스쿼트 시 손모아서
//            Log.d("스쿼트 예외처리2", "측정가능 - 손 모으는 중 O");
//
//
//
//        }else{
//            Log.d("스쿼트 예외처리2", "측정불가 - 손 모으는 중 X");
//        }

    }


    public void pushup_data(int pose_count, boolean pose_status,
                            double a1, double a2, double b1, double b2, double c1, double c2,
                            double d1, double d2, double e1, double e2, double f1, double f2,
                            double g1, double g2, double h1, double h2, double i1, double i2) {
        Log.d("푸쉬업 변수", String.valueOf(pose_status));
        Log.d("푸쉬업 개수", String.valueOf(pose_count));

        // 개수 측정 -  (어깨 - 팔꿈치 - 손목) - 각도가 100 이하일 경우 카운트
        double line_ab = Math.sqrt(Math.pow(a1 - b1, 2) + Math.pow(a2 - b2, 2));
        double line_bc = Math.sqrt(Math.pow(b1 - c1, 2) + Math.pow(b2 - c2, 2));
        double line_ca = Math.sqrt(Math.pow(c1 - a1, 2) + Math.pow(c2 - a2, 2));
        double result_up = (line_ab * line_ab + line_bc * line_bc - line_ca * line_ca);
        double result_down = 2 * line_ab * line_bc;
        double result = result_up / result_down;
        double cosX = Math.acos(result);
        double degree = Math.toDegrees(cosX);
        // 40 ~ 155도
        Log.d("푸쉬업 각도모음(팔)", String.valueOf(degree));
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 예외처리 1 - (엉덩이 y좌표 > 손목 y좌표) && (어깨 y좌표 > 손목 y좌표) - 엎드려 있는지 파악
        // 엎드림 여부

        boolean prostrate = false;
        if((e2 < c2) && (a2 < c2)){
            prostrate = true;
        }else{
            prostrate = false;
        }
        Log.d("푸쉬업 손목 좌표", String.valueOf(c1) + "/" + String.valueOf(c2));
        Log.d("푸쉬업 엉덩이 좌표", String.valueOf(e1) + "/" + String.valueOf(e2));
        Log.d("푸쉬업 어깨 좌표", String.valueOf(a1) + "/" + String.valueOf(a2));


        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 예외처리 2 - (머리 , 엉덩이 , 발목) -  몸이 1자인지 파악하기 위한 각도 (150도 이상일 경우에만 측정, 150도이하일 경우 측정 X)
        double line_de = Math.sqrt(Math.pow(d1 - e1, 2) + Math.pow(d2 - e2, 2));
        double line_ef = Math.sqrt(Math.pow(e1 - f1, 2) + Math.pow(e2 - f2, 2));
        double line_fd = Math.sqrt(Math.pow(f1 - d1, 2) + Math.pow(f2 - d2, 2));
        double result_up_body = (line_de * line_de + line_ef * line_ef - line_fd * line_fd);
        double result_down_body = 2 * line_de * line_ef;
        double result_body = result_up_body / result_down_body;
        double cosX_body = Math.acos(result_body);
        double degree_body = Math.toDegrees(cosX_body);
        // 몸 1자 여부 파악   150도 ~ 180도
        Log.d("푸쉬업 각도모음(몸1자)", String.valueOf(degree_body));
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 예외처리 3 - (머리 , 엉덩이 , 발목) -  몸이 1자인지 파악하기 위한 각도 (150도 이상일 경우에만 측정, 150도이하일 경우 측정 X)
        double line_gh = Math.sqrt(Math.pow(g1 - h1, 2) + Math.pow(g2 - h2, 2));
        double line_hi = Math.sqrt(Math.pow(h1 - i1, 2) + Math.pow(h2 - i2, 2));
        double line_ig = Math.sqrt(Math.pow(i1 - g1, 2) + Math.pow(i2 - g2, 2));
        double result_up_leg = (line_gh * line_gh + line_hi * line_hi - line_ig * line_ig);
        double result_down_leg = 2 * line_gh * line_hi;
        double result_leg = result_up_leg / result_down_leg;
        double cosX_leg = Math.acos(result_leg);
        double degree_leg = Math.toDegrees(cosX_leg);
        // 다리 1자 여부 파악  150도 ~ 180도
        Log.d("푸쉬업 각도모음(다리1자)", String.valueOf(degree_leg));



        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



        if(prostrate) {
            Log.d("푸쉬업 예외처리1", "측정가능 - 엎드려 있는 중 O");


            if(degree_body>120){
                Log.d("푸쉬업 예외처리2", "측정가능 - 몸 1자 O");

                if(degree_leg>140) {
                    Log.d("푸쉬업 예외처리3", "측정가능 - 다리 1자 O");

                    if (degree >= 140 && pose_status == false) {
                        // 1단계
                        // 준비 중, 인식 X
                        Log.d("동작인식 각도 순서", "1단계");
                        Log.d("동작인식 각도 결과값", "준비 중, 인식 X");
                        PoseInformation.pose_status = false;
                        PoseInformation.pose_degree = 140.0;
                    } else if (degree < 110 &&  pose_status == false) {
                        // 2단계
                        // 푸쉬업 중, 인식 X
                        Log.d("동작인식 각도 순서", "2단계");
                        Log.d("동작인식 각도 결과값", "푸쉬업 중, 인식 X");
                        PoseInformation.pose_status = true;
                        if (degree < PoseInformation.pose_degree) {
                            PoseInformation.pose_degree = degree;
                        }
                    } else if (degree < 110 &&  pose_status == true) {
                        // 3단계
                        // 푸쉬업 중, 인식 O
                        Log.d("동작인식 각도 순서", "3단계");
                        Log.d("동작인식 각도 결과값", "푸쉬업 중, 인식 O");
                        PoseInformation.pose_status = true;
                        if (degree < PoseInformation.pose_degree) {
                            PoseInformation.pose_degree = degree;
                        }
                    } else if (degree >= 140 && pose_status == true) {
                        // 4단계
                        // 준비 중, 인식 O
                        Log.d("동작인식 각도 순서", "4단계");
                        Log.d("동작인식 각도 결과값", "준비 중, 인식 O");
                        Log.d("동작인식 각도 결과값", "==============");
                        Log.d("동작인식 각도 결과값", "카운트하기");
                        Log.d("동작인식 각도 결과값", "==============");
                        PoseInformation.pose_status = false;
                        PoseInformation.pose_count = PoseInformation.pose_count + 1;
                    }
                }else{
                    Log.d("푸쉬업 예외처리3", "측정불가 - 다리 1자 X");
                }
            }else{
                Log.d("푸쉬업 예외처리2", "측정불가 - 몸 1자 X");
            }


        }else{
            Log.d("푸쉬업 예외처리1", "측정불가 - 엎드려 있는 중 X");
        }



    }

    public void knee_pushup_data(int pose_count, boolean pose_status,
                                 double a1, double a2, double b1, double b2, double c1, double c2,
                                 double d1, double d2, double e1, double e2, double f1, double f2,
                                 double g1, double g2, double h1, double h2, double i1, double i2) {
        Log.d("무릎푸쉬업 변수", String.valueOf(pose_status));
        Log.d("무릎푸쉬업 개수", String.valueOf(pose_count));

        // 개수 측정 -  (어깨 - 팔꿈치 - 손목) - 각도가 100 이하일 경우 카운트
        double line_ab = Math.sqrt(Math.pow(a1 - b1, 2) + Math.pow(a2 - b2, 2));
        double line_bc = Math.sqrt(Math.pow(b1 - c1, 2) + Math.pow(b2 - c2, 2));
        double line_ca = Math.sqrt(Math.pow(c1 - a1, 2) + Math.pow(c2 - a2, 2));
        double result_up = (line_ab * line_ab + line_bc * line_bc - line_ca * line_ca);
        double result_down = 2 * line_ab * line_bc;
        double result = result_up / result_down;
        double cosX = Math.acos(result);
        double degree = Math.toDegrees(cosX);
        // 40 ~ 155도
        Log.d("무릎푸쉬업 각도모음(팔)", String.valueOf(degree));
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 예외처리 1 - (머리 y좌표 = 엉덩이 y좌표) - 엎드려 있는지 파악
        // 엎드림 여부
        double pushup_prostrate = Math.abs(d2 - e2);
        boolean prostrate = false;
        if(pushup_prostrate<100){
            prostrate = true;
        }else{
            prostrate = false;
        }
        Log.d("무릎푸쉬업 머리 좌표", String.valueOf(d1) + "/" + String.valueOf(d2));
        Log.d("무릎푸쉬업 엉덩이 좌표", String.valueOf(e1) + "/" + String.valueOf(e2));
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 예외처리 2 - (머리 , 엉덩이 , 발목) -  몸이 1자인지 파악하기 위한 각도 (150도 이상일 경우에만 측정, 150도이하일 경우 측정 X)
        double line_de = Math.sqrt(Math.pow(d1 - e1, 2) + Math.pow(d2 - e2, 2));
        double line_ef = Math.sqrt(Math.pow(e1 - f1, 2) + Math.pow(e2 - f2, 2));
        double line_fd = Math.sqrt(Math.pow(f1 - d1, 2) + Math.pow(f2 - d2, 2));
        double result_up_body = (line_de * line_de + line_ef * line_ef - line_fd * line_fd);
        double result_down_body = 2 * line_de * line_ef;
        double result_body = result_up_body / result_down_body;
        double cosX_body = Math.acos(result_body);
        double degree_body = Math.toDegrees(cosX_body);
        // 몸 1자 여부 파악   150도 ~ 180도
        Log.d("무릎푸쉬업 각도모음(몸1자)", String.valueOf(degree_body));
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 예외처리 3 - (머리 , 엉덩이 , 발목) -  몸이 1자인지 파악하기 위한 각도 (150도 이상일 경우에만 측정, 150도이하일 경우 측정 X)
        double line_gh = Math.sqrt(Math.pow(g1 - h1, 2) + Math.pow(g2 - h2, 2));
        double line_hi = Math.sqrt(Math.pow(h1 - i1, 2) + Math.pow(h2 - i2, 2));
        double line_ig = Math.sqrt(Math.pow(i1 - g1, 2) + Math.pow(i2 - g2, 2));
        double result_up_leg = (line_gh * line_gh + line_hi * line_hi - line_ig * line_ig);
        double result_down_leg = 2 * line_gh * line_hi;
        double result_leg = result_up_leg / result_down_leg;
        double cosX_leg = Math.acos(result_leg);
        double degree_leg = Math.toDegrees(cosX_leg);
        // 다리 1자 여부 파악 100도 이하
        Log.d("무릎푸쉬업 각도모음(다리1자)", String.valueOf(degree_leg));
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        if(prostrate) {
            Log.d("무릎푸쉬업 예외처리1", "측정가능 - 엎드려 있는 중 O");

//            if(degree_body>120) {
//                Log.d("무릎푸쉬업 예외처리2", "측정가능 - 몸 1자 O");
//
//            }else{
//                Log.d("무릎푸쉬업 예외처리2", "측정불가 - 몸 1자 X");
//            }

            if(degree_leg<100) {
                Log.d("무릎푸쉬업 예외처리3", "측정가능 - 무릎 대기 O");

                if (degree >= 140 && pose_status == false) {
                    // 1단계
                    // 준비 중, 인식 X
                    Log.d("동작인식 각도 순서", "1단계");
                    Log.d("동작인식 각도 결과값", "준비 중, 인식 X");
                    PoseInformation.pose_status = false;
                    PoseInformation.pose_degree = 140.0;
                } else if (degree < 110 &&  pose_status == false) {
                    // 2단계
                    // 무릎푸쉬업 중, 인식 X
                    Log.d("동작인식 각도 순서", "2단계");
                    Log.d("동작인식 각도 결과값", "무릎푸쉬업 중, 인식 X");
                    PoseInformation.pose_status = true;
                    if (degree < PoseInformation.pose_degree) {
                        PoseInformation.pose_degree = degree;
                    }
                } else if (degree < 110 &&  pose_status == true) {
                    // 3단계
                    // 무릎푸쉬업 중, 인식 O
                    Log.d("동작인식 각도 순서", "3단계");
                    Log.d("동작인식 각도 결과값", "무릎푸쉬업 중, 인식 O");
                    PoseInformation.pose_status = true;
                    if (degree < PoseInformation.pose_degree) {
                        PoseInformation.pose_degree = degree;
                    }
                } else if (degree >= 140 && pose_status == true) {
                    // 4단계
                    // 준비 중, 인식 O
                    Log.d("동작인식 각도 순서", "4단계");
                    Log.d("동작인식 각도 결과값", "준비 중, 인식 O");
                    Log.d("동작인식 각도 결과값", "==============");
                    Log.d("동작인식 각도 결과값", "카운트하기");
                    Log.d("동작인식 각도 결과값", "==============");
                    PoseInformation.pose_status = false;
                    PoseInformation.pose_count = PoseInformation.pose_count + 1;
                }
            }else{
                Log.d("무릎푸쉬업 예외처리3", "측정불가 - 무릎 대기 X");
            }



        }else{
            Log.d("무릎푸쉬업 예외처리1", "측정불가 - 엎드려 있는 중 X");
        }

    }



    public void burpee_data(int pose_count, boolean pose_status, boolean pose_status_sub, double a1, double a2, double b1, double b2, double c1, double c2, double d1, double d2, double e1, double e2, double f1, double f2) {
        Log.d("버피변수", String.valueOf(pose_status));
        Log.d("버피개수", String.valueOf(pose_count));

        double line_ab = Math.sqrt(Math.pow(a1 - b1, 2) + Math.pow(a2 - b2, 2));
        double line_bc = Math.sqrt(Math.pow(b1 - c1, 2) + Math.pow(b2 - c2, 2));
        double line_ca = Math.sqrt(Math.pow(c1 - a1, 2) + Math.pow(c2 - a2, 2));


        double result_up = (line_ab * line_ab + line_bc * line_bc - line_ca * line_ca);
        double result_down = 2 * line_ab * line_bc;
        double result = result_up / result_down;

        double cosX = Math.acos(result);
        double degree = Math.toDegrees(cosX);
        //50~170
        Log.d("버피각도모음(머리-엉덩이-발목)", String.valueOf(degree));

        double line_de = Math.sqrt(Math.pow(d1 - e1, 2) + Math.pow(d2 - e2, 2));
        double line_ef = Math.sqrt(Math.pow(e1 - f1, 2) + Math.pow(e2 - f2, 2));
        double line_fd = Math.sqrt(Math.pow(f1 - d1, 2) + Math.pow(f2 - d2, 2));

        double result_up_sub = (line_de * line_de + line_ef * line_ef - line_fd * line_fd);
        double result_down_sub = 2 * line_de * line_ef;
        double result_sub = result_up_sub / result_down_sub;

        double cosX_sub = Math.acos(result_sub);
        double degree_sub = Math.toDegrees(cosX_sub);
        //엎드림 여부파악
        Log.d("버피각도모음(어깨, 손목, 발목)", String.valueOf(degree_sub));



        if (degree >= 145 && pose_status == false && degree_sub >= 145 && pose_status_sub == false) {
            //1단계
            //준비중,인식X
            Log.d("동작인식각도순서", "1단계");
            Log.d("동작인식각도결과값", "준비중,인식X");
            PoseInformation.pose_status = false;
        } else if (degree < 115 &&  pose_status == false && degree_sub < 115 && pose_status_sub == false) {
            //2단계
            //버피중간동작(구부리기)중,인식X
            //버피마무리동작(엎드리기),인식X
            Log.d("동작인식각도순서", "2단계");
            Log.d("동작인식각도결과값", "버피중간동작(구부리기)중,인식X");
            PoseInformation.pose_degree = degree;
            PoseInformation.pose_status = true;
        } else if (degree < 115 &&  pose_status == true && degree_sub < 115 && pose_status_sub == false) {
            //3단계
            //버피중간동작(구부리기)중,인식O
            //버피마무리동작(엎드리기),인식X
            Log.d("동작인식각도순서", "3단계");
            Log.d("동작인식각도결과값", "버피중간동작(구부리기)중,인식O");
            PoseInformation.pose_status = true;

        } else if (pose_status == true && degree_sub < 115 && pose_status_sub == false) {
            //4단계
            //버피중간동작(구부리기)중,인식O
            //버피마무리동작(엎드리기),인식X
            Log.d("동작인식각도순서", "4단계");
            Log.d("동작인식각도결과값", "버피마무리동작(엎드리기)중,인식X");
            //여기서엎드리기상태True로변경
            PoseInformation.pose_status_sub = true;
            //각도(머리-엉덩이-발목)이 작을수록 점수가 낮다
            if (degree > PoseInformation.pose_degree) {
                PoseInformation.pose_degree = degree;
                Log.d("동작인식각도변경", "구부리기각도변경"+ PoseInformation.pose_degree);
            }
        } else if (pose_status == true && degree_sub < 115 && pose_status_sub == true) {
            //5단계
            //버피중간동작(구부리기)중,인식O
            //버피마무리동작(엎드리기),인식O
            Log.d("동작인식각도순서", "5단계");
            Log.d("동작인식각도결과값", "버피마무리동작(엎드리기)중,인식O");
            //여기서엎드리기상태 True로변경
            PoseInformation.pose_status_sub = true;
            //엎드린 상태에서의 각도(머리-엉덩이-발목) 측정
            //각도가 작을수록 점수가 낮다
            if (degree > PoseInformation.pose_degree) {
                PoseInformation.pose_degree = degree;
                Log.d("동작인식각도변경", "구부리기각도변경"+ PoseInformation.pose_degree);
            }
        }  else if (degree >= 145 && pose_status == true && degree_sub >= 145 && pose_status_sub == true) {
            //5단계
            //준비중,인식O
            Log.d("동작인식각도순서", "6단계");
            Log.d("동작인식각도결과값", "준비중,인식O");
            Log.d("동작인식각도결과값", "==============");
            Log.d("동작인식각도결과값", "카운트하기");
            Log.d("동작인식각도결과값", "==============");
            PoseInformation.pose_status = false;
            PoseInformation.pose_status_sub = false;
            PoseInformation.pose_count = PoseInformation.pose_count + 1;
        }
    }

    public void crunch_data(int pose_count, boolean pose_status,
                            double a1, double a2, double b1, double b2, double c1, double c2,
                            double d1, double d2, double e1, double e2, double f1, double f2,
                            double g1, double g2, double h1, double h2) {
        Log.d("크런치변수", String.valueOf(pose_status));
        Log.d("크런치개수", String.valueOf(pose_count));

        double line_ab = Math.sqrt(Math.pow(a1 - b1, 2) + Math.pow(a2 - b2, 2));
        double line_bc = Math.sqrt(Math.pow(b1 - c1, 2) + Math.pow(b2 - c2, 2));
        double line_ca = Math.sqrt(Math.pow(c1 - a1, 2) + Math.pow(c2 - a2, 2));
        double result_up = (line_ab * line_ab + line_bc * line_bc - line_ca * line_ca);
        double result_down = 2 * line_ab * line_bc;
        double result = result_up / result_down;
        double cosX = Math.acos(result);
        double degree = Math.toDegrees(cosX);
        // 100도 ~ 145도
        Log.d("크런치각도모음", String.valueOf(degree));
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 예외처리 1 - (엉덩이 y좌표 = 발목 y좌표) - 누워 있는지 파악
        // 누워있는지 여부
        double crunch_lay = Math.abs(d2 - f2);
        boolean lay = false;
        if(crunch_lay<50){
            lay = true;
        }else{
            lay = false;
        }
        Log.d("크런치 엉덩이 좌표", String.valueOf(d1) + "/" + String.valueOf(d2));
        Log.d("크런치 발목 좌표", String.valueOf(f1) + "/" + String.valueOf(f2));
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 예외처리2 - (엉덩이 , 무릎 , 발목) - 다리를 굽혔는지 확인
        double line_de = Math.sqrt(Math.pow(d1 - e1, 2) + Math.pow(d2 - e2, 2));
        double line_ef = Math.sqrt(Math.pow(e1 - f1, 2) + Math.pow(e2 - f2, 2));
        double line_fd = Math.sqrt(Math.pow(f1 - d1, 2) + Math.pow(f2 - d2, 2));
        double result_up_leg = (line_de * line_de + line_ef * line_ef - line_fd * line_fd);
        double result_down_leg = 2 * line_de * line_ef;
        double result_leg = result_up_leg / result_down_leg;
        double cosX_leg = Math.acos(result_leg);
        double degree_leg = Math.toDegrees(cosX_leg);
        //다리 굽히기 여부파악 50~65도
        Log.d("크런치 다리각도모음", String.valueOf(degree_leg));
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 예외처리 3 - (손목 = 무릎) - 카운트 시 무릎 짚었는 지 확인
        double crunch_touch_x = Math.abs(g1 - h1);
        double crunch_touch_y = Math.abs(g2 - h2);
        boolean touch = false;
        if(crunch_touch_x<30 && crunch_touch_y<30){
            touch = true;
        }else{
            touch = false;
        }
        Log.d("크런치 손목 좌표", String.valueOf(g1) + "/" + String.valueOf(g2));
        Log.d("크런치 무릎 좌표", String.valueOf(h1) + "/" + String.valueOf(h2));


        if(lay){
            Log.d("크런치 예외처리1", "측정가능 - 누워 있는 중 O");

            if(degree_leg<110){
                Log.d("크런치 예외처리2", "측정가능 - 다리 굽히는 중 O");

                if (degree >= 130 && pose_status == false) {
                    // 1단계
                    // 준비 중, 인식 X
                    Log.d("동작인식 각도 순서", "1단계");
                    Log.d("동작인식 각도 결과값", "준비 중, 인식 X");
                    PoseInformation.pose_status = false;
                    PoseInformation.pose_degree = 130.0;
                } else if (degree < 120 && touch==true && pose_status == false) {
                    // 2단계
                    // 크런치 중, 인식 X
                    Log.d("동작인식 각도 순서", "2단계");
                    Log.d("동작인식 각도 결과값", "크런치 중, 인식 X");
                    PoseInformation.pose_status = true;
                    if (degree < PoseInformation.pose_degree) {
                        PoseInformation.pose_degree = degree;
                    }
                } else if (degree < 120 &&  touch==true && pose_status == true) {
                    // 3단계
                    // 크런치 중, 인식 O
                    Log.d("동작인식 각도 순서", "3단계");
                    Log.d("동작인식 각도 결과값", "크런치 중, 인식 O");
                    PoseInformation.pose_status = true;
                    if (degree < PoseInformation.pose_degree) {
                        PoseInformation.pose_degree = degree;
                    }
                } else if (degree >= 130 && pose_status == true) {
                    // 4단계
                    // 준비 중, 인식 O
                    Log.d("동작인식 각도 순서", "4단계");
                    Log.d("동작인식 각도 결과값", "준비 중, 인식 O");
                    Log.d("동작인식 각도 결과값", "==============");
                    Log.d("동작인식 각도 결과값", "카운트하기");
                    Log.d("동작인식 각도 결과값", "==============");
                    PoseInformation.pose_status = false;
                    PoseInformation.pose_count = PoseInformation.pose_count + 1;
                }

            }else{
                Log.d("크런치 예외처리2", "측정불가 -  다리 굽히는 중 X");
            }


        }else{
            Log.d("크런치 예외처리1", "측정불가 - 누워 있는 중 X");
        }

    }


    public void vup_data(int pose_count, boolean pose_status,
                         double a1, double a2, double b1, double b2, double c1, double c2,
                         double d1, double d2, double e1, double e2, double f1, double f2,
                         double g1, double g2, double h1, double h2) {
        Log.d("브이업변수", String.valueOf(pose_status));
        Log.d("브이업개수", String.valueOf(pose_count));

        double line_ab = Math.sqrt(Math.pow(a1 - b1, 2) + Math.pow(a2 - b2, 2));
        double line_bc = Math.sqrt(Math.pow(b1 - c1, 2) + Math.pow(b2 - c2, 2));
        double line_ca = Math.sqrt(Math.pow(c1 - a1, 2) + Math.pow(c2 - a2, 2));
        double result_up = (line_ab * line_ab + line_bc * line_bc - line_ca * line_ca);
        double result_down = 2 * line_ab * line_bc;
        double result = result_up / result_down;
        double cosX = Math.acos(result);
        double degree = Math.toDegrees(cosX);
        // 예측 (90도 ~ 145도)
        Log.d("브이업각도모음", String.valueOf(degree));
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 예외처리1 - (엉덩이 = 손목) - 몸이 바닥에 있는지 확인
        // 누워있는지 여부
        double vup_lay = Math.abs(d2 - f2);
        boolean lay = false;
        if(vup_lay<50){
            lay = true;
        }else{
            lay = false;
        }
        Log.d("브이업 엉덩이 좌표", String.valueOf(d1) + "/" + String.valueOf(d2));
        Log.d("브이업 손목 좌표", String.valueOf(f1) + "/" + String.valueOf(f2));
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 예외처리2 - (엉덩이 , 어깨 , 손목) - 팔을 짚었는지 확인
        double line_de = Math.sqrt(Math.pow(d1 - e1, 2) + Math.pow(d2 - e2, 2));
        double line_ef = Math.sqrt(Math.pow(e1 - f1, 2) + Math.pow(e2 - f2, 2));
        double line_fd = Math.sqrt(Math.pow(f1 - d1, 2) + Math.pow(f2 - d2, 2));
        double result_up_hand = (line_de * line_de + line_ef * line_ef - line_fd * line_fd);
        double result_down_hand = 2 * line_de * line_ef;
        double result_hand = result_up_hand / result_down_hand;
        double cosX_hand = Math.acos(result_hand);
        double degree_hand = Math.toDegrees(cosX_hand);
        //팔짚기 여부파악 15~50도
        Log.d("브이업 팔짚기각도모음", String.valueOf(degree_hand));
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 예외처리3 - (발목, 머리) - 카운트 시 발목이 머리 위에 있는지 확인
        boolean legup = false;
        if(g2<=h2){
            Log.d("브이업 다리 위로", "O");
            legup = true;
        }else{
            Log.d("브이업 다리 위로", "X");
            legup = false;
        }
        Log.d("브이업 발목 좌표", String.valueOf(g1) + "/" + String.valueOf(g2));
        Log.d("브이업 머리 좌표", String.valueOf(h1) + "/" + String.valueOf(h2));
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        if(lay){
            Log.d("브이업 예외처리1", "측정가능 - 브이업 준비자세 중 O");

            if(10<degree_hand && degree_hand<90){
                Log.d("브이업 예외처리2", "측정가능 - 팔짚기 중 O");

                if (degree >= 120 && pose_status == false) {
                    // 1단계
                    // 준비 중, 인식 X
                    Log.d("동작인식 각도 순서", "1단계");
                    Log.d("동작인식 각도 결과값", "준비 중, 인식 X");
                    PoseInformation.pose_status = false;
                    PoseInformation.pose_degree = 120.0;
                } else if (degree < 110 && legup==true && pose_status == false) {
                    // 2단계
                    // 브이업 중, 인식 X
                    Log.d("동작인식 각도 순서", "2단계");
                    Log.d("동작인식 각도 결과값", "브이업 중, 인식 X");
                    PoseInformation.pose_status = true;
                    if (degree < PoseInformation.pose_degree) {
                        PoseInformation.pose_degree = degree;
                    }
                } else if (degree < 110 &&  legup==true &&pose_status == true) {
                    // 3단계
                    // 브이업 중, 인식 O
                    Log.d("동작인식 각도 순서", "3단계");
                    Log.d("동작인식 각도 결과값", "브이업 중, 인식 O");
                    PoseInformation.pose_status = true;
                    if (degree < PoseInformation.pose_degree) {
                        PoseInformation.pose_degree = degree;
                    }
                } else if (degree >= 120 && pose_status == true) {
                    // 4단계
                    // 준비 중, 인식 O
                    Log.d("동작인식 각도 순서", "4단계");
                    Log.d("동작인식 각도 결과값", "준비 중, 인식 O");
                    Log.d("동작인식 각도 결과값", "==============");
                    Log.d("동작인식 각도 결과값", "카운트하기");
                    Log.d("동작인식 각도 결과값", "==============");
                    PoseInformation.pose_status = false;
                    PoseInformation.pose_count = PoseInformation.pose_count + 1;
                }

            }else{
                Log.d("브이업 예외처리2", "측정불가 -  팔짚기 중 X");
            }

        }else{
            Log.d("브이업 예외처리1", "측정불가 - 브이업 준비자세 중 X");
        }


    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


    public void kneeup_data(int pose_count, boolean pose_status, double a1, double a2, double b1, double b2, double c1, double c2, double d1, double d2, double e1, double e2, double f1, double f2) {
        Log.d("접었다폈다복근 변수", String.valueOf(pose_status));
        Log.d("접었다폈다복근 개수", String.valueOf(pose_count));

        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 개수 측정 -  각도1(엉덩이, 무릎, 발목) -  각도가 110이하일 경우 카운트
        double line_ab = Math.sqrt(Math.pow(a1 - b1, 2) + Math.pow(a2 - b2, 2));
        double line_bc = Math.sqrt(Math.pow(b1 - c1, 2) + Math.pow(b2 - c2, 2));
        double line_ca = Math.sqrt(Math.pow(c1 - a1, 2) + Math.pow(c2 - a2, 2));
        double result_up = (line_ab * line_ab + line_bc * line_bc - line_ca * line_ca);
        double result_down = 2 * line_ab * line_bc;
        double result = result_up / result_down;
        double cosX = Math.acos(result);
        double degree = Math.toDegrees(cosX);
        // 90 ~ 155
        Log.d("접었다폈다복근각도모음", String.valueOf(degree));

        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 예외처리1 -  (엉덩이 - 어깨 - 팔꿈치) (20도~70도일 경우에만 측정, 그 외의 경우 측정 X) -> 손을 바닥에 올바른 각도로 짚었는지 측정
        double line_de = Math.sqrt(Math.pow(d1 - e1, 2) + Math.pow(d2 - e2, 2));
        double line_ef = Math.sqrt(Math.pow(e1 - f1, 2) + Math.pow(e2 - f2, 2));
        double line_fd = Math.sqrt(Math.pow(f1 - d1, 2) + Math.pow(f2 - d2, 2));
        double result_up_sub = (line_de * line_de + line_ef * line_ef - line_fd * line_fd);
        double result_down_sub = 2 * line_de * line_ef;
        double result_sub = result_up_sub / result_down_sub;
        double cosX_sub = Math.acos(result_sub);
        double degree_sub = Math.toDegrees(cosX_sub);
        // 팔짚기 여부 파악 (40도정도)
        Log.d("접었다폈다복근각도모음(팔짚기)", String.valueOf(degree_sub));


        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 예외처리2 -  (발목 >> 엉덩이) - 서서 동작하는 것 방지
        boolean ankle_up = false;
        if(c2<a2){
            Log.d("접었다폈다복근 다리 위로", "O");
            ankle_up = true;
        }else{
            Log.d("접었다폈다복근 다리 위로", "X");
            ankle_up = false;
        }
        Log.d("접었다폈다복근 엉덩이 좌표", String.valueOf(a1) + "/" + String.valueOf(a2));
        Log.d("접었다폈다복근 발목 좌표", String.valueOf(c1) + "/" + String.valueOf(c2));

        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 예외처리3 -  (무릎 >>> 어깨) - 다리를 바닥에 대고하는 것 방지
        boolean knee_up = false;
        if(b2<e2){
            Log.d("접었다폈다복근 다리 높게 위로", "O");
            knee_up = true;
        }else{
            Log.d("접었다폈다복근 다리 높게 위로", "X");
            knee_up = false;
        }
        Log.d("접었다폈다복근 무릎 좌표", String.valueOf(b1) + "/" + String.valueOf(b2));
        Log.d("접었다폈다복근 어깨 좌표", String.valueOf(e1) + "/" + String.valueOf(e2));

        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        if(ankle_up){
            Log.d("접었다폈다복근 예외처리2", "측정가능 - 접었다폈다복근 다리 위로 O");

            if ( 20 < degree_sub && degree_sub < 110 ) {
                Log.d("접었다폈다복근 예외처리1", "측정가능 - 팔 짚은 것으로 인식 O");
                if (degree >= 150 && pose_status == false) {
                    // 1단계
                    // 준비 중, 인식 X
                    Log.d("동작인식 각도 순서", "1단계");
                    Log.d("동작인식 각도 결과값", "준비 중, 인식 X");
                    PoseInformation.pose_status = false;
                    PoseInformation.pose_degree = 150.0;
                } else if (degree < 110 && knee_up == true && pose_status == false) {
                    // 2단계
                    // 접었다폈다복근 중, 인식 X
                    Log.d("동작인식 각도 순서", "2단계");
                    Log.d("동작인식 각도 결과값", "접었다폈다복근 중, 인식 X");
                    PoseInformation.pose_status = true;
                    if (degree < PoseInformation.pose_degree) {
                        PoseInformation.pose_degree = degree;
                    }
                } else if (degree < 110 && knee_up == true &&pose_status == true) {
                    // 3단계
                    // 접었다폈다복근 중, 인식 O
                    Log.d("동작인식 각도 순서", "3단계");
                    Log.d("동작인식 각도 결과값", "접었다폈다복근 중, 인식 O");
                    PoseInformation.pose_status = true;
                    if (degree < PoseInformation.pose_degree) {
                        PoseInformation.pose_degree = degree;
                    }
                } else if (degree >= 150 && pose_status == true) {
                    // 4단계
                    // 준비 중, 인식 O
                    Log.d("동작인식 각도 순서", "4단계");
                    Log.d("동작인식 각도 결과값", "준비 중, 인식 O");
                    Log.d("동작인식 각도 결과값", "==============");
                    Log.d("동작인식 각도 결과값", "카운트하기");
                    Log.d("동작인식 각도 결과값", "==============");
                    PoseInformation.pose_status = false;
                    PoseInformation.pose_count = PoseInformation.pose_count + 1;
                }
            } else {
                Log.d("접었다폈다복근 예외처리1", "측정불가 - 팔 짚은 것으로 인식 X");
            }

        }else{
            Log.d("접었다폈다복근 예외처리2", "측정불가 - 접었다폈다복근 다리 위로 X");
        }


    }

    public void ankleupdown_data(int pose_count, boolean pose_status,
                                 double a1, double a2, double b1, double b2, double c1, double c2,
                                 double d1, double d2, double e1, double e2, double f1, double f2,
                                 double g1, double g2, double h1, double h2) {
        Log.d("위아래지그재그복근 변수", String.valueOf(pose_status));
        Log.d("위아래지그재그복근 개수", String.valueOf(pose_count));
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 개수 측정 - 각도1(왼쪽발목, 엉덩이, 오른쪽발목) - 양쪽 발목이 교차할때마다 0.5씩 카운트 - 30도 이상일 경우 카운트
        double line_ab = Math.sqrt(Math.pow(a1 - b1, 2) + Math.pow(a2 - b2, 2));
        double line_bc = Math.sqrt(Math.pow(b1 - c1, 2) + Math.pow(b2 - c2, 2));
        double line_ca = Math.sqrt(Math.pow(c1 - a1, 2) + Math.pow(c2 - a2, 2));
        double result_up = (line_ab * line_ab + line_bc * line_bc - line_ca * line_ca);
        double result_down = 2 * line_ab * line_bc;
        double result = result_up / result_down;
        double cosX = Math.acos(result);
        double degree = Math.toDegrees(cosX);
        // 1~35도
        Log.d("위아래지그재그복근각도모음", String.valueOf(degree));
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 예외처리1 -  (엉덩이 - 어깨 - 팔꿈치) (20도~110도일 경우에만 측정, 그 외의 경우 측정 X) -> 손을 바닥에 올바른 각도로 짚었는지 측정
        double line_de = Math.sqrt(Math.pow(d1 - e1, 2) + Math.pow(d2 - e2, 2));
        double line_ef = Math.sqrt(Math.pow(e1 - f1, 2) + Math.pow(e2 - f2, 2));
        double line_fd = Math.sqrt(Math.pow(f1 - d1, 2) + Math.pow(f2 - d2, 2));
        double result_up_sub = (line_de * line_de + line_ef * line_ef - line_fd * line_fd);
        double result_down_sub = 2 * line_de * line_ef;
        double result_sub = result_up_sub / result_down_sub;
        double cosX_sub = Math.acos(result_sub);
        double degree_sub = Math.toDegrees(cosX_sub);
        // 팔짚기 여부 파악 (40도정도)
        Log.d("위아래지그재그복근각도모음(팔짚기)", String.valueOf(degree_sub));
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 예외처리2 -  (발목 >= 엉덩이) - 서서 동작하는 것 방지
        boolean ankle_up = false;
        if(a2<=b2){
            Log.d("위아래지그재그복근 다리 위로", "O");
            ankle_up = true;
        }else{
            Log.d("위아래지그재그복근 다리 위로", "X");
            ankle_up = false;
        }
        //Log.d("위아래지그재그복근 엉덩이 좌표", String.valueOf(b1) + "/" + String.valueOf(b2));
        //Log.d("위아래지그재그복근 발목 좌표", String.valueOf(a1) + "/" + String.valueOf(a2));
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 예외처리3 -  (발목 >= 어깨) - 카운트 시 발목이 어깨 위로 올라가는지 확인
        boolean ankle_up_high = false;
        if( (a2<=g2) || (c2<=h2) ){
            Log.d("위아래지그재그복근 예외처리3", "측정가능 - 카운트 시 발목이 어깨 위로 올라가는지 확인 O");
            ankle_up_high = true;
        }else{
            Log.d("위아래지그재그복근 예외처리3", "측정불가 - 카운트 시 발목이 어깨 위로 올라가는지 확인 X");
            ankle_up_high = false;
        }

        Log.d("위아래지그재그복근 왼쪽발목 좌표", String.valueOf(a1) + "/" + String.valueOf(a2));
        Log.d("위아래지그재그복근 왼쪽어깨 좌표", String.valueOf(g1) + "/" + String.valueOf(g2));
        Log.d("위아래지그재그복근 오른쪽발목 좌표", String.valueOf(c1) + "/" + String.valueOf(c2));
        Log.d("위아래지그재그복근 오른쪽어깨 좌표", String.valueOf(h1) + "/" + String.valueOf(h2));



        if(ankle_up) {
            Log.d("위아래지그재그복근 예외처리2", "측정가능 - 위아래지그재그복근 다리 위로 O");

            if (20 < degree_sub && degree_sub < 110) {
                Log.d("위아래지그재그복근 예외처리1", "측정가능 - 팔 짚은 것으로 인식 O");

                if (degree < 10 && pose_status == false) {
                    // 1단계
                    // 준비 중, 인식 X
                    Log.d("동작인식 각도 순서", "1단계");
                    Log.d("동작인식 각도 결과값", "준비 중, 인식 X");
                    PoseInformation.pose_status = false;
                    PoseInformation.pose_degree = 20.0;
                } else if (30 < degree &&  ankle_up_high==true && pose_status == false) {
                    // 2단계
                    // 위아래지그재그복근중, 인식 X
                    Log.d("동작인식 각도 순서", "2단계");
                    Log.d("동작인식 각도 결과값", "위아래지그재그복근 중, 인식 X");
                    PoseInformation.pose_status = true;
                    if (degree > PoseInformation.pose_degree) {
                        PoseInformation.pose_degree = degree;
                    }
                } else if (30 < degree && ankle_up_high==true && pose_status == true) {
                    // 3단계
                    // 위아래지그재그복근 중, 인식 O
                    Log.d("동작인식 각도 순서", "3단계");
                    Log.d("동작인식 각도 결과값", "위아래지그재그복근 중, 인식 O");
                    PoseInformation.pose_status = true;
                    if (degree > PoseInformation.pose_degree) {
                        PoseInformation.pose_degree = degree;
                    }
                } else if (degree < 10  && pose_status == true) {

                    PoseInformation.pose_status = false;
                    PoseInformation.pose_count_double = PoseInformation.pose_count_double + 0.5;

                    if(PoseInformation.pose_count_double%1==0 && PoseInformation.pose_count_double!=0){ // 1로 나눴을 때 나머지가 0인경우, 0이 아닌경우

                        // 4단계
                        // 준비 중, 인식 O
                        Log.d("동작인식 각도 순서", "4단계");
                        Log.d("동작인식 각도 결과값", "준비 중, 인식 O");
                        Log.d("동작인식 각도 결과값", "==============");
                        Log.d("동작인식 각도 결과값", "카운트하기");
                        Log.d("동작인식 각도 결과값", "==============");
                        PoseInformation.pose_count = (int) Math.floor(PoseInformation.pose_count_double);

                    }else{ // 나머지가 0.5인경우

                    }

                }

            }else{
                Log.d("위아래지그재그복근 예외처리1", "측정불가 - 팔 짚은 것으로 인식 X");
            }

        }else{
            Log.d("위아래지그재그복근 예외처리2", "측정불가 - 위아래지그재그복근 다리 위로 X");
        }



//        if (degree < 20 && pose_status == false) {
//            // 1단계
//            // 준비 중, 인식 X
//            Log.d("동작인식 각도 순서", "1단계");
//            Log.d("동작인식 각도 결과값", "준비 중, 인식 X");
//            PoseInformation.pose_status = false;
//            PoseInformation.pose_degree = 20.0;
//        } else if (30 < degree && pose_status == false) {
//            // 2단계
//            // 위아래지그재그복근중, 인식 X
//            Log.d("동작인식 각도 순서", "2단계");
//            Log.d("동작인식 각도 결과값", "위아래지그재그복근 중, 인식 X");
//            PoseInformation.pose_status = true;
//            if (degree > PoseInformation.pose_degree) {
//                PoseInformation.pose_degree = degree;
//            }
//        } else if (30 < degree && pose_status == true) {
//            // 3단계
//            // 위아래지그재그복근 중, 인식 O
//            Log.d("동작인식 각도 순서", "3단계");
//            Log.d("동작인식 각도 결과값", "위아래지그재그복근 중, 인식 O");
//            PoseInformation.pose_status = true;
//            if (degree > PoseInformation.pose_degree) {
//                PoseInformation.pose_degree = degree;
//            }
//        } else if (degree < 20  && pose_status == true) {
//
//            PoseInformation.pose_status = false;
//            PoseInformation.pose_count_double = PoseInformation.pose_count_double + 0.5;
//
//            if(PoseInformation.pose_count_double%1==0 && PoseInformation.pose_count_double!=0){ // 1로 나눴을 때 나머지가 0인경우, 0이 아닌경우
//
//                // 4단계
//                // 준비 중, 인식 O
//                Log.d("동작인식 각도 순서", "4단계");
//                Log.d("동작인식 각도 결과값", "준비 중, 인식 O");
//                Log.d("동작인식 각도 결과값", "==============");
//                Log.d("동작인식 각도 결과값", "카운트하기");
//                Log.d("동작인식 각도 결과값", "==============");
//                PoseInformation.pose_count = (int) Math.floor(PoseInformation.pose_count_double);
//
//            }else{ // 나머지가 0.5인경우
//
//            }
//
//        }

    }

    public void lunge_data(int pose_count, boolean pose_status, double a1, double a2, double b1, double b2, double c1, double c2,
                           double d1, double d2, double e1, double e2, double f1, double f2) {
        Log.d("런지변수", String.valueOf(pose_status));
        Log.d("런지개수", String.valueOf(pose_count));
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 개수 측정
        double line_ab = Math.sqrt(Math.pow(a1 - b1, 2) + Math.pow(a2 - b2, 2));
        double line_bc = Math.sqrt(Math.pow(b1 - c1, 2) + Math.pow(b2 - c2, 2));
        double line_ca = Math.sqrt(Math.pow(c1 - a1, 2) + Math.pow(c2 - a2, 2));
        double result_up_left = (line_ab * line_ab + line_bc * line_bc - line_ca * line_ca);
        double result_down_left = 2 * line_ab * line_bc;
        double result_left = result_up_left / result_down_left;
        double cosX_left = Math.acos(result_left);
        double degree_left = Math.toDegrees(cosX_left);
        // 70~160
        Log.d("런지각도모음(왼쪽발목 - 왼쪽무릎 - 엉덩이)", String.valueOf(degree_left));
        double line_de = Math.sqrt(Math.pow(d1 - e1, 2) + Math.pow(d2 - e2, 2));
        double line_ef = Math.sqrt(Math.pow(e1 - f1, 2) + Math.pow(e2 - f2, 2));
        double line_fd = Math.sqrt(Math.pow(f1 - d1, 2) + Math.pow(f2 - d2, 2));
        double result_up_right = (line_de * line_de + line_ef * line_ef - line_fd * line_fd);
        double result_down_right = 2 * line_de * line_ef;
        double result_right = result_up_right / result_down_right;
        double cosX_right = Math.acos(result_right);
        double degree_right = Math.toDegrees(cosX_right);
        // 110 ~ 160
        Log.d("런지각도모음(오른쪽발목 - 오른쪽무릎 - 엉덩이)", String.valueOf(degree_right));
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 예외처리1 - (왼쪽발목, 엉덩이, 오른쪽발목) - 두 발이 떨어져있는지 확인 (스쿼트에서도 카운트되는 부분 방지)
        double line_ac = Math.sqrt(Math.pow(a1 - c1, 2) + Math.pow(a2 - c2, 2));
        double line_cd = Math.sqrt(Math.pow(c1 - d1, 2) + Math.pow(c2 - d2, 2));
        double line_da = Math.sqrt(Math.pow(d1 - a1, 2) + Math.pow(d2 - a2, 2));
        double result_up_sub = (line_ac * line_ac + line_cd * line_cd - line_da * line_da);
        double result_down_sub = 2 * line_ac * line_cd;
        double result_sub = result_up_sub / result_down_sub;
        double cosX_sub = Math.acos(result_sub);
        double degree_sub = Math.toDegrees(cosX_sub);
        // 런지 자세 판별 (50도~90도)
        Log.d("런지각도모음(왼쪽발목 - 엉덩이 - 오른쪽발목)", String.valueOf(degree_sub));
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        if(degree_sub>20){
            Log.d("런지 예외처리1", "측정가능 - 다리 벌리는 중 O");

            if ( (degree_left >= 140 && degree_right >= 140) && pose_status == false) {
                // 1단계
                // 준비 중, 인식 X
                Log.d("동작인식 각도 순서", "1단계");
                Log.d("동작인식 각도 결과값", "준비 중, 인식 X");
                PoseInformation.pose_status = false;
                PoseInformation.pose_degree = 140.0;
            } else if ( (degree_left < 110 && degree_right < 110) && pose_status == false) {
                // 2단계
                // 런지 중, 인식 X
                Log.d("동작인식 각도 순서", "2단계");
                Log.d("동작인식 각도 결과값", "런지 중, 인식 X");
                PoseInformation.pose_status = true;
                if (degree_left < PoseInformation.pose_degree) {
                    PoseInformation.pose_degree = degree_left;
                }
                if (degree_right < PoseInformation.pose_degree) {
                    PoseInformation.pose_degree = degree_right;
                }
            } else if ((degree_left < 110 && degree_right < 110) && pose_status == true) {
                // 3단계
                // 런지 중, 인식 O
                Log.d("동작인식 각도 순서", "3단계");
                Log.d("동작인식 각도 결과값", "런지 중, 인식 O");
                PoseInformation.pose_status = true;
                if (degree_left < PoseInformation.pose_degree) {
                    PoseInformation.pose_degree = degree_left;
                }
                if (degree_right < PoseInformation.pose_degree) {
                    PoseInformation.pose_degree = degree_right;
                }
            } else if ((degree_left >= 140 && degree_right >= 140) && pose_status == true) {
                // 4단계
                // 준비 중, 인식 O
                Log.d("동작인식 각도 순서", "4단계");
                Log.d("동작인식 각도 결과값", "준비 중, 인식 O");
                Log.d("동작인식 각도 결과값", "==============");
                Log.d("동작인식 각도 결과값", "카운트하기");
                Log.d("동작인식 각도 결과값", "==============");
                PoseInformation.pose_status = false;
                PoseInformation.pose_count = PoseInformation.pose_count + 1;
            }


        }else{
            Log.d("런지 예외처리1", "측정불가 - 다리 벌리는 중 X");
        }


    }



    public void goodmorning_data(int pose_count, boolean pose_status,
                                 double a1, double a2, double b1, double b2, double c1, double c2,
                                 double d1, double d2, double e1, double e2, double f1, double f2, double g1, double g2,
                                 double h1, double h2, double i1, double i2, double j1, double j2,
                                 double k1, double k2, double l1, double l2, double m1, double m2) {
        Log.d("굿모닝변수", String.valueOf(pose_status));
        Log.d("굿모닝개수", String.valueOf(pose_count));
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 개수 측정  - 각도1(어깨, 엉덩이, 발목) - 각도가 120도 이하일 경우 측정
        double line_ab = Math.sqrt(Math.pow(a1 - b1, 2) + Math.pow(a2 - b2, 2));
        double line_bc = Math.sqrt(Math.pow(b1 - c1, 2) + Math.pow(b2 - c2, 2));
        double line_ca = Math.sqrt(Math.pow(c1 - a1, 2) + Math.pow(c2 - a2, 2));
        double result_up = (line_ab * line_ab + line_bc * line_bc - line_ca * line_ca);
        double result_down = 2 * line_ab * line_bc;
        double result = result_up / result_down;
        double cosX = Math.acos(result);
        double degree = Math.toDegrees(cosX);
        // 95도 ~ 170도
        Log.d("굿모닝각도모음", String.valueOf(degree));
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 예외처리1 - (왼쪽손목>왼쪽어깨, 오른쪽손목>오른쪽어깨) - 굿모닝 준비자세
        boolean hand_ear = false;
        if(d2<=e2 || f2<=g2 ){
            Log.d("굿모닝 팔목이 어깨보다 위에 위치", "O");
            hand_ear = true;
        }else{
            Log.d("굿모닝 팔목이 어깨보다 위에 위치", "X");
            hand_ear = false;
        }


        Log.d("굿모닝 왼쪽손목 좌표", String.valueOf(d1) + "/" + String.valueOf(d2));
        Log.d("굿모닝 왼쪽어깨 좌표", String.valueOf(e1) + "/" + String.valueOf(e2));
        Log.d("굿모닝 오른쪽손목 좌표", String.valueOf(f1) + "/" + String.valueOf(f2));
        Log.d("굿모닝 오른쪽어깨 좌표", String.valueOf(g1) + "/" + String.valueOf(g2));

        Log.d("굿모닝 발목 좌표", String.valueOf(j1) + "/" + String.valueOf(j2));

        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 예외처리2 - (왼쪽발목, 엉덩이, 오른쪽발목) - 두 발이 붙어있는지 확인
        double line_hi = Math.sqrt(Math.pow(h1 - i1, 2) + Math.pow(h2 - i2, 2));
        double line_ij = Math.sqrt(Math.pow(i1 - j1, 2) + Math.pow(i2 - j2, 2));
        double line_jh = Math.sqrt(Math.pow(j1 - h1, 2) + Math.pow(j2 - h2, 2));
        double result_up_sub = (line_hi * line_hi + line_ij * line_ij - line_jh * line_jh);
        double result_down_sub = 2 * line_hi * line_ij;
        double result_sub = result_up_sub / result_down_sub;
        double cosX_sub = Math.acos(result_sub);
        double degree_sub = Math.toDegrees(cosX_sub);
        Log.d("굿모닝다리벌림각도모음", String.valueOf(degree_sub));
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 예외처리3 - (엉덩이, 무릎, 발목) - 다리 1자로
        double line_kl = Math.sqrt(Math.pow(k1 - l1, 2) + Math.pow(k2 - l2, 2));
        double line_lm = Math.sqrt(Math.pow(l1 - m1, 2) + Math.pow(l2 - m2, 2));
        double line_mk = Math.sqrt(Math.pow(m1 - k1, 2) + Math.pow(m2 - k2, 2));
        double result_up_leg = (line_kl * line_kl + line_lm * line_lm - line_mk * line_mk);
        double result_down_leg = 2 * line_kl * line_lm;
        double result_leg = result_up_leg / result_down_leg;
        double cosX_leg = Math.acos(result_leg);
        double degree_leg = Math.toDegrees(cosX_leg);
        Log.d("굿모닝다리각도모음", String.valueOf(degree_leg));

        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        if(degree_leg>140){
            Log.d("굿모닝 예외처리3", "측정가능 - 다리 1자 O");

            if (degree >= 160 && hand_ear && pose_status == false) {
                // 1단계
                // 준비 중, 인식 X
                Log.d("동작인식 각도 순서", "1단계");
                Log.d("동작인식 각도 결과값", "준비 중, 인식 X");
                PoseInformation.pose_status = false;
                PoseInformation.pose_degree = 160.0;
            } else if (degree < 120 &&  pose_status == false) {
                // 2단계
                // 굿모닝 중, 인식 X
                Log.d("동작인식 각도 순서", "2단계");
                Log.d("동작인식 각도 결과값", "굿모닝 중, 인식 X");
                PoseInformation.pose_status = true;
                if (degree < PoseInformation.pose_degree) {
                    PoseInformation.pose_degree = degree;
                }
            } else if (degree < 120 &&  pose_status == true) {
                // 3단계
                //굿모닝 중, 인식 O
                Log.d("동작인식 각도 순서", "3단계");
                Log.d("동작인식 각도 결과값", "굿모닝 중, 인식 O");
                PoseInformation.pose_status = true;
                if (degree < PoseInformation.pose_degree) {
                    PoseInformation.pose_degree = degree;
                }
            } else if (degree >= 160 && hand_ear && pose_status == true) {
                // 4단계
                // 준비 중, 인식 O
                Log.d("동작인식 각도 순서", "4단계");
                Log.d("동작인식 각도 결과값", "준비 중, 인식 O");
                Log.d("동작인식 각도 결과값", "==============");
                Log.d("동작인식 각도 결과값", "카운트하기");
                Log.d("동작인식 각도 결과값", "==============");
                PoseInformation.pose_status = false;
                PoseInformation.pose_count = PoseInformation.pose_count + 1;
            }

        }else{
            Log.d("굿모닝 예외처리3", "측정불가 - 다리 1자 X");
        }


    }


    public void dumbbellshoulder_data(int pose_count, boolean pose_status,
                                      double a1, double a2, double b1, double b2, double c1, double c2,
                                      double d1, double d2, double e1, double e2, double f1, double f2,
                                      double g1, double g2, double h1, double h2, double i1, double i2,
                                      double j1, double j2, double k1, double k2, double l1, double l2) {
        Log.d("덤벨숄더프레스변수", String.valueOf(pose_status));
        Log.d("덤벨숄더프레스개수", String.valueOf(pose_count));

        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 개수 측정1 - 각도1(왼쪽어깨, 왼쪽팔꿈치, 왼쪽손목) - 140도 이상일 경우 카운트
        double line_ab = Math.sqrt(Math.pow(a1 - b1, 2) + Math.pow(a2 - b2, 2));
        double line_bc = Math.sqrt(Math.pow(b1 - c1, 2) + Math.pow(b2 - c2, 2));
        double line_ca = Math.sqrt(Math.pow(c1 - a1, 2) + Math.pow(c2 - a2, 2));
        double result_up_left = (line_ab * line_ab + line_bc * line_bc - line_ca * line_ca);
        double result_down_left = 2 * line_ab * line_bc;
        double result_left = result_up_left / result_down_left;
        double cosX_left = Math.acos(result_left);
        double degree_left = Math.toDegrees(cosX_left);
        // 40 ~ 170
        Log.d("덤벨숄더프레스각도모음(왼)", String.valueOf(degree_left));
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 개수 측정2 - 각도2(오른쪽어깨, 른쪽팔꿈치, 른쪽손목) - 140도 이상일 경우 카운트
        double line_de = Math.sqrt(Math.pow(d1 - e1, 2) + Math.pow(d2 - e2, 2));
        double line_ef = Math.sqrt(Math.pow(e1 - f1, 2) + Math.pow(e2 - f2, 2));
        double line_fd = Math.sqrt(Math.pow(f1 - d1, 2) + Math.pow(f2 - d2, 2));
        double result_up_right = (line_de * line_de + line_ef * line_ef - line_fd * line_fd);
        double result_down_right = 2 * line_de * line_ef;
        double result_right = result_up_right / result_down_right;
        double cosX_right = Math.acos(result_right);
        double degree_right = Math.toDegrees(cosX_right);
        Log.d("덤벨숄더프레스각도모음(오른)", String.valueOf(degree_right));

        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 예외처리1 - (왼쪽엉덩이, 왼쪽무릎, 왼쪽발목) - 1자
        double line_gh = Math.sqrt(Math.pow(g1 - h1, 2) + Math.pow(g2 - h2, 2));
        double line_hi = Math.sqrt(Math.pow(h1 - i1, 2) + Math.pow(h2 - i2, 2));
        double line_ig = Math.sqrt(Math.pow(i1 - g1, 2) + Math.pow(i2 - g2, 2));
        double result_up_left_leg = (line_gh * line_gh + line_hi * line_hi - line_ig * line_ig);
        double result_down_left_leg = 2 * line_gh * line_hi;
        double result_left_leg = result_up_left_leg / result_down_left_leg;
        double cosX_left_leg = Math.acos(result_left_leg);
        double degree_left_leg = Math.toDegrees(cosX_left_leg);
        Log.d("덤벨숄더프레스각도모음(왼다리 1자)", String.valueOf(degree_left_leg));
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 예외처리2 - (오른쪽엉덩이, 오른쪽무릎, 오른쪽발목) - 1자
        double line_jk = Math.sqrt(Math.pow(j1 - k1, 2) + Math.pow(j2 - k2, 2));
        double line_kl = Math.sqrt(Math.pow(k1 - l1, 2) + Math.pow(k2 - l2, 2));
        double line_lj = Math.sqrt(Math.pow(l1 - j1, 2) + Math.pow(l2 - j2, 2));
        double result_up_right_leg = (line_jk * line_jk + line_kl * line_kl - line_lj * line_lj);
        double result_down_right_leg = 2 * line_jk * line_kl;
        double result_right_leg = result_up_right_leg / result_down_right_leg;
        double cosX_right_leg = Math.acos(result_right_leg);
        double degree_right_leg = Math.toDegrees(cosX_right_leg);
        Log.d("덤벨숄더프레스각도모음(오른다리 1자)", String.valueOf(degree_right_leg));
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 예외처리3 -(왼쪽손목>왼쪽어깨, 오른쪽손목>오른쪽어깨) - 덤벨숄더프레스 준비자세
        boolean hand_ear = false;
        if(c2<=a2 && f2<=d2 ){
            Log.d("덤벨숄더프레스 팔목이 어깨보다 위에 위치", "O");
            hand_ear = true;
        }else{
            Log.d("덤벨숄더프레스 팔목이 어깨보다 위에 위치", "X");
            hand_ear = false;
        }
        Log.d("덤벨숄더프레스 왼쪽손목 좌표", String.valueOf(c1) + "/" + String.valueOf(c2));
        Log.d("덤벨숄더프레스 왼쪽어깨 좌표", String.valueOf(a1) + "/" + String.valueOf(a2));
        Log.d("덤벨숄더프레스 오른쪽손목 좌표", String.valueOf(f1) + "/" + String.valueOf(f2));
        Log.d("덤벨숄더프레스 오른쪽어깨 좌표", String.valueOf(d1) + "/" + String.valueOf(d2));
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        if(degree_left_leg>150 && degree_right_leg>150){
            Log.d("덤벨숄더프레스 예외처리1,2", "측정가능 - 다리 1자 O");

            if(hand_ear){
                Log.d("덤벨숄더프레스 예외처리3", "측정가능 -  팔목이 어깨보다 위에 위치 O");

                if (degree_left <= 100 && degree_right <= 100 && pose_status == false) {
                    // 1단계
                    // 준비 중, 인식 X
                    Log.d("동작인식 각도 순서", "1단계");
                    Log.d("동작인식 각도 결과값", "준비 중, 인식 X");
                    PoseInformation.pose_status = false;
                    PoseInformation.pose_degree = 90.0;
                } else if (degree_left > 140 && degree_right > 140 && pose_status == false) {
                    // 2단계
                    // 덤벨숄더프레스 중, 인식 X
                    Log.d("동작인식 각도 순서", "2단계");
                    Log.d("동작인식 각도 결과값", "덤벨숄더프레스 중, 인식 X");
                    PoseInformation.pose_status = true;
                    if (degree_left > PoseInformation.pose_degree) {
                        PoseInformation.pose_degree = degree_left;
                    }
                } else if (degree_left > 140 && degree_right > 140 && pose_status == true) {
                    // 3단계
                    //덤벨숄더프레스 중, 인식 O
                    Log.d("동작인식 각도 순서", "3단계");
                    Log.d("동작인식 각도 결과값", "덤벨숄더프레스 중, 인식 O");
                    PoseInformation.pose_status = true;
                    if (degree_left > PoseInformation.pose_degree) {
                        PoseInformation.pose_degree = degree_left;
                    }
                } else if (degree_left <= 100 && degree_right <= 100 &&pose_status == true) {
                    // 4단계
                    // 준비 중, 인식 O
                    Log.d("동작인식 각도 순서", "4단계");
                    Log.d("동작인식 각도 결과값", "준비 중, 인식 O");
                    Log.d("동작인식 각도 결과값", "==============");
                    Log.d("동작인식 각도 결과값", "카운트하기");
                    Log.d("동작인식 각도 결과값", "==============");
                    PoseInformation.pose_status = false;
                    PoseInformation.pose_count = PoseInformation.pose_count + 1;
                }

            }else{
                Log.d("덤벨숄더프레스 예외처리3", "측정불가 -  팔목이 어깨보다 위에 위치 X");
            }

        }else{
            Log.d("덤벨숄더프레스 예외처리1,2", "측정불가 - 다리 1자 X");
        }

    }



    public void dumbbelllow_data(int pose_count, boolean pose_status,
                                 double a1, double a2, double b1, double b2, double c1, double c2,
                                 double d1, double d2, double e1, double e2, double f1, double f2,
                                 double g1, double g2, double h1, double h2, double i1, double i2) {
        Log.d("덤벨로우 변수", String.valueOf(pose_status));
        Log.d("덤벨로우 개수", String.valueOf(pose_count));

        double line_ab = Math.sqrt(Math.pow(a1 - b1, 2) + Math.pow(a2 - b2, 2));
        double line_bc = Math.sqrt(Math.pow(b1 - c1, 2) + Math.pow(b2 - c2, 2));
        double line_ca = Math.sqrt(Math.pow(c1 - a1, 2) + Math.pow(c2 - a2, 2));

        double result_up = (line_ab * line_ab + line_bc * line_bc - line_ca * line_ca);
        double result_down = 2 * line_ab * line_bc;
        double result = result_up / result_down;

        double cosX = Math.acos(result);
        double degree = Math.toDegrees(cosX);
        // 70 ~ 145
        Log.d("덤벨로우각도모음", String.valueOf(degree));

        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 예외처리1 -  (머리, 엉덩이, 발목) - 덤벨로우 준비자세(130도 이하)
        double line_de = Math.sqrt(Math.pow(d1 - e1, 2) + Math.pow(d2 - e2, 2));
        double line_ef = Math.sqrt(Math.pow(e1 - f1, 2) + Math.pow(e2 - f2, 2));
        double line_fd = Math.sqrt(Math.pow(f1 - d1, 2) + Math.pow(f2 - d2, 2));
        double result_up_sub = (line_de * line_de + line_ef * line_ef - line_fd * line_fd);
        double result_down_sub = 2 * line_de * line_ef;
        double result_sub = result_up_sub / result_down_sub;
        double cosX_sub = Math.acos(result_sub);
        double degree_sub = Math.toDegrees(cosX_sub);
        // 준비자세 여부 파악 (90도정도)
        Log.d("덤벨로우각도모음(준비자세)", String.valueOf(degree_sub));
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        //  예외처리2 -  (머리> 엉덩이> 발목) - 누워서 할 경우 대비
        boolean stand_up = false;
        if(d2<=e2 && e2<=f2 ){
            Log.d("덤벨로우 머리>엉덩이>발목", "O");
            stand_up = true;
        }else{
            Log.d("덤벨로우 머리>엉덩이>발목", "X");
            stand_up = false;
        }
        Log.d("덤벨로우 머리 좌표", String.valueOf(d1) + "/" + String.valueOf(d2));
        Log.d("덤벨로우 엉덩이 좌표", String.valueOf(e1) + "/" + String.valueOf(e2));
        Log.d("덤벨로우 발목 좌표", String.valueOf(f1) + "/" + String.valueOf(f2));
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 예외처리3 -  (엉덩이 - 무릎 - 발목) - 덤벨로우 준비자세2 (140도 이하)
        double line_gh = Math.sqrt(Math.pow(g1 - h1, 2) + Math.pow(g2 - h2, 2));
        double line_hi = Math.sqrt(Math.pow(h1 - i1, 2) + Math.pow(h2 - i2, 2));
        double line_ig = Math.sqrt(Math.pow(i1 - g1, 2) + Math.pow(i2 - g2, 2));
        double result_up_sub2 = (line_gh * line_gh + line_hi * line_hi - line_ig * line_ig);
        double result_down_sub2 = 2 * line_gh * line_hi;
        double result_sub2 = result_up_sub2 / result_down_sub2;
        double cosX_sub2 = Math.acos(result_sub2);
        double degree_sub2 = Math.toDegrees(cosX_sub2);
        // 준비자세2 여부 파악 (130도정도)
        Log.d("덤벨로우각도모음(준비자세2)", String.valueOf(degree_sub2));
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 예외처리4 -  (어깨 >> 손목) - 손목보다 어깨가 위에 위치
        boolean hand_down = false;
        if(a2 < c2 ){
            Log.d("덤벨로우 어깨 >> 손목", "O");
            hand_down = true;
        }else{
            Log.d("덤벨로우 어깨 >> 손목", "X");
            hand_down = false;
        }
        Log.d("덤벨로우 어깨 좌표", String.valueOf(a1) + "/" + String.valueOf(a2));
        Log.d("덤벨로우 손목 좌표", String.valueOf(c1) + "/" + String.valueOf(c2));


        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        if(stand_up){
            Log.d("덤벨로우 예외처리2", "측정가능 - 머리>엉덩이>발목 O");

            if(hand_down){
                Log.d("덤벨로우 예외처리4", "측정가능 - 덤벨로우 어깨 >> 손목 O");

                if (degree_sub < 130 ) {
                    Log.d("덤벨로우 예외처리1", "측정가능 - 덤벨로우 준비자세 O");

                    if (degree_sub2 < 150 ) {
                        Log.d("덤벨로우 예외처리3", "측정가능 - 덤벨로우 준비자세2 O");

                        if (degree >= 130 && pose_status == false) {
                            // 1단계
                            // 준비 중, 인식 X
                            Log.d("동작인식 각도 순서", "1단계");
                            Log.d("동작인식 각도 결과값", "준비 중, 인식 X");
                            PoseInformation.pose_status = false;
                            PoseInformation.pose_degree = 130.0;
                        } else if (degree < 110 && pose_status == false) {
                            // 2단계
                            // 덤벨로우 중, 인식 X
                            Log.d("동작인식 각도 순서", "2단계");
                            Log.d("동작인식 각도 결과값", "덤벨로우 중, 인식 X");
                            PoseInformation.pose_status = true;
                            if (degree < PoseInformation.pose_degree) {
                                PoseInformation.pose_degree = degree;
                            }
                        } else if (degree < 110 && pose_status == true) {
                            // 3단계
                            // 덤벨로우 중, 인식 O
                            Log.d("동작인식 각도 순서", "3단계");
                            Log.d("동작인식 각도 결과값", "덤벨로우 중, 인식 O");
                            PoseInformation.pose_status = true;
                            if (degree < PoseInformation.pose_degree) {
                                PoseInformation.pose_degree = degree;
                            }
                        } else if (degree >= 130 && pose_status == true) {
                            // 4단계
                            // 준비 중, 인식 O
                            Log.d("동작인식 각도 순서", "4단계");
                            Log.d("동작인식 각도 결과값", "준비 중, 인식 O");
                            Log.d("동작인식 각도 결과값", "==============");
                            Log.d("동작인식 각도 결과값", "카운트하기");
                            Log.d("동작인식 각도 결과값", "==============");
                            PoseInformation.pose_status = false;
                            PoseInformation.pose_count = PoseInformation.pose_count + 1;
                        }

                    }else{
                        Log.d("덤벨로우 예외처리3", "측정가능 - 덤벨로우 준비자세2 O");
                    }

                } else {
                    Log.d("덤벨로우 예외처리1", "측정불가 - 덤벨로우 준비자세 X");
                }

            }else{
                Log.d("덤벨로우 예외처리4", "측정불가 - 덤벨로우 어깨 >> 손목 X");
            }


        }else{
            Log.d("덤벨로우 예외처리2", "측정불가 - 머리>엉덩이>발목 X");
        }



    }





    //////////////////////////////////////////////////// 점핑 체조 ////////////////////////////////////////////////////


    public void basicjump_data(int pose_count, boolean pose_status, double a1, double a2, double b1, double b2, double c1, double c2, double d1, double d2) {
        Log.d("제자리점핑변수", String.valueOf(pose_status));
        Log.d("제자리점핑개수", String.valueOf(pose_count));

        Log.d("왼발좌표", String.valueOf(a1)+"/"+String.valueOf(a2));
        Log.d("오른발좌표",String.valueOf(b1)+"/"+String.valueOf(b2));


        //귀간의 거리
        //10보다 클경우 정면
        //10보다 작을 경우 측면
        double turn_status = Math.abs(c1-d1);
        Log.d("왼쪽귀좌표", String.valueOf(c1)+"/"+String.valueOf(c2));
        Log.d("오른쪽귀좌표",String.valueOf(d1)+"/"+String.valueOf(d2));

        if(PoseInformation.pose_arraylist.size() > 0 && PoseInformation.pose_arraylist.get(0) != "1"){
            //첫번째 배열의 시작이 1사분면이 아닐 경우 -> BallInformation.ball_arraylist 초기화
            Log.d("동작인식", "동작 배열 : 오류 -> 배열 초기화");
            PoseInformation.pose_arraylist.clear();

        }else{
            if( ((a1>360 && b1 <360) || (a1<360 && b1>360)) && turn_status>10 && PoseInformation.pose_arraylist.size()==0){
                Log.d("동작인식 각도 순서", "1단계");
                Log.d("동작인식 각도 결과값", "준비 중");
                PoseInformation.pose_arraylist.add("1");
            }else if(((a1>360 && b1 >360) || (a1<360 && b1<360)) && turn_status<10 && PoseInformation.pose_arraylist.size()==1 && PoseInformation.pose_arraylist.get(0)=="1"){
                Log.d("동작인식 각도 순서", "2단계");
                Log.d("동작인식 각도 결과값", "회전 중(1)");
                PoseInformation.pose_arraylist.add("2");
            }else if( ((a1>360 && b1 <360) || (a1<360 && b1>360)) && turn_status>10 && PoseInformation.pose_arraylist.size()==2 && PoseInformation.pose_arraylist.get(0)=="1"
                    && PoseInformation.pose_arraylist.get(1)=="2"){
                Log.d("동작인식 각도 순서", "3단계");
                Log.d("동작인식 각도 결과값", "뒤돌기 중");
                PoseInformation.pose_arraylist.add("3");
            }else if( ((a1>360 && b1 >360) || (a1<360 && b1<360)) && turn_status<10 && PoseInformation.pose_arraylist.size()==3 && PoseInformation.pose_arraylist.get(0)=="1"
                    && PoseInformation.pose_arraylist.get(1)=="2" && PoseInformation.pose_arraylist.get(2)=="3"){
                Log.d("동작인식 각도 순서", "4단계");
                Log.d("동작인식 각도 결과값", "회전 중(2)");
                PoseInformation.pose_arraylist.add("4");
            }else if( ((a1>360 && b1 <360) || (a1<360 && b1>360)) && turn_status>10 && PoseInformation.pose_arraylist.size()==4 && PoseInformation.pose_arraylist.get(0)=="1"
                    && PoseInformation.pose_arraylist.get(1)=="2" && PoseInformation.pose_arraylist.get(2)=="3" && PoseInformation.pose_arraylist.get(3)=="4"){
                Log.d("동작인식 각도 순서", "5단계");
                Log.d("동작인식 각도 결과값", "준비 중");
                PoseInformation.pose_arraylist.clear();
                PoseInformation.pose_count = PoseInformation.pose_count + 1;
            }
        }



    }


    public void twolegsidejump_data(int pose_count, boolean pose_status, double a1, double a2, double b1, double b2) {
        Log.d("두발사이드점핑변수", String.valueOf(pose_status));
        Log.d("두발사이드점핑개수", String.valueOf(pose_count));

        Log.d("왼발좌표", String.valueOf(a1)+"/"+String.valueOf(a2));
        Log.d("오른발좌표",String.valueOf(b1)+"/"+String.valueOf(b2));


        if((a1>360 && b1 <360) || (a1<360 && b1>360)){
            //두 발 모으기 전
            Log.d("두발사이드점핑(준비자세)","두발 모으기 전");
            Log.d("두발사이드점핑(준비자세)",String.valueOf(a1)+"/"+String.valueOf(b1));
            PoseInformation.pose_status = false;

        }else{
            Log.d("두발사이드점핑(준비자세)","두발 모은 후");
            Log.d("두발사이드점핑(준비자세)",String.valueOf(a1)+"/"+String.valueOf(b1));

            if(a1>360 && b1 >360 && pose_status == false){
                Log.d("동작인식 각도 순서", "1단계");
                Log.d("동작인식 각도 결과값", "준비 중, 인식 X");
            }else if(a1<360 && b1 <360 && pose_status == false){
                Log.d("동작인식 각도 순서", "2단계");
                Log.d("동작인식 각도 결과값", "준비 중, 인식 X");
                PoseInformation.pose_status = true;
            }else if(a1>360 && b1 >360 && pose_status == true){
                Log.d("동작인식 각도 순서", "3단계");
                Log.d("동작인식 각도 결과값", "사이드 점핑 중, 인식 O");
                Log.d("동작인식 각도 결과값", "==============");
                Log.d("동작인식 각도 결과값", "카운트하기");
                Log.d("동작인식 각도 결과값", "==============");
                PoseInformation.pose_status = false;
                PoseInformation.pose_count = PoseInformation.pose_count + 1;
            }


        }


    }


    public void twolegfrontjump_data(int pose_count, boolean pose_status, double a1, double a2, double b1, double b2, double c1, double c2, double d1, double d2) {
        Log.d("두발앞뒤점핑변수", String.valueOf(pose_status));
        Log.d("두발앞뒤점핑개수", String.valueOf(pose_count));

        Log.d("왼발좌표", String.valueOf(a1)+"/"+String.valueOf(a2));
        Log.d("오른발좌표",String.valueOf(b1)+"/"+String.valueOf(b2));

        Log.d("왼쪽귀좌표", String.valueOf(c1)+"/"+String.valueOf(c2));
        Log.d("오른쪽귀좌표",String.valueOf(d1)+"/"+String.valueOf(d2));

        //귀간의 거리
        //10보다 클경우 정면
        //10보다 작을 경우 측면
        double turn_status = Math.abs(c1-d1);


        if((a1>360 && b1 <360) || (a1<360 && b1>360)){
            //두 발 모으기 전
            Log.d("두발앞뒤점핑(준비자세)","두발 모으기 전");
            Log.d("두발앞뒤점핑(준비자세)",String.valueOf(a1)+"/"+String.valueOf(b1));
            PoseInformation.pose_status = false;

        }else if(turn_status>10){
            //정면을 응시할 경우
            PoseInformation.pose_status = false;
        }
        else{
            Log.d("두발앞뒤점핑(준비자세)","두발 모은 후");
            Log.d("두발앞뒤점핑(준비자세)",String.valueOf(a1)+"/"+String.valueOf(b1));

            if(a1>360 && b1 >360 && turn_status<10 && pose_status == false){
                Log.d("동작인식 각도 순서", "1단계");
                Log.d("동작인식 각도 결과값", "준비 중, 인식 X");
            }else if(a1<360 && b1 <360 && turn_status<10 &&pose_status == false){
                Log.d("동작인식 각도 순서", "2단계");
                Log.d("동작인식 각도 결과값", "준비 중, 인식 X");
                PoseInformation.pose_status = true;
            }else if(a1>360 && b1 >360 && turn_status<10 &&pose_status == true){
                Log.d("동작인식 각도 순서", "3단계");
                Log.d("동작인식 각도 결과값", "사이드 점핑 중, 인식 O");
                Log.d("동작인식 각도 결과값", "==============");
                Log.d("동작인식 각도 결과값", "카운트하기");
                Log.d("동작인식 각도 결과값", "==============");
                PoseInformation.pose_status = false;
                PoseInformation.pose_count = PoseInformation.pose_count + 1;
            }

        }


    }



    public void punchstep_data(int pose_count, boolean pose_status, double a1, double a2, double b1, double b2, double c1, double c2, double d1, double d2, double e1, double e2, double f1, double f2, double g1, double g2, double h1, double h2) {
        Log.d("펀치스텝변수", String.valueOf(pose_status));
        Log.d("펀치스텝개수", String.valueOf(pose_count));


        double line_ab = Math.sqrt(Math.pow(a1 - b1, 2) + Math.pow(a2 - b2, 2));
        double line_bc = Math.sqrt(Math.pow(b1 - c1, 2) + Math.pow(b2 - c2, 2));
        double line_ca = Math.sqrt(Math.pow(c1 - a1, 2) + Math.pow(c2 - a2, 2));
        double result_up = (line_ab * line_ab + line_bc * line_bc - line_ca * line_ca);
        double result_down = 2 * line_ab * line_bc;
        double result = result_up / result_down;

        double cosX = Math.acos(result);
        double degree = Math.toDegrees(cosX);

        // 10 ~100
        Log.d("펀치스텝 각도모음1", String.valueOf(degree));

        double line_de = Math.sqrt(Math.pow(d1 - e1, 2) + Math.pow(d2 - e2, 2));
        double line_ef = Math.sqrt(Math.pow(e1 - f1, 2) + Math.pow(e2 - f2, 2));
        double line_fd = Math.sqrt(Math.pow(f1 - d1, 2) + Math.pow(f2 - d2, 2));
        double result_up_sub = (line_de * line_de + line_ef * line_ef - line_fd * line_fd);
        double result_down_sub = 2 * line_de * line_ef;
        double result_sub = result_up_sub / result_down_sub;

        double cosX_sub = Math.acos(result_sub);
        double degree_sub = Math.toDegrees(cosX_sub);

        // 10 ~100
        Log.d("펀치스텝 각도모음2", String.valueOf(degree_sub));



        Log.d("왼발좌표", String.valueOf(g1) + "/" + String.valueOf(g2));
        Log.d("오른발좌표", String.valueOf(h1) + "/" + String.valueOf(h2));

        //발 높이간의 거리
        //10보다 클경우 한발만 바닥에
        //10보다 작을 경우 양발 바닥에
        double punch_status = Math.abs(g2-h2);

        if (PoseInformation.pose_arraylist.size() > 0 && PoseInformation.pose_arraylist.get(0) != "1") {
            Log.d("동작인식", "동작 배열 : 오류 -> 배열 초기화");
            PoseInformation.pose_arraylist.clear();

        } else {
            if (punch_status < 20 && (degree>50 || degree_sub>50) && PoseInformation.pose_arraylist.size() == 0) {
                Log.d("동작인식 각도 순서", "1단계");
                Log.d("동작인식 각도 결과값", "준비 중");
                PoseInformation.pose_arraylist.add("1");
            }else if (punch_status > 20 && PoseInformation.pose_arraylist.size() == 1 && (degree>50 || degree_sub>50) && PoseInformation.pose_arraylist.get(0) == "1") {
                Log.d("동작인식 각도 순서", "2단계");
                Log.d("동작인식 각도 결과값", "펀치스텝 중");
                PoseInformation.pose_arraylist.add("2");
            }else if (punch_status < 20 && (degree>50 || degree_sub>50) && PoseInformation.pose_arraylist.size() == 2
                    && PoseInformation.pose_arraylist.get(0) == "1" && PoseInformation.pose_arraylist.get(1) == "2") {
                Log.d("동작인식 각도 순서", "3단계");
                Log.d("동작인식 각도 결과값", "펀치스텝 중");
                PoseInformation.pose_arraylist.clear();
                PoseInformation.pose_count = PoseInformation.pose_count + 1;
            }

        }
    }

    public void zigzagjump_data(int pose_count, boolean pose_status, double a1, double a2, double b1, double b2, double c1, double c2, double d1, double d2, double e1, double e2, double f1, double f2) {
        Log.d("지그재그점핑변수", String.valueOf(pose_status));
        Log.d("지그재그점핑개수", String.valueOf(pose_count));

        Log.d("왼발좌표", String.valueOf(a1)+"/"+String.valueOf(a2));
        Log.d("오른발좌표",String.valueOf(b1)+"/"+String.valueOf(b2));


        //귀간의 거리
        //10보다 클경우 정면
        //10보다 작을 경우 측면
        double turn_status = Math.abs(c1-d1);
        Log.d("왼쪽귀좌표", String.valueOf(c1)+"/"+String.valueOf(c2));
        Log.d("오른쪽귀좌표",String.valueOf(d1)+"/"+String.valueOf(d2));
        //모을때 - 30 차이
        //벌릴때 - 80 차이
        Log.d("왼무릎좌표", String.valueOf(e1)+"/"+String.valueOf(e2));
        Log.d("오른무릎좌표",String.valueOf(f1)+"/"+String.valueOf(f2));
        double cross_status = Math.abs(e1-f1);


        if((a1>360 && b1 <360) || (a1<360 && b1>360)){
            //두 발이 수직선을 기준으로 좌우로 있을 경우 카운트
            Log.d("지그재그점핑","두발 모으기 전");
            Log.d("지그재그점핑","측정 시작");
            Log.d("지그재그점핑",String.valueOf(a1)+"/"+String.valueOf(b1));


            if(cross_status>50 && turn_status>10 && pose_status == false){
                Log.d("동작인식 각도 순서", "1단계");
                Log.d("동작인식 각도 결과값", "준비 중, 인식 X");
            }else if(cross_status<50 && turn_status>10 && pose_status == false){
                Log.d("동작인식 각도 순서", "2단계");
                Log.d("동작인식 각도 결과값", "지그재그 점핑 중, 인식 X");
                PoseInformation.pose_status = true;
            }else if(cross_status<50 && turn_status>10 && pose_status == true){
                Log.d("동작인식 각도 순서", "3단계");
                Log.d("동작인식 각도 결과값", "지그재그 점핑 중, 인식 O");
                PoseInformation.pose_status = true;
            }else if(cross_status>50 && turn_status>10 &&pose_status == true){
                Log.d("동작인식 각도 순서", "4단계");
                Log.d("동작인식 각도 결과값", "준비 중, 인식 O");
                PoseInformation.pose_status = false;
                PoseInformation.pose_count = PoseInformation.pose_count + 1;
            }

        }else{
            Log.d("지그재그점핑","올바르지 않은 자세");
            Log.d("지그재그점핑","측정 불가");



        }


    }

    public void steprunning_data(int pose_count, boolean pose_status,  double a1, double a2, double b1, double b2, double c1, double c2, double d1, double d2, double e1, double e2, double f1, double f2) {
        Log.d("스텝러닝변수", String.valueOf(pose_status));
        Log.d("스텝러닝개수", String.valueOf(pose_count));

        Log.d("왼발좌표", String.valueOf(a1)+"/"+String.valueOf(a2));
        Log.d("오른발좌표",String.valueOf(b1)+"/"+String.valueOf(b2));


        //귀간의 거리
        //10보다 클경우 정면
        //10보다 작을 경우 측면
        double turn_status = Math.abs(c1-d1);
        Log.d("왼쪽귀좌표", String.valueOf(c1)+"/"+String.valueOf(c2));
        Log.d("오른쪽귀좌표",String.valueOf(d1)+"/"+String.valueOf(d2));
        //모을때 - 30 차이
        //벌릴때 - 80 차이
        Log.d("왼무릎좌표", String.valueOf(e1)+"/"+String.valueOf(e2));
        Log.d("오른무릎좌표",String.valueOf(f1)+"/"+String.valueOf(f2));
        double cross_status = Math.abs(e1-f1);


        if((a1>360 && b1 <360) || (a1<360 && b1>360)){
            //두 발이 수직선을 기준으로 좌우로 있을 경우 카운트
            Log.d("스텝러닝","두발 모으기 전");
            Log.d("스텝러닝","측정 시작");
            Log.d("스텝러닝",String.valueOf(a1)+"/"+String.valueOf(b1));


            if(cross_status>50 && turn_status<10 && pose_status == false){
                Log.d("동작인식 각도 순서", "1단계");
                Log.d("동작인식 각도 결과값", "준비 중, 인식 X");
            }else if(cross_status<50 && turn_status<10 && pose_status == false){
                Log.d("동작인식 각도 순서", "2단계");
                Log.d("동작인식 각도 결과값", "지그재그 점핑 중, 인식 X");
                PoseInformation.pose_status = true;
            }else if(cross_status<50 && turn_status<10 && pose_status == true){
                Log.d("동작인식 각도 순서", "3단계");
                Log.d("동작인식 각도 결과값", "지그재그 점핑 중, 인식 O");
                PoseInformation.pose_status = true;
            }else if(cross_status>50 && turn_status<10 &&pose_status == true){
                Log.d("동작인식 각도 순서", "4단계");
                Log.d("동작인식 각도 결과값", "준비 중, 인식 O");
                PoseInformation.pose_status = false;
                PoseInformation.pose_count = PoseInformation.pose_count + 1;
            }

        }else{
            Log.d("스텝러닝","올바르지 않은 자세");
            Log.d("스텝러닝","측정 불가");


        }


    }

    public void stepturnning_data(int pose_count, boolean pose_status, double a1, double a2, double b1, double b2, double c1, double c2, double d1, double d2) {
        Log.d("스텝돌기변수", String.valueOf(pose_status));
        Log.d("스텝돌기개수", String.valueOf(pose_count));

        Log.d("왼발좌표", String.valueOf(a1) + "/" + String.valueOf(a2));
        Log.d("오른발좌표", String.valueOf(b1) + "/" + String.valueOf(b2));


        //귀간의 거리
        //10보다 클경우 정면
        //10보다 작을 경우 측면
        double turn_status = Math.abs(c1 - d1);
        Log.d("왼쪽귀좌표", String.valueOf(c1) + "/" + String.valueOf(c2));
        Log.d("오른쪽귀좌표", String.valueOf(d1) + "/" + String.valueOf(d2));

        if (PoseInformation.pose_arraylist.size() > 0 && PoseInformation.pose_arraylist.get(0) != "1") {
            //첫번째 배열의 시작이 1사분면이 아닐 경우 -> BallInformation.ball_arraylist 초기화
            Log.d("동작인식", "동작 배열 : 오류 -> 배열 초기화");
            PoseInformation.pose_arraylist.clear();

        } else {
            if (((a1 > 360 && b1 < 360) || (a1 < 360 && b1 > 360)) && turn_status > 10 && PoseInformation.pose_arraylist.size() == 0) {
                Log.d("동작인식 각도 순서", "1단계");
                Log.d("동작인식 각도 결과값", "준비 중");
                PoseInformation.pose_arraylist.add("1");
            } else if (turn_status < 10 && PoseInformation.pose_arraylist.size() == 1 && PoseInformation.pose_arraylist.get(0) == "1") {
                Log.d("동작인식 각도 순서", "2단계");
                Log.d("동작인식 각도 결과값", "회전 중(1)");
                PoseInformation.pose_arraylist.add("2");
            } else if (((a1 > 360 && b1 < 360) || (a1 < 360 && b1 > 360)) && turn_status > 10 && PoseInformation.pose_arraylist.size() == 2 && PoseInformation.pose_arraylist.get(0) == "1"
                    && PoseInformation.pose_arraylist.get(1) == "2") {
                Log.d("동작인식 각도 순서", "3단계");
                Log.d("동작인식 각도 결과값", "뒤돌기 중");
                PoseInformation.pose_arraylist.add("3");
            } else if (turn_status < 10 && PoseInformation.pose_arraylist.size() == 3 && PoseInformation.pose_arraylist.get(0) == "1"
                    && PoseInformation.pose_arraylist.get(1) == "2" && PoseInformation.pose_arraylist.get(2) == "3") {
                Log.d("동작인식 각도 순서", "4단계");
                Log.d("동작인식 각도 결과값", "회전 중(2)");
                PoseInformation.pose_arraylist.add("4");
            } else if (((a1 > 360 && b1 < 360) || (a1 < 360 && b1 > 360)) && turn_status > 10 && PoseInformation.pose_arraylist.size() == 4 && PoseInformation.pose_arraylist.get(0) == "1"
                    && PoseInformation.pose_arraylist.get(1) == "2" && PoseInformation.pose_arraylist.get(2) == "3" && PoseInformation.pose_arraylist.get(3) == "4") {
                Log.d("동작인식 각도 순서", "5단계");
                Log.d("동작인식 각도 결과값", "준비 중");
                PoseInformation.pose_arraylist.clear();
                PoseInformation.pose_count = PoseInformation.pose_count + 1;
            }
        }
    }


    public void onelegstep_data(int pose_count, boolean pose_status, double a1, double a2, double b1, double b2, double c1, double c2, double d1, double d2) {
        Log.d("한발스텝변수", String.valueOf(pose_status));
        Log.d("한발스텝개수", String.valueOf(pose_count));

        Log.d("왼발좌표", String.valueOf(a1) + "/" + String.valueOf(a2));
        Log.d("오른발좌표", String.valueOf(b1) + "/" + String.valueOf(b2));


        //귀간의 거리
        //10보다 클경우 정면
        //10보다 작을 경우 측면
        double turn_status = Math.abs(c1 - d1);
        Log.d("왼쪽귀좌표", String.valueOf(c1) + "/" + String.valueOf(c2));
        Log.d("오른쪽귀좌표", String.valueOf(d1) + "/" + String.valueOf(d2));


        if (PoseInformation.pose_arraylist.size() > 0 && PoseInformation.pose_arraylist.get(0) != "1") {
            //첫번째 배열의 시작이 1사분면이 아닐 경우 -> BallInformation.ball_arraylist 초기화
            Log.d("동작인식", "동작 배열 : 오류 -> 배열 초기화");
            PoseInformation.pose_arraylist.clear();

        } else {
            if (((a1 > 360 && b1 < 360) || (a1 < 360 && b1 > 360)) && turn_status > 10 && PoseInformation.pose_arraylist.size() == 0) {
                Log.d("동작인식 각도 순서", "1단계");
                Log.d("동작인식 각도 결과값", "준비 중");
                PoseInformation.pose_arraylist.add("1");
            } else if (((a1 > 360 && b1 > 360) || (a1 < 360 && b1 < 360)) && turn_status > 10 && PoseInformation.pose_arraylist.size() == 1 && PoseInformation.pose_arraylist.get(0) == "1") {
                Log.d("동작인식 각도 순서", "2단계");
                Log.d("동작인식 각도 결과값", "이동 중(1)");
                PoseInformation.pose_arraylist.add("2");
            } else if (((a1 > 360 && b1 < 360) || (a1 < 360 && b1 > 360)) && turn_status > 10 && PoseInformation.pose_arraylist.size() == 2 && PoseInformation.pose_arraylist.get(0) == "1"
                    && PoseInformation.pose_arraylist.get(1) == "2") {
                Log.d("동작인식 각도 순서", "3단계");
                Log.d("동작인식 각도 결과값", "원위치 중");
                PoseInformation.pose_arraylist.add("3");
            } else if (((a1 > 360 && b1 > 360) || (a1 < 360 && b1 < 360)) && turn_status > 10 && PoseInformation.pose_arraylist.size() == 3 && PoseInformation.pose_arraylist.get(0) == "1"
                    && PoseInformation.pose_arraylist.get(1) == "2" && PoseInformation.pose_arraylist.get(2) == "3") {
                Log.d("동작인식 각도 순서", "4단계");
                Log.d("동작인식 각도 결과값", "이동 중(2)");
                PoseInformation.pose_arraylist.add("4");
            } else if (((a1 > 360 && b1 < 360) || (a1 < 360 && b1 > 360)) && turn_status > 10 && PoseInformation.pose_arraylist.size() == 4 && PoseInformation.pose_arraylist.get(0) == "1"
                    && PoseInformation.pose_arraylist.get(1) == "2" && PoseInformation.pose_arraylist.get(2) == "3" && PoseInformation.pose_arraylist.get(3) == "4") {
                Log.d("동작인식 각도 순서", "5단계");
                Log.d("동작인식 각도 결과값", "준비 중");
                PoseInformation.pose_arraylist.clear();
                PoseInformation.pose_count = PoseInformation.pose_count + 1;
            }
        }
    }


    public void floorstep_data(int pose_count, boolean pose_status, double a1, double a2, double b1, double b2, double c1, double c2, double d1, double d2) {
        Log.d("바닥찍기변수", String.valueOf(pose_status));
        Log.d("바닥찍기개수", String.valueOf(pose_count));

        Log.d("왼발좌표", String.valueOf(a1) + "/" + String.valueOf(a2));
        Log.d("오른발좌표", String.valueOf(b1) + "/" + String.valueOf(b2));

        //손과 발의 거리
        //40보다 클경우 점핑 중
        //40보다 작을 경우 바닥 찍기 중
        double floor_status = Math.abs(a2 - c2);
        Log.d("왼쪽발목좌표", String.valueOf(a1) + "/" + String.valueOf(a2));
        Log.d("왼쪽손목좌표", String.valueOf(c1) + "/" + String.valueOf(c2));


        if (PoseInformation.pose_arraylist.size() > 0 && PoseInformation.pose_arraylist.get(0) != "1") {
            //첫번째 배열의 시작이 1사분면이 아닐 경우 -> BallInformation.ball_arraylist 초기화
            Log.d("동작인식", "동작 배열 : 오류 -> 배열 초기화");
            PoseInformation.pose_arraylist.clear();

        } else {
            if (((a1 > 360 && b1 > 360) || (a1 < 360 && b1 < 360)) && floor_status > 40 &&PoseInformation.pose_arraylist.size() == 0) {
                Log.d("동작인식 각도 순서", "1단계");
                Log.d("동작인식 각도 결과값", "준비 중");
                PoseInformation.pose_arraylist.add("1");
            }else if(((a1 > 360 && b1 > 360) || (a1 < 360 && b1 < 360)) && floor_status > 40 &&PoseInformation.pose_arraylist.size() == 1 && PoseInformation.pose_arraylist.get(0) == "1"){
                Log.d("동작인식 각도 순서", "2단계");
                Log.d("동작인식 각도 결과값", "이동 중(1)");
                PoseInformation.pose_arraylist.add("2");
            }else if(((a1 > 360 && b1 > 360) || (a1 < 360 && b1 < 360)) && floor_status > 40 &&PoseInformation.pose_arraylist.size() == 2 && PoseInformation.pose_arraylist.get(0) == "1"
                    && PoseInformation.pose_arraylist.get(1) == "2"){
                Log.d("동작인식 각도 순서", "3단계");
                Log.d("동작인식 각도 결과값", "이동 중(2)");
                PoseInformation.pose_arraylist.add("3");
            }else if(((a1 > 360 && b1 > 360) || (a1 < 360 && b1 < 360)) && floor_status < 40 &&PoseInformation.pose_arraylist.size() == 3 && PoseInformation.pose_arraylist.get(0) == "1"
                    && PoseInformation.pose_arraylist.get(1) == "2" && PoseInformation.pose_arraylist.get(2) == "3"){
                Log.d("동작인식 각도 순서", "4단계");
                Log.d("동작인식 각도 결과값", "바닥찍기");
                PoseInformation.pose_arraylist.clear();
                PoseInformation.pose_count = PoseInformation.pose_count + 1;
            }

        }
    }

    public void basicshoulder_data(int pose_count, boolean pose_status, double a1, double a2, double b1, double b2, double c1, double c2, double d1, double d2, double e1, double e2, double f1, double f2, double g1, double g2, double h1, double h2, double i1, double i2, double j1, double j2) {
        Log.d("제자리어깨짚기변수", String.valueOf(pose_status));
        Log.d("제자리어깨짚기개수", String.valueOf(pose_count));


        double line_ab = Math.sqrt(Math.pow(a1 - b1, 2) + Math.pow(a2 - b2, 2));
        double line_bc = Math.sqrt(Math.pow(b1 - c1, 2) + Math.pow(b2 - c2, 2));
        double line_ca = Math.sqrt(Math.pow(c1 - a1, 2) + Math.pow(c2 - a2, 2));
        double result_up = (line_ab * line_ab + line_bc * line_bc - line_ca * line_ca);
        double result_down = 2 * line_ab * line_bc;
        double result = result_up / result_down;

        double cosX = Math.acos(result);
        double degree = Math.toDegrees(cosX);

        // 10 ~100
        Log.d("제자리어깨짚기 각도모음1", String.valueOf(degree));

        double line_de = Math.sqrt(Math.pow(d1 - e1, 2) + Math.pow(d2 - e2, 2));
        double line_ef = Math.sqrt(Math.pow(e1 - f1, 2) + Math.pow(e2 - f2, 2));
        double line_fd = Math.sqrt(Math.pow(f1 - d1, 2) + Math.pow(f2 - d2, 2));
        double result_up_sub = (line_de * line_de + line_ef * line_ef - line_fd * line_fd);
        double result_down_sub = 2 * line_de * line_ef;
        double result_sub = result_up_sub / result_down_sub;

        double cosX_sub = Math.acos(result_sub);
        double degree_sub = Math.toDegrees(cosX_sub);

        // 10 ~100
        Log.d("제자리어깨짚기 각도모음2", String.valueOf(degree_sub));


        //어깨 짚기 여부
        double shoulder_status1 = Math.abs(a1 - b1);
        double shoulder_status2 = Math.abs(a2 - b2);
        double shoulder_status3 = Math.abs(d1 - e1);
        double shoulder_status4 = Math.abs(d2 - e2);

        //귀간의 거리
        //10보다 클경우 정면
        //10보다 작을 경우 측면
        double turn_status = Math.abs(i1 - j1);
        Log.d("왼쪽귀좌표", String.valueOf(i1) + "/" + String.valueOf(i2));
        Log.d("오른쪽귀좌표", String.valueOf(j1) + "/" + String.valueOf(j2));

        if (PoseInformation.pose_arraylist.size() > 0 && PoseInformation.pose_arraylist.get(0) != "1") {
            Log.d("동작인식", "동작 배열 : 오류 -> 배열 초기화");
            PoseInformation.pose_arraylist.clear();

        } else {
            if (((g1 > 360 && h1 < 360) || (g1 < 360 && h1 > 360)) && (degree > 150 && degree_sub >150) && turn_status>10 && PoseInformation.pose_arraylist.size() == 0) {
                Log.d("동작인식 각도 순서", "1단계");
                Log.d("동작인식 각도 결과값", "팔 위로");
                PoseInformation.pose_arraylist.add("1");
            }else if ( ((g1 > 360 && h1 < 360) || (g1 < 360 && h1 > 360)) && ((shoulder_status1<20 && shoulder_status2<20) || (shoulder_status3<20&& shoulder_status4<20))  && turn_status>10 && PoseInformation.pose_arraylist.size() == 1
                    && PoseInformation.pose_arraylist.get(0) == "1") {
                Log.d("동작인식 각도 순서", "2단계");
                Log.d("동작인식 각도 결과값", "어깨 짚기 중");
                PoseInformation.pose_arraylist.add("2");
            }else if ( ((g1 > 360 && h1 < 360) || (g1 < 360 && h1 > 360)) && (70<degree && degree < 130 && 70<degree_sub && degree_sub <130 )  && turn_status>10 && PoseInformation.pose_arraylist.size() == 2
                    && PoseInformation.pose_arraylist.get(0) == "1" && PoseInformation.pose_arraylist.get(1) == "2") {
                Log.d("동작인식 각도 순서", "3단계");
                Log.d("동작인식 각도 결과값", "팔 벌리기 중");
                PoseInformation.pose_arraylist.add("3");
            }else if ( ((g1 > 360 && h1 < 360) || (g1 < 360 && h1 > 360)) && ((shoulder_status1<20 && shoulder_status2<20) || (shoulder_status3<20&& shoulder_status4<20))  &&  turn_status>10 && PoseInformation.pose_arraylist.size() == 3
                    && PoseInformation.pose_arraylist.get(0) == "1" && PoseInformation.pose_arraylist.get(1) == "2" && PoseInformation.pose_arraylist.get(2) == "3") {
                Log.d("동작인식 각도 순서", "4단계");
                Log.d("동작인식 각도 결과값", "어깨 짚기 중");
                PoseInformation.pose_arraylist.clear();
                PoseInformation.pose_count = PoseInformation.pose_count + 1;
            }

        }
    }

    public void twolegsideshoulder_data(int pose_count, boolean pose_status, double a1, double a2, double b1, double b2, double c1, double c2, double d1, double d2, double e1, double e2, double f1, double f2, double g1, double g2, double h1, double h2, double i1, double i2, double j1, double j2) {
        Log.d("두발사이드어깨짚기변수", String.valueOf(pose_status));
        Log.d("두발사이드어깨짚기개수", String.valueOf(pose_count));


        double line_ab = Math.sqrt(Math.pow(a1 - b1, 2) + Math.pow(a2 - b2, 2));
        double line_bc = Math.sqrt(Math.pow(b1 - c1, 2) + Math.pow(b2 - c2, 2));
        double line_ca = Math.sqrt(Math.pow(c1 - a1, 2) + Math.pow(c2 - a2, 2));
        double result_up = (line_ab * line_ab + line_bc * line_bc - line_ca * line_ca);
        double result_down = 2 * line_ab * line_bc;
        double result = result_up / result_down;

        double cosX = Math.acos(result);
        double degree = Math.toDegrees(cosX);

        // 10 ~100
        Log.d("두발사이드어깨짚기 각도모음1", String.valueOf(degree));

        double line_de = Math.sqrt(Math.pow(d1 - e1, 2) + Math.pow(d2 - e2, 2));
        double line_ef = Math.sqrt(Math.pow(e1 - f1, 2) + Math.pow(e2 - f2, 2));
        double line_fd = Math.sqrt(Math.pow(f1 - d1, 2) + Math.pow(f2 - d2, 2));
        double result_up_sub = (line_de * line_de + line_ef * line_ef - line_fd * line_fd);
        double result_down_sub = 2 * line_de * line_ef;
        double result_sub = result_up_sub / result_down_sub;

        double cosX_sub = Math.acos(result_sub);
        double degree_sub = Math.toDegrees(cosX_sub);

        // 10 ~100
        Log.d("두발사이드어깨짚기 각도모음2", String.valueOf(degree_sub));


        //어깨 짚기 여부
        double shoulder_status1 = Math.abs(a1 - b1);
        double shoulder_status2 = Math.abs(a2 - b2);
        double shoulder_status3 = Math.abs(d1 - e1);
        double shoulder_status4 = Math.abs(d2 - e2);

        //귀간의 거리
        //10보다 클경우 정면
        //10보다 작을 경우 측면
        double turn_status = Math.abs(i1 - j1);
        Log.d("왼쪽귀좌표", String.valueOf(i1) + "/" + String.valueOf(i2));
        Log.d("오른쪽귀좌표", String.valueOf(j1) + "/" + String.valueOf(j2));


        if (PoseInformation.pose_arraylist.size() > 0 && PoseInformation.pose_arraylist.get(0) != "1") {
            Log.d("동작인식", "동작 배열 : 오류 -> 배열 초기화");
            PoseInformation.pose_arraylist.clear();

        } else {
            if ( ((g1 > 360 && h1 > 360) || (g1 < 360 && h1 < 360)) && (degree > 150 && degree_sub >150) && turn_status>10 && PoseInformation.pose_arraylist.size() == 0) {
                Log.d("동작인식 각도 순서", "1단계");
                Log.d("동작인식 각도 결과값", "팔 위로");
                PoseInformation.pose_arraylist.add("1");
            }else if (((shoulder_status1<20 && shoulder_status2<20) || (shoulder_status3<20&& shoulder_status4<20))  && turn_status>10 && PoseInformation.pose_arraylist.size() == 1
                    && PoseInformation.pose_arraylist.get(0) == "1") {
                Log.d("동작인식 각도 순서", "2단계");
                Log.d("동작인식 각도 결과값", "어깨 짚기 중");
                PoseInformation.pose_arraylist.add("2");
            }else if ( ((g1 > 360 && h1 > 360) || (g1 < 360 && h1 < 360)) && (70<degree && degree < 130 && 70<degree_sub && degree_sub <130 )  && turn_status>10 && PoseInformation.pose_arraylist.size() == 2
                    && PoseInformation.pose_arraylist.get(0) == "1" && PoseInformation.pose_arraylist.get(1) == "2") {
                Log.d("동작인식 각도 순서", "3단계");
                Log.d("동작인식 각도 결과값", "팔 벌리기 중");
                PoseInformation.pose_arraylist.add("3");
            }else if (((shoulder_status1<20 && shoulder_status2<20) || (shoulder_status3<20&& shoulder_status4<20))  && turn_status>10 && PoseInformation.pose_arraylist.size() == 3
                    && PoseInformation.pose_arraylist.get(0) == "1" && PoseInformation.pose_arraylist.get(1) == "2" && PoseInformation.pose_arraylist.get(2) == "3") {
                Log.d("동작인식 각도 순서", "4단계");
                Log.d("동작인식 각도 결과값", "어깨 짚기 중");
                PoseInformation.pose_arraylist.clear();
                PoseInformation.pose_count = PoseInformation.pose_count + 1;
            }
        }
    }

    public void twolegfrontshoulder_data(int pose_count, boolean pose_status, double a1, double a2, double b1, double b2, double c1, double c2, double d1, double d2, double e1, double e2, double f1, double f2, double g1, double g2, double h1, double h2, double i1, double i2, double j1, double j2) {
        Log.d("두발앞뒤어깨짚기변수", String.valueOf(pose_status));
        Log.d("두발앞뒤어깨짚기개수", String.valueOf(pose_count));


        double line_ab = Math.sqrt(Math.pow(a1 - b1, 2) + Math.pow(a2 - b2, 2));
        double line_bc = Math.sqrt(Math.pow(b1 - c1, 2) + Math.pow(b2 - c2, 2));
        double line_ca = Math.sqrt(Math.pow(c1 - a1, 2) + Math.pow(c2 - a2, 2));
        double result_up = (line_ab * line_ab + line_bc * line_bc - line_ca * line_ca);
        double result_down = 2 * line_ab * line_bc;
        double result = result_up / result_down;

        double cosX = Math.acos(result);
        double degree = Math.toDegrees(cosX);

        // 10 ~100
        Log.d("두발앞뒤어깨짚기 각도모음1", String.valueOf(degree));

        double line_de = Math.sqrt(Math.pow(d1 - e1, 2) + Math.pow(d2 - e2, 2));
        double line_ef = Math.sqrt(Math.pow(e1 - f1, 2) + Math.pow(e2 - f2, 2));
        double line_fd = Math.sqrt(Math.pow(f1 - d1, 2) + Math.pow(f2 - d2, 2));
        double result_up_sub = (line_de * line_de + line_ef * line_ef - line_fd * line_fd);
        double result_down_sub = 2 * line_de * line_ef;
        double result_sub = result_up_sub / result_down_sub;

        double cosX_sub = Math.acos(result_sub);
        double degree_sub = Math.toDegrees(cosX_sub);

        // 10 ~100
        Log.d("두발앞뒤어깨짚기 각도모음2", String.valueOf(degree_sub));


        //어깨 짚기 여부
        double shoulder_status1 = Math.abs(a1 - b1);
        double shoulder_status2 = Math.abs(a2 - b2);
        double shoulder_status3 = Math.abs(d1 - e1);
        double shoulder_status4 = Math.abs(d2 - e2);

        //귀간의 거리
        //10보다 클경우 정면
        //10보다 작을 경우 측면
        double turn_status = Math.abs(i1 - j1);
        Log.d("왼쪽귀좌표", String.valueOf(i1) + "/" + String.valueOf(i2));
        Log.d("오른쪽귀좌표", String.valueOf(j1) + "/" + String.valueOf(j2));


        if (PoseInformation.pose_arraylist.size() > 0 && PoseInformation.pose_arraylist.get(0) != "1") {
            Log.d("동작인식", "동작 배열 : 오류 -> 배열 초기화");
            PoseInformation.pose_arraylist.clear();

        } else {
            if ( ((g1 > 360 && h1 > 360) || (g1 < 360 && h1 < 360)) && (degree > 150 && degree_sub >150) && turn_status<10 && PoseInformation.pose_arraylist.size() == 0) {
                Log.d("동작인식 각도 순서", "1단계");
                Log.d("동작인식 각도 결과값", "팔 위로");
                PoseInformation.pose_arraylist.add("1");
            }else if (((shoulder_status1<20 && shoulder_status2<20) || (shoulder_status3<20&& shoulder_status4<20))  && turn_status<10 && PoseInformation.pose_arraylist.size() == 1
                    && PoseInformation.pose_arraylist.get(0) == "1") {
                Log.d("동작인식 각도 순서", "2단계");
                Log.d("동작인식 각도 결과값", "어깨 짚기 중");
                PoseInformation.pose_arraylist.add("2");
            }else if ( ((g1 > 360 && h1 > 360) || (g1 < 360 && h1 < 360)) && (70<degree && degree < 130 && 70<degree_sub && degree_sub <130 )  && turn_status<10 && PoseInformation.pose_arraylist.size() == 2
                    && PoseInformation.pose_arraylist.get(0) == "1" && PoseInformation.pose_arraylist.get(1) == "2") {
                Log.d("동작인식 각도 순서", "3단계");
                Log.d("동작인식 각도 결과값", "팔 벌리기 중");
                PoseInformation.pose_arraylist.add("3");
            }else if (((shoulder_status1<20 && shoulder_status2<20) || (shoulder_status3<20&& shoulder_status4<20))  && turn_status<10 && PoseInformation.pose_arraylist.size() == 3
                    && PoseInformation.pose_arraylist.get(0) == "1" && PoseInformation.pose_arraylist.get(1) == "2" && PoseInformation.pose_arraylist.get(2) == "3") {
                Log.d("동작인식 각도 순서", "4단계");
                Log.d("동작인식 각도 결과값", "어깨 짚기 중");
                PoseInformation.pose_arraylist.clear();
                PoseInformation.pose_count = PoseInformation.pose_count + 1;
            }

        }
    }

    public void literunning_data(int pose_count, boolean pose_status, double a1, double a2, double b1, double b2) {
        Log.d("가볍게뛰기변수", String.valueOf(pose_status));
        Log.d("가볍게뛰기개수", String.valueOf(pose_count));


        //뛰는 상태 체크 (10~ 70)
        //30보다 작을경우 양발 바닥에
        //30보다 클 경우 뛰는 중
        double running_status = Math.abs(a2 -  b2);
        Log.d("왼쪽발좌표", String.valueOf(a1) + "/" + String.valueOf(a2));
        Log.d("오른쪽발좌표", String.valueOf(b1) + "/" + String.valueOf(b2));


        if (running_status <30 && PoseInformation.pose_arraylist.size() == 0) {
            Log.d("동작인식 각도 순서", "1단계");
            Log.d("동작인식 각도 결과값", "서있는자세-1");
            PoseInformation.pose_arraylist.add("1");
        }else if (running_status>30 && PoseInformation.pose_arraylist.size() == 1
                && PoseInformation.pose_arraylist.get(0) == "1") {
            Log.d("동작인식 각도 순서", "2단계");
            Log.d("동작인식 각도 결과값", "뛰는 중-1");
            PoseInformation.pose_arraylist.add("2");
        }else if (running_status<30 && PoseInformation.pose_arraylist.size() == 2
                && PoseInformation.pose_arraylist.get(0) == "1" && PoseInformation.pose_arraylist.get(1) == "2") {
            Log.d("동작인식 각도 순서", "3단계");
            Log.d("동작인식 각도 결과값", "서 있는 자세-2");
            PoseInformation.pose_arraylist.add("3");
        }else if (running_status>30 && PoseInformation.pose_arraylist.size() == 3
                && PoseInformation.pose_arraylist.get(0) == "1" && PoseInformation.pose_arraylist.get(1) == "2"
                && PoseInformation.pose_arraylist.get(2) == "3" ) {
            Log.d("동작인식 각도 순서", "4단계");
            Log.d("동작인식 각도 결과값", "뛰는 중-2");
            PoseInformation.pose_arraylist.clear();
            PoseInformation.pose_count = PoseInformation.pose_count + 1;
        }


    }



}