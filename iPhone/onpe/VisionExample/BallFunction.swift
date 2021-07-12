//
//  BallFunction.swift
//  VisionExample
//
//  Created by Ik ju Song on 2021/02/14.
//  Copyright © 2021 Google Inc. All rights reserved.
//

import Foundation

public class BallFunction {

    let TAG : String = "메서드";

    //저글링 1단계 (공 하나, 위아래)
    public func step1(){

        print(TAG, "저글링 개수 : \(BallInformation.ball_count)");
        print(TAG, "저글링 배열 : \(BallInformation.ball_arraylist)");

        if(BallInformation.ball_arraylist.count > 0 && BallInformation.ball_arraylist[0] != "down"){
            //첫번째 배열의 시작이 1사분면이 아닐 경우 -> BallInformation.ball_arraylist 초기화
            print(TAG, "공 배열 : 오류 -> 배열 초기화");
            BallInformation.ball_arraylist.removeAll()

        }else{
            if((BallInformation.ball_position_red == 1 || BallInformation.ball_position_red == 4) && BallInformation.ball_arraylist.count==0){
                print(TAG, "step1-0단계");
                print(TAG, "공: 아래, 던지기 전");
                BallInformation.ball_arraylist.append("down");
            }else if((BallInformation.ball_position_red == 1 || BallInformation.ball_position_red == 4) && BallInformation.ball_arraylist.count == 1) {
                print(TAG, "step1-1단계");
                print(TAG, "공: 아래, 던지기 전");
            }else if((BallInformation.ball_position_red == 2 || BallInformation.ball_position_red == 3) &&  BallInformation.ball_arraylist.count == 1 && BallInformation.ball_arraylist[0] == "down"){
                print(TAG, "step1-2단계");
                print(TAG, "공: 위로 던진 후 위치인식 X");
                BallInformation.ball_arraylist.append("up");
            }else if((BallInformation.ball_position_red == 2 || BallInformation.ball_position_red == 3) && BallInformation.ball_arraylist.count == 2 && BallInformation.ball_arraylist[0] == "down" &&
                    BallInformation.ball_arraylist[1] == "up"){
                print(TAG, "step1-3단계");
                print(TAG, "공: 위로 던진 후 위치인식 O");
            }else if((BallInformation.ball_position_red == 1 || BallInformation.ball_position_red == 4) && BallInformation.ball_arraylist.count==2){
                print(TAG, "step1-4단계");
                print(TAG, "공: 아래 되돌아온 후 위치인식 X");
                BallInformation.ball_arraylist.append("down");
            }else if((BallInformation.ball_position_red == 1 || BallInformation.ball_position_red == 4) && BallInformation.ball_arraylist.count == 3 && BallInformation.ball_arraylist[0] == "down" &&
                    BallInformation.ball_arraylist[1] == "up" && BallInformation.ball_arraylist[2] == "down"){
                print(TAG, "step1-5단계");
                print(TAG, "공: 아래 되돌아온 후 위치인식 O");
                //개수 올리기
                BallInformation.ball_count = BallInformation.ball_count+1;
                BallInformation.ball_arraylist.removeAll()
            }else{
                BallInformation.ball_arraylist.removeAll()
            }


        }

    }

    //저글링 2단계 (공 하나,양옆)
    public func step2(){

        print(TAG, "저글링 개수 : \(BallInformation.ball_count)");
        print(TAG, "저글링 배열 : \(BallInformation.ball_arraylist)");

        if(BallInformation.ball_arraylist.count > 0 && BallInformation.ball_arraylist[0] != "right"){
            //첫번째 배열의 시작이 1사분면이 아닐 경우 -> BallInformation.ball_arraylist 초기화
            print(TAG, "공 배열 : 오류 -> 배열 초기화");
            BallInformation.ball_arraylist.removeAll()

        }else{
            if((BallInformation.ball_position_red == 1 || BallInformation.ball_position_red == 2) && BallInformation.ball_arraylist.count == 0){
                print(TAG, "step1-0단계");
                print(TAG, "공: 우측, 던지기 전");
                BallInformation.ball_arraylist.append("right");
            }else if((BallInformation.ball_position_red == 1 || BallInformation.ball_position_red == 2) && BallInformation.ball_arraylist.count==1) {
                print(TAG, "step1-1단계");
                print(TAG, "공: 우측, 던지기 전");
            }else if((BallInformation.ball_position_red == 3 || BallInformation.ball_position_red == 4) &&  BallInformation.ball_arraylist.count == 1 && BallInformation.ball_arraylist[0] == "right"){
                print(TAG, "step1-2단계");
                print(TAG, "공: 좌측으로 던진 후 위치인식 X");
                BallInformation.ball_arraylist.append("left");
            }else if((BallInformation.ball_position_red == 3 || BallInformation.ball_position_red == 4) && BallInformation.ball_arraylist.count==2 && BallInformation.ball_arraylist[0] == "right" &&
                    BallInformation.ball_arraylist[1] == "left"){
                print(TAG, "step1-3단계");
                print(TAG, "공: 좌측으로 던진 후 위치인식 O");
            }else if((BallInformation.ball_position_red == 1 || BallInformation.ball_position_red == 2) && BallInformation.ball_arraylist.count==2){
                print(TAG, "step1-4단계");
                print(TAG, "공: 우측 되돌아온 후 위치인식 X");
                BallInformation.ball_arraylist.append("right");
            }else if((BallInformation.ball_position_red == 1 || BallInformation.ball_position_red == 2) && BallInformation.ball_arraylist.count==3 && BallInformation.ball_arraylist[0]=="right" &&
                    BallInformation.ball_arraylist[1]=="left" && BallInformation.ball_arraylist[2]=="right"){
                print(TAG, "step1-5단계");
                print(TAG, "공: 우측 되돌아온 후 위치인식 O");
                //개수 올리기
                BallInformation.ball_count = BallInformation.ball_count+1;
                BallInformation.ball_arraylist.removeAll()
            }else{
                BallInformation.ball_arraylist.removeAll()
            }


        }

    }



