package com.funidea.newonpe.notice_class.notice_recyclerview_utils



/** notice Item
 *
 * all_notice_fragment, class_notice_fragment, message_notice_fragment 의 3개의 새소식에서
 * 소식 리스트를 보여주는 RecyclerView의 Item
 */



//학급 커뮤니티 리사이클러뷰 아이템 클래스
class notice_Item
(
    //게시글 번호
    var number : String,
    //유저 아이디
    var user_id : String,
    //유저 이름
    var user_name : String,
    //제목
    var title : String,
    //작성일자
    var write_date : String,

    var content :String,

    //보여질 게시글 번호
    var show_community_number : String


)



