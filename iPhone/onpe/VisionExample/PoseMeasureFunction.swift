//
//  poseMeasureFuntion.swift
//  VisionExample
//
//  Created by Ik ju Song on 2021/02/10.
//  Copyright © 2021 Google Inc. All rights reserved.
//

import Foundation
import UIKit

public class PoseMeasureFunction {
    
    
    
    public func squat_data(pose_count : Int, pose_status : Bool,
                           a1 : Double, a2 : Double, b1 : Double,  b2 : Double,  c1 : Double,  c2 : Double,
                           d1 : Double,  d2 : Double,  e1 : Double,  e2 : Double,  f1 : Double,  f2 : Double,
                           g1 : Double,  g2 : Double,  h1 : Double,  h2 : Double,  i1 : Double,  i2 : Double,
                           j1 : Double,  j2 : Double,  k1 : Double,  k2 : Double,  l1 : Double,  l2 : Double,
                           m1 : Double,  m2 : Double,  n1 : Double,  n2 : Double,  o1 : Double,  o2 : Double) {
        
        print("스쿼드변수", (pose_status));
        print("스쿼드개수", (pose_count));
        
        
        // 개수 측정 -  (엉덩이 - 무릎 - 발목) - 각도가 110 이하일 경우 카운트
        let line_ab : Double = sqrt(pow(a1 - b1, 2) + pow(a2 - b2, 2));
        let line_bc : Double = sqrt(pow(b1 - c1, 2) + pow(b2 - c2, 2));
        let line_ca : Double = sqrt(pow(c1 - a1, 2) + pow(c2 - a2, 2));
        let result_up : Double = (line_ab * line_ab + line_bc * line_bc - line_ca * line_ca);
        let result_down : Double = 2 * line_ab * line_bc;
        let result : Double = result_up / result_down;
        let cosX : Double = acos(result);
        let degree : Double = (cosX * 180.0 / .pi)
        // 60도 ~ 170도
        print("스쿼트 다리 각도모음", (degree));
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 예외처리 1 - (머리 > 엉덩이 > 발목) - 누워서 스쿼트할 경우 대비
        // 기립 여부
        var stand_up : Bool = false;
        if(d2+10<e2 && e2+10<f2){
            stand_up = true;
        }else{
            stand_up = false;
        }
        /*
         print("스쿼트 머리 좌표", (d1) + "/" + (d2));
         print("스쿼트 엉덩이 좌표", (e1) + "/" + (e2));
         print("스쿼트 발목 좌표", (f1) + "/" + (f2));
         */
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 예외처리 2 - (손목 - 어깨 - 발목) - 스쿼트 시 손모아서
        let line_gh : Double = sqrt(pow(g1 - h1, 2) + pow(g2 - h2, 2));
        let line_hi : Double = sqrt(pow(h1 - i1, 2) + pow(h2 - i2, 2));
        let line_ig : Double = sqrt(pow(i1 - g1, 2) + pow(i2 - g2, 2));
        let result_up_hand : Double = (line_gh * line_gh + line_hi * line_hi - line_ig * line_ig);
        let result_down_hand : Double = 2 * line_gh * line_hi;
        let result_hand : Double = result_up_hand / result_down_hand;
        let cosX_hand : Double = acos(result_hand);
        let degree_hand : Double = (cosX_hand * 180.0 / .pi)
        // 80도 ~ 110도
        print("스쿼트 손 각도모음", (degree_hand));
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 예외처리 3 - (좌우 어깨, 무릎, 발목 좌표 동일)
        //좌우 어깨/무릎/발목 간의 거리
        //30보다 작을 경우 겹쳐있다고 판단
        //30보다 클경우 겹쳐있지 않다고 판단
        let squat_shoulder_status_x : Double = abs(j1 - k1);
        let squat_shoulder_status_y : Double = abs(j2 - k2);
        let squat_knee_status_x : Double = abs(l1 - m1);
        let squat_knee_status_y : Double = abs(l2 - m2);
        let squat_ankle_status_x : Double = abs(n1 - o1);
        let squat_ankle_status_y : Double = abs(n2 - o2);
        var squat_both : Bool = false;
        if(squat_shoulder_status_x<30 && squat_shoulder_status_y<30 && squat_knee_status_x<30 && squat_knee_status_y<30 && squat_ankle_status_x<30 && squat_ankle_status_y<30){
            squat_both = true;
        }else{
            squat_both = false;
        }
        
        /*
         print("스쿼트 왼쪽어깨 좌표", (j1) + "/" + (j2));
         print("스쿼트 오른쪽어깨 좌표", (k1) + "/" + (k2));
         print("스쿼트 왼쪽무릎 좌표", (l1)  + "/" + (l2));
         print("스쿼트 오른쪽무릎 좌표", (m1) + "/" + (m2));
         print("스쿼트 왼쪽발목 좌표", (n1) + "/" + (n2));
         print("스쿼트 오른쪽발목 좌표", (o1) + "/" + (o2));
         */
        
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        if(stand_up){
            // 예외처리 1 - (머리 > 엉덩이 > 발목) - 누워서 스쿼트할 경우 대비
            print("스쿼트 예외처리1", "측정가능 - 서 있는 중 O");
            
            
            if(squat_both){
                print("스쿼트 예외처리3", "측정가능 - 스쿼트 자세 O");
                
                if (degree >= 160 && pose_status == false) {
                    // 1단계
                    // 준비 중, 인식 X
                    print("동작인식 각도 순서", "1단계");
                    print("동작인식 각도 결과값", "준비 중, 인식 X");
                    PoseInformation.pose_status = false;
                    PoseInformation.pose_degree = 160.0;
                } else if (degree < 120 && 60 < degree && pose_status == false) {
                    // 2단계
                    //스쿼트 중, 인식 X
                    print("동작인식 각도 순서", "2단계");
                    print("동작인식 각도 결과값", "스쿼트 중, 인식 X");
                    PoseInformation.pose_status = true;
                    if (degree < PoseInformation.pose_degree) {
                        PoseInformation.pose_degree = degree;
                    }
                } else if (degree < 120 && 60 < degree && pose_status == true) {
                    // 3단계
                    //스쿼트 중, 인식 O
                    print("동작인식 각도 순서", "3단계");
                    print("동작인식 각도 결과값", "스쿼트 중, 인식 O");
                    PoseInformation.pose_status = true;
                    if (degree < PoseInformation.pose_degree) {
                        PoseInformation.pose_degree = degree;
                    }
                } else if (degree >= 160 && pose_status == true) {
                    // 4단계
                    // 준비 중, 인식 O
                    print("동작인식 각도 순서", "4단계");
                    print("동작인식 각도 결과값", "준비 중, 인식 O");
                    print("동작인식 각도 결과값", "==============");
                    print("동작인식 각도 결과값", "카운트하기");
                    print("동작인식 각도 결과값", "==============");
                    PoseInformation.pose_status = false;
                    PoseInformation.pose_count = PoseInformation.pose_count + 1;
                    PoseInformation.count_check_bool = true
                }
                
            }else{
                print("스쿼트 예외처리3", "측정불가 - 스쿼트 자세 X");
            }
            
        }else{
            print("스쿼트 예외처리1", "측정불가 - 서 있는 중 X");
            
        }
        
    }
    