    //저글링 3단계 (공하나,삼각형,반시계)
    public func step3(){

        print(TAG, "저글링 개수 : \(BallInformation.ball_count)");
        print(TAG, "저글링 배열 :  \(BallInformation.ball_arraylist)");


        if(BallInformation.ball_arraylist.count > 0 && BallInformation.ball_arraylist[0] != "1"){
            //첫번째 배열의 시작이 1사분면이 아닐 경우 -> BallInformation.ball_arraylist 초기화
            print(TAG, "공 배열 : 오류 -> 배열 초기화");
            BallInformation.ball_arraylist.removeAll()

        }else{
            print(TAG, "공 배열 : 정상 -> 배열 추가");

            if(BallInformation.ball_position_red == 1 && BallInformation.ball_arraylist.count==0){
                print(TAG, "step3-0단계");
                print(TAG, "공: 1사분면, 던지기 전");
                BallInformation.ball_arraylist.append("1");
            }else if(BallInformation.ball_position_red == 1 && BallInformation.ball_arraylist.count==1) {
                print(TAG, "step3-1단계");
                print(TAG, "공: 1사분면, 던지기 전");
            }else if(BallInformation.ball_position_red == 2 && BallInformation.ball_arraylist.count==1 && BallInformation.ball_arraylist[0]=="1"){
                print(TAG, "step3-2단계");
                print(TAG, "공: 2사분면, 던진 후, 2사분면 위치인식 X");
                BallInformation.ball_arraylist.append("2");
            }else if(BallInformation.ball_position_red == 2 && BallInformation.ball_arraylist.count==2 && BallInformation.ball_arraylist[0]=="1" &&
                    BallInformation.ball_arraylist[1]=="2"){
                print(TAG, "step3-3단계");
                print(TAG, "공: 2사분면, 던진 후, 2사분면 위치인식 O");
            }else if(BallInformation.ball_position_red == 3 && BallInformation.ball_arraylist.count==2){
                print(TAG, "step3-4단계");
                print(TAG, "공: 3사분면, 던진 후, 3사분면 위치인식 X");
                BallInformation.ball_arraylist.append("3");
            }else if(BallInformation.ball_position_red == 3 && BallInformation.ball_arraylist.count==3 && BallInformation.ball_arraylist[0]=="1" &&
                    BallInformation.ball_arraylist[1]=="2" && BallInformation.ball_arraylist[2]=="3"){
                print(TAG, "step3-5단계");
                print(TAG, "공: 3사분면, 던진 후, 3사분면 위치인식 O");
            }else if(BallInformation.ball_position_red == 4 && BallInformation.ball_arraylist.count==3){
                print(TAG, "step3-6단계");
                print(TAG, "공: 4사분면, 던진 후, 4사분면 위치인식 X");
                BallInformation.ball_arraylist.append("4");
            }else if(BallInformation.ball_position_red == 4 && BallInformation.ball_arraylist.count==4 && BallInformation.ball_arraylist[0]=="1" &&
                    BallInformation.ball_arraylist[1]=="2" && BallInformation.ball_arraylist[2]=="3" && BallInformation.ball_arraylist[3]=="4"){
                print(TAG, "step3-7단계");
                print(TAG, "공: 4사분면, 던진 후, 4사분면 위치인식 O");
            }else if(BallInformation.ball_position_red == 1 && BallInformation.ball_arraylist.count==4){
                print(TAG, "step3-8단계");
                print(TAG, "공: 1사분면, 공 이동 후, 1사분면 위치인식 X");
                BallInformation.ball_arraylist.append("1");
            }else if(BallInformation.ball_position_red == 1 && BallInformation.ball_arraylist.count==5 && BallInformation.ball_arraylist[0]=="1" &&
                    BallInformation.ball_arraylist[1]=="2" && BallInformation.ball_arraylist[2]=="3" && BallInformation.ball_arraylist[3]=="4" &&
                    BallInformation.ball_arraylist[4]=="1"){
                print(TAG, "step3-9단계");
                print(TAG, "공: 1사분면, 공 이동 후, 1사분면 위치인식 O");
                //개수 올리기
                BallInformation.ball_count = BallInformation.ball_count+1;
                BallInformation.ball_arraylist.removeAll()
            }else{
                //나머지의 경우 공 배열 초기화
                BallInformation.ball_arraylist.removeAll()
            }
        }
    }

    //저글링 4단계 (공 하나, 산모양)
    public func step4(){

        print(TAG, "저글링 개수 : \(BallInformation.ball_count)");
        print(TAG, "저글링 배열 : \(BallInformation.ball_arraylist)");

        if(BallInformation.ball_arraylist.count > 0 && BallInformation.ball_arraylist[0] != "1"){
            //첫번째 배열의 시작이 1사분면이 아닐 경우 -> BallInformation.ball_arraylist 초기화
            print(TAG, "공 배열 : 오류 -> 배열 초기화");
            BallInformation.ball_arraylist.removeAll()

        }else{
            print(TAG, "공 배열 : 정상 -> 배열 추가");
            if(BallInformation.ball_position_red == 1 && BallInformation.ball_arraylist.count==0){
                print(TAG, "step4-0단계");
                print(TAG, "공: 1사분면, 던지기 전");
                BallInformation.ball_arraylist.append("1");
            }else if(BallInformation.ball_position_red == 1 && BallInformation.ball_arraylist.count==1) {
                print(TAG, "step4-1단계");
                print(TAG, "공: 1사분면, 던지기 전");
            }else if(BallInformation.ball_position_red == 2 && BallInformation.ball_arraylist.count==1  && BallInformation.ball_arraylist[0]=="1"){
                print(TAG, "step4-2단계");
                print(TAG, "공: 2사분면, 던진 후, 2사분면 위치인식 X");
                BallInformation.ball_arraylist.append("2");
            }else if(BallInformation.ball_position_red == 2 && BallInformation.ball_arraylist.count==2 && BallInformation.ball_arraylist[0]=="1" &&
                    BallInformation.ball_arraylist[1]=="2"){
                print(TAG, "step4-3단계");
                print(TAG, "공: 2사분면, 던진 후, 2사분면 위치인식 O");
            }else if(BallInformation.ball_position_red == 3 && BallInformation.ball_arraylist.count==2 ){
                print(TAG, "step4-4단계");
                print(TAG, "공: 3사분면, 던진 후, 3사분면 위치인식 X");
                BallInformation.ball_arraylist.append("3");
            }else if(BallInformation.ball_position_red == 3 && BallInformation.ball_arraylist.count==3 && BallInformation.ball_arraylist[0]=="1" &&
                    BallInformation.ball_arraylist[1]=="2" && BallInformation.ball_arraylist[2]=="3"){
                print(TAG, "step4-5단계");
                print(TAG, "공: 3사분면, 던진 후, 3사분면 위치인식 O");
            }else if(BallInformation.ball_position_red == 4 && BallInformation.ball_arraylist.count==3){
                print(TAG, "step4-6단계");
                print(TAG, "공: 4사분면, 던진 후, 4사분면 위치인식 X");
                //개수 추가
                BallInformation.ball_count = BallInformation.ball_count+1;
                BallInformation.ball_arraylist.append("4");
            }else if(BallInformation.ball_position_red == 4 && BallInformation.ball_arraylist.count==4 && BallInformation.ball_arraylist[0]=="1" &&
                    BallInformation.ball_arraylist[1]=="2" && BallInformation.ball_arraylist[2]=="3" && BallInformation.ball_arraylist[3]=="4"){
                print(TAG, "step4-7단계");
                print(TAG, "공: 4사분면, 던진 후, 4사분면 위치인식 O");
            }else if(BallInformation.ball_position_red == 3 && BallInformation.ball_arraylist.count==4){
                print(TAG, "step4-8단계");
                print(TAG, "공: 3사분면, 던진 후, 3사분면 위치인식 X");
                BallInformation.ball_arraylist.append("3");
            }else if(BallInformation.ball_position_red == 3 && BallInformation.ball_arraylist.count==5 && BallInformation.ball_arraylist[0]=="1" &&
                    BallInformation.ball_arraylist[1]=="2" && BallInformation.ball_arraylist[2]=="3" && BallInformation.ball_arraylist[3]=="4" &&
                    BallInformation.ball_arraylist[4]=="3"){
                print(TAG, "step4-9단계");
                print(TAG, "공: 3사분면, 던진 후, 3사분면 위치인식 O");
            }else if(BallInformation.ball_position_red == 2 && BallInformation.ball_arraylist.count==5){
                print(TAG, "step4-10단계");
                print(TAG, "공: 2사분면, 던진 후, 2사분면 위치인식 X");
                BallInformation.ball_arraylist.append("2");
            }else if(BallInformation.ball_position_red == 2 && BallInformation.ball_arraylist.count==6 && BallInformation.ball_arraylist[0]=="1" &&
                    BallInformation.ball_arraylist[1]=="2" && BallInformation.ball_arraylist[2]=="3" && BallInformation.ball_arraylist[3]=="4" &&
                    BallInformation.ball_arraylist[4]=="3" && BallInformation.ball_arraylist[5]=="2" ){
                print(TAG, "step4-11단계");
                print(TAG, "공: 2사분면, 던진 후, 2사분면 위치인식 O");
            }else if(BallInformation.ball_position_red == 1 && BallInformation.ball_arraylist.count==6){
                print(TAG, "step4-12단계");
                print(TAG, "공: 1사분면, 던진 후, 1사분면 위치인식 X");
                BallInformation.ball_arraylist.append("1");
            }else if(BallInformation.ball_position_red == 1 && BallInformation.ball_arraylist.count==7 && BallInformation.ball_arraylist[0]=="1" &&
                    BallInformation.ball_arraylist[1]=="2" && BallInformation.ball_arraylist[2]=="3" && BallInformation.ball_arraylist[3]=="4" &&
                    BallInformation.ball_arraylist[4]=="3" && BallInformation.ball_arraylist[5]=="2" && BallInformation.ball_arraylist[6]=="1"){
                print(TAG, "step4-13단계");
                print(TAG, "공: 1사분면, 던진 후, 1사분면 위치인식 O");
                //개수 올리기
                BallInformation.ball_count = BallInformation.ball_count+1;
                BallInformation.ball_arraylist.removeAll()
            }else{
                //나머지의 경우 공 배열 초기화
                BallInformation.ball_arraylist.removeAll()
            }

        }



    }


