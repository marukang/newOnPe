package com.funidea.newonpe.juggling;


import android.util.Log;

public class Juggling_Function {

    private static final String TAG = "메서드";



    //동시 공던져잡기
    public void same(){

        Log.d(TAG, "저글링 개수 : "+ Juggling_Information.ball_count);
        Log.d(TAG, "저글링 배열 : "+String.valueOf(Juggling_Information.ball_arraylist));


        if((Juggling_Information.ball_position_red == 1 || Juggling_Information.ball_position_red == 4)&& (Juggling_Information.ball_position_blue == 1 || Juggling_Information.ball_position_blue == 4)&& Juggling_Information.ball_arraylist.size()==0){
            Log.d(TAG, "동시 공던져잡기-0단계");
            Log.d(TAG, "빨간공: 아래, 던지기 전");
            Log.d(TAG, "파란공: 아래, 던지기 전");
            Juggling_Information.ball_arraylist.add("down");
        }else if((Juggling_Information.ball_position_red == 1 || Juggling_Information.ball_position_red == 4)&& (Juggling_Information.ball_position_blue == 1 || Juggling_Information.ball_position_blue == 4)&& Juggling_Information.ball_arraylist.size()==1){
            Log.d(TAG, "동시 공던져잡기-1단계");
            Log.d(TAG, "빨간공: 아래, 던지기 전");
            Log.d(TAG, "파란공: 아래, 던지기 전");
        }else if((Juggling_Information.ball_position_red == 2 || Juggling_Information.ball_position_red == 3)&& (Juggling_Information.ball_position_blue == 2 ||
                Juggling_Information.ball_position_blue == 3)&& Juggling_Information.ball_arraylist.size()==1 && Juggling_Information.ball_arraylist.get(0)=="down"){
            Log.d(TAG, "동시 공던져잡기-2단계");
            Log.d(TAG, "빨간공: 위로 던진 후 위치인식 X");
            Log.d(TAG, "파란공: 위로 던진 후 위치인식 X");
            Juggling_Information.ball_arraylist.add("up");
        }else if((Juggling_Information.ball_position_red == 2 || Juggling_Information.ball_position_red == 3)&& (Juggling_Information.ball_position_blue == 2 || Juggling_Information.ball_position_blue == 3)
                && Juggling_Information.ball_arraylist.size()==2 && Juggling_Information.ball_arraylist.get(0)=="down" && Juggling_Information.ball_arraylist.get(1)=="up"){
            Log.d(TAG, "동시 공던져잡기-3단계");
            Log.d(TAG, "빨간공: 위로 던진 후 위치인식 O");
            Log.d(TAG, "파란공: 위로 던진 후 위치인식 O");
        }else if((Juggling_Information.ball_position_red == 1 || Juggling_Information.ball_position_red == 4)&& (Juggling_Information.ball_position_blue == 1 || Juggling_Information.ball_position_blue == 4)
                && Juggling_Information.ball_arraylist.size()==2 ){
            Log.d(TAG, "동시 공던져잡기-4단계");
            Log.d(TAG, "빨간공: 아래로 되돌아온 후, 위치인식 X");
            Log.d(TAG, "파란공: 아래로 되돌아온 후, 위치인식 X");
            Juggling_Information.ball_arraylist.add("down");
        }else if((Juggling_Information.ball_position_red == 1 || Juggling_Information.ball_position_red == 4)&& (Juggling_Information.ball_position_blue == 1 || Juggling_Information.ball_position_blue == 4)
                && Juggling_Information.ball_arraylist.size()==3 && Juggling_Information.ball_arraylist.get(0)=="down" && Juggling_Information.ball_arraylist.get(1)=="up" && Juggling_Information.ball_arraylist.get(2)=="down" ){
            Log.d(TAG, "동시 공던져잡기-5단계");
            Log.d(TAG, "빨간공: 아래로 되돌아온 후, 위치인식 O");
            Log.d(TAG, "파란공: 아래로 되돌아온 후, 위치인식 O");
            Juggling_Information.ball_count = Juggling_Information.ball_count+1;
            Juggling_Information.ball_arraylist.clear();
        }

    }

