package com.funidea.newonpe.page.home.class_community_board

/** 커뮤니티에서 글 목록을 보여주는 RecyclerView 의 Item
 *
 */

//학급 커뮤니티 리사이클러뷰 아이템 클래스
class class_community_Item
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
    //카운트
    var comment_count : Int,
    //보여질 게시글 번호
    var show_community_number : String


)