    public func pushup_data(pose_count : Int, pose_status : Bool,
                            a1 : Double, a2 : Double, b1 : Double,  b2 : Double,  c1 : Double,  c2 : Double,
                            d1 : Double,  d2 : Double,  e1 : Double,  e2 : Double,  f1 : Double,  f2 : Double,
                            g1 : Double,  g2 : Double,  h1 : Double,  h2 : Double,  i1 : Double,  i2 : Double) {
        /*
         print("푸쉬업 변수", String.valueOf(pose_status));
         print("푸쉬업 개수", String.valueOf(pose_count));
         */
        
        // 개수 측정 -  (어깨 - 팔꿈치 - 손목) - 각도가 100 이하일 경우 카운트
        let line_ab : Double = sqrt(pow(a1 - b1, 2) + pow(a2 - b2, 2));
        let line_bc : Double = sqrt(pow(b1 - c1, 2) + pow(b2 - c2, 2));
        let line_ca : Double = sqrt(pow(c1 - a1, 2) + pow(c2 - a2, 2));
        let result_up : Double = (line_ab * line_ab + line_bc * line_bc - line_ca * line_ca);
        let result_down : Double = 2 * line_ab * line_bc;
        let result : Double = result_up / result_down;
        let cosX : Double = acos(result);
        let degree  : Double = (cosX * 180.0 / .pi)
        // 40 ~ 155도
        //print("푸쉬업 각도모음(팔)", String.valueOf(degree));
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 예외처리 1 - (엉덩이 y좌표 > 손목 y좌표) && (어깨 y좌표 > 손목 y좌표) - 엎드려 있는지 파악
        // 엎드림 여부
        
        var prostrate : Bool = false;
        if((e2 < c2) && (a2 < c2)){
            prostrate = true;
        }else{
            prostrate = false;
        }
        /*
         print("푸쉬업 손목 좌표", String.valueOf(c1) + "/" + String.valueOf(c2));
         print("푸쉬업 엉덩이 좌표", String.valueOf(e1) + "/" + String.valueOf(e2));
         print("푸쉬업 어깨 좌표", String.valueOf(a1) + "/" + String.valueOf(a2));
         */
        
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 예외처리 2 - (머리 , 엉덩이 , 발목) -  몸이 1자인지 파악하기 위한 각도 (150도 이상일 경우에만 측정, 150도이하일 경우 측정 X)
        let line_de : Double = sqrt(pow(d1 - e1, 2) + pow(d2 - e2, 2));
        let line_ef : Double = sqrt(pow(e1 - f1, 2) + pow(e2 - f2, 2));
        let line_fd : Double = sqrt(pow(f1 - d1, 2) + pow(f2 - d2, 2));
        let result_up_body : Double = (line_de * line_de + line_ef * line_ef - line_fd * line_fd);
        let result_down_body : Double = 2 * line_de * line_ef;
        let result_body : Double = result_up_body / result_down_body;
        let cosX_body : Double = acos(result_body);
        let degree_body : Double = (cosX_body * 180.0 / .pi)
        // 몸 1자 여부 파악   150도 ~ 180도
        //print("푸쉬업 각도모음(몸1자)", String.valueOf(degree_body));
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 예외처리 3 - (머리 , 엉덩이 , 발목) -  몸이 1자인지 파악하기 위한 각도 (150도 이상일 경우에만 측정, 150도이하일 경우 측정 X)
        let line_gh : Double = sqrt(pow(g1 - h1, 2) + pow(g2 - h2, 2));
        let line_hi : Double = sqrt(pow(h1 - i1, 2) + pow(h2 - i2, 2));
        let line_ig : Double = sqrt(pow(i1 - g1, 2) + pow(i2 - g2, 2));
        let result_up_leg : Double = (line_gh * line_gh + line_hi * line_hi - line_ig * line_ig);
        let result_down_leg : Double = 2 * line_gh * line_hi;
        let result_leg : Double = result_up_leg / result_down_leg;
        let cosX_leg : Double = acos(result_leg);
        let degree_leg : Double = (cosX_leg * 180.0 / .pi)
        // 다리 1자 여부 파악  150도 ~ 180도
        //print("푸쉬업 각도모음(다리1자)", String.valueOf(degree_leg));
        
        
        
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        
        
        if(prostrate) {
            print("푸쉬업 예외처리1", "측정가능 - 엎드려 있는 중 O");
            
            
            if(degree_body>120){
                print("푸쉬업 예외처리2", "측정가능 - 몸 1자 O");
                
                if(degree_leg>140) {
                    print("푸쉬업 예외처리3", "측정가능 - 다리 1자 O");
                    
                    if (degree >= 140 && pose_status == false) {
                        // 1단계
                        // 준비 중, 인식 X
                        print("동작인식 각도 순서", "1단계");
                        print("동작인식 각도 결과값", "준비 중, 인식 X");
                        PoseInformation.pose_status = false;
                        PoseInformation.pose_degree = 140.0;
                    } else if (degree < 110 &&  pose_status == false) {
                        // 2단계
                        // 푸쉬업 중, 인식 X
                        print("동작인식 각도 순서", "2단계");
                        print("동작인식 각도 결과값", "푸쉬업 중, 인식 X");
                        PoseInformation.pose_status = true;
                        if (degree < PoseInformation.pose_degree) {
                            PoseInformation.pose_degree = degree;
                        }
                    } else if (degree < 110 &&  pose_status == true) {
                        // 3단계
                        // 푸쉬업 중, 인식 O
                        print("동작인식 각도 순서", "3단계");
                        print("동작인식 각도 결과값", "푸쉬업 중, 인식 O");
                        PoseInformation.pose_status = true;
                        if (degree < PoseInformation.pose_degree) {
                            PoseInformation.pose_degree = degree;
                        }
                    } else if (degree >= 140 && pose_status == true) {
                        // 4단계
                        // 준비 중, 인식 O
                        print("동작인식 각도 순서", "4단계");
                        print("동작인식 각도 결과값", "준비 중, 인식 O");
                        print("동작인식 각도 결과값", "==============");
                        print("동작인식 각도 결과값", "카운트하기");
                        print("동작인식 각도 결과값", "==============");
                        
                        PoseInformation.pose_status = false;
                        PoseInformation.pose_count = PoseInformation.pose_count + 1;
                        PoseInformation.count_check_bool = true
                    }
                }else{
                    print("푸쉬업 예외처리3", "측정불가 - 다리 1자 X");
                }
            }else{
                print("푸쉬업 예외처리2", "측정불가 - 몸 1자 X");
            }
            
            
        }else{
            print("푸쉬업 예외처리1", "측정불가 - 엎드려 있는 중 X");
        }
        
        
    }
    
    public func knee_pushup_data(pose_count : Int, pose_status : Bool,
                                 a1 : Double, a2 : Double, b1 : Double,  b2 : Double,  c1 : Double,  c2 : Double,
                                 d1 : Double,  d2 : Double,  e1 : Double,  e2 : Double,  f1 : Double,  f2 : Double,
                                 g1 : Double,  g2 : Double,  h1 : Double,  h2 : Double,  i1 : Double,  i2 : Double) {
        /*
         print("무릎푸쉬업 변수", String.valueOf(pose_status));
         print("무릎푸쉬업 개수", String.valueOf(pose_count));
         */
        
        // 개수 측정 -  (어깨 - 팔꿈치 - 손목) - 각도가 100 이하일 경우 카운트
        let line_ab : Double = sqrt(pow(a1 - b1, 2) + pow(a2 - b2, 2));
        let line_bc : Double = sqrt(pow(b1 - c1, 2) + pow(b2 - c2, 2));
        let line_ca : Double = sqrt(pow(c1 - a1, 2) + pow(c2 - a2, 2));
        let result_up : Double = (line_ab * line_ab + line_bc * line_bc - line_ca * line_ca);
        let result_down : Double = 2 * line_ab * line_bc;
        let result : Double = result_up / result_down;
        let cosX : Double = acos(result);
        let degree : Double = (cosX * 180.0 / .pi)
        // 40 ~ 155도
        //print("무릎푸쉬업 각도모음(팔)", String.valueOf(degree));
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 예외처리 1 - (머리 y좌표 = 엉덩이 y좌표) - 엎드려 있는지 파악
        // 엎드림 여부
        let pushup_prostrate : Double = abs(d2 - e2);
        var prostrate : Bool = false;
        if(pushup_prostrate<100){
            prostrate = true;
        }else{
            prostrate = false;
        }
        /*
         print("무릎푸쉬업 머리 좌표", String.valueOf(d1) + "/" + String.valueOf(d2));
         print("무릎푸쉬업 엉덩이 좌표", String.valueOf(e1) + "/" + String.valueOf(e2));
         */
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 예외처리 2 - (머리 , 엉덩이 , 발목) -  몸이 1자인지 파악하기 위한 각도 (150도 이상일 경우에만 측정, 150도이하일 경우 측정 X)
        let line_de : Double = sqrt(pow(d1 - e1, 2) + pow(d2 - e2, 2));
        let line_ef : Double = sqrt(pow(e1 - f1, 2) + pow(e2 - f2, 2));
        let line_fd : Double = sqrt(pow(f1 - d1, 2) + pow(f2 - d2, 2));
        let result_up_body : Double = (line_de * line_de + line_ef * line_ef - line_fd * line_fd);
        let result_down_body : Double = 2 * line_de * line_ef;
        let result_body : Double = result_up_body / result_down_body;
        let cosX_body : Double = acos(result_body);
        let degree_body : Double = (cosX_body * 180.0 / .pi)
        // 몸 1자 여부 파악   150도 ~ 180도
        //print("무릎푸쉬업 각도모음(몸1자)", String.valueOf(degree_body));
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 예외처리 3 - (머리 , 엉덩이 , 발목) -  몸이 1자인지 파악하기 위한 각도 (150도 이상일 경우에만 측정, 150도이하일 경우 측정 X)
        let line_gh : Double = sqrt(pow(g1 - h1, 2) + pow(g2 - h2, 2));
        let line_hi : Double = sqrt(pow(h1 - i1, 2) + pow(h2 - i2, 2));
        let line_ig : Double = sqrt(pow(i1 - g1, 2) + pow(i2 - g2, 2));
        let result_up_leg : Double = (line_gh * line_gh + line_hi * line_hi - line_ig * line_ig);
        let result_down_leg : Double = 2 * line_gh * line_hi;
        let result_leg : Double = result_up_leg / result_down_leg;
        let cosX_leg : Double = acos(result_leg);
        let degree_leg : Double = (cosX_leg * 180.0 / .pi)
        // 다리 1자 여부 파악 100도 이하
        //print("무릎푸쉬업 각도모음(다리1자)", String.valueOf(degree_leg));
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        if(prostrate) {
            print("무릎푸쉬업 예외처리1", "측정가능 - 엎드려 있는 중 O");
            
            //            if(degree_body>120) {
            //                print("무릎푸쉬업 예외처리2", "측정가능 - 몸 1자 O");
            //
            //            }else{
            //                print("무릎푸쉬업 예외처리2", "측정불가 - 몸 1자 X");
            //            }
            
            if(degree_leg<100) {
                //print("무릎푸쉬업 예외처리3", "측정가능 - 무릎 대기 O");
                
                if (degree >= 140 && pose_status == false) {
                    // 1단계
                    // 준비 중, 인식 X
                    //print("동작인식 각도 순서", "1단계");
                    //print("동작인식 각도 결과값", "준비 중, 인식 X");
                    PoseInformation.pose_status = false;
                    PoseInformation.pose_degree = 140.0;
                } else if (degree < 110 &&  pose_status == false) {
                    // 2단계
                    // 무릎푸쉬업 중, 인식 X
                    //print("동작인식 각도 순서", "2단계");
                    //print("동작인식 각도 결과값", "무릎푸쉬업 중, 인식 X");
                    PoseInformation.pose_status = true;
                    if (degree < PoseInformation.pose_degree) {
                        PoseInformation.pose_degree = degree;
                    }
                } else if (degree < 110 &&  pose_status == true) {
                    // 3단계
                    // 무릎푸쉬업 중, 인식 O
                    //print("동작인식 각도 순서", "3단계");
                    //print("동작인식 각도 결과값", "무릎푸쉬업 중, 인식 O");
                    PoseInformation.pose_status = true;
                    if (degree < PoseInformation.pose_degree) {
                        PoseInformation.pose_degree = degree;
                    }
                } else if (degree >= 140 && pose_status == true) {
                    // 4단계
                    // 준비 중, 인식 O
                    /*
                     print("동작인식 각도 순서", "4단계");
                     print("동작인식 각도 결과값", "준비 중, 인식 O");
                     print("동작인식 각도 결과값", "==============");
                     print("동작인식 각도 결과값", "카운트하기");
                     print("동작인식 각도 결과값", "==============");
                     */
                    PoseInformation.pose_status = false;
                    PoseInformation.pose_count = PoseInformation.pose_count + 1;
                    PoseInformation.count_check_bool = true
                }
            }else{
                print("무릎푸쉬업 예외처리3", "측정불가 - 무릎 대기 X");
            }
            
            
            
        }else{
            print("무릎푸쉬업 예외처리1", "측정불가 - 엎드려 있는 중 X");
        }
        
        
    }
    