    //번갈아 공던져잡기
    public void cross(){

        Log.d(TAG, "저글링 개수 : "+ Juggling_Information.ball_count);
        Log.d(TAG, "저글링 배열 : "+String.valueOf(Juggling_Information.ball_arraylist));


        if((Juggling_Information.ball_position_red == 1 || Juggling_Information.ball_position_red == 4)&& (Juggling_Information.ball_position_blue == 2 || Juggling_Information.ball_position_blue == 3)&& Juggling_Information.ball_arraylist.size()==0){
            Log.d(TAG, "번갈아 공던져잡기-0단계");
            Log.d(TAG, "빨간공: 아래, 던지기 전");
            Log.d(TAG, "파란공: 위, 던진 후");
            Juggling_Information.ball_arraylist.add("down");
        }else if((Juggling_Information.ball_position_red == 1 || Juggling_Information.ball_position_red == 4)&& (Juggling_Information.ball_position_blue == 2 || Juggling_Information.ball_position_blue == 3)&& Juggling_Information.ball_arraylist.size()==1){
            Log.d(TAG, "번갈아 공던져잡기-1단계");
            Log.d(TAG, "빨간공: 아래, 던지기 전");
            Log.d(TAG, "파란공: 위, 던진 후");
        }else if((Juggling_Information.ball_position_red == 2 || Juggling_Information.ball_position_red == 3)&& (Juggling_Information.ball_position_blue == 1 || Juggling_Information.ball_position_blue == 4)
                && Juggling_Information.ball_arraylist.size()==1 && Juggling_Information.ball_arraylist.get(0)=="down"){
            Log.d(TAG, "번갈아 공던져잡기-2단계");
            Log.d(TAG, "빨간공: 위로 던진 후 위치인식 X");
            Log.d(TAG, "파란공: 아래로 뒤돌아온 후 위치인식 X");
            Juggling_Information.ball_arraylist.add("up");
        }else if((Juggling_Information.ball_position_red == 2 || Juggling_Information.ball_position_red == 3)&& (Juggling_Information.ball_position_blue == 1 || Juggling_Information.ball_position_blue == 4)
                && Juggling_Information.ball_arraylist.size()==2 && Juggling_Information.ball_arraylist.get(0)=="down" && Juggling_Information.ball_arraylist.get(1)=="up"){
            Log.d(TAG, "번갈아 공던져잡기-3단계");
            Log.d(TAG, "빨간공: 위로 던진 후 위치인식 O");
            Log.d(TAG, "파란공: 아래로 뒤돌아온 후 위치인식 O");
        }else if((Juggling_Information.ball_position_red == 1 || Juggling_Information.ball_position_red == 4)&& (Juggling_Information.ball_position_blue == 2 || Juggling_Information.ball_position_blue == 3)
                && Juggling_Information.ball_arraylist.size()==2 ){
            Log.d(TAG, "번갈아 공던져잡기-4단계");
            Log.d(TAG, "빨간공: 아래로 되돌아온 후, 위치인식 X");
            Log.d(TAG, "파란공: 위로 던진 후, 위치인식 X");
            Juggling_Information.ball_arraylist.add("down");
        }else if((Juggling_Information.ball_position_red == 1 || Juggling_Information.ball_position_red == 4)&& (Juggling_Information.ball_position_blue == 2 || Juggling_Information.ball_position_blue == 3)
                && Juggling_Information.ball_arraylist.size()==3 && Juggling_Information.ball_arraylist.get(0)=="down" && Juggling_Information.ball_arraylist.get(1)=="up" && Juggling_Information.ball_arraylist.get(2)=="down" ){
            Log.d(TAG, "번갈아 공던져잡기-5단계");
            Log.d(TAG, "빨간공: 아래로 되돌아온 후, 위치인식 O");
            Log.d(TAG, "파란공: 위로 던진 후, 위치인식 O");
            Juggling_Information.ball_count = Juggling_Information.ball_count+1;
            Juggling_Information.ball_arraylist.clear();
        }

    }

    //헛갈려 공던져잡기(반시계)
    public void turn_anticlock(){

        Log.d(TAG, "저글링 개수 : "+ Juggling_Information.ball_count);
        Log.d(TAG, "저글링 배열 : "+String.valueOf(Juggling_Information.ball_arraylist));


        if(Juggling_Information.ball_arraylist.size() > 0 && Juggling_Information.ball_arraylist.get(0) != "1"){
            //첫번째 배열의 시작이 1사분면이 아닐 경우 -> BallInformation.ball_arraylist 초기화
            Log.d(TAG, "공 배열 : 오류 -> 배열 초기화");
            Juggling_Information.ball_arraylist.clear();

        }else{
            Log.d(TAG, "공 배열 : 정상 -> 배열 추가");

            if(Juggling_Information.ball_position_red == 1  && Juggling_Information.ball_position_blue == 4  && Juggling_Information.ball_arraylist.size()==0){
                Log.d(TAG, "헛갈려 공던져잡기(반시계)-0단계");
                Log.d(TAG, "빨간공: 1사분면 - 인식 X");
                Log.d(TAG, "파란공: 4사분면 - 인식 X");
                Juggling_Information.ball_arraylist.add("1");
            }else if(Juggling_Information.ball_position_red == 1 && Juggling_Information.ball_position_blue == 4 && Juggling_Information.ball_arraylist.size()==1) {
                Log.d(TAG, "헛갈려 공던져잡기(반시계)-1단계");
                Log.d(TAG, "빨간공: 1사분면 - 인식 O");
                Log.d(TAG, "파란공: 4사분면 - 인식 O");
            }else if(Juggling_Information.ball_position_red == 2 && (Juggling_Information.ball_position_blue == 4  || Juggling_Information.ball_position_blue == 1) && Juggling_Information.ball_arraylist.size()==1 && Juggling_Information.ball_arraylist.get(0)=="1"){
                Log.d(TAG, "헛갈려 공던져잡기(반시계)-2단계");
                Log.d(TAG, "빨간공: 2사분면 - 인식 X");
                Log.d(TAG, "파란공: 1 or 4사분면 - 인식 X");
                Juggling_Information.ball_arraylist.add("2");
            }else if(Juggling_Information.ball_position_red == 2  && (Juggling_Information.ball_position_blue == 4  || Juggling_Information.ball_position_blue == 1) && Juggling_Information.ball_arraylist.size()==2 && Juggling_Information.ball_arraylist.get(0)=="1" &&
                    Juggling_Information.ball_arraylist.get(1)=="2"){
                Log.d(TAG, "헛갈려 공던져잡기(반시계)-3단계");
                Log.d(TAG, "빨간공: 2사분면 - 인식 O");
                Log.d(TAG, "파란공: 1 or 4사분면 - 인식 O");
            }else if(Juggling_Information.ball_position_red == 3 && (Juggling_Information.ball_position_blue == 4  || Juggling_Information.ball_position_blue == 1) && Juggling_Information.ball_arraylist.size()==2){
                Log.d(TAG, "헛갈려 공던져잡기(반시계)-4단계");
                Log.d(TAG, "빨간공: 3사분면 - 인식 X");
                Log.d(TAG, "파란공: 1 or 4사분면 - 인식 X");
                Juggling_Information.ball_arraylist.add("3");
            }else if(Juggling_Information.ball_position_red == 3 && (Juggling_Information.ball_position_blue == 4  || Juggling_Information.ball_position_blue == 1) && Juggling_Information.ball_arraylist.size()==3 && Juggling_Information.ball_arraylist.get(0)=="1" &&
                    Juggling_Information.ball_arraylist.get(1)=="2" && Juggling_Information.ball_arraylist.get(2)=="3"){
                Log.d(TAG, "헛갈려 공던져잡기(반시계)-5단계");
                Log.d(TAG, "빨간공: 3사분면 - 인식 O");
                Log.d(TAG, "파란공: 1 or 4사분면 - 인식 O");
            }else if(Juggling_Information.ball_position_red == 4 && Juggling_Information.ball_position_blue == 1 && Juggling_Information.ball_arraylist.size()==3){
                Log.d(TAG, "헛갈려 공던져잡기(반시계)-6단계");
                Log.d(TAG, "빨간공: 4사분면 - 인식 X");
                Log.d(TAG, "파란공: 1사분면 - 인식 X");
                Juggling_Information.ball_arraylist.add("4");
            }else if(Juggling_Information.ball_position_red == 4 && Juggling_Information.ball_position_blue == 1 && Juggling_Information.ball_arraylist.size()==4 && Juggling_Information.ball_arraylist.get(0)=="1" &&
                    Juggling_Information.ball_arraylist.get(1)=="2" && Juggling_Information.ball_arraylist.get(2)=="3" && Juggling_Information.ball_arraylist.get(3)=="4"){
                Log.d(TAG, "헛갈려 공던져잡기(반시계)-7단계");
                Log.d(TAG, "빨간공: 4사분면 - 인식 O");
                Log.d(TAG, "파란공: 1사분면 - 인식 O");
            }else if(Juggling_Information.ball_position_red == 1 && Juggling_Information.ball_position_blue == 4 && Juggling_Information.ball_arraylist.size()==4){
                Log.d(TAG, "헛갈려 공던져잡기(반시계)-8단계");
                Log.d(TAG, "빨간공: 1사분면 - 인식 X");
                Log.d(TAG, "파란공: 4사분면 - 인식 X");
                Juggling_Information.ball_arraylist.add("1");
            }else if(Juggling_Information.ball_position_red == 1 && Juggling_Information.ball_position_blue == 4 && Juggling_Information.ball_arraylist.size()==5 && Juggling_Information.ball_arraylist.get(0)=="1" &&
                    Juggling_Information.ball_arraylist.get(1)=="2" && Juggling_Information.ball_arraylist.get(2)=="3" && Juggling_Information.ball_arraylist.get(3)=="4" &&
                    Juggling_Information.ball_arraylist.get(4)=="1"){
                Log.d(TAG, "헛갈려 공던져잡기(반시계)-9단계");
                Log.d(TAG, "빨간공: 1사분면 - 인식 O");
                Log.d(TAG, "파란공: 4사분면 - 인식 O");
                //개수 올리기
                Juggling_Information.ball_count = Juggling_Information.ball_count+1;
                Juggling_Information.ball_arraylist.clear();
            }
        }
    }