    //저글링 5단계 (공 2개, 나란히 위아래)
    public func step5(){

        print(TAG, "저글링 개수 : \(BallInformation.ball_count)");
        print(TAG, "저글링 배열 : \(BallInformation.ball_arraylist)");


        if((BallInformation.ball_position_red == 1 || BallInformation.ball_position_red == 4) && (BallInformation.ball_position_blue == 1 || BallInformation.ball_position_blue == 4) && BallInformation.ball_arraylist.count==0){
            print(TAG, "step5-0단계");
            print(TAG, "빨간공: 아래, 던지기 전");
            print(TAG, "파란공: 아래, 던지기 전");
            BallInformation.ball_arraylist.append("down");
        }else if((BallInformation.ball_position_red == 1 || BallInformation.ball_position_red == 4) && (BallInformation.ball_position_blue == 1 || BallInformation.ball_position_blue == 4) && BallInformation.ball_arraylist.count==1){
            print(TAG, "step5-1단계");
            print(TAG, "빨간공: 아래, 던지기 전");
            print(TAG, "파란공: 아래, 던지기 전");
        }else if((BallInformation.ball_position_red == 2 || BallInformation.ball_position_red == 3) && (BallInformation.ball_position_blue == 2 ||
                BallInformation.ball_position_blue == 3) && BallInformation.ball_arraylist.count==1 && BallInformation.ball_arraylist[0]=="down"){
            print(TAG, "step5-2단계");
            print(TAG, "빨간공: 위로 던진 후 위치인식 X");
            print(TAG, "파란공: 위로 던진 후 위치인식 X");
            BallInformation.ball_arraylist.append("up");
        }else if((BallInformation.ball_position_red == 2 || BallInformation.ball_position_red == 3) && (BallInformation.ball_position_blue == 2 || BallInformation.ball_position_blue == 3)
                && BallInformation.ball_arraylist.count==2 && BallInformation.ball_arraylist[0]=="down" && BallInformation.ball_arraylist[1]=="up"){
            print(TAG, "step5-3단계");
            print(TAG, "빨간공: 위로 던진 후 위치인식 O");
            print(TAG, "파란공: 위로 던진 후 위치인식 O");
        }else if((BallInformation.ball_position_red == 1 || BallInformation.ball_position_red == 4) && (BallInformation.ball_position_blue == 1 || BallInformation.ball_position_blue == 4)
                && BallInformation.ball_arraylist.count==2 ){
            print(TAG, "step5-4단계");
            print(TAG, "빨간공: 아래로 되돌아온 후, 위치인식 X");
            print(TAG, "파란공: 아래로 되돌아온 후, 위치인식 X");
            BallInformation.ball_arraylist.append("down");
        }else if((BallInformation.ball_position_red == 1 || BallInformation.ball_position_red == 4) && (BallInformation.ball_position_blue == 1 || BallInformation.ball_position_blue == 4)
                && BallInformation.ball_arraylist.count==3 && BallInformation.ball_arraylist[0]=="down" && BallInformation.ball_arraylist[1]=="up" && BallInformation.ball_arraylist[2]=="down" ){
            print(TAG, "step5-5단계");
            print(TAG, "빨간공: 아래로 되돌아온 후, 위치인식 O");
            print(TAG, "파란공: 아래로 되돌아온 후, 위치인식 O");
            BallInformation.ball_count = BallInformation.ball_count+1;
            BallInformation.ball_arraylist.removeAll()
        }

    }