    public func burpee_data(pose_count : Int, pose_status : Bool, pose_status_sub : Bool, a1 : Double, a2 : Double, b1 : Double, b2 : Double, c1 : Double, c2 : Double, d1 : Double, d2 : Double, e1 : Double, e2 : Double, f1 : Double, f2 : Double) {
        print("버피변수", (pose_status));
        print("버피개수", (pose_count));
        
        
        let line_ab : Double = sqrt(pow(a1 - b1, 2) + pow(a2 - b2, 2));
        let line_bc : Double = sqrt(pow(b1 - c1, 2) + pow(b2 - c2, 2));
        let line_ca : Double = sqrt(pow(c1 - a1, 2) + pow(c2 - a2, 2));
        
        
        let result_up : Double = (line_ab * line_ab + line_bc * line_bc - line_ca * line_ca);
        let result_down : Double = 2 * line_ab * line_bc;
        let result : Double = result_up / result_down;
        
        let cosX : Double = acos(result);
        let degree : Double = (cosX * 180.0 / .pi)
        //50~170
        //print("버피각도모음(머리-엉덩이-발목)", String.valueOf(degree));
        
        let line_de : Double = sqrt(pow(d1 - e1, 2) + pow(d2 - e2, 2));
        let line_ef : Double = sqrt(pow(e1 - f1, 2) + pow(e2 - f2, 2));
        let line_fd : Double = sqrt(pow(f1 - d1, 2) + pow(f2 - d2, 2));
        
        let result_up_sub : Double = (line_de * line_de + line_ef * line_ef - line_fd * line_fd);
        let result_down_sub : Double = 2 * line_de * line_ef;
        let result_sub : Double = result_up_sub / result_down_sub;
        
        let cosX_sub : Double = acos(result_sub);
        let degree_sub : Double = (cosX_sub * 180.0 / .pi)
        //엎드림 여부파악
        //print("버피각도모음(어깨, 손목, 발목)", String.valueOf(degree_sub));
        
        
        
        if (degree >= 145 && pose_status == false && degree_sub >= 145 && pose_status_sub == false) {
            //1단계
            //준비중,인식X
            print("동작인식각도순서", "1단계");
            print("동작인식각도결과값", "준비중,인식X");
            PoseInformation.pose_status = false;
        } else if (degree < 115 &&  pose_status == false && degree_sub < 115 && pose_status_sub == false) {
            //2단계
            //버피중간동작(구부리기)중,인식X
            //버피마무리동작(엎드리기),인식X
            print("동작인식각도순서", "2단계");
            print("동작인식각도결과값", "버피중간동작(구부리기)중,인식X");
            PoseInformation.pose_degree = degree;
            PoseInformation.pose_status = true;
        } else if (degree < 115 &&  pose_status == true && degree_sub < 115 && pose_status_sub == false) {
            //3단계
            //버피중간동작(구부리기)중,인식O
            //버피마무리동작(엎드리기),인식X
            print("동작인식각도순서", "3단계");
            print("동작인식각도결과값", "버피중간동작(구부리기)중,인식O");
            PoseInformation.pose_status = true;
            
        } else if (pose_status == true && degree_sub < 115 && pose_status_sub == false) {
            //4단계
            //버피중간동작(구부리기)중,인식O
            //버피마무리동작(엎드리기),인식X
            print("동작인식각도순서", "4단계");
            print("동작인식각도결과값", "버피마무리동작(엎드리기)중,인식X");
            //여기서엎드리기상태True로변경
            PoseInformation.pose_status_sub = true;
            //각도(머리-엉덩이-발목)이 작을수록 점수가 낮다
            if (degree > PoseInformation.pose_degree) {
                PoseInformation.pose_degree = degree;
                //print("동작인식각도변경", "구부리기각도변경"+ PoseInformation.pose_degree);
            }
        } else if (pose_status == true && degree_sub < 115 && pose_status_sub == true) {
            //5단계
            //버피중간동작(구부리기)중,인식O
            //버피마무리동작(엎드리기),인식O
            print("동작인식각도순서", "5단계");
            print("동작인식각도결과값", "버피마무리동작(엎드리기)중,인식O");
            //여기서엎드리기상태 True로변경
            PoseInformation.pose_status_sub = true;
            //엎드린 상태에서의 각도(머리-엉덩이-발목) 측정
            //각도가 작을수록 점수가 낮다
            if (degree > PoseInformation.pose_degree) {
                PoseInformation.pose_degree = degree;
                //print("동작인식각도변경", "구부리기각도변경"+ PoseInformation.pose_degree);
            }
        }  else if (degree >= 145 && pose_status == true && degree_sub >= 145 && pose_status_sub == true) {
            //5단계
            //준비중,인식O
            print("동작인식각도순서", "6단계");
            print("동작인식각도결과값", "준비중,인식O");
            print("동작인식각도결과값", "==============");
            print("동작인식각도결과값", "카운트하기");
            print("동작인식각도결과값", "==============");
            
            PoseInformation.pose_status = false;
            PoseInformation.pose_status_sub = false;
            PoseInformation.pose_count = PoseInformation.pose_count + 1;
            PoseInformation.count_check_bool = true
        }
    }
    
    
    public func crunch_data(pose_count : Int, pose_status : Bool,
                            a1 : Double, a2 : Double, b1 : Double,  b2 : Double,  c1 : Double,  c2 : Double,
                            d1 : Double,  d2 : Double,  e1 : Double,  e2 : Double,  f1 : Double,  f2 : Double,
                            g1 : Double,  g2 : Double,  h1 : Double,  h2 : Double) {
        print("크런치변수", (pose_status));
        print("크런치개수", (pose_count));
        
        
        let line_ab : Double = sqrt(pow(a1 - b1, 2) + pow(a2 - b2, 2));
        let line_bc : Double = sqrt(pow(b1 - c1, 2) + pow(b2 - c2, 2));
        let line_ca : Double = sqrt(pow(c1 - a1, 2) + pow(c2 - a2, 2));
        let result_up : Double = (line_ab * line_ab + line_bc * line_bc - line_ca * line_ca);
        let result_down : Double = 2 * line_ab * line_bc;
        let result : Double = result_up / result_down;
        let cosX : Double = acos(result);
        let degree : Double = (cosX * 180.0 / .pi);
        // 100도 ~ 145도
        //print("크런치각도모음", String.valueOf(degree));
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 예외처리 1 - (엉덩이 y좌표 = 발목 y좌표) - 누워 있는지 파악
        // 누워있는지 여부
        let crunch_lay : Double = abs(d2 - f2);
        var lay : Bool = false;
        if(crunch_lay<50){
            lay = true;
        }else{
            lay = false;
        }
        /*
         print("크런치 엉덩이 좌표", String.valueOf(d1) + "/" + String.valueOf(d2));
         print("크런치 발목 좌표", String.valueOf(f1) + "/" + String.valueOf(f2));
         */
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 예외처리2 - (엉덩이 , 무릎 , 발목) - 다리를 굽혔는지 확인
        let line_de : Double = sqrt(pow(d1 - e1, 2) + pow(d2 - e2, 2));
        let line_ef : Double = sqrt(pow(e1 - f1, 2) + pow(e2 - f2, 2));
        let line_fd : Double = sqrt(pow(f1 - d1, 2) + pow(f2 - d2, 2));
        let result_up_leg : Double = (line_de * line_de + line_ef * line_ef - line_fd * line_fd);
        let result_down_leg : Double = 2 * line_de * line_ef;
        let result_leg : Double = result_up_leg / result_down_leg;
        let cosX_leg : Double = acos(result_leg);
        let degree_leg : Double = (cosX_leg * 180.0 / .pi);
        //다리 굽히기 여부파악 50~65도
        //print("크런치 다리각도모음", String.valueOf(degree_leg));
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 예외처리 3 - (손목 = 무릎) - 카운트 시 무릎 짚었는 지 확인
        let crunch_touch_x : Double = abs(g1 - h1);
        let crunch_touch_y : Double = abs(g2 - h2);
        var touch : Bool = false;
        if(crunch_touch_x<30 && crunch_touch_y<30){
            touch = true;
        }else{
            touch = false;
        }
        /*
         print("크런치 손목 좌표", String.valueOf(g1) + "/" + String.valueOf(g2));
         print("크런치 무릎 좌표", String.valueOf(h1) + "/" + String.valueOf(h2));
         */
        
        if(lay){
            print("크런치 예외처리1", "측정가능 - 누워 있는 중 O");
            
            if(degree_leg<110){
                print("크런치 예외처리2", "측정가능 - 다리 굽히는 중 O");
                
                if (degree >= 130 && pose_status == false) {
                    // 1단계
                    // 준비 중, 인식 X
                    print("동작인식 각도 순서", "1단계");
                    print("동작인식 각도 결과값", "준비 중, 인식 X");
                    PoseInformation.pose_status = false;
                    PoseInformation.pose_degree = 130.0;
                } else if (degree < 120 && touch==true && pose_status == false) {
                    // 2단계
                    // 크런치 중, 인식 X
                    print("동작인식 각도 순서", "2단계");
                    print("동작인식 각도 결과값", "크런치 중, 인식 X");
                    PoseInformation.pose_status = true;
                    if (degree < PoseInformation.pose_degree) {
                        PoseInformation.pose_degree = degree;
                    }
                } else if (degree < 120 &&  touch==true && pose_status == true) {
                    // 3단계
                    // 크런치 중, 인식 O
                    print("동작인식 각도 순서", "3단계");
                    print("동작인식 각도 결과값", "크런치 중, 인식 O");
                    PoseInformation.pose_status = true;
                    if (degree < PoseInformation.pose_degree) {
                        PoseInformation.pose_degree = degree;
                    }
                } else if (degree >= 130 && pose_status == true) {
                    // 4단계
                    // 준비 중, 인식 O
                    print("동작인식 각도 순서", "4단계");
                    print("동작인식 각도 결과값", "준비 중, 인식 O");
                    print("동작인식 각도 결과값", "==============");
                    print("동작인식 각도 결과값", "카운트하기");
                    print("동작인식 각도 결과값", "==============");
                    PoseInformation.pose_status = false;
                    PoseInformation.pose_count = PoseInformation.pose_count + 1;
                    PoseInformation.count_check_bool = true
                }
                
            }else{
                print("크런치 예외처리2", "측정불가 -  다리 굽히는 중 X");
            }
            
            
        }else{
            print("크런치 예외처리1", "측정불가 - 누워 있는 중 X");
        }
    }
    
