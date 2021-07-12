package com.funidea.newonpe.message


/** Class message Item
 *
 *  message 내역을 보여주는 RecyclerView 의 Item
 *
 *  선생님께 보낸 메세지 내역을 나타내 주는 Recyclerview 의 Item class 입니다.
 */


class class_message_Item
(

    //번호
    var number : String,
    //타이틀
    var title : String,
    //작성 일
    var write_date : String,
    //답변 여부
    var message_state_value : Int,

    var show_number : String
)