    //헛갈려 공던져잡기(시계)
    public void turn_clock(){

        Log.d(TAG, "저글링 개수 : "+ Juggling_Information.ball_count);
        Log.d(TAG, "저글링 배열 : "+String.valueOf(Juggling_Information.ball_arraylist));


        if(Juggling_Information.ball_arraylist.size() > 0 && Juggling_Information.ball_arraylist.get(0) != "4"){
            //첫번째 배열의 시작이 1사분면이 아닐 경우 -> BallInformation.ball_arraylist 초기화
            Log.d(TAG, "공 배열 : 오류 -> 배열 초기화");
            Juggling_Information.ball_arraylist.clear();

        }else{
            Log.d(TAG, "공 배열 : 정상 -> 배열 추가");

            if(Juggling_Information.ball_position_blue == 4  && Juggling_Information.ball_position_red == 1  && Juggling_Information.ball_arraylist.size()==0){
                Log.d(TAG, "헛갈려 공던져잡기(시계)-0단계");
                Log.d(TAG, "파란공: 4사분면 - 인식 X");
                Log.d(TAG, "빨간공: 1사분면 - 인식 X");
                Juggling_Information.ball_arraylist.add("4");
            }else if(Juggling_Information.ball_position_blue == 4 && Juggling_Information.ball_position_red == 1 && Juggling_Information.ball_arraylist.size()==1) {
                Log.d(TAG, "헛갈려 공던져잡기(시계)-1단계");
                Log.d(TAG, "파란공: 4사분면 - 인식 O");
                Log.d(TAG, "빨간공: 1사분면 - 인식 O");
            }else if(Juggling_Information.ball_position_blue == 3 && (Juggling_Information.ball_position_red == 4  || Juggling_Information.ball_position_red == 1) && Juggling_Information.ball_arraylist.size()==1 && Juggling_Information.ball_arraylist.get(0)=="4"){
                Log.d(TAG, "헛갈려 공던져잡기(시계)-2단계");
                Log.d(TAG, "파란공: 3사분면 - 인식 X");
                Log.d(TAG, "빨간공: 1 or 4사분면 - 인식 X");
                Juggling_Information.ball_arraylist.add("3");
            }else if(Juggling_Information.ball_position_blue == 3  && (Juggling_Information.ball_position_red == 4  || Juggling_Information.ball_position_red == 1) && Juggling_Information.ball_arraylist.size()==2 && Juggling_Information.ball_arraylist.get(0)=="4" &&
                    Juggling_Information.ball_arraylist.get(1)=="3"){
                Log.d(TAG, "헛갈려 공던져잡기(시계)-3단계");
                Log.d(TAG, "파란공: 3사분면 - 인식 O");
                Log.d(TAG, "빨간공: 1 or 4사분면 - 인식 O");
            }else if(Juggling_Information.ball_position_blue == 2 && (Juggling_Information.ball_position_red == 4  || Juggling_Information.ball_position_red == 1) && Juggling_Information.ball_arraylist.size()==2){
                Log.d(TAG, "헛갈려 공던져잡기(시계)-4단계");
                Log.d(TAG, "파란공: 2사분면 - 인식 X");
                Log.d(TAG, "빨간공: 1 or 4사분면 - 인식 X");
                Juggling_Information.ball_arraylist.add("2");
            }else if(Juggling_Information.ball_position_blue == 2 && (Juggling_Information.ball_position_red == 4  || Juggling_Information.ball_position_red == 1) && Juggling_Information.ball_arraylist.size()==3 && Juggling_Information.ball_arraylist.get(0)=="4" &&
                    Juggling_Information.ball_arraylist.get(1)=="3" && Juggling_Information.ball_arraylist.get(2)=="2"){
                Log.d(TAG, "헛갈려 공던져잡기(시계)-5단계");
                Log.d(TAG, "파란공: 2사분면 - 인식 O");
                Log.d(TAG, "빨간공: 1 or 4사분면 - 인식 O");
            }else if(Juggling_Information.ball_position_blue == 1 && Juggling_Information.ball_position_red == 4 && Juggling_Information.ball_arraylist.size()==3){
                Log.d(TAG, "헛갈려 공던져잡기(시계)-6단계");
                Log.d(TAG, "파란공: 1사분면 - 인식 X");
                Log.d(TAG, "빨간공: 4사분면 - 인식 X");
                Juggling_Information.ball_arraylist.add("1");
            }else if(Juggling_Information.ball_position_blue == 1 && Juggling_Information.ball_position_red == 4 && Juggling_Information.ball_arraylist.size()==4 && Juggling_Information.ball_arraylist.get(0)=="4" &&
                    Juggling_Information.ball_arraylist.get(1)=="3" && Juggling_Information.ball_arraylist.get(2)=="2" && Juggling_Information.ball_arraylist.get(3)=="1"){
                Log.d(TAG, "헛갈려 공던져잡기(시계)-7단계");
                Log.d(TAG, "파란공: 1사분면 - 인식 O");
                Log.d(TAG, "빨간공: 4사분면 - 인식 O");
            }else if(Juggling_Information.ball_position_blue == 4 && Juggling_Information.ball_position_red == 1 && Juggling_Information.ball_arraylist.size()==4){
                Log.d(TAG, "헛갈려 공던져잡기(시계)-8단계");
                Log.d(TAG, "파란공: 4사분면 - 인식 X");
                Log.d(TAG, "빨간공: 1사분면 - 인식 X");
                Juggling_Information.ball_arraylist.add("4");
            }else if(Juggling_Information.ball_position_blue == 4 && Juggling_Information.ball_position_red == 1 && Juggling_Information.ball_arraylist.size()==5 && Juggling_Information.ball_arraylist.get(0)=="4" &&
                    Juggling_Information.ball_arraylist.get(1)=="3" && Juggling_Information.ball_arraylist.get(2)=="2" && Juggling_Information.ball_arraylist.get(3)=="1" &&
                    Juggling_Information.ball_arraylist.get(4)=="4"){
                Log.d(TAG, "헛갈려 공던져잡기(시계)-9단계");
                Log.d(TAG, "파란공: 4사분면 - 인식 O");
                Log.d(TAG, "빨간공: 1사분면 - 인식 O");
                //개수 올리기p
                Juggling_Information.ball_count = Juggling_Information.ball_count+1;
                Juggling_Information.ball_arraylist.clear();
            }
        }
    }