    public func vup_data(pose_count : Int, pose_status : Bool,
                         a1 : Double, a2 : Double, b1 : Double,  b2 : Double,  c1 : Double,  c2 : Double,
                         d1 : Double,  d2 : Double,  e1 : Double,  e2 : Double,  f1 : Double,  f2 : Double,
                         g1 : Double,  g2 : Double,  h1 : Double,  h2 : Double) {
        print("브이업변수", (pose_status));
        print("브이업개수", (pose_count));
        
        
        let line_ab : Double = sqrt(pow(a1 - b1, 2) + pow(a2 - b2, 2));
        let line_bc : Double = sqrt(pow(b1 - c1, 2) + pow(b2 - c2, 2));
        let line_ca : Double = sqrt(pow(c1 - a1, 2) + pow(c2 - a2, 2));
        let result_up : Double = (line_ab * line_ab + line_bc * line_bc - line_ca * line_ca);
        let result_down : Double = 2 * line_ab * line_bc;
        let result : Double = result_up / result_down;
        let cosX : Double = acos(result);
        let degree : Double = (cosX * 180.0 / .pi);
        // 예측 (90도 ~ 145도)
        //print("브이업각도모음", String.valueOf(degree));
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 예외처리1 - (엉덩이 = 손목) - 몸이 바닥에 있는지 확인
        // 누워있는지 여부
        let vup_lay : Double = abs(d2 - f2);
        var lay : Bool = false;
        if(vup_lay<50){
            lay = true;
        }else{
            lay = false;
        }
        /*
         print("브이업 엉덩이 좌표", String.valueOf(d1) + "/" + String.valueOf(d2));
         print("브이업 손목 좌표", String.valueOf(f1) + "/" + String.valueOf(f2));
         */
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 예외처리2 - (엉덩이 , 어깨 , 손목) - 팔을 짚었는지 확인
        let line_de : Double = sqrt(pow(d1 - e1, 2) + pow(d2 - e2, 2));
        let line_ef : Double = sqrt(pow(e1 - f1, 2) + pow(e2 - f2, 2));
        let line_fd : Double = sqrt(pow(f1 - d1, 2) + pow(f2 - d2, 2));
        let result_up_hand : Double = (line_de * line_de + line_ef * line_ef - line_fd * line_fd);
        let result_down_hand : Double = 2 * line_de * line_ef;
        let result_hand : Double = result_up_hand / result_down_hand;
        let cosX_hand : Double = acos(result_hand);
        let degree_hand : Double = (cosX_hand * 180.0 / .pi)
        //팔짚기 여부파악 15~50도
        //print("브이업 팔짚기각도모음", String.valueOf(degree_hand));
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 예외처리3 - (발목, 머리) - 카운트 시 발목이 머리 위에 있는지 확인
        var legup : Bool = false;
        if(g2<=h2){
            print("브이업 다리 위로", "O");
            legup = true;
        }else{
            print("브이업 다리 위로", "X");
            legup = false;
        }
        /*
         print("브이업 발목 좌표", String.valueOf(g1) + "/" + String.valueOf(g2));
         print("브이업 머리 좌표", String.valueOf(h1) + "/" + String.valueOf(h2));
         */
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        if(lay){
            print("브이업 예외처리1", "측정가능 - 브이업 준비자세 중 O");
            
            if(10<degree_hand && degree_hand<90){
                print("브이업 예외처리2", "측정가능 - 팔짚기 중 O");
                
                if (degree >= 120 && pose_status == false) {
                    // 1단계
                    // 준비 중, 인식 X
                    print("동작인식 각도 순서", "1단계");
                    print("동작인식 각도 결과값", "준비 중, 인식 X");
                    PoseInformation.pose_status = false;
                    PoseInformation.pose_degree = 120.0;
                } else if (degree < 110 && legup == true && pose_status == false) {
                    // 2단계
                    // 브이업 중, 인식 X
                    print("동작인식 각도 순서", "2단계");
                    print("동작인식 각도 결과값", "브이업 중, 인식 X");
                    PoseInformation.pose_status = true;
                    if (degree < PoseInformation.pose_degree) {
                        PoseInformation.pose_degree = degree;
                    }
                } else if (degree < 110 &&  legup == true && pose_status == true) {
                    // 3단계
                    // 브이업 중, 인식 O
                    print("동작인식 각도 순서", "3단계");
                    print("동작인식 각도 결과값", "브이업 중, 인식 O");
                    PoseInformation.pose_status = true;
                    if (degree < PoseInformation.pose_degree) {
                        PoseInformation.pose_degree = degree;
                    }
                } else if (degree >= 120 && pose_status == true) {
                    // 4단계
                    // 준비 중, 인식 O
                    print("동작인식 각도 순서", "4단계");
                    print("동작인식 각도 결과값", "준비 중, 인식 O");
                    print("동작인식 각도 결과값", "==============");
                    print("동작인식 각도 결과값", "카운트하기");
                    print("동작인식 각도 결과값", "==============");
                    PoseInformation.pose_status = false;
                    PoseInformation.pose_count = PoseInformation.pose_count + 1;
                    PoseInformation.count_check_bool = true
                }
                
            }else{
                print("브이업 예외처리2", "측정불가 -  팔짚기 중 X");
            }
            
        }else{
            print("브이업 예외처리1", "측정불가 - 브이업 준비자세 중 X");
        }
    }
    
