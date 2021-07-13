package com.funidea.newonpe.network;


import java.util.List;

import okhttp3.MultipartBody;
import okhttp3.RequestBody;
import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.http.Field;
import retrofit2.http.FormUrlEncoded;
import retrofit2.http.Multipart;
import retrofit2.http.POST;
import retrofit2.http.Part;

/** BackEnd 서버와 연동해서 데이터를 가져올 때 필요한 메서드 모음
 *
 *
 */

public interface ServerConnection {


    //유저 로그인
    @FormUrlEncoded
    @POST("/app/login")
    Call<ResponseBody> login
    (
            @Field("student_id") String user_id,
            @Field("student_password") String user_password,
            @Field("fcmtoken") String fcmtoken
    );

    //유저 로그인
    @FormUrlEncoded
    @POST("/app/login")
    Call<ResponseBody> auto_login
    (
            @Field("student_id") String user_id,
            @Field("student_token") String user_token,
            @Field("fcmtoken") String fcmtoken
    );

    @FormUrlEncoded
    @POST("app/sns_login")
    Call<ResponseBody> auto_sns_login
    (
                    @Field("student_id") String user_id,
                    @Field("student_token") String user_token,
                    @Field("fcmtoken") String fcmtoken,
                    @Field("loginType") String loginType,
                    @Field("student_name") String student_name,
                    @Field("student_email") String student_email,
                    @Field("student_push_agreement") String student_push_agreement,
                    @Field("student_phone_number") String student_phone_number
    );

    //회원 가입 - 아이디 중복확인
    @FormUrlEncoded
    @POST("/app/id_overlap_check")
    Call<ResponseBody> id_overlap_check
    (
            @Field("student_id") String user_id

    );

    //회원 가입 - 이메일 인증번호 전송
    @FormUrlEncoded
    @POST("/app/email_authentication")
    Call<ResponseBody> email_authentication
    (
            @Field("student_email") String student_email

    );

    //회원 가입 - 최종 보내기
    @FormUrlEncoded
    @POST("/app/sign_up")
    Call<ResponseBody> sign_up
    (
            @Field("student_id") String student_id,
            @Field("student_name") String student_name,
            @Field("student_password") String student_student_password,
            @Field("student_phone_number") String student_phone,
            @Field("student_email") String student_email,
            @Field("authentication_code")String authentication_code,
            @Field("student_push_agreement") String student_push_agreement
    );

    //회원 가입 - 최종 보내기
    //폰번호 없음
    @FormUrlEncoded
    @POST("/app/sign_up")
    Call<ResponseBody> sign_up_no_phone_number
    (
            @Field("student_id") String student_id,
            @Field("student_name") String student_name,
            @Field("student_password") String student_student_password,
            @Field("student_email") String student_email,
            @Field("authentication_code")String authentication_code,
            @Field("student_push_agreement") String student_push_agreement
    );


    //아이디 찾기
    @FormUrlEncoded
    @POST("/app/find_id")
    Call<ResponseBody> find_id
    (
            @Field("student_name") String student_name,
            @Field("student_email") String student_email

    );

    //비밀번호 찾기
    @FormUrlEncoded
    @POST("/app/find_pw")
    Call<ResponseBody> find_pw
    (
            @Field("student_id") String student_id,
            @Field("student_name") String student_name,
            @Field("student_email") String student_email

    );


    //비밀번호 찾기
    @FormUrlEncoded
    @POST("/app/find_change_pw")
    Call<ResponseBody> find_change_pw
    (
            @Field("student_email") String student_email, //이메일
            @Field("student_password") String student_password, //비밀번호
            @Field("authentication_code") String authentication_code //인증번호 코드

    );

    //faq 목록 가져오기
    @FormUrlEncoded
    @POST("/app/community/get_student_faq")
    Call<ResponseBody> get_student_faq
    (
            @Field("student_id") String student_id, //아이디
            @Field("student_token") String student_token//토큰

    );

    //사용자 푸쉬 변경
    @FormUrlEncoded
    @POST("/app/member/push_agreement_change")
    Call<ResponseBody> push_agreement_change
    (
            @Field("student_id") String student_id, //아이디
            @Field("student_token") String student_token,//토큰
            @Field("student_push_agreement") String push_agreement//푸시 값

    );