    //기본 저글링잡기
    public void basic(){

        Log.d(TAG, "저글링 개수 : "+ Juggling_Information.ball_count);
        Log.d(TAG, "저글링 배열 : "+String.valueOf(Juggling_Information.ball_arraylist));

        if(Juggling_Information.ball_arraylist.size() > 0 && Juggling_Information.ball_arraylist.get(0) != "1"){
            //첫번째 배열의 시작이 1사분면이 아닐 경우 -> BallInformation.ball_arraylist 초기화
            Log.d(TAG, "공 배열 : 오류 -> 배열 초기화");
            Juggling_Information.ball_arraylist.clear();

        }else{
            Log.d(TAG, "공 배열 : 정상 -> 배열 추가");
            if(Juggling_Information.ball_position_red == 1 && Juggling_Information.ball_position_blue == 4 && Juggling_Information.ball_arraylist.size()==0){
                Log.d(TAG, "기본 저글링잡기-0단계");
                Log.d(TAG, "빨간공: 1사분면, 던지기 전");
                Log.d(TAG, "파란공: 4사분면, 던지기 전");
                Juggling_Information.ball_arraylist.add("1");
            }else if(Juggling_Information.ball_position_red == 1 && Juggling_Information.ball_position_blue == 4 && Juggling_Information.ball_arraylist.size()==1) {
                Log.d(TAG, "기본 저글링잡기-1단계");
                Log.d(TAG, "빨간공: 1사분면, 던지기 전");
                Log.d(TAG, "파란공: 4사분면, 던지기 전");
            }else if((Juggling_Information.ball_position_red == 2 ||  Juggling_Information.ball_position_red == 3) && Juggling_Information.ball_arraylist.size()==1  && Juggling_Information.ball_arraylist.get(0)=="1"){
                Log.d(TAG, "기본 저글링잡기-2단계");
                Log.d(TAG, "빨간공: 2,3사분면, 던진 후, 2,3사분면 위치인식 X");
                Juggling_Information.ball_arraylist.add("up");
            }else if((Juggling_Information.ball_position_red == 2 ||  Juggling_Information.ball_position_red == 3) && Juggling_Information.ball_arraylist.size()==2 && Juggling_Information.ball_arraylist.get(0)=="1" &&
                    Juggling_Information.ball_arraylist.get(1)=="up"){
                Log.d(TAG, "기본 저글링잡기-3단계");
                Log.d(TAG, "빨간공: 2,3사분면, 던진 후, 2,3사분면 위치인식 O");
            }else if(Juggling_Information.ball_position_red == 4 && Juggling_Information.ball_position_blue == 1  && Juggling_Information.ball_arraylist.size()==2){
                Log.d(TAG, "기본 저글링잡기-4단계");
                Log.d(TAG, "빨간공: 4사분면, 던진 후, 4사분면 위치인식 X");
                Log.d(TAG, "파란공: 1사분면, 던진 후, 1사분면 위치인식 X");
                //개수 추가
                Juggling_Information.ball_count = Juggling_Information.ball_count+1;
                Juggling_Information.ball_arraylist.add("4");
            }else if(Juggling_Information.ball_position_red == 4 && Juggling_Information.ball_position_blue == 1  && Juggling_Information.ball_arraylist.size()==3 && Juggling_Information.ball_arraylist.get(0)=="1" &&
                    Juggling_Information.ball_arraylist.get(1)=="up" && Juggling_Information.ball_arraylist.get(2)=="4"){
                Log.d(TAG, "기본 저글링잡기-5단계");
                Log.d(TAG, "빨간공: 4사분면, 던진 후, 4사분면 위치인식 O");
                Log.d(TAG, "파란공: 1사분면, 던진 후, 1사분면 위치인식 O");
            }else if((Juggling_Information.ball_position_red == 2 ||  Juggling_Information.ball_position_red == 3) && Juggling_Information.ball_arraylist.size()==3){
                Log.d(TAG, "기본 저글링잡기-6단계");
                Log.d(TAG, "빨간공: 2,3사분면, 던진 후, 2,3사분면 위치인식 X");
                Juggling_Information.ball_arraylist.add("up");
            }else if((Juggling_Information.ball_position_red == 2 ||  Juggling_Information.ball_position_red == 3) && Juggling_Information.ball_arraylist.size()==4 && Juggling_Information.ball_arraylist.get(0)=="1" &&
                    Juggling_Information.ball_arraylist.get(1)=="up" && Juggling_Information.ball_arraylist.get(2)=="4" && Juggling_Information.ball_arraylist.get(3)=="up"){
                Log.d(TAG, "기본 저글링잡기-7단계");
                Log.d(TAG, "빨간공: 2,3사분면, 던진 후, 2,3사분면 위치인식 O");
            }else if(Juggling_Information.ball_position_red == 1 && Juggling_Information.ball_position_blue == 4  && Juggling_Information.ball_arraylist.size()==4){
                Log.d(TAG, "기본 저글링잡기-8단계");
                Log.d(TAG, "빨간공: 1사분면, 던진 후, 1사분면 위치인식 X");
                Log.d(TAG, "파란공: 4사분면, 던진 후, 4사분면 위치인식 X");
                Juggling_Information.ball_arraylist.add("1");
            }else if(Juggling_Information.ball_position_red == 1 && Juggling_Information.ball_position_blue == 4 && Juggling_Information.ball_arraylist.size()==5 && Juggling_Information.ball_arraylist.get(0)=="1" &&
                    Juggling_Information.ball_arraylist.get(1)=="up" && Juggling_Information.ball_arraylist.get(2)=="4" && Juggling_Information.ball_arraylist.get(3)=="up" &&
                    Juggling_Information.ball_arraylist.get(4)=="1"){
                Log.d(TAG, "기본 저글링잡기-9단계");
                Log.d(TAG, "빨간공: 1사분면, 던진 후, 1사분면 위치인식 O");
                Log.d(TAG, "파란공: 4사분면, 던진 후, 4사분면 위치인식 O");
                //개수 올리기
                Juggling_Information.ball_count = Juggling_Information.ball_count+1;
                Juggling_Information.ball_arraylist.clear();
            }

        }



    }

