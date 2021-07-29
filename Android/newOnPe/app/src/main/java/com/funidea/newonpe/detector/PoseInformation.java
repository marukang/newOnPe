package com.funidea.newonpe.detector;

import java.util.ArrayList;

public class PoseInformation {

    //배열 개수
    static public int array_count=0;

    //동작 상태 (True-운동 상태, False - 준비 상태)
    static public boolean pose_status = false;
    static public boolean pose_status_sub = false;
    //동작 각도
    static public double pose_degree = 180;

    //동작 개수
    static public int pose_count = 0;
    //동작 개수 (0.5씩 카운트)
    static public double pose_count_double = 0.0;
    //동작 위치 배열
    static public ArrayList<String> pose_arraylist = new ArrayList<String>();

    /////////////////////////////////////////////////////////////////////////////////////////////

    //동작 정확도 (BAD, NORMAL, GOOD)
    static public String pose_score = "--";
    //동작 정확도 총점
    static public int pose_score_total = 0;
    //동작 정확도 평균
    static public double pose_score_average = 0;
    //동작 정확도 리스트 모음
    static public ArrayList<String> pose_score_list = new ArrayList<String>();

}