    //사용자 기초정보 변경
    @FormUrlEncoded
    @POST("/app/member/default_information_change")
    Call<ResponseBody> user_information_change
    (
            @Field("student_id") String student_id, //아이디
            @Field("student_token") String student_token,//토큰
            @Field("student_content") String student_content,//자기소개
            @Field("student_tall") String student_tall,//학생 키
            @Field("student_weight") String student_weight,//학생 몸무게
            @Field("student_age") String student_age//학생 나이




    );

    //사용자 기초정보 변경
    @FormUrlEncoded
    @POST("/app/member/default_information_change")
    Call<ResponseBody> first_user_information_change
    (
            @Field("student_id") String student_id, //아이디
            @Field("student_token") String student_token,//토큰
            @Field("student_content") String student_content,//자기소개
            @Field("student_tall") String student_tall,//학생 키
            @Field("student_weight") String student_weight,//학생 몸무게
            @Field("student_age") String student_age,//학생 나이
            @Field("student_sex") String student_sex//학생 성별




    );



    //사용자 학급 정보 변경
    @FormUrlEncoded
    @POST("/app/member/class_information_change")
    Call<ResponseBody> class_information_change
    (
            @Field("student_id") String student_id, //아이디
            @Field("student_level") String student_level ,//학급
            @Field("student_class") String student_class,//반
            @Field("student_number") String student_number,//학생 번호
            @Field("student_token") String student_token//토큰


    );

    //사용자 프로필 이미지 변경
    @Multipart
    @POST("/app/member/profile_change")
    Call<ResponseBody> profile_change
    (

            @Part("student_id") RequestBody student_id, // 아이디
            @Part("student_token") RequestBody student_token,// 토큰
            @Part List<MultipartBody.Part> image_file // 이미지 파일
    );

    //사용자 비밀번호 변경
    @FormUrlEncoded
    @POST("/app/member/password_information_change")
    Call<ResponseBody> password_information_change
    (
            @Field("student_id") String student_id, //아이디
            @Field("student_token") String student_token,//토큰
            @Field("student_password_before") String student_password_before,//이전 비밀번호
            @Field("student_password_new") String student_password_new// 새로운 비밀번호
    );
    
    //콘텐츠 관 목록 가져오기
    @FormUrlEncoded
    @POST("/app/community/get_student_content_list_admin")
    Call<ResponseBody> get_student_content_list_admin
    (
            @Field("student_id") String student_id, //아이디
            @Field("student_token") String student_token//토큰

    );
    //사용자 소식 목록 가져오기
    @FormUrlEncoded
    @POST("/app/community/get_student_notice_list")
    Call<ResponseBody> get_student_notice_list
            (
                    @Field("student_id") String student_id, //아이디
                    @Field("student_token") String student_token,//토큰
                    @Field("student_class_code") String student_class_code//클래스 코드

            );


    //사용자 메세지 목록 가져오기
    @FormUrlEncoded
    @POST("/app/community/get_student_message_list")
    Call<ResponseBody> get_student_message_list
    (
            @Field("student_id") String student_id, //아이디
            @Field("student_token") String student_token,//토큰
            @Field("student_class_code") String student_class_code//클래스 코드

    );

    //사용자 메세지 상세보기 가져오기
    @FormUrlEncoded
    @POST("/app/community/get_student_message")
    Call<ResponseBody> get_student_message
    (
            @Field("student_id") String student_id, //아이디
            @Field("student_token") String student_token,//토큰
            @Field("message_number") String student_class_code//클래스 코드

    );

    //사용자 메세지 보내기
    @FormUrlEncoded
    @POST("/app/community/send_student_message")
    Call<ResponseBody> send_student_message
    (
            @Field("student_id") String student_id, //아이디
            @Field("student_token") String student_token,//토큰
            @Field("student_name") String student_name,//학생 이름
            @Field("student_class_code") String student_class_code,//해당 클래스 코드
            @Field("student_message_title") String student_message_title,//제목
            @Field("student_message_text") String student_message_text//내용


    );
    //사용자 메세지 수정
    @FormUrlEncoded
    @POST("/app/community/update_student_message")
    Call<ResponseBody> update_student_message
    (
            @Field("student_id") String student_id, //아이디
            @Field("student_token") String student_token,//토큰
            @Field("student_message_title") String student_name,//메세지 제목
            @Field("student_message_text") String student_class_code,//메세지 내용
            @Field("student_message_number") String student_message_number//메시지 번호

    );