    //동시 엇갈려 저글링잡기
    public void same_cross(){

        Log.d(TAG, "저글링 개수 : "+ Juggling_Information.ball_count);
        Log.d(TAG, "저글링 배열 : "+String.valueOf(Juggling_Information.ball_arraylist));

        if(Juggling_Information.ball_arraylist.size() > 0 && Juggling_Information.ball_arraylist.get(0) != "1"){
            //첫번째 배열의 시작이 1사분면이 아닐 경우 -> BallInformation.ball_arraylist 초기화
            Log.d(TAG, "공 배열 : 오류 -> 배열 초기화");
            Juggling_Information.ball_arraylist.clear();

        }else{
            Log.d(TAG, "공 배열 : 정상 -> 배열 추가");
            if(Juggling_Information.ball_position_red == 1 && Juggling_Information.ball_position_blue == 4 && Juggling_Information.ball_arraylist.size()==0){
                Log.d(TAG, "동시 엇갈려 저글링잡기-0단계");
                Log.d(TAG, "빨간공: 1사분면, 던지기 전");
                Log.d(TAG, "파란공: 4사분면, 던지기 전");
                Juggling_Information.ball_arraylist.add("1");
            }else if(Juggling_Information.ball_position_red == 1 && Juggling_Information.ball_position_blue == 4 && Juggling_Information.ball_arraylist.size()==1) {
                Log.d(TAG, "동시 엇갈려 저글링잡기-1단계");
                Log.d(TAG, "빨간공: 1사분면, 던지기 전");
                Log.d(TAG, "파란공: 4사분면, 던지기 전");
            }else if(Juggling_Information.ball_position_red == 4 && Juggling_Information.ball_position_blue == 1 && Juggling_Information.ball_arraylist.size()==1  && Juggling_Information.ball_arraylist.get(0)=="1"){
                Log.d(TAG, "동시 엇갈려 저글링잡기-2단계");
                Log.d(TAG, "빨간공: 4사분면 위치인식 X");
                Log.d(TAG, "파란공: 1사분면 위치인식 X");
                Juggling_Information.ball_arraylist.add("4");
            }else if(Juggling_Information.ball_position_red == 4 && Juggling_Information.ball_position_blue == 1 && Juggling_Information.ball_arraylist.size()==2 && Juggling_Information.ball_arraylist.get(0)=="1" &&
                    Juggling_Information.ball_arraylist.get(1)=="4"){
                Log.d(TAG, "동시 엇갈려 저글링잡기-3단계");
                Log.d(TAG, "빨간공: 4사분면 위치인식 O");
                Log.d(TAG, "파란공: 1사분면 위치인식 O");
            }else if(Juggling_Information.ball_position_red == 3 && Juggling_Information.ball_position_blue == 2 && Juggling_Information.ball_arraylist.size()==2){
                Log.d(TAG, "동시 엇갈려 저글링잡기-4단계");
                Log.d(TAG, "빨간공: 3사분면, 던진 후, 3사분면 위치인식 X");
                Log.d(TAG, "파란공: 2사분면, 던진 후, 2사분면 위치인식 X");
                Juggling_Information.ball_arraylist.add("3");
            }else if(Juggling_Information.ball_position_red == 3 && Juggling_Information.ball_position_blue == 2 && Juggling_Information.ball_arraylist.size()==3 && Juggling_Information.ball_arraylist.get(0)=="1" &&
                    Juggling_Information.ball_arraylist.get(1)=="4" && Juggling_Information.ball_arraylist.get(2)=="3"){
                Log.d(TAG, "동시 엇갈려 저글링잡기-5단계");
                Log.d(TAG, "빨간공: 3사분면, 던진 후, 3사분면 위치인식 O");
                Log.d(TAG, "파란공: 2사분면, 던진 후, 2사분면 위치인식 O");
            }else if(Juggling_Information.ball_position_red == 4 && Juggling_Information.ball_position_blue == 1 && Juggling_Information.ball_arraylist.size()==3){
                Log.d(TAG, "동시 엇갈려 저글링잡기-6단계");
                Log.d(TAG, "빨간공: 4사분면, 되돌아온 후, 4사분면 위치인식 X");
                Log.d(TAG, "파란공: 1사분면, 되돌아온 후, 1사분면 위치인식 X");
                //개수 올리기p
                Juggling_Information.ball_count = Juggling_Information.ball_count+1;
                Juggling_Information.ball_arraylist.add("4");
            }else if(Juggling_Information.ball_position_red == 4 && Juggling_Information.ball_position_blue == 1 && Juggling_Information.ball_arraylist.size()==4 && Juggling_Information.ball_arraylist.get(0)=="1" &&
                    Juggling_Information.ball_arraylist.get(1)=="4" && Juggling_Information.ball_arraylist.get(2)=="3" && Juggling_Information.ball_arraylist.get(3)=="4"){
                Log.d(TAG, "동시 엇갈려 저글링잡기-7단계");
                Log.d(TAG, "빨간공: 4사분면, 되돌아온 후, 4사분면 위치인식 O");
                Log.d(TAG, "파란공: 1사분면, 되돌아온 후, 1사분면 위치인식 O");
            }else if(Juggling_Information.ball_position_red == 1 && Juggling_Information.ball_position_blue == 4  && Juggling_Information.ball_arraylist.size()==4){
                Log.d(TAG, "동시 엇갈려 저글링잡기-8단계");
                Log.d(TAG, "빨간공: 1사분면, 되돌아온 후, 1사분면 위치인식 X");
                Log.d(TAG, "파란공: 4사분면, 되돌아온 후, 4사분면 위치인식 X");
                Juggling_Information.ball_arraylist.add("1");
            }else if(Juggling_Information.ball_position_red == 1 && Juggling_Information.ball_position_blue == 4 && Juggling_Information.ball_arraylist.size()==5 && Juggling_Information.ball_arraylist.get(0)=="1" &&
                    Juggling_Information.ball_arraylist.get(1)=="4" && Juggling_Information.ball_arraylist.get(2)=="3" && Juggling_Information.ball_arraylist.get(3)=="4"
                    && Juggling_Information.ball_arraylist.get(4)=="1"){
                Log.d(TAG, "동시 엇갈려 저글링잡기-9단계");
                Log.d(TAG, "빨간공: 1사분면, 되돌아온 후, 1사분면 위치인식 O");
                Log.d(TAG, "파란공: 4사분면, 되돌아온 후, 4사분면 위치인식 O");
            }else if(Juggling_Information.ball_position_red == 2 && Juggling_Information.ball_position_blue == 3 && Juggling_Information.ball_arraylist.size()==5){
                Log.d(TAG, "동시 엇갈려 저글링잡기-10단계");
                Log.d(TAG, "빨간공: 2사분면, 던진 후, 2사분면 위치인식 X");
                Log.d(TAG, "파란공: 3사분면, 던진 후, 3사분면 위치인식 X");
                Juggling_Information.ball_arraylist.add("2");
            }else if(Juggling_Information.ball_position_red == 2 && Juggling_Information.ball_position_blue == 3 && Juggling_Information.ball_arraylist.size()==6 && Juggling_Information.ball_arraylist.get(0)=="1" &&
                    Juggling_Information.ball_arraylist.get(1)=="4" && Juggling_Information.ball_arraylist.get(2)=="3" && Juggling_Information.ball_arraylist.get(3)=="4"
                    && Juggling_Information.ball_arraylist.get(4)=="1" && Juggling_Information.ball_arraylist.get(5)=="2"){
                Log.d(TAG, "동시 엇갈려 저글링잡기-11단계");
                Log.d(TAG, "빨간공: 2사분면, 던진 후, 2사분면 위치인식 O");
                Log.d(TAG, "파란공: 3사분면, 던진 후, 3사분면 위치인식 O");
            }else if(Juggling_Information.ball_position_red == 1 && Juggling_Information.ball_position_blue == 4 && Juggling_Information.ball_arraylist.size()==6){
                Log.d(TAG, "동시 엇갈려 저글링잡기-12단계");
                Log.d(TAG, "빨간공: 1사분면, 되돌아온 후, 1사분면 위치인식 X");
                Log.d(TAG, "파란공: 4사분면, 되돌아온 후, 4사분면 위치인식 X");
                Juggling_Information.ball_arraylist.add("1");
            }else if(Juggling_Information.ball_position_red == 1 && Juggling_Information.ball_position_blue == 4 && Juggling_Information.ball_arraylist.size()==7 && Juggling_Information.ball_arraylist.get(0)=="1" &&
                    Juggling_Information.ball_arraylist.get(1)=="4" && Juggling_Information.ball_arraylist.get(2)=="3" && Juggling_Information.ball_arraylist.get(3)=="4"
                    && Juggling_Information.ball_arraylist.get(4)=="1" && Juggling_Information.ball_arraylist.get(5)=="2" && Juggling_Information.ball_arraylist.get(6)=="1"){
                Log.d(TAG, "동시 엇갈려 저글링잡기-13단계");
                Log.d(TAG, "빨간공: 1사분면, 되돌아온 후, 1사분면 위치인식 O");
                Log.d(TAG, "파란공: 4사분면, 되돌아온 후, 4사분면 위치인식 O");
                //개수 올리기p
                Juggling_Information.ball_count = Juggling_Information.ball_count+1;
                Juggling_Information.ball_arraylist.clear();
            }

        }

    }