    //저글링 6단계 (공 2개, 엇갈려 위아래)
    public func step6(){

        print(TAG, "저글링 개수 : \(BallInformation.ball_count)");
        print(TAG, "저글링 배열 : \(BallInformation.ball_arraylist)");


        if((BallInformation.ball_position_red == 1 || BallInformation.ball_position_red == 4) && (BallInformation.ball_position_blue == 2 || BallInformation.ball_position_blue == 3) && BallInformation.ball_arraylist.count==0){
            print(TAG, "step6-0단계");
            print(TAG, "빨간공: 아래, 던지기 전");
            print(TAG, "파란공: 위, 던진 후");
            BallInformation.ball_arraylist.append("down");
        }else if((BallInformation.ball_position_red == 1 || BallInformation.ball_position_red == 4) && (BallInformation.ball_position_blue == 2 || BallInformation.ball_position_blue == 3) && BallInformation.ball_arraylist.count==1){
            print(TAG, "step6-1단계");
            print(TAG, "빨간공: 아래, 던지기 전");
            print(TAG, "파란공: 위, 던진 후");
        }else if((BallInformation.ball_position_red == 2 || BallInformation.ball_position_red == 3) && (BallInformation.ball_position_blue == 1 || BallInformation.ball_position_blue == 4)
                && BallInformation.ball_arraylist.count==1 && BallInformation.ball_arraylist[0]=="down"){
            print(TAG, "step6-2단계");
            print(TAG, "빨간공: 위로 던진 후 위치인식 X");
            print(TAG, "파란공: 아래로 뒤돌아온 후 위치인식 X");
            BallInformation.ball_arraylist.append("up");
        }else if((BallInformation.ball_position_red == 2 || BallInformation.ball_position_red == 3) && (BallInformation.ball_position_blue == 1 || BallInformation.ball_position_blue == 4)
                && BallInformation.ball_arraylist.count==2 && BallInformation.ball_arraylist[0]=="down" && BallInformation.ball_arraylist[1]=="up"){
            print(TAG, "step6-3단계");
            print(TAG, "빨간공: 위로 던진 후 위치인식 O");
            print(TAG, "파란공: 아래로 뒤돌아온 후 위치인식 O");
        }else if((BallInformation.ball_position_red == 1 || BallInformation.ball_position_red == 4) && (BallInformation.ball_position_blue == 2 || BallInformation.ball_position_blue == 3)
                && BallInformation.ball_arraylist.count==2 ){
            print(TAG, "step6-4단계");
            print(TAG, "빨간공: 아래로 되돌아온 후, 위치인식 X");
            print(TAG, "파란공: 위로 던진 후, 위치인식 X");
            BallInformation.ball_arraylist.append("down");
        }else if((BallInformation.ball_position_red == 1 || BallInformation.ball_position_red == 4) && (BallInformation.ball_position_blue == 2 || BallInformation.ball_position_blue == 3)
                && BallInformation.ball_arraylist.count==3 && BallInformation.ball_arraylist[0]=="down" && BallInformation.ball_arraylist[1]=="up" && BallInformation.ball_arraylist[2]=="down" ){
            print(TAG, "step6-5단계");
            print(TAG, "빨간공: 아래로 되돌아온 후, 위치인식 O");
            print(TAG, "파란공: 위로 던진 후, 위치인식 O");
            BallInformation.ball_count = BallInformation.ball_count+1;
            BallInformation.ball_arraylist.removeAll()
        }

    }

    //저글링 7단계 (공 2개, 삼각형 저글링) (반시계방향)
    public func step7(){

        print(TAG, "저글링 개수 : \(BallInformation.ball_count)");
        print(TAG, "저글링 배열 : \(BallInformation.ball_arraylist)");


        if(BallInformation.ball_arraylist.count > 0 && BallInformation.ball_arraylist[0] != "1"){
            //첫번째 배열의 시작이 1사분면이 아닐 경우 -> BallInformation.ball_arraylist 초기화
            print(TAG, "공 배열 : 오류 -> 배열 초기화");
            BallInformation.ball_arraylist.removeAll()

        }else{
            print(TAG, "공 배열 : 정상 -> 배열 추가");

            if(BallInformation.ball_position_red == 1  && BallInformation.ball_position_blue == 4  && BallInformation.ball_arraylist.count==0){
                print(TAG, "step7-0단계");
                print(TAG, "빨간공: 1사분면 - 인식 X");
                print(TAG, "파란공: 4사분면 - 인식 X");
                BallInformation.ball_arraylist.append("1");
            }else if(BallInformation.ball_position_red == 1 && BallInformation.ball_position_blue == 4 && BallInformation.ball_arraylist.count==1) {
                print(TAG, "step7-1단계");
                print(TAG, "빨간공: 1사분면 - 인식 O");
                print(TAG, "파란공: 4사분면 - 인식 O");
            }else if(BallInformation.ball_position_red == 2 && (BallInformation.ball_position_blue == 4  || BallInformation.ball_position_blue == 1) && BallInformation.ball_arraylist.count==1 && BallInformation.ball_arraylist[0]=="1"){
                print(TAG, "step7-2단계");
                print(TAG, "빨간공: 2사분면 - 인식 X");
                print(TAG, "파란공: 1 or 4사분면 - 인식 X");
                BallInformation.ball_arraylist.append("2");
            }else if(BallInformation.ball_position_red == 2  && (BallInformation.ball_position_blue == 4  || BallInformation.ball_position_blue == 1) && BallInformation.ball_arraylist.count==2 && BallInformation.ball_arraylist[0]=="1" &&
                    BallInformation.ball_arraylist[1]=="2"){
                print(TAG, "step7-3단계");
                print(TAG, "빨간공: 2사분면 - 인식 O");
                print(TAG, "파란공: 1 or 4사분면 - 인식 O");
            }else if(BallInformation.ball_position_red == 3 && (BallInformation.ball_position_blue == 4  || BallInformation.ball_position_blue == 1) && BallInformation.ball_arraylist.count==2){
                print(TAG, "step7-4단계");
                print(TAG, "빨간공: 3사분면 - 인식 X");
                print(TAG, "파란공: 1 or 4사분면 - 인식 X");
                BallInformation.ball_arraylist.append("3");
            }else if(BallInformation.ball_position_red == 3 && (BallInformation.ball_position_blue == 4  || BallInformation.ball_position_blue == 1) && BallInformation.ball_arraylist.count==3 && BallInformation.ball_arraylist[0]=="1" &&
                    BallInformation.ball_arraylist[1]=="2" && BallInformation.ball_arraylist[2]=="3"){
                print(TAG, "step7-5단계");
                print(TAG, "빨간공: 3사분면 - 인식 O");
                print(TAG, "파란공: 1 or 4사분면 - 인식 O");
            }else if(BallInformation.ball_position_red == 4 && BallInformation.ball_position_blue == 1 && BallInformation.ball_arraylist.count==3){
                print(TAG, "step7-6단계");
                print(TAG, "빨간공: 4사분면 - 인식 X");
                print(TAG, "파란공: 1사분면 - 인식 X");
                BallInformation.ball_arraylist.append("4");
            }else if(BallInformation.ball_position_red == 4 && BallInformation.ball_position_blue == 1 && BallInformation.ball_arraylist.count==4 && BallInformation.ball_arraylist[0]=="1" &&
                    BallInformation.ball_arraylist[1]=="2" && BallInformation.ball_arraylist[2]=="3" && BallInformation.ball_arraylist[3]=="4"){
                print(TAG, "step7-7단계");
                print(TAG, "빨간공: 4사분면 - 인식 O");
                print(TAG, "파란공: 1사분면 - 인식 O");
            }else if(BallInformation.ball_position_red == 1 && BallInformation.ball_position_blue == 4 && BallInformation.ball_arraylist.count==4){
                print(TAG, "step7-8단계");
                print(TAG, "빨간공: 1사분면 - 인식 X");
                print(TAG, "파란공: 4사분면 - 인식 X");
                BallInformation.ball_arraylist.append("1");
            }else if(BallInformation.ball_position_red == 1 && BallInformation.ball_position_blue == 4 && BallInformation.ball_arraylist.count==5 && BallInformation.ball_arraylist[0]=="1" &&
                    BallInformation.ball_arraylist[1]=="2" && BallInformation.ball_arraylist[2]=="3" && BallInformation.ball_arraylist[3]=="4" &&
                    BallInformation.ball_arraylist[4]=="1"){
                print(TAG, "step7-9단계");
                print(TAG, "빨간공: 1사분면 - 인식 O");
                print(TAG, "파란공: 4사분면 - 인식 O");
                //개수 올리기
                BallInformation.ball_count = BallInformation.ball_count+1;
                BallInformation.ball_arraylist.removeAll()
            }
        }
    }