    //사용자 메세지 삭제
   @FormUrlEncoded
    @POST("/app/community/delete_student_message")
    Call<ResponseBody> delete_student_message
    (
            @Field("student_id") String student_id, //아이디
            @Field("student_token") String student_token,//토큰
            @Field("student_message_number") String student_message_title//메시지 번호

    );

   //커뮤니티 리스트 가져오기 1
   @FormUrlEncoded
   @POST("/app/community/get_student_community_list")
   Call<ResponseBody> get_student_community_list
   (
           @Field("student_id") String student_id, //아이디
           @Field("student_token") String student_token,//토큰
           @Field("student_class_code") String student_class_code//클래스 번호

   );
  //커뮤니티 글 상세보기 데이터 가져오기 2
  @FormUrlEncoded
  @POST("/app/community/get_student_community")
  Call<ResponseBody> get_student_community
  (
          @Field("student_id") String student_id, //아이디
          @Field("student_token") String student_token,//토큰
          @Field("community_number") String community_number//커뮤니티 글 번호

  );
  //커뮤니티 글 작성 3
  @Multipart
  @POST("/app/community/create_student_community")
  Call<ResponseBody> create_student_community
  (
          @Part("student_id") RequestBody student_id, //아이디
          @Part("student_token") RequestBody student_token,//토큰
          @Part("student_name") RequestBody student_name,//이름
          @Part("student_class_code") RequestBody student_class_code,//클래스 코드
          @Part("community_title") RequestBody community_title,//글 제목
          @Part("community_text") RequestBody community_text,//글 내용
          @Part List<MultipartBody.Part> community_file, //파일
          @Part("community_file_name") RequestBody community_file_name,//글 내용
          @Part("community_file_name") RequestBody community_file_name2//글 내용
  );

  //커뮤니티 글 수정 4
  @Multipart
  @POST("/app/community/update_student_community")
  Call<ResponseBody> update_student_community
  (
          @Part("student_id") RequestBody student_id, //아이디
          @Part("student_token") RequestBody student_token,//토큰
          @Part("community_number") RequestBody student_class_code,//클래스 코드
          @Part("community_title") RequestBody community_title,//글 제목
          @Part("community_text") RequestBody community_text,//글 내용
          @Part("community_file1") RequestBody community_file1,
          @Part("community_file2") RequestBody community_file2,
          @Part List<MultipartBody.Part> community_new_file, //파일
          @Part("community_file_insert_name") RequestBody community_file_insert_name1,//글 내용
          @Part("community_file_insert_name") RequestBody community_file_insert_name2,//글 내용
          @Part("community_file_delete_name") RequestBody community_file_delete_name1,//글 삭제
          @Part("community_file_delete_name") RequestBody community_file_delete_name2//글 삭제
  );


  //커뮤니티 글 삭제5
  @FormUrlEncoded
  @POST("/app/community/delete_student_community")
  Call<ResponseBody> delete_student_community
  (
          @Field("student_id") String student_id, //아이디
          @Field("student_token") String student_token,//토큰
          @Field("community_number") String community_number//커뮤니티 글 번호
  );
  //커뮤니티 댓글 리스트 가져오기 6
  @FormUrlEncoded
  @POST("/app/community/get_student_community_comment_list")
  Call<ResponseBody> get_student_community_comment_list
  (
          @Field("student_id") String student_id, //아이디
          @Field("student_token") String student_token,//토큰
          @Field("community_number") String community_number//커뮤니티 글 번호

  );

  //커뮤니티 글 댓글 작성 7
  @FormUrlEncoded
  @POST("/app/community/create_student_community_comment_list")
  Call<ResponseBody> create_student_community_comment_list
  (
          @Field("student_id") String student_id, //아이디
          @Field("student_token") String student_token,//토큰
          @Field("student_name") String student_name,//토큰
          @Field("community_number") String community_number,//커뮤니티 글 번호
          @Field("comment_content") String comment_content//커뮤니티 댓글 내용

  );

  //커뮤니티 글 댓글 삭제 8
  @FormUrlEncoded
  @POST("/app/community/delete_student_community_comment_list")
  Call<ResponseBody> delete_student_community_comment_list
  (
          @Field("student_id") String student_id, //아이디
          @Field("student_token") String student_token,//토큰
          @Field("community_number") String community_number,//커뮤니티 코맨트 번호
          @Field("comment_number") String comment_number//커뮤니티 글 번호

  );