    //한손고정 엇갈려잡기(반시계)
    public void onehand_anticlock(int ball1_x,int ball1_y,int ball2_x,int ball2_y) {

        if(Juggling_Information.ball_arraylist.size() > 0 && Juggling_Information.ball_arraylist.get(0) != "left"){
            //첫번째 배열의 시작이 left가 아닐 경우 -> BallInformation.ball_arraylist 초기화
            Log.d(TAG, "공 배열 : 오류 -> 배열 초기화");
            Juggling_Information.ball_arraylist.clear();
        }else{
            if (ball1_x - 20 <= ball2_x && ball2_x <= ball1_x + 20 && ball1_y+10 < ball2_y && Juggling_Information.ball_arraylist.size() == 0) {
                Log.d(TAG, "한손고정 엇갈려잡기(반시계)-0단계");
                Log.d(TAG, "파란공이 왼쪽에 있는것 인지 X");
                Juggling_Information.ball_arraylist.add("left");
            } else if (ball1_x - 20 <= ball2_x && ball2_x <= ball1_x + 20 && ball1_y+10 < ball2_y && Juggling_Information.ball_arraylist.size() == 1) {
                Log.d(TAG, "한손고정 엇갈려잡기(반시계)-1단계");
                Log.d(TAG, "파란공이 왼쪽에 있는것 인지 O");
            } else if (ball1_y - 20 <= ball2_y && ball2_y <= ball1_y + 20 && ball1_x+10 < ball2_x && Juggling_Information.ball_arraylist.size() == 1 && Juggling_Information.ball_arraylist.get(0)=="left") {
                Log.d(TAG, "한손고정 엇갈려잡기(반시계)-2단계");
                Log.d(TAG, "파란공이 아래에 있는것 인지 X");
                Juggling_Information.ball_arraylist.add("down");
            } else if (ball1_y - 20 <= ball2_y && ball2_y <= ball1_y + 20 && ball1_x+10 < ball2_x && Juggling_Information.ball_arraylist.size() == 2) {
                Log.d(TAG, "한손고정 엇갈려잡기(반시계)-3단계");
                Log.d(TAG, "파란공이 아래에 있는것 인지 O");
            } else if (ball1_x - 20 <= ball2_x && ball2_x <= ball1_x + 20 && ball1_y > ball2_y+10 && Juggling_Information.ball_arraylist.size() == 2 && Juggling_Information.ball_arraylist.get(0)=="left" && Juggling_Information.ball_arraylist.get(1)=="down") {
                Log.d(TAG, "한손고정 엇갈려잡기(반시계)-4단계");
                Log.d(TAG, "파란공이 오른쪽에 있는것 인지 X");
                Juggling_Information.ball_arraylist.add("right");
            } else if (ball1_x - 20 <= ball2_x && ball2_x <= ball1_x + 20 && ball1_y > ball2_y+10 && Juggling_Information.ball_arraylist.size() == 3) {
                Log.d(TAG, "한손고정 엇갈려잡기(반시계)-5단계");
                Log.d(TAG, "파란공이 오른쪽에 있는것 인지 O");
            } else if (ball1_y - 20 <= ball2_y && ball2_y <= ball1_y + 20 && ball1_x > ball2_x+10 && Juggling_Information.ball_arraylist.size() == 3
                    && Juggling_Information.ball_arraylist.get(0)=="left" && Juggling_Information.ball_arraylist.get(1)=="down" && Juggling_Information.ball_arraylist.get(2)=="right") {
                Log.d(TAG, "한손고정 엇갈려잡기(반시계)-6단계");
                Log.d(TAG, "파란공이 위에 있는것 인지 X");
                Juggling_Information.ball_arraylist.add("up");
            } else if (ball1_y - 20 <= ball2_y && ball2_y <= ball1_y + 20 && ball1_x > ball2_x+10 && Juggling_Information.ball_arraylist.size() == 4) {
                Log.d(TAG, "한손고정 엇갈려잡기(반시계)-7단계");
                Log.d(TAG, "파란공이 위에 있는것 인지 O");
            } else if (ball1_x - 20 <= ball2_x && ball2_x <= ball1_x + 20 && ball1_y+10 < ball2_y && Juggling_Information.ball_arraylist.size() == 4
                    && Juggling_Information.ball_arraylist.get(0)=="left" && Juggling_Information.ball_arraylist.get(1)=="down" && Juggling_Information.ball_arraylist.get(2)=="right" && Juggling_Information.ball_arraylist.get(3)=="up") {
                Log.d(TAG, "한손고정 엇갈려잡기(반시계)-8단계");
                Log.d(TAG, "파란공이 왼쪽에 있는것 인지 X");
                Juggling_Information.ball_arraylist.add("left");
            } else if (ball1_x - 20 <= ball2_x && ball2_x <= ball1_x + 20 && ball1_y+10 < ball2_y && Juggling_Information.ball_arraylist.size() == 5) {
                Log.d(TAG, "한손고정 엇갈려잡기(반시계)-9단계");
                Log.d(TAG, "파란공이 왼쪽에 있는것 인지 O");
                //개수 올리기
                Juggling_Information.ball_count = Juggling_Information.ball_count+1;
                Juggling_Information.ball_arraylist.clear();
            }
        }



    }