    //저글링 8단계 (공 2개, 삼각형 저글링) (시계방향)
    public func step8(){

        print(TAG, "저글링 개수 : \(BallInformation.ball_count)");
        print(TAG, "저글링 배열 : \(BallInformation.ball_arraylist)");


        if(BallInformation.ball_arraylist.count > 0 && BallInformation.ball_arraylist[0] != "4"){
            //첫번째 배열의 시작이 1사분면이 아닐 경우 -> BallInformation.ball_arraylist 초기화
            print(TAG, "공 배열 : 오류 -> 배열 초기화");
            BallInformation.ball_arraylist.removeAll()

        }else{
            print(TAG, "공 배열 : 정상 -> 배열 추가");

            if(BallInformation.ball_position_blue == 4  && BallInformation.ball_position_red == 1  && BallInformation.ball_arraylist.count==0){
                print(TAG, "step8-0단계");
                print(TAG, "파란공: 4사분면 - 인식 X");
                print(TAG, "빨간공: 1사분면 - 인식 X");
                BallInformation.ball_arraylist.append("4");
            }else if(BallInformation.ball_position_blue == 4 && BallInformation.ball_position_red == 1 && BallInformation.ball_arraylist.count==1) {
                print(TAG, "step8-1단계");
                print(TAG, "파란공: 4사분면 - 인식 O");
                print(TAG, "빨간공: 1사분면 - 인식 O");
            }else if(BallInformation.ball_position_blue == 3 && (BallInformation.ball_position_red == 4  || BallInformation.ball_position_red == 1) && BallInformation.ball_arraylist.count==1 && BallInformation.ball_arraylist[0]=="4"){
                print(TAG, "step8-2단계");
                print(TAG, "파란공: 3사분면 - 인식 X");
                print(TAG, "빨간공: 1 or 4사분면 - 인식 X");
                BallInformation.ball_arraylist.append("3");
            }else if(BallInformation.ball_position_blue == 3  && (BallInformation.ball_position_red == 4  || BallInformation.ball_position_red == 1) && BallInformation.ball_arraylist.count==2 && BallInformation.ball_arraylist[0]=="4" &&
                    BallInformation.ball_arraylist[1]=="3"){
                print(TAG, "step8-3단계");
                print(TAG, "파란공: 3사분면 - 인식 O");
                print(TAG, "빨간공: 1 or 4사분면 - 인식 O");
            }else if(BallInformation.ball_position_blue == 2 && (BallInformation.ball_position_red == 4  || BallInformation.ball_position_red == 1) && BallInformation.ball_arraylist.count==2){
                print(TAG, "step8-4단계");
                print(TAG, "파란공: 2사분면 - 인식 X");
                print(TAG, "빨간공: 1 or 4사분면 - 인식 X");
                BallInformation.ball_arraylist.append("2");
            }else if(BallInformation.ball_position_blue == 2 && (BallInformation.ball_position_red == 4  || BallInformation.ball_position_red == 1) && BallInformation.ball_arraylist.count==3 && BallInformation.ball_arraylist[0]=="4" &&
                    BallInformation.ball_arraylist[1]=="3" && BallInformation.ball_arraylist[2]=="2"){
                print(TAG, "step8-5단계");
                print(TAG, "파란공: 2사분면 - 인식 O");
                print(TAG, "빨간공: 1 or 4사분면 - 인식 O");
            }else if(BallInformation.ball_position_blue == 1 && BallInformation.ball_position_red == 4 && BallInformation.ball_arraylist.count==3){
                print(TAG, "step8-6단계");
                print(TAG, "파란공: 1사분면 - 인식 X");
                print(TAG, "빨간공: 4사분면 - 인식 X");
                BallInformation.ball_arraylist.append("1");
            }else if(BallInformation.ball_position_blue == 1 && BallInformation.ball_position_red == 4 && BallInformation.ball_arraylist.count==4 && BallInformation.ball_arraylist[0]=="4" &&
                    BallInformation.ball_arraylist[1]=="3" && BallInformation.ball_arraylist[2]=="2" && BallInformation.ball_arraylist[3]=="1"){
                print(TAG, "step8-7단계");
                print(TAG, "파란공: 1사분면 - 인식 O");
                print(TAG, "빨간공: 4사분면 - 인식 O");
            }else if(BallInformation.ball_position_blue == 4 && BallInformation.ball_position_red == 1 && BallInformation.ball_arraylist.count==4){
                print(TAG, "step8-8단계");
                print(TAG, "파란공: 4사분면 - 인식 X");
                print(TAG, "빨간공: 1사분면 - 인식 X");
                BallInformation.ball_arraylist.append("4");
            }else if(BallInformation.ball_position_blue == 4 && BallInformation.ball_position_red == 1 && BallInformation.ball_arraylist.count==5 && BallInformation.ball_arraylist[0]=="4" &&
                    BallInformation.ball_arraylist[1]=="3" && BallInformation.ball_arraylist[2]=="2" && BallInformation.ball_arraylist[3]=="1" &&
                    BallInformation.ball_arraylist[4]=="4"){
                print(TAG, "step8-9단계");
                print(TAG, "파란공: 4사분면 - 인식 O");
                print(TAG, "빨간공: 1사분면 - 인식 O");
                //개수 올리기p
                BallInformation.ball_count = BallInformation.ball_count+1;
                BallInformation.ball_arraylist.removeAll()
            }
        }
    }