    public func ankleupdown_data(pose_count : Int, pose_status : Bool,
                                 a1 : Double, a2 : Double, b1 : Double,  b2 : Double,  c1 : Double,  c2 : Double,
                                 d1 : Double,  d2 : Double,  e1 : Double,  e2 : Double,  f1 : Double,  f2 : Double,
                                 g1 : Double,  g2 : Double,  h1 : Double,  h2 : Double) {
        print("위아래지그재그복근 변수", (pose_status));
        print("위아래지그재그복근 개수", (pose_count));
        
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 개수 측정 - 각도1(왼쪽발목, 엉덩이, 오른쪽발목) - 양쪽 발목이 교차할때마다 0.5씩 카운트 - 30도 이상일 경우 카운트
        let line_ab : Double = sqrt(pow(a1 - b1, 2) + pow(a2 - b2, 2));
        let line_bc : Double = sqrt(pow(b1 - c1, 2) + pow(b2 - c2, 2));
        let line_ca : Double = sqrt(pow(c1 - a1, 2) + pow(c2 - a2, 2));
        let result_up : Double = (line_ab * line_ab + line_bc * line_bc - line_ca * line_ca);
        let result_down : Double = 2 * line_ab * line_bc;
        let result : Double = result_up / result_down;
        let cosX : Double = acos(result);
        let degree : Double = (cosX * 180.0 / .pi);
        // 1~35도
        //print("위아래지그재그복근각도모음", String.valueOf(degree));
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 예외처리1 -  (엉덩이 - 어깨 - 팔꿈치) (20도~110도일 경우에만 측정, 그 외의 경우 측정 X) -> 손을 바닥에 올바른 각도로 짚었는지 측정
        let line_de : Double = sqrt(pow(d1 - e1, 2) + pow(d2 - e2, 2));
        let line_ef : Double = sqrt(pow(e1 - f1, 2) + pow(e2 - f2, 2));
        let line_fd : Double = sqrt(pow(f1 - d1, 2) + pow(f2 - d2, 2));
        let result_up_sub : Double = (line_de * line_de + line_ef * line_ef - line_fd * line_fd);
        let result_down_sub : Double = 2 * line_de * line_ef;
        let result_sub : Double = result_up_sub / result_down_sub;
        let cosX_sub : Double = acos(result_sub);
        let degree_sub : Double = (cosX_sub * 180.0 / .pi);
        // 팔짚기 여부 파악 (40도정도)
        //print("위아래지그재그복근각도모음(팔짚기)", String.valueOf(degree_sub));
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 예외처리2 -  (발목 >= 엉덩이) - 서서 동작하는 것 방지
        var ankle_up : Bool = false;
        if(a2<=b2){
            print("위아래지그재그복근 다리 위로", "O");
            ankle_up = true;
        }else{
            print("위아래지그재그복근 다리 위로", "X");
            ankle_up = false;
        }
        //print("위아래지그재그복근 엉덩이 좌표", String.valueOf(b1) + "/" + String.valueOf(b2));
        //print("위아래지그재그복근 발목 좌표", String.valueOf(a1) + "/" + String.valueOf(a2));
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 예외처리3 -  (발목 >= 어깨) - 카운트 시 발목이 어깨 위로 올라가는지 확인
        var ankle_up_high : Bool = false;
        if( (a2 <= g2) || (c2 <= h2) ){
            print("위아래지그재그복근 예외처리3", "측정가능 - 카운트 시 발목이 어깨 위로 올라가는지 확인 O");
            ankle_up_high = true;
        }else{
            print("위아래지그재그복근 예외처리3", "측정불가 - 카운트 시 발목이 어깨 위로 올라가는지 확인 X");
            ankle_up_high = false;
        }
        /*
         print("위아래지그재그복근 왼쪽발목 좌표", String.valueOf(a1) + "/" + String.valueOf(a2));
         print("위아래지그재그복근 왼쪽어깨 좌표", String.valueOf(g1) + "/" + String.valueOf(g2));
         print("위아래지그재그복근 오른쪽발목 좌표", String.valueOf(c1) + "/" + String.valueOf(c2));
         print("위아래지그재그복근 오른쪽어깨 좌표", String.valueOf(h1) + "/" + String.valueOf(h2));
         */
        
        
        if(ankle_up) {
            print("위아래지그재그복근 예외처리2", "측정가능 - 위아래지그재그복근 다리 위로 O");
            
            if (20 < degree_sub && degree_sub < 110) {
                print("위아래지그재그복근 예외처리1", "측정가능 - 팔 짚은 것으로 인식 O");
                
                if (degree < 10 && pose_status == false) {
                    // 1단계
                    // 준비 중, 인식 X
                    print("동작인식 각도 순서", "1단계");
                    print("동작인식 각도 결과값", "준비 중, 인식 X");
                    PoseInformation.pose_status = false;
                    PoseInformation.pose_degree = 20.0;
                } else if (30 < degree &&  ankle_up_high==true && pose_status == false) {
                    // 2단계
                    // 위아래지그재그복근중, 인식 X
                    print("동작인식 각도 순서", "2단계");
                    print("동작인식 각도 결과값", "위아래지그재그복근 중, 인식 X");
                    PoseInformation.pose_status = true;
                    if (degree > PoseInformation.pose_degree) {
                        PoseInformation.pose_degree = degree;
                    }
                } else if (30 < degree && ankle_up_high==true && pose_status == true) {
                    // 3단계
                    // 위아래지그재그복근 중, 인식 O
                    print("동작인식 각도 순서", "3단계");
                    print("동작인식 각도 결과값", "위아래지그재그복근 중, 인식 O");
                    PoseInformation.pose_status = true;
                    if (degree > PoseInformation.pose_degree) {
                        PoseInformation.pose_degree = degree;
                    }
                } else if (degree < 10  && pose_status == true) {
                    
                    PoseInformation.pose_status = false;
                    PoseInformation.pose_count_double = PoseInformation.pose_count_double + 0.5;
                    
                    if(PoseInformation.pose_count_double.truncatingRemainder(dividingBy: 1.0) == 0 && PoseInformation.pose_count_double != 0){ // 1로 나눴을 때 나머지가 0인경우, 0이 아닌경우
                        
                        // 4단계
                        // 준비 중, 인식 O
                        print("동작인식 각도 순서", "4단계");
                        print("동작인식 각도 결과값", "준비 중, 인식 O");
                        print("동작인식 각도 결과값", "==============");
                        print("동작인식 각도 결과값", "카운트하기");
                        print("동작인식 각도 결과값", "==============");
                        PoseInformation.pose_count = Int(floor(PoseInformation.pose_count_double));
                        PoseInformation.count_check_bool = true
                        
                    }else{ // 나머지가 0.5인경우
                        
                    }
                    
                }
                
            }else{
                print("위아래지그재그복근 예외처리1", "측정불가 - 팔 짚은 것으로 인식 X");
            }
            
        }else{
            print("위아래지그재그복근 예외처리2", "측정불가 - 위아래지그재그복근 다리 위로 X");
        }
    }
    