  //학생 신규 클래스 추가
  @FormUrlEncoded
  @POST("/app/class/student_class_update")
  Call<ResponseBody> student_class_update
  (
          @Field("student_id") String student_id, //아이디
          @Field("student_token") String student_token,//토큰
          @Field("class_code") String class_code,//신규 클래스 코드
          @Field("student_classcode") String student_class_code//전체 클래스 코드 값

  );

  //클래스 입장
  @FormUrlEncoded
  @POST("/app/class/get_class_unit_list")
  Call<ResponseBody> get_class_unit_list
  (
          @Field("student_id") String student_id, //아이디
          @Field("student_token") String student_token,//토큰
          @Field("class_code") String class_code//클래스 코드


  );

  //차시별(단원별) 클래스 수업 입장하기
  @FormUrlEncoded
  @POST("/app/curriculum/student_get_curriculum")
  Call<ResponseBody> student_get_curriculum
  (
          @Field("student_id") String student_id, //아이디
          @Field("student_token") String student_token,//토큰
          @Field("class_code") String class_code,//클래스 코드
          @Field("unit_code") String unit_code//유닛 코드
  );

  //수업 참여확인하기
  @FormUrlEncoded
  @POST("/app/curriculum/student_update_participation")
  Call<ResponseBody> student_update_participation
  (
          @Field("student_id") String student_id, //아이디
          @Field("student_token") String student_token,//토큰
          @Field("class_code") String class_code,//클래스 코드
          @Field("unit_code") String unit_code,//유닛 코드
          @Field("student_number") String student_number,//유닛 코드
          @Field("unit_class_type") String unit_class_type,//유닛 코드
          @Field("unit_group_name") String unit_group_name//유닛 코드
  );

    //최종 과제 제출하기
    @FormUrlEncoded
    @POST("/app/curriculum/student_update_submit_task")
    Call<ResponseBody> student_update_submit_task
    (
            @Field("student_id") String student_id, //아이디
            @Field("student_token") String student_token,//토큰
            @Field("class_code") String class_code,//클래스 코드
            @Field("unit_code") String unit_code,//유닛 코드
            @Field("student_number") String student_number,//유닛 코드
            @Field("unit_class_type") String unit_class_type,//유닛 코드
            @Field("unit_group_name") String unit_group_name//유닛 코드
    );



    //수업 현황 조회하기
    @FormUrlEncoded
    @POST("/app/record/get_student_class_record")
    Call<ResponseBody> get_student_class_record
    (
            @Field("student_id") String student_id, //아이디
            @Field("student_token") String student_token,//토큰
            @Field("class_code") String class_code,//클래스 코드
            @Field("unit_code") String unit_code//유닛 코드
    );
    //수업 콘텐츠 가져오기
    @FormUrlEncoded
    @POST("/app/class/get_content_list")
    Call<ResponseBody> get_content_list
    (
            @Field("student_id") String student_id, //아이디
            @Field("student_token") String student_token,//토큰
            @Field("content_code") String class_code//클래스 코드

    );

    //수업 현황 최초 생성하기
    @FormUrlEncoded
    @POST("/app/record/create_student_class_record")
    Call<ResponseBody> create_student_class_record
    (
            @Field("student_id") String student_id, //아이디
            @Field("student_token") String student_token,//토큰
            @Field("class_code") String class_code,//클래스 코드
            @Field("unit_code") String unit_code,//해당 클래스 유닛(차시별)코드
            @Field("student_name") String student_name,//학생 이름
            @Field("student_grade") String student_grade,//학생 학년
            @Field("student_group") String student_group,//학생 반
            @Field("student_number") String student_number,//학생 반
            @Field("student_participation") String student_participation,//출석 여부
            @Field("student_practice") String student_practice//실습과제 여부

    );