    //저글링 9단계 (공 2개, 산모양 저글링)
    public func step9(){

        print(TAG, "저글링 개수 : \(BallInformation.ball_count)");
        print(TAG, "저글링 배열 : \(BallInformation.ball_arraylist)");

        if(BallInformation.ball_arraylist.count > 0 && BallInformation.ball_arraylist[0] != "1"){
            //첫번째 배열의 시작이 1사분면이 아닐 경우 -> BallInformation.ball_arraylist 초기화
            print(TAG, "공 배열 : 오류 -> 배열 초기화");
            BallInformation.ball_arraylist.removeAll()

        }else{
            print(TAG, "공 배열 : 정상 -> 배열 추가");
            if(BallInformation.ball_position_red == 1 && BallInformation.ball_position_blue == 4 && BallInformation.ball_arraylist.count==0){
                print(TAG, "step9-0단계");
                print(TAG, "빨간공: 1사분면, 던지기 전");
                print(TAG, "파란공: 4사분면, 던지기 전");
                BallInformation.ball_arraylist.append("1");
            }else if(BallInformation.ball_position_red == 1 && BallInformation.ball_position_blue == 4 && BallInformation.ball_arraylist.count==1) {
                print(TAG, "step9-1단계");
                print(TAG, "빨간공: 1사분면, 던지기 전");
                print(TAG, "파란공: 4사분면, 던지기 전");
            }else if((BallInformation.ball_position_red == 2 ||  BallInformation.ball_position_red == 3) && BallInformation.ball_arraylist.count==1  && BallInformation.ball_arraylist[0]=="1"){
                print(TAG, "step9-2단계");
                print(TAG, "빨간공: 2,3사분면, 던진 후, 2,3사분면 위치인식 X");
                BallInformation.ball_arraylist.append("up");
            }else if((BallInformation.ball_position_red == 2 ||  BallInformation.ball_position_red == 3) && BallInformation.ball_arraylist.count==2 && BallInformation.ball_arraylist[0]=="1" &&
                    BallInformation.ball_arraylist[1]=="up"){
                print(TAG, "step9-3단계");
                print(TAG, "빨간공: 2,3사분면, 던진 후, 2,3사분면 위치인식 O");
            }else if(BallInformation.ball_position_red == 4 && BallInformation.ball_position_blue == 1  && BallInformation.ball_arraylist.count==2){
                print(TAG, "step9-4단계");
                print(TAG, "빨간공: 4사분면, 던진 후, 4사분면 위치인식 X");
                print(TAG, "파란공: 1사분면, 던진 후, 1사분면 위치인식 X");
                //개수 추가
                BallInformation.ball_count = BallInformation.ball_count+1;
                BallInformation.ball_arraylist.append("4");
            }else if(BallInformation.ball_position_red == 4 && BallInformation.ball_position_blue == 1  && BallInformation.ball_arraylist.count==3 && BallInformation.ball_arraylist[0]=="1" &&
                    BallInformation.ball_arraylist[1]=="up" && BallInformation.ball_arraylist[2]=="4"){
                print(TAG, "step9-5단계");
                print(TAG, "빨간공: 4사분면, 던진 후, 4사분면 위치인식 O");
                print(TAG, "파란공: 1사분면, 던진 후, 1사분면 위치인식 O");
            }else if((BallInformation.ball_position_red == 2 ||  BallInformation.ball_position_red == 3) && BallInformation.ball_arraylist.count==3){
                print(TAG, "step9-6단계");
                print(TAG, "빨간공: 2,3사분면, 던진 후, 2,3사분면 위치인식 X");
                BallInformation.ball_arraylist.append("up");
            }else if((BallInformation.ball_position_red == 2 ||  BallInformation.ball_position_red == 3) && BallInformation.ball_arraylist.count==4 && BallInformation.ball_arraylist[0]=="1" &&
                    BallInformation.ball_arraylist[1]=="up" && BallInformation.ball_arraylist[2]=="4" && BallInformation.ball_arraylist[3]=="up"){
                print(TAG, "step9-7단계");
                print(TAG, "빨간공: 2,3사분면, 던진 후, 2,3사분면 위치인식 O");
            }else if(BallInformation.ball_position_red == 1 && BallInformation.ball_position_blue == 4  && BallInformation.ball_arraylist.count==4){
                print(TAG, "step9-8단계");
                print(TAG, "빨간공: 1사분면, 던진 후, 1사분면 위치인식 X");
                print(TAG, "파란공: 4사분면, 던진 후, 4사분면 위치인식 X");
                BallInformation.ball_arraylist.append("1");
            }else if(BallInformation.ball_position_red == 1 && BallInformation.ball_position_blue == 4 && BallInformation.ball_arraylist.count==5 && BallInformation.ball_arraylist[0]=="1" &&
                    BallInformation.ball_arraylist[1]=="up" && BallInformation.ball_arraylist[2]=="4" && BallInformation.ball_arraylist[3]=="up" &&
                    BallInformation.ball_arraylist[4]=="1"){
                print(TAG, "step9-9단계");
                print(TAG, "빨간공: 1사분면, 던진 후, 1사분면 위치인식 O");
                print(TAG, "파란공: 4사분면, 던진 후, 4사분면 위치인식 O");
                //개수 올리기
                BallInformation.ball_count = BallInformation.ball_count+1;
                BallInformation.ball_arraylist.removeAll()
            }

        }



    }