    public func goodmorning_data(pose_count : Int, pose_status : Bool,
                                 a1 : Double, a2 : Double, b1 : Double,  b2 : Double,  c1 : Double,  c2 : Double,
                                 d1 : Double,  d2 : Double,  e1 : Double,  e2 : Double,  f1 : Double,  f2 : Double,
                                 g1 : Double,  g2 : Double,  h1 : Double,  h2 : Double,  i1 : Double,  i2 : Double,
                                 j1 : Double,  j2 : Double,  k1 : Double,  k2 : Double,  l1 : Double,  l2 : Double,
                                 m1 : Double,  m2 : Double) {
        print("굿모닝변수", (pose_status));
        print("굿모닝개수", (pose_count));
        
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 개수 측정  - 각도1(어깨, 엉덩이, 발목) - 각도가 120도 이하일 경우 측정
        let line_ab : Double = sqrt(pow(a1 - b1, 2) + pow(a2 - b2, 2));
        let line_bc : Double = sqrt(pow(b1 - c1, 2) + pow(b2 - c2, 2));
        let line_ca : Double = sqrt(pow(c1 - a1, 2) + pow(c2 - a2, 2));
        let result_up : Double = (line_ab * line_ab + line_bc * line_bc - line_ca * line_ca);
        let result_down : Double = 2 * line_ab * line_bc;
        let result : Double = result_up / result_down;
        let cosX : Double = acos(result);
        let degree : Double = (cosX * 180.0 / .pi);
        // 95도 ~ 170도
        //print("굿모닝각도모음", String.valueOf(degree));
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 예외처리1 - (왼쪽손목>왼쪽어깨, 오른쪽손목>오른쪽어깨) - 굿모닝 준비자세
        var hand_ear : Bool = false;
        if(d2<=e2 || f2<=g2 ){
            print("굿모닝 팔목이 어깨보다 위에 위치", "O");
            hand_ear = true;
        }else{
            print("굿모닝 팔목이 어깨보다 위에 위치", "X");
            hand_ear = false;
        }
        
        /*
         print("굿모닝 왼쪽손목 좌표", String.valueOf(d1) + "/" + String.valueOf(d2));
         print("굿모닝 왼쪽어깨 좌표", String.valueOf(e1) + "/" + String.valueOf(e2));
         print("굿모닝 오른쪽손목 좌표", String.valueOf(f1) + "/" + String.valueOf(f2));
         print("굿모닝 오른쪽어깨 좌표", String.valueOf(g1) + "/" + String.valueOf(g2));
         
         print("굿모닝 발목 좌표", String.valueOf(j1) + "/" + String.valueOf(j2));
         */
        
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 예외처리2 - (왼쪽발목, 엉덩이, 오른쪽발목) - 두 발이 붙어있는지 확인
        let line_hi : Double = sqrt(pow(h1 - i1, 2) + pow(h2 - i2, 2));
        let line_ij : Double = sqrt(pow(i1 - j1, 2) + pow(i2 - j2, 2));
        let line_jh : Double = sqrt(pow(j1 - h1, 2) + pow(j2 - h2, 2));
        let result_up_sub : Double = (line_hi * line_hi + line_ij * line_ij - line_jh * line_jh);
        let result_down_sub : Double = 2 * line_hi * line_ij;
        let result_sub : Double = result_up_sub / result_down_sub;
        let cosX_sub : Double = acos(result_sub);
        let degree_sub : Double = (cosX_sub * 180.0 / .pi);
        //print("굿모닝다리벌림각도모음", String.valueOf(degree_sub));
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 예외처리3 - (엉덩이, 무릎, 발목) - 다리 1자로
        let line_kl : Double = sqrt(pow(k1 - l1, 2) + pow(k2 - l2, 2));
        let line_lm : Double = sqrt(pow(l1 - m1, 2) + pow(l2 - m2, 2));
        let line_mk : Double = sqrt(pow(m1 - k1, 2) + pow(m2 - k2, 2));
        let result_up_leg : Double = (line_kl * line_kl + line_lm * line_lm - line_mk * line_mk);
        let result_down_leg : Double = 2 * line_kl * line_lm;
        let result_leg : Double = result_up_leg / result_down_leg;
        let cosX_leg : Double = acos(result_leg);
        let degree_leg : Double = (cosX_leg * 180.0 / .pi);
        //print("굿모닝다리각도모음", String.valueOf(degree_leg));
        
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        if(degree_leg>140){
            print("굿모닝 예외처리3", "측정가능 - 다리 1자 O");
            
            if (degree >= 160 && hand_ear && pose_status == false) {
                // 1단계
                // 준비 중, 인식 X
                print("동작인식 각도 순서", "1단계");
                print("동작인식 각도 결과값", "준비 중, 인식 X");
                PoseInformation.pose_status = false;
                PoseInformation.pose_degree = 160.0;
            } else if (degree < 120 &&  pose_status == false) {
                // 2단계
                // 굿모닝 중, 인식 X
                print("동작인식 각도 순서", "2단계");
                print("동작인식 각도 결과값", "굿모닝 중, 인식 X");
                PoseInformation.pose_status = true;
                if (degree < PoseInformation.pose_degree) {
                    PoseInformation.pose_degree = degree;
                }
            } else if (degree < 120 &&  pose_status == true) {
                // 3단계
                //굿모닝 중, 인식 O
                print("동작인식 각도 순서", "3단계");
                print("동작인식 각도 결과값", "굿모닝 중, 인식 O");
                PoseInformation.pose_status = true;
                if (degree < PoseInformation.pose_degree) {
                    PoseInformation.pose_degree = degree;
                }
            } else if (degree >= 160 && hand_ear && pose_status == true) {
                // 4단계
                // 준비 중, 인식 O
                print("동작인식 각도 순서", "4단계");
                print("동작인식 각도 결과값", "준비 중, 인식 O");
                print("동작인식 각도 결과값", "==============");
                print("동작인식 각도 결과값", "카운트하기");
                print("동작인식 각도 결과값", "==============");
                PoseInformation.pose_status = false;
                PoseInformation.pose_count = PoseInformation.pose_count + 1;
                PoseInformation.count_check_bool = true
            }
            
        }else{
            print("굿모닝 예외처리3", "측정불가 - 다리 1자 X");
        }
        
        
    }
    
    
    public func dumbbellshoulder_data(pose_count : Int, pose_status : Bool,
                                      a1 : Double, a2 : Double, b1 : Double,  b2 : Double,  c1 : Double,  c2 : Double,
                                      d1 : Double,  d2 : Double,  e1 : Double,  e2 : Double,  f1 : Double,  f2 : Double,
                                      g1 : Double,  g2 : Double,  h1 : Double,  h2 : Double,  i1 : Double,  i2 : Double,
                                      j1 : Double,  j2 : Double,  k1 : Double,  k2 : Double,  l1 : Double,  l2 : Double) {
        
        print("덤벨숄더프레스변수", (pose_status));
        print("덤벨숄더프레스개수", (pose_count));
        
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 개수 측정1 - 각도1(왼쪽어깨, 왼쪽팔꿈치, 왼쪽손목) - 140도 이상일 경우 카운트
        let line_ab : Double = sqrt(pow(a1 - b1, 2) + pow(a2 - b2, 2));
        let line_bc : Double = sqrt(pow(b1 - c1, 2) + pow(b2 - c2, 2));
        let line_ca : Double = sqrt(pow(c1 - a1, 2) + pow(c2 - a2, 2));
        let result_up_left : Double = (line_ab * line_ab + line_bc * line_bc - line_ca * line_ca);
        let result_down_left : Double = 2 * line_ab * line_bc;
        let result_left : Double = result_up_left / result_down_left;
        let cosX_left : Double = acos(result_left);
        let degree_left : Double = (cosX_left  * 180.0 / .pi);
        // 40 ~ 170
        //print("덤벨숄더프레스각도모음(왼)", String.valueOf(degree_left));
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 개수 측정2 - 각도2(오른쪽어깨, 른쪽팔꿈치, 른쪽손목) - 140도 이상일 경우 카운트
        let line_de : Double = sqrt(pow(d1 - e1, 2) + pow(d2 - e2, 2));
        let line_ef : Double = sqrt(pow(e1 - f1, 2) + pow(e2 - f2, 2));
        let line_fd : Double = sqrt(pow(f1 - d1, 2) + pow(f2 - d2, 2));
        let result_up_right : Double = (line_de * line_de + line_ef * line_ef - line_fd * line_fd);
        let result_down_right : Double = 2 * line_de * line_ef;
        let result_right : Double = result_up_right / result_down_right;
        let cosX_right : Double = acos(result_right);
        let degree_right : Double = (cosX_right * 180.0 / .pi);
        //print("덤벨숄더프레스각도모음(오른)", String.valueOf(degree_right));
        
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 예외처리1 - (왼쪽엉덩이, 왼쪽무릎, 왼쪽발목) - 1자
        let line_gh : Double = sqrt(pow(g1 - h1, 2) + pow(g2 - h2, 2));
        let line_hi : Double = sqrt(pow(h1 - i1, 2) + pow(h2 - i2, 2));
        let line_ig : Double = sqrt(pow(i1 - g1, 2) + pow(i2 - g2, 2));
        let result_up_left_leg : Double = (line_gh * line_gh + line_hi * line_hi - line_ig * line_ig);
        let result_down_left_leg : Double = 2 * line_gh * line_hi;
        let result_left_leg : Double = result_up_left_leg / result_down_left_leg;
        let cosX_left_leg : Double = acos(result_left_leg);
        let degree_left_leg : Double = (cosX_left_leg * 180.0 / .pi);
        //print("덤벨숄더프레스각도모음(왼다리 1자)", String.valueOf(degree_left_leg));
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 예외처리2 - (오른쪽엉덩이, 오른쪽무릎, 오른쪽발목) - 1자
        let line_jk : Double = sqrt(pow(j1 - k1, 2) + pow(j2 - k2, 2));
        let line_kl : Double = sqrt(pow(k1 - l1, 2) + pow(k2 - l2, 2));
        let line_lj : Double = sqrt(pow(l1 - j1, 2) + pow(l2 - j2, 2));
        let result_up_right_leg : Double = (line_jk * line_jk + line_kl * line_kl - line_lj * line_lj);
        let result_down_right_leg : Double = 2 * line_jk * line_kl;
        let result_right_leg : Double = result_up_right_leg / result_down_right_leg;
        let cosX_right_leg : Double = acos(result_right_leg);
        let degree_right_leg : Double = (cosX_right_leg * 180.0 / .pi);
        //print("덤벨숄더프레스각도모음(오른다리 1자)", String.valueOf(degree_right_leg));
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 예외처리3 -(왼쪽손목>왼쪽어깨, 오른쪽손목>오른쪽어깨) - 덤벨숄더프레스 준비자세
        var hand_ear : Bool = false;
        if(c2<=a2 && f2<=d2 ){
            print("덤벨숄더프레스 팔목이 어깨보다 위에 위치", "O");
            hand_ear = true;
        }else{
            print("덤벨숄더프레스 팔목이 어깨보다 위에 위치", "X");
            hand_ear = false;
        }
        /*
         print("덤벨숄더프레스 왼쪽손목 좌표", String.valueOf(c1) + "/" + String.valueOf(c2));
         print("덤벨숄더프레스 왼쪽어깨 좌표", String.valueOf(a1) + "/" + String.valueOf(a2));
         print("덤벨숄더프레스 오른쪽손목 좌표", String.valueOf(f1) + "/" + String.valueOf(f2));
         print("덤벨숄더프레스 오른쪽어깨 좌표", String.valueOf(d1) + "/" + String.valueOf(d2));
         */
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        if(degree_left_leg>150 && degree_right_leg>150){
            print("덤벨숄더프레스 예외처리1,2", "측정가능 - 다리 1자 O");
            
            if(hand_ear){
                print("덤벨숄더프레스 예외처리3", "측정가능 -  팔목이 어깨보다 위에 위치 O");
                
                if (degree_left <= 100 && degree_right <= 100 && pose_status == false) {
                    // 1단계
                    // 준비 중, 인식 X
                    print("동작인식 각도 순서", "1단계");
                    print("동작인식 각도 결과값", "준비 중, 인식 X");
                    PoseInformation.pose_status = false;
                    PoseInformation.pose_degree = 90.0;
                } else if (degree_left > 140 && degree_right > 140 && pose_status == false) {
                    // 2단계
                    // 덤벨숄더프레스 중, 인식 X
                    print("동작인식 각도 순서", "2단계");
                    print("동작인식 각도 결과값", "덤벨숄더프레스 중, 인식 X");
                    PoseInformation.pose_status = true;
                    if (degree_left > PoseInformation.pose_degree) {
                        PoseInformation.pose_degree = degree_left;
                    }
                } else if (degree_left > 140 && degree_right > 140 && pose_status == true) {
                    // 3단계
                    //덤벨숄더프레스 중, 인식 O
                    print("동작인식 각도 순서", "3단계");
                    print("동작인식 각도 결과값", "덤벨숄더프레스 중, 인식 O");
                    PoseInformation.pose_status = true;
                    if (degree_left > PoseInformation.pose_degree) {
                        PoseInformation.pose_degree = degree_left;
                    }
                } else if (degree_left <= 100 && degree_right <= 100 && pose_status == true) {
                    // 4단계
                    // 준비 중, 인식 O
                    print("동작인식 각도 순서", "4단계");
                    print("동작인식 각도 결과값", "준비 중, 인식 O");
                    print("동작인식 각도 결과값", "==============");
                    print("동작인식 각도 결과값", "카운트하기");
                    print("동작인식 각도 결과값", "==============");
                    PoseInformation.pose_status = false;
                    PoseInformation.pose_count = PoseInformation.pose_count + 1;
                    PoseInformation.count_check_bool = true
                }
                
            }else{
                print("덤벨숄더프레스 예외처리3", "측정불가 -  팔목이 어깨보다 위에 위치 X");
            }
            
        }else{
            print("덤벨숄더프레스 예외처리1,2", "측정불가 - 다리 1자 X");
        }
        
        
    }
    
