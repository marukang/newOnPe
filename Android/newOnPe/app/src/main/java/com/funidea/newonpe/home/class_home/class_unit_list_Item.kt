package com.funidea.newonpe.home.class_home

/** 클래스 차시(단원)별 리스트를 나타내주는 RecyclerView Item
 *
 */

class class_unit_list_Item
    (
    //차시별 클래스 시작일
    var class_unit_start_date : String,
    //차시별 클래스 종료일
    var class_unit_end_date : String,
    //차시별 클래스 제목
    var class_unit_title : String,
    //차시별 클래스 코드
    var class_unit_code : String,
    //차시별 클래스 상태값
    var class_unit_value : Int
)