    //저글링 10단계 (공 2개, 헛갈려 저글링잡기1)
    public func step10(){

        print(TAG, "저글링 개수 : \(BallInformation.ball_count)");
        print(TAG, "저글링 배열 : \(BallInformation.ball_arraylist)");

        if(BallInformation.ball_arraylist.count > 0 && BallInformation.ball_arraylist[0] != "1"){
            //첫번째 배열의 시작이 1사분면이 아닐 경우 -> BallInformation.ball_arraylist 초기화
            print(TAG, "공 배열 : 오류 -> 배열 초기화");
            BallInformation.ball_arraylist.removeAll()

        }else{
            print(TAG, "공 배열 : 정상 -> 배열 추가");
            if(BallInformation.ball_position_red == 1 && BallInformation.ball_position_blue == 4 && BallInformation.ball_arraylist.count==0){
                print(TAG, "step10-0단계");
                print(TAG, "빨간공: 1사분면, 던지기 전");
                print(TAG, "파란공: 4사분면, 던지기 전");
                BallInformation.ball_arraylist.append("1");
            }else if(BallInformation.ball_position_red == 1 && BallInformation.ball_position_blue == 4 && BallInformation.ball_arraylist.count==1) {
                print(TAG, "step10-1단계");
                print(TAG, "빨간공: 1사분면, 던지기 전");
                print(TAG, "파란공: 4사분면, 던지기 전");
            }else if(BallInformation.ball_position_red == 4 && BallInformation.ball_position_blue == 1 && BallInformation.ball_arraylist.count==1  && BallInformation.ball_arraylist[0]=="1"){
                print(TAG, "step10-2단계");
                print(TAG, "빨간공: 4사분면 위치인식 X");
                print(TAG, "파란공: 1사분면 위치인식 X");
                BallInformation.ball_arraylist.append("4");
            }else if(BallInformation.ball_position_red == 4 && BallInformation.ball_position_blue == 1 && BallInformation.ball_arraylist.count==2 && BallInformation.ball_arraylist[0]=="1" &&
                    BallInformation.ball_arraylist[1]=="4"){
                print(TAG, "step10-3단계");
                print(TAG, "빨간공: 4사분면 위치인식 O");
                print(TAG, "파란공: 1사분면 위치인식 O");
            }else if(BallInformation.ball_position_red == 3 && BallInformation.ball_position_blue == 2 && BallInformation.ball_arraylist.count==2){
                print(TAG, "step10-4단계");
                print(TAG, "빨간공: 3사분면, 던진 후, 3사분면 위치인식 X");
                print(TAG, "파란공: 2사분면, 던진 후, 2사분면 위치인식 X");
                BallInformation.ball_arraylist.append("3");
            }else if(BallInformation.ball_position_red == 3 && BallInformation.ball_position_blue == 2 && BallInformation.ball_arraylist.count==3 && BallInformation.ball_arraylist[0]=="1" &&
                    BallInformation.ball_arraylist[1]=="4" && BallInformation.ball_arraylist[2]=="3"){
                print(TAG, "step10-5단계");
                print(TAG, "빨간공: 3사분면, 던진 후, 3사분면 위치인식 O");
                print(TAG, "파란공: 2사분면, 던진 후, 2사분면 위치인식 O");
            }else if(BallInformation.ball_position_red == 4 && BallInformation.ball_position_blue == 1 && BallInformation.ball_arraylist.count==3){
                print(TAG, "step10-6단계");
                print(TAG, "빨간공: 4사분면, 되돌아온 후, 4사분면 위치인식 X");
                print(TAG, "파란공: 1사분면, 되돌아온 후, 1사분면 위치인식 X");
                //개수 올리기p
                BallInformation.ball_count = BallInformation.ball_count+1;
                BallInformation.ball_arraylist.append("4");
            }else if(BallInformation.ball_position_red == 4 && BallInformation.ball_position_blue == 1 && BallInformation.ball_arraylist.count==4 && BallInformation.ball_arraylist[0]=="1" &&
                    BallInformation.ball_arraylist[1]=="4" && BallInformation.ball_arraylist[2]=="3" && BallInformation.ball_arraylist[3]=="4"){
                print(TAG, "step10-7단계");
                print(TAG, "빨간공: 4사분면, 되돌아온 후, 4사분면 위치인식 O");
                print(TAG, "파란공: 1사분면, 되돌아온 후, 1사분면 위치인식 O");
            }else if(BallInformation.ball_position_red == 1 && BallInformation.ball_position_blue == 4  && BallInformation.ball_arraylist.count==4){
                print(TAG, "step10-8단계");
                print(TAG, "빨간공: 1사분면, 되돌아온 후, 1사분면 위치인식 X");
                print(TAG, "파란공: 4사분면, 되돌아온 후, 4사분면 위치인식 X");
                BallInformation.ball_arraylist.append("1");
            }else if(BallInformation.ball_position_red == 1 && BallInformation.ball_position_blue == 4 && BallInformation.ball_arraylist.count==5 && BallInformation.ball_arraylist[0]=="1" &&
                    BallInformation.ball_arraylist[1]=="4" && BallInformation.ball_arraylist[2]=="3" && BallInformation.ball_arraylist[3]=="4"
                    && BallInformation.ball_arraylist[4]=="1"){
                print(TAG, "step10-9단계");
                print(TAG, "빨간공: 1사분면, 되돌아온 후, 1사분면 위치인식 O");
                print(TAG, "파란공: 4사분면, 되돌아온 후, 4사분면 위치인식 O");
            }else if(BallInformation.ball_position_red == 2 && BallInformation.ball_position_blue == 3 && BallInformation.ball_arraylist.count==5){
                print(TAG, "step10-10단계");
                print(TAG, "빨간공: 2사분면, 던진 후, 2사분면 위치인식 X");
                print(TAG, "파란공: 3사분면, 던진 후, 3사분면 위치인식 X");
                BallInformation.ball_arraylist.append("2");
            }else if(BallInformation.ball_position_red == 2 && BallInformation.ball_position_blue == 3 && BallInformation.ball_arraylist.count==6 && BallInformation.ball_arraylist[0]=="1" &&
                    BallInformation.ball_arraylist[1]=="4" && BallInformation.ball_arraylist[2]=="3" && BallInformation.ball_arraylist[3]=="4"
                    && BallInformation.ball_arraylist[4]=="1" && BallInformation.ball_arraylist[5]=="2"){
                print(TAG, "step10-11단계");
                print(TAG, "빨간공: 2사분면, 던진 후, 2사분면 위치인식 O");
                print(TAG, "파란공: 3사분면, 던진 후, 3사분면 위치인식 O");
            }else if(BallInformation.ball_position_red == 1 && BallInformation.ball_position_blue == 4 && BallInformation.ball_arraylist.count==6){
                print(TAG, "step10-12단계");
                print(TAG, "빨간공: 1사분면, 되돌아온 후, 1사분면 위치인식 X");
                print(TAG, "파란공: 4사분면, 되돌아온 후, 4사분면 위치인식 X");
                BallInformation.ball_arraylist.append("1");
            }else if(BallInformation.ball_position_red == 1 && BallInformation.ball_position_blue == 4 && BallInformation.ball_arraylist.count==7 && BallInformation.ball_arraylist[0]=="1" &&
                    BallInformation.ball_arraylist[1]=="4" && BallInformation.ball_arraylist[2]=="3" && BallInformation.ball_arraylist[3]=="4"
                    && BallInformation.ball_arraylist[4]=="1" && BallInformation.ball_arraylist[5]=="2" && BallInformation.ball_arraylist[6]=="1"){
                print(TAG, "step10-13단계");
                print(TAG, "빨간공: 1사분면, 되돌아온 후, 1사분면 위치인식 O");
                print(TAG, "파란공: 4사분면, 되돌아온 후, 4사분면 위치인식 O");
                //개수 올리기p
                BallInformation.ball_count = BallInformation.ball_count+1;
                BallInformation.ball_arraylist.removeAll()
            }

        }

    }