    //수업 실습 기록하기
    @FormUrlEncoded
    @POST("/app/record/update_student_record_class_practice")
    Call<ResponseBody> update_student_record_class_practice
    (
            @Field("student_id") String student_id, //아이디
            @Field("student_token") String student_token,//토큰
            @Field("class_code") String class_code,//클래스 코드
            @Field("unit_code") String unit_code,//유니 코드
            @Field("class_practice") String class_practice,//유니 코드
            @Field("content_use_time") String class_content_use_time, // 이용시간
            @Field("unit_group_name") String class_unit_group_name // 그룹 이름

    );
    //과제 실습 기록하기
    @FormUrlEncoded
    @POST("/app/record/update_student_record_task_practice")
    Call<ResponseBody> update_student_record_task_practice
    (
            @Field("student_id") String student_id, //아이디
            @Field("student_token") String student_token,//토큰
            @Field("class_code") String class_code,//클래스 코드
            @Field("unit_code") String unit_code,//유니 코드
            @Field("task_practice") String task_practice,//유니 코드
            @Field("content_use_time") String class_content_use_time, // 이용시간
            @Field("unit_group_name") String class_unit_group_name // 그룹 이름


    );
    //평가 실습 기록하기
    @FormUrlEncoded
    @POST("/app/record/update_student_record_evaluation_practice")
    Call<ResponseBody> update_student_record_evaluation_practice
    (
            @Field("student_id") String student_id, //아이디
            @Field("student_token") String student_token,//토큰
            @Field("class_code") String class_code,//클래스 코드
            @Field("unit_code") String unit_code,//유니 코드
            @Field("evaluation_practice") String evaluation_practice,//유니 코드
            @Field("content_use_time") String class_content_use_time, // 이용시간
            @Field("unit_group_name") String class_unit_group_name // 그룹 이름


    );
    //본인 확인 이미지 올리기
    @Multipart
    @POST("/app/record/update_student_record_image_confirmation")
    Call<ResponseBody> update_student_record_image_confirmation
    (
            @Part("student_id") RequestBody student_id, //아이디
            @Part("student_token") RequestBody student_token,//토큰
            @Part("class_code") RequestBody class_code,//클래스 코드
            @Part("unit_code") RequestBody unit_code,//유니 코드
            @Part("image_file_name") RequestBody image_file_name,//이미지 파일
            @Part List<MultipartBody.Part> file //파일

    );

    //제출 유형 가져오기
    ///app/record/get_class_project_submit_type
    @FormUrlEncoded
    @POST("/app/record/get_class_project_submit_type")
    Call<ResponseBody> get_class_project_submit_type
    (
            @Field("student_id") String student_id, //아이디
            @Field("student_token") String student_token,//토큰
            @Field("class_code") String class_code//클래스 코드
    );

    //전체 공지사항 가져오기 & 메세지 가져오기
    @FormUrlEncoded
    @POST("/app/member/get_my_news")
    Call<ResponseBody> get_my_news
    (
            @Field("student_id") String student_id, //아이디
            @Field("student_token") String student_token,//토큰
            @Field("type") String type//클래스 코드



    );

    //전체 공지사항 가져오기
    @FormUrlEncoded
    @POST("/app/member/get_my_news")
    Call<ResponseBody> get_my_news_in_class
    (
            @Field("student_id") String student_id, //아이디
            @Field("student_token") String student_token,//토큰
            @Field("type") String type,//타입
            @Field("class_code") String class_code//클래스 코드



    );

    //탈퇴하기
    @FormUrlEncoded
    @POST("/app/member/student_resign")
    Call<ResponseBody> student_resign
    (
            @Field("student_id") String student_id, //아이디
            @Field("student_token") String student_token,//토큰
            @Field("student_password") String student_password//학생 비밀번호
    );

/* //사용자 프로필 이미지 변경
    @Multipart
    @POST("/app/member/profile_change")
    Call<ResponseBody> profile_change
    (

            @Part("student_id") RequestBody student_id, // 아이디
            @Part("student_token") RequestBody student_token,// 토큰
            @Part List<MultipartBody.Part> image_file // 이미지 파일
    );*/

    /*  //커뮤니티 글 수정 4
  @Multipart
  @POST("/app/community/update_student_community")
  Call<ResponseBody> update_student_community
  (
          @Part("student_id") RequestBody student_id, //아이디
          @Part("student_token") RequestBody student_token,//토큰
          @Part("community_number") RequestBody student_class_code,//클래스 코드
          @Part("community_title") RequestBody community_title,//글 제목
          @Part("community_text") RequestBody community_text,//글 내용
          @Part("community_file1") RequestBody community_file1,
          @Part("community_file2") RequestBody community_file2,
          @Part List<MultipartBody.Part> community_new_file, //파일
          @Part("community_file_insert_name") RequestBody community_file_insert_name1,//글 내용
          @Part("community_file_insert_name") RequestBody community_file_insert_name2,//글 내용
          @Part("community_file_delete_name") RequestBody community_file_delete_name1,//글 삭제
          @Part("community_file_delete_name") RequestBody community_file_delete_name2//글 삭제
  );
*/
}