    public func kneeup_data(pose_count : Int, pose_status : Bool, a1 : Double, a2 : Double, b1 : Double, b2 : Double, c1 : Double, c2 : Double, d1 : Double, d2 : Double, e1 : Double, e2 : Double, f1 : Double, f2 : Double) {
        print("접었다폈다복근 변수", (pose_status));
        print("접었다폈다복근 개수", (pose_count));
        
        let line_ab : Double = sqrt(pow(a1 - b1, 2) + pow(a2 - b2, 2));
        let line_bc : Double = sqrt(pow(b1 - c1, 2) + pow(b2 - c2, 2));
        let line_ca : Double = sqrt(pow(c1 - a1, 2) + pow(c2 - a2, 2));
        let result_up : Double = (line_ab * line_ab + line_bc * line_bc - line_ca * line_ca);
        let result_down : Double = 2 * line_ab * line_bc;
        let result : Double = result_up / result_down;
        let cosX : Double = acos(result);
        let degree : Double = (cosX * 180.0 / .pi);
        // 90 ~ 155
        //print("접었다폈다복근각도모음", String.valueOf(degree));
        
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 예외처리1 -  (엉덩이 - 어깨 - 팔꿈치) (20도~70도일 경우에만 측정, 그 외의 경우 측정 X) -> 손을 바닥에 올바른 각도로 짚었는지 측정
        let line_de : Double = sqrt(pow(d1 - e1, 2) + pow(d2 - e2, 2));
        let line_ef : Double = sqrt(pow(e1 - f1, 2) + pow(e2 - f2, 2));
        let line_fd : Double = sqrt(pow(f1 - d1, 2) + pow(f2 - d2, 2));
        let result_up_sub : Double = (line_de * line_de + line_ef * line_ef - line_fd * line_fd);
        let result_down_sub : Double = 2 * line_de * line_ef;
        let result_sub : Double = result_up_sub / result_down_sub;
        let cosX_sub : Double = acos(result_sub);
        let degree_sub : Double = (cosX_sub * 180.0 / .pi);
        // 팔짚기 여부 파악 (40도정도)
        //print("접었다폈다복근각도모음(팔짚기)", String.valueOf(degree_sub));
        
        
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 예외처리2 -  (발목 >> 엉덩이) - 서서 동작하는 것 방지
        var ankle_up : Bool = false;
        if(c2<a2){
            print("접었다폈다복근 다리 위로", "O");
            ankle_up = true;
        }else{
            print("접었다폈다복근 다리 위로", "X");
            ankle_up = false;
        }
        /*
         print("접었다폈다복근 엉덩이 좌표", String.valueOf(a1) + "/" + String.valueOf(a2));
         print("접었다폈다복근 발목 좌표", String.valueOf(c1) + "/" + String.valueOf(c2));
         */
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 예외처리3 -  (무릎 >>> 어깨) - 다리를 바닥에 대고하는 것 방지
        var knee_up : Bool = false;
        if(b2<e2){
            print("접었다폈다복근 다리 높게 위로", "O");
            knee_up = true;
        }else{
            print("접었다폈다복근 다리 높게 위로", "X");
            knee_up = false;
        }
        /*
         print("접었다폈다복근 무릎 좌표", String.valueOf(b1) + "/" + String.valueOf(b2));
         print("접었다폈다복근 어깨 좌표", String.valueOf(e1) + "/" + String.valueOf(e2));
         */
        
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        if(ankle_up){
            print("접었다폈다복근 예외처리2", "측정가능 - 접었다폈다복근 다리 위로 O");
            
            if ( 20 < degree_sub && degree_sub < 110 ) {
                print("접었다폈다복근 예외처리1", "측정가능 - 팔 짚은 것으로 인식 O");
                if (degree >= 150 && pose_status == false) {
                    // 1단계
                    // 준비 중, 인식 X
                    print("동작인식 각도 순서", "1단계");
                    print("동작인식 각도 결과값", "준비 중, 인식 X");
                    PoseInformation.pose_status = false;
                    PoseInformation.pose_degree = 150.0;
                } else if (degree < 110 && knee_up == true && pose_status == false) {
                    // 2단계
                    // 접었다폈다복근 중, 인식 X
                    print("동작인식 각도 순서", "2단계");
                    print("동작인식 각도 결과값", "접었다폈다복근 중, 인식 X");
                    PoseInformation.pose_status = true;
                    if (degree < PoseInformation.pose_degree) {
                        PoseInformation.pose_degree = degree;
                    }
                } else if (degree < 110 && knee_up == true && pose_status == true) {
                    // 3단계
                    // 접었다폈다복근 중, 인식 O
                    print("동작인식 각도 순서", "3단계");
                    print("동작인식 각도 결과값", "접었다폈다복근 중, 인식 O");
                    PoseInformation.pose_status = true;
                    if (degree < PoseInformation.pose_degree) {
                        PoseInformation.pose_degree = degree;
                    }
                } else if (degree >= 150 && pose_status == true) {
                    // 4단계
                    // 준비 중, 인식 O
                    print("동작인식 각도 순서", "4단계");
                    print("동작인식 각도 결과값", "준비 중, 인식 O");
                    print("동작인식 각도 결과값", "==============");
                    print("동작인식 각도 결과값", "카운트하기");
                    print("동작인식 각도 결과값", "==============");
                    PoseInformation.pose_status = false;
                    PoseInformation.pose_count = PoseInformation.pose_count + 1;
                    PoseInformation.count_check_bool = true
                }
            } else {
                print("접었다폈다복근 예외처리1", "측정불가 - 팔 짚은 것으로 인식 X");
            }
            
        }else{
            print("접었다폈다복근 예외처리2", "측정불가 - 접었다폈다복근 다리 위로 X");
        }
        
        
    }
    
    public func lunge_data(pose_count : Int, pose_status : Bool, a1 : Double, a2 : Double, b1 : Double, b2 : Double, c1 : Double, c2 : Double, d1 : Double, d2 : Double, e1 : Double, e2 : Double, f1 : Double, f2 : Double) {
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                // 개수 측정
        let line_ab : Double = sqrt(pow(a1 - b1, 2) + pow(a2 - b2, 2));
        let line_bc : Double = sqrt(pow(b1 - c1, 2) + pow(b2 - c2, 2));
        let line_ca : Double = sqrt(pow(c1 - a1, 2) + pow(c2 - a2, 2));
        let result_up_left : Double = (line_ab * line_ab + line_bc * line_bc - line_ca * line_ca);
        let result_down_left : Double = 2 * line_ab * line_bc;
        let result_left : Double = result_up_left / result_down_left;
        let cosX_left : Double = acos(result_left);
        let degree_left : Double = (cosX_left * 180.0 / .pi);
                // 70~160
                //print("런지각도모음(왼쪽발목 - 왼쪽무릎 - 엉덩이)", String.valueOf(degree_left));
        let line_de : Double = sqrt(pow(d1 - e1, 2) + pow(d2 - e2, 2));
        let line_ef : Double = sqrt(pow(e1 - f1, 2) + pow(e2 - f2, 2));
        let line_fd : Double = sqrt(pow(f1 - d1, 2) + pow(f2 - d2, 2));
        let result_up_right : Double = (line_de * line_de + line_ef * line_ef - line_fd * line_fd);
        let result_down_right : Double = 2 * line_de * line_ef;
        let result_right : Double = result_up_right / result_down_right;
        let cosX_right : Double = acos(result_right);
        let degree_right : Double = (cosX_right * 180.0 / .pi);
                // 110 ~ 160
                //print("런지각도모음(오른쪽발목 - 오른쪽무릎 - 엉덩이)", String.valueOf(degree_right));
                /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                // 예외처리1 - (왼쪽발목, 엉덩이, 오른쪽발목) - 두 발이 떨어져있는지 확인 (스쿼트에서도 카운트되는 부분 방지)
        let line_ac : Double = sqrt(pow(a1 - c1, 2) + pow(a2 - c2, 2));
        let line_cd : Double = sqrt(pow(c1 - d1, 2) + pow(c2 - d2, 2));
        let line_da : Double = sqrt(pow(d1 - a1, 2) + pow(d2 - a2, 2));
        let result_up_sub : Double = (line_ac * line_ac + line_cd * line_cd - line_da * line_da);
        let result_down_sub : Double = 2 * line_ac * line_cd;
        let result_sub : Double = result_up_sub / result_down_sub;
        let cosX_sub : Double = acos(result_sub);
        let degree_sub : Double = (cosX_sub * 180.0 / .pi);
                // 런지 자세 판별 (50도~90도)
                //print("런지각도모음(왼쪽발목 - 엉덩이 - 오른쪽발목)", String.valueOf(degree_sub));
                /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        if(degree_sub>20){
            print("런지 예외처리1", "측정가능 - 다리 벌리는 중 O");
            
            if ( (degree_left >= 140 && degree_right >= 140) && pose_status == false) {
                // 1단계
                // 준비 중, 인식 X
                print("동작인식 각도 순서", "1단계");
                print("동작인식 각도 결과값", "준비 중, 인식 X");
                PoseInformation.pose_status = false;
                PoseInformation.pose_degree = 140.0;
            } else if ( (degree_left < 110 && degree_right < 110) && pose_status == false) {
                // 2단계
                // 런지 중, 인식 X
                print("동작인식 각도 순서", "2단계");
                print("동작인식 각도 결과값", "런지 중, 인식 X");
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
                print("동작인식 각도 순서", "3단계");
                print("동작인식 각도 결과값", "런지 중, 인식 O");
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
                print("동작인식 각도 순서", "4단계");
                print("동작인식 각도 결과값", "준비 중, 인식 O");
                print("동작인식 각도 결과값", "==============");
                print("동작인식 각도 결과값", "카운트하기");
                print("동작인식 각도 결과값", "==============");
                PoseInformation.pose_status = false;
                PoseInformation.pose_count = PoseInformation.pose_count + 1;
                PoseInformation.count_check_bool = true
            }
            
            
        }else{
            print("런지 예외처리1", "측정불가 - 다리 벌리는 중 X");
        }
        
        
        
        
    }
    