    public func step11(ball1_x : Int, ball1_y : Int, ball2_x : Int, ball2_y : Int) {

        if(BallInformation.ball_arraylist.count > 0 && BallInformation.ball_arraylist[0] != "left"){
            //첫번째 배열의 시작이 left가 아닐 경우 -> BallInformation.ball_arraylist 초기화
            print(TAG, "공 배열 : 오류 -> 배열 초기화");
            BallInformation.ball_arraylist.removeAll()
        }else{
            if (ball1_x - 20 <= ball2_x && ball2_x <= ball1_x + 20 && ball1_y+10 < ball2_y && BallInformation.ball_arraylist.count == 0) {
                print(TAG, "step11-0단계");
                print(TAG, "파란공이 왼쪽에 있는것 인지 X");
                BallInformation.ball_arraylist.append("left");
            } else if (ball1_x - 20 <= ball2_x && ball2_x <= ball1_x + 20 && ball1_y+10 < ball2_y && BallInformation.ball_arraylist.count == 1) {
                print(TAG, "step11-1단계");
                print(TAG, "파란공이 왼쪽에 있는것 인지 O");
            } else if (ball1_y - 20 <= ball2_y && ball2_y <= ball1_y + 20 && ball1_x+10 < ball2_x && BallInformation.ball_arraylist.count == 1 && BallInformation.ball_arraylist[0]=="left") {
                print(TAG, "step11-2단계");
                print(TAG, "파란공이 아래에 있는것 인지 X");
                BallInformation.ball_arraylist.append("down");
            } else if (ball1_y - 20 <= ball2_y && ball2_y <= ball1_y + 20 && ball1_x+10 < ball2_x && BallInformation.ball_arraylist.count == 2) {
                print(TAG, "step11-3단계");
                print(TAG, "파란공이 아래에 있는것 인지 O");
            } else if (ball1_x - 20 <= ball2_x && ball2_x <= ball1_x + 20 && ball1_y > ball2_y+10 && BallInformation.ball_arraylist.count == 2 && BallInformation.ball_arraylist[0]=="left" && BallInformation.ball_arraylist[1]=="down") {
                print(TAG, "step11-4단계");
                print(TAG, "파란공이 오른쪽에 있는것 인지 X");
                BallInformation.ball_arraylist.append("right");
            } else if (ball1_x - 20 <= ball2_x && ball2_x <= ball1_x + 20 && ball1_y > ball2_y+10 && BallInformation.ball_arraylist.count == 3) {
                print(TAG, "step11-5단계");
                print(TAG, "파란공이 오른쪽에 있는것 인지 O");
            } else if (ball1_y - 20 <= ball2_y && ball2_y <= ball1_y + 20 && ball1_x > ball2_x+10 && BallInformation.ball_arraylist.count == 3
                    && BallInformation.ball_arraylist[0]=="left" && BallInformation.ball_arraylist[1]=="down" && BallInformation.ball_arraylist[2]=="right") {
                print(TAG, "step11-6단계");
                print(TAG, "파란공이 위에 있는것 인지 X");
                BallInformation.ball_arraylist.append("up");
            } else if (ball1_y - 20 <= ball2_y && ball2_y <= ball1_y + 20 && ball1_x > ball2_x+10 && BallInformation.ball_arraylist.count == 4) {
                print(TAG, "step11-7단계");
                print(TAG, "파란공이 위에 있는것 인지 O");
            } else if (ball1_x - 20 <= ball2_x && ball2_x <= ball1_x + 20 && ball1_y+10 < ball2_y && BallInformation.ball_arraylist.count == 4
                    && BallInformation.ball_arraylist[0]=="left" && BallInformation.ball_arraylist[1]=="down" && BallInformation.ball_arraylist[2]=="right" && BallInformation.ball_arraylist[3]=="up") {
                print(TAG, "step11-8단계");
                print(TAG, "파란공이 왼쪽에 있는것 인지 X");
                BallInformation.ball_arraylist.append("left");
            } else if (ball1_x - 20 <= ball2_x && ball2_x <= ball1_x + 20 && ball1_y+10 < ball2_y && BallInformation.ball_arraylist.count == 5) {
                print(TAG, "step11-9단계");
                print(TAG, "파란공이 왼쪽에 있는것 인지 O");
                //개수 올리기
                BallInformation.ball_count = BallInformation.ball_count+1;
                BallInformation.ball_arraylist.removeAll()
            }
        }



    }

    public func step12(ball1_x : Int, ball1_y : Int, ball2_x : Int, ball2_y : Int) {

        
        if(BallInformation.ball_arraylist.count > 0 && BallInformation.ball_arraylist[0] != "right"){
            //첫번째 배열의 시작이 left가 아닐 경우 -> BallInformation.ball_arraylist 초기화
            print(TAG, "공 배열 : 오류 -> 배열 초기화");
            BallInformation.ball_arraylist.removeAll()
        }else{
            if (ball1_x - 20 <= ball2_x && ball2_x <= ball1_x + 20 && ball1_y > ball2_y+10 && BallInformation.ball_arraylist.count == 0) {
                print(TAG, "step12-0단계");
                print(TAG, "파란공이 오른쪽에 있는것 인지 X");
                BallInformation.ball_arraylist.append("right");
            } else if (ball1_x - 20 <= ball2_x && ball2_x <= ball1_x + 20 && ball1_y > ball2_y+10 && BallInformation.ball_arraylist.count == 1) {
                print(TAG, "step12-1단계");
                print(TAG, "파란공이 오른쪽에 있는것 인지 O");
            } else if (ball1_y - 20 <= ball2_y && ball2_y <= ball1_y + 20 && ball1_x+10 < ball2_x && BallInformation.ball_arraylist.count == 1 && BallInformation.ball_arraylist[0]=="right") {
                print(TAG, "step12-2단계");
                print(TAG, "파란공이 아래에 있는것 인지 X");
                BallInformation.ball_arraylist.append("down");
            } else if (ball1_y - 20 <= ball2_y && ball2_y <= ball1_y + 20 && ball1_x+10 < ball2_x && BallInformation.ball_arraylist.count == 2) {
                print(TAG, "step12-3단계");
                print(TAG, "파란공이 아래에 있는것 인지 O");
            } else if (ball1_x - 20 <= ball2_x && ball2_x <= ball1_x + 20 && ball1_y+10 < ball2_y && BallInformation.ball_arraylist.count == 2 && BallInformation.ball_arraylist[0]=="right" && BallInformation.ball_arraylist[1]=="down") {
                print(TAG, "step12-4단계");
                print(TAG, "파란공이 왼쪽에 있는것 인지 X");
                BallInformation.ball_arraylist.append("left");
            } else if (ball1_x - 20 <= ball2_x && ball2_x <= ball1_x + 20 && ball1_y+10 < ball2_y && BallInformation.ball_arraylist.count == 3) {
                print(TAG, "step12-5단계");
                print(TAG, "파란공이 왼쪽에 있는것 인지 O");
            } else if (ball1_y - 20 <= ball2_y && ball2_y <= ball1_y + 20 && ball1_x > ball2_x+10 && BallInformation.ball_arraylist.count == 3
                    && BallInformation.ball_arraylist[0]=="right" && BallInformation.ball_arraylist[1]=="down" && BallInformation.ball_arraylist[2]=="left") {
                print(TAG, "step12-6단계");
                print(TAG, "파란공이 위에 있는것 인지 X");
                BallInformation.ball_arraylist.append("up");
            } else if (ball1_y - 20 <= ball2_y && ball2_y <= ball1_y + 20 && ball1_x > ball2_x+10 && BallInformation.ball_arraylist.count == 4) {
                print(TAG, "step12-7단계");
                print(TAG, "파란공이 위에 있는것 인지 O");
            } else if (ball1_x - 20 <= ball2_x && ball2_x <= ball1_x + 20 && ball1_y > ball2_y+10 && BallInformation.ball_arraylist.count == 4
                    && BallInformation.ball_arraylist[0]=="right" && BallInformation.ball_arraylist[1] == "down" && BallInformation.ball_arraylist[2]=="left" && BallInformation.ball_arraylist[3] == "up") {
                print(TAG, "step12-8단계");
                print(TAG, "파란공이 오른쪽에 있는것 인지 X");
                BallInformation.ball_arraylist.append("right");
            } else if (ball1_x - 20 <= ball2_x && ball2_x <= ball1_x + 20 && ball1_y > ball2_y+10 && BallInformation.ball_arraylist.count == 5) {
                print(TAG, "step12-9단계");
                print(TAG, "파란공이 오른쪽에 있는것 인지 O");
                //개수 올리기
                BallInformation.ball_count = BallInformation.ball_count+1;
                BallInformation.ball_arraylist.removeAll()
            }
        }



    }

}