    //한손고정 엇갈려잡기(시계)
    public void onehand_clock(int ball1_x,int ball1_y,int ball2_x,int ball2_y) {

        if(Juggling_Information.ball_arraylist.size() > 0 && Juggling_Information.ball_arraylist.get(0) != "right"){
            //첫번째 배열의 시작이 left가 아닐 경우 -> BallInformation.ball_arraylist 초기화
            Log.d(TAG, "공 배열 : 오류 -> 배열 초기화");
            Juggling_Information.ball_arraylist.clear();
        }else{
            if (ball1_x - 20 <= ball2_x && ball2_x <= ball1_x + 20 && ball1_y > ball2_y+10 && Juggling_Information.ball_arraylist.size() == 0) {
                Log.d(TAG, "한손고정 엇갈려잡기(시계)-0단계");
                Log.d(TAG, "파란공이 오른쪽에 있는것 인지 X");
                Juggling_Information.ball_arraylist.add("right");
            } else if (ball1_x - 20 <= ball2_x && ball2_x <= ball1_x + 20 && ball1_y > ball2_y+10 && Juggling_Information.ball_arraylist.size() == 1) {
                Log.d(TAG, "한손고정 엇갈려잡기(시계)-1단계");
                Log.d(TAG, "파란공이 오른쪽에 있는것 인지 O");
            } else if (ball1_y - 20 <= ball2_y && ball2_y <= ball1_y + 20 && ball1_x+10 < ball2_x && Juggling_Information.ball_arraylist.size() == 1 && Juggling_Information.ball_arraylist.get(0)=="right") {
                Log.d(TAG, "한손고정 엇갈려잡기(시계)-2단계");
                Log.d(TAG, "파란공이 아래에 있는것 인지 X");
                Juggling_Information.ball_arraylist.add("down");
            } else if (ball1_y - 20 <= ball2_y && ball2_y <= ball1_y + 20 && ball1_x+10 < ball2_x && Juggling_Information.ball_arraylist.size() == 2) {
                Log.d(TAG, "한손고정 엇갈려잡기(시계)-3단계");
                Log.d(TAG, "파란공이 아래에 있는것 인지 O");
            } else if (ball1_x - 20 <= ball2_x && ball2_x <= ball1_x + 20 && ball1_y+10 < ball2_y && Juggling_Information.ball_arraylist.size() == 2 && Juggling_Information.ball_arraylist.get(0)=="right" && Juggling_Information.ball_arraylist.get(1)=="down") {
                Log.d(TAG, "한손고정 엇갈려잡기(시계)-4단계");
                Log.d(TAG, "파란공이 왼쪽에 있는것 인지 X");
                Juggling_Information.ball_arraylist.add("left");
            } else if (ball1_x - 20 <= ball2_x && ball2_x <= ball1_x + 20 && ball1_y+10 < ball2_y && Juggling_Information.ball_arraylist.size() == 3) {
                Log.d(TAG, "한손고정 엇갈려잡기(시계)-5단계");
                Log.d(TAG, "파란공이 왼쪽에 있는것 인지 O");
            } else if (ball1_y - 20 <= ball2_y && ball2_y <= ball1_y + 20 && ball1_x > ball2_x+10 && Juggling_Information.ball_arraylist.size() == 3
                    && Juggling_Information.ball_arraylist.get(0)=="right" && Juggling_Information.ball_arraylist.get(1)=="down" && Juggling_Information.ball_arraylist.get(2)=="left") {
                Log.d(TAG, "한손고정 엇갈려잡기(시계)-6단계");
                Log.d(TAG, "파란공이 위에 있는것 인지 X");
                Juggling_Information.ball_arraylist.add("up");
            } else if (ball1_y - 20 <= ball2_y && ball2_y <= ball1_y + 20 && ball1_x > ball2_x+10 && Juggling_Information.ball_arraylist.size() == 4) {
                Log.d(TAG, "한손고정 엇갈려잡기(시계)-7단계");
                Log.d(TAG, "파란공이 위에 있는것 인지 O");
            } else if (ball1_x - 20 <= ball2_x && ball2_x <= ball1_x + 20 && ball1_y > ball2_y+10 && Juggling_Information.ball_arraylist.size() == 4
                    && Juggling_Information.ball_arraylist.get(0)=="right" && Juggling_Information.ball_arraylist.get(1)=="down" && Juggling_Information.ball_arraylist.get(2)=="left" && Juggling_Information.ball_arraylist.get(3)=="up") {
                Log.d(TAG, "한손고정 엇갈려잡기(시계)-8단계");
                Log.d(TAG, "파란공이 오른쪽에 있는것 인지 X");
                Juggling_Information.ball_arraylist.add("right");
            } else if (ball1_x - 20 <= ball2_x && ball2_x <= ball1_x + 20 && ball1_y > ball2_y+10 && Juggling_Information.ball_arraylist.size() == 5) {
                Log.d(TAG, "한손고정 엇갈려잡기(시계)-9단계");
                Log.d(TAG, "파란공이 오른쪽에 있는것 인지 O");
                //개수 올리기
                Juggling_Information.ball_count = Juggling_Information.ball_count+1;
                Juggling_Information.ball_arraylist.clear();
            }
        }



    }

}