    public func dumbbelllow_data(pose_count : Int, pose_status : Bool,
                                 a1 : Double, a2 : Double, b1 : Double,  b2 : Double,  c1 : Double,  c2 : Double,
                                 d1 : Double,  d2 : Double,  e1 : Double,  e2 : Double,  f1 : Double,  f2 : Double,
                                 g1 : Double,  g2 : Double,  h1 : Double,  h2 : Double,  i1 : Double,  i2 : Double) {
        print("덤벨로우 변수", (pose_status));
        print("덤벨로우 개수", (pose_count));
        
        let line_ab : Double = sqrt(pow(a1 - b1, 2) + pow(a2 - b2, 2));
        let line_bc : Double = sqrt(pow(b1 - c1, 2) + pow(b2 - c2, 2));
        let line_ca : Double = sqrt(pow(c1 - a1, 2) + pow(c2 - a2, 2));
        
        let result_up : Double = (line_ab * line_ab + line_bc * line_bc - line_ca * line_ca);
        let result_down : Double = 2 * line_ab * line_bc;
        let result : Double = result_up / result_down;
        
        let cosX : Double = acos(result);
        let degree : Double = (cosX * 180.0 / .pi);
        // 70 ~ 145
        //print("덤벨로우각도모음", String.valueOf(degree));
        
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 예외처리1 -  (머리, 엉덩이, 발목) - 덤벨로우 준비자세(130도 이하)
        let line_de : Double = sqrt(pow(d1 - e1, 2) + pow(d2 - e2, 2));
        let line_ef : Double = sqrt(pow(e1 - f1, 2) + pow(e2 - f2, 2));
        let line_fd : Double = sqrt(pow(f1 - d1, 2) + pow(f2 - d2, 2));
        let result_up_sub : Double = (line_de * line_de + line_ef * line_ef - line_fd * line_fd);
        let result_down_sub : Double = 2 * line_de * line_ef;
        let result_sub : Double = result_up_sub / result_down_sub;
        let cosX_sub : Double = acos(result_sub);
        let degree_sub : Double = (cosX_sub * 180.0 / .pi);
        // 준비자세 여부 파악 (90도정도)
        //print("덤벨로우각도모음(준비자세)", String.valueOf(degree_sub));
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        //  예외처리2 -  (머리> 엉덩이> 발목) - 누워서 할 경우 대비
        var stand_up : Bool = false;
        if(d2<=e2 && e2<=f2 ){
            print("덤벨로우 머리>엉덩이>발목", "O");
            stand_up = true;
        }else{
            print("덤벨로우 머리>엉덩이>발목", "X");
            stand_up = false;
        }
        /*
        print("덤벨로우 머리 좌표", String.valueOf(d1) + "/" + String.valueOf(d2));
        print("덤벨로우 엉덩이 좌표", String.valueOf(e1) + "/" + String.valueOf(e2));
        print("덤벨로우 발목 좌표", String.valueOf(f1) + "/" + String.valueOf(f2));
        */
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 예외처리3 -  (엉덩이 - 무릎 - 발목) - 덤벨로우 준비자세2 (140도 이하)
        let line_gh : Double = sqrt(pow(g1 - h1, 2) + pow(g2 - h2, 2));
        let line_hi : Double = sqrt(pow(h1 - i1, 2) + pow(h2 - i2, 2));
        let line_ig : Double = sqrt(pow(i1 - g1, 2) + pow(i2 - g2, 2));
        let result_up_sub2 : Double = (line_gh * line_gh + line_hi * line_hi - line_ig * line_ig);
        let result_down_sub2 : Double = 2 * line_gh * line_hi;
        let result_sub2 : Double = result_up_sub2 / result_down_sub2;
        let cosX_sub2 : Double = acos(result_sub2);
        let degree_sub2 : Double = (cosX_sub2 * 180.0 / .pi);
        // 준비자세2 여부 파악 (130도정도)
        //print("덤벨로우각도모음(준비자세2)", String.valueOf(degree_sub2));
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 예외처리4 -  (어깨 >> 손목) - 손목보다 어깨가 위에 위치
        var hand_down : Bool = false;
        if(a2 < c2 ){
            print("덤벨로우 어깨 >> 손목", "O");
            hand_down = true;
        }else{
            print("덤벨로우 어깨 >> 손목", "X");
            hand_down = false;
        }
        /*
        print("덤벨로우 어깨 좌표", String.valueOf(a1) + "/" + String.valueOf(a2));
        print("덤벨로우 손목 좌표", String.valueOf(c1) + "/" + String.valueOf(c2));
        */
        
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        if(stand_up){
            print("덤벨로우 예외처리2", "측정가능 - 머리>엉덩이>발목 O");
            
            if(hand_down){
                print("덤벨로우 예외처리4", "측정가능 - 덤벨로우 어깨 >> 손목 O");
                
                if (degree_sub < 130 ) {
                    print("덤벨로우 예외처리1", "측정가능 - 덤벨로우 준비자세 O");
                    
                    if (degree_sub2 < 150 ) {
                        print("덤벨로우 예외처리3", "측정가능 - 덤벨로우 준비자세2 O");
                        
                        if (degree >= 130 && pose_status == false) {
                            // 1단계
                            // 준비 중, 인식 X
                            print("동작인식 각도 순서", "1단계");
                            print("동작인식 각도 결과값", "준비 중, 인식 X");
                            PoseInformation.pose_status = false;
                            PoseInformation.pose_degree = 130.0;
                        } else if (degree < 110 && pose_status == false) {
                            // 2단계
                            // 덤벨로우 중, 인식 X
                            print("동작인식 각도 순서", "2단계");
                            print("동작인식 각도 결과값", "덤벨로우 중, 인식 X");
                            PoseInformation.pose_status = true;
                            if (degree < PoseInformation.pose_degree) {
                                PoseInformation.pose_degree = degree;
                            }
                        } else if (degree < 110 && pose_status == true) {
                            // 3단계
                            // 덤벨로우 중, 인식 O
                            print("동작인식 각도 순서", "3단계");
                            print("동작인식 각도 결과값", "덤벨로우 중, 인식 O");
                            PoseInformation.pose_status = true;
                            if (degree < PoseInformation.pose_degree) {
                                PoseInformation.pose_degree = degree;
                            }
                        } else if (degree >= 130 && pose_status == true) {
                            // 4단계
                            // 준비 중, 인식 O
                            print("동작인식 각도 순서", "4단계");
                            print("동작인식 각도 결과값", "준비 중, 인식 O");
                            print("동작인식 각도 결과값", "==============");
                            print("동작인식 각도 결과값", "카운트하기");
                            print("동작인식 각도 결과값", "==============");
                            PoseInformation.pose_status = false;
                            PoseInformation.pose_count = PoseInformation.pose_count + 1;
                            PoseInformation.count_check_bool = true
                        }
                        
                    }else{
                        print("덤벨로우 예외처리3", "측정가능 - 덤벨로우 준비자세2 O");
                    }
                    
                } else {
                    print("덤벨로우 예외처리1", "측정불가 - 덤벨로우 준비자세 X");
                }
                
            }else{
                print("덤벨로우 예외처리4", "측정불가 - 덤벨로우 어깨 >> 손목 X");
            }
            
        }else{
            print("덤벨로우 예외처리2", "측정불가 - 머리>엉덩이>발목 X");
        }
        
    }
    
    
}
