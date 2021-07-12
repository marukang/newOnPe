//
//  jsonStruct.swift
//  VisionExample
//
//  Created by Ik ju Song on 2021/01/28.
//  Copyright © 2021 Google Inc. All rights reserved.
//

import Foundation



struct userInformation: Codable {
    var access_token : String?
    var new_messgae_state : String?
    var news_state : String?
    var student_age : String?
    var student_class : String?
    var student_classcode : String?
    var student_content : String?
    var student_create_date : String?
    var student_email : String?
    var student_email_agreement : String?
    var student_id : String?
    var student_image_url : String?
    var student_level : String?
    var student_message_agreement : String?
    var student_name : String?
    var student_number : String?
    var student_phone : String?
    var student_push_agreement : String?
    var student_recent_join_date : String?
    var student_school : String?
    var student_sex : String?
    var student_state : String?
    var student_tall : String?
    var student_weight : String?
    var student_recent_exercise_date : String?
    
    var fail : String?

}

struct _successFail : Codable {
    var success : String?
    var fail : String?
    var student_token : String?
}

struct _successFailMessage : Codable {
    var success : Success?
    var fail : String?
    var student_token : String?
    
    enum CodingKeys: CodingKey {
        case success
        case student_token
        case fail
    }
}
struct Success: Codable {
    var messageNumber, messageClassCode, messageTitle, messageText: String?
    var messageDate, messageID, messageName, messageCommentState: String?
    var messageComment, messageTeacherName, messageTeacherID, messageCommentDate: String?

    enum CodingKeys: String, CodingKey {
        case messageNumber = "message_number"
        case messageClassCode = "message_class_code"
        case messageTitle = "message_title"
        case messageText = "message_text"
        case messageDate = "message_date"
        case messageID = "message_id"
        case messageName = "message_name"
        case messageCommentState = "message_comment_state"
        case messageComment = "message_comment"
        case messageTeacherName = "message_teacher_name"
        case messageTeacherID = "message_teacher_id"
        case messageCommentDate = "message_comment_date"
    }
}

struct _successFailFaq : Codable {
    var success : [Faq]?
    var fail : String?
    var student_token : String?
    
    enum CodingKeys: CodingKey {
        case success
        case student_token
        case fail
    }
}

struct Faq: Codable {
    var faq_content, faq_date, faq_number, faq_target: String?
    var faq_title, faq_type : String?
}

struct _successFailContent : Codable {
    var success : [Content]?
    var fail : String?
    var student_token : String?
    
}

struct Content: Codable {
    var content_date, content_id, content_number, content_youtube_url: String?
}

struct _successFailCommunity : Codable {
    var success : Community?
    var fail : String?
    var student_token : String?
    
    
}

struct Community : Codable {
    var community_class_code: String?
    var community_count : String?
    var community_date : String?
    var community_file1 : String?
    var community_file2 : String?
    var community_id : String?
    var community_name : String?
    var community_number : String?
    var community_text : String?
    var community_title : String?
}

struct _successFailCommunityList : Codable {
    var success : [CommunityList]?
    var fail : String?
    var student_token : String?
    
    
}

struct CommunityList : Codable {
    var community_class_code: String?
    var community_count : String?
    var community_date : String?
    var community_file1 : String?
    var community_file2 : String?
    var community_id : String?
    var community_name : String?
    var community_number : String?
    var community_text : String?
    var community_title : String?
}



struct _successFailCommentList : Codable {
    var success : [CommentList]?
    var fail : String?
    var student_token : String?
}

struct CommentList : Codable {
    var comment_community_number: String?
    var comment_content : String?
    var comment_date : String?
    var comment_id : String?
    var comment_name : String?
    var comment_number : String?
}

struct _successFailClass : Codable {
    var success : String?
    var fail : String?
    var student_token : String?
}

struct ClassList : Codable {
    var unit_class_name : String?
    var unit_code : String?
    var unit_start_date : String?
    var unit_end_date : String?
}

struct _successFailunit : Codable {
    var success : [UnitList]?
    var fail : String?
    var student_token : String?
    
}

struct UnitList : Codable {
    var class_code : String?
    var content_code_list : String?
    var content_evaluation_type : String?
    var content_home_work : String?
    var content_participation : String?
    var content_submit_task : String?
    var content_test : String?
    var content_use_time : String?
    var unit_attached_file : String?
    var unit_class_name : String?
    var unit_class_text : String?
    var unit_class_type : String?
    var unit_code : String?
    var unit_content_url : String?
    var unit_end_date : String?
    var unit_group_name : String?
    var unit_group_id_list : String?
    var unit_start_date : String?
    var unit_youtube_url : String?
    
}

struct unitContent : Codable {
    var content_name : String?
    var content_code : String?
    var content_title : String?
}

struct exerciseContent : Codable{
    var content_code : String?
    var content_value : String?
    var content_title : String?
    var content_user : String?
    var content_class_level : String?
    var content_class_grade : String?
    var content_write_date : String?
    var content_number_list : String?
    var content_name_list : String?
    var content_cateogry_list : String?
    var content_type_list : String?
    var content_area_list : String?
    var content_detail_name_list : String?
    var content_count_list : String?
    var content_time : String?
    var content_url : String?
    var content_level_list : String?
}

struct _successFailRecord : Codable{
    var success : recordDic?
    var fail : String?
    var student_token : String?
}
struct recordDic : Codable {
    var class_code : String?
    var class_practice : String?
    var evaluation_practice : String?
    var evaluation_type_1: String?
    var evaluation_type_2 : String?
    var evaluation_type_3 : String?
    var image_confirmation : String?
    var stduent_number : String?
    var student_grade : String?
    var student_group : String?
    var student_name : String?
    var student_participation : String?
    var student_practice : String?
    var task_practice : String?
    var unit_code : String?
}

struct recordList : Codable {
    var content_title : String?
    var content_name : String?
    var content_category : String?
    var content_detail_name : String?
    var content_average_score : String?
    var content_count : String?
    var content_time : String?
    
}

struct poseRecordStruct {
    var content_name : String?
    var content_category : String?
    var content_detail_name : String?
    var content_average_score : String?
    var content_count : String?
    var content_time : String?
}
struct _successFailMessageList : Codable{
    var success : [MessageList]?
    var fail : String?
    var student_token : String?
}

struct MessageList : Codable {
    var message_comment_state : String?
    var message_date : String?
    var message_number : String?
    var message_title : String?
}

struct submitAdressList : Codable {
    var type : String?
    var link : String?
}
public struct _successFailPushList : Codable {
    var success : [pushList]?
    var fail : String?
    var student_token : String?
}

public struct pushList : Codable {
    var push_content : String?
    var push_create_date : String?
    var push_number : String?
    var push_reservation_time : String?
    var push_state : String?
    var push_title : String?
    var notice_class_code : String?
    var notice_content : String?
    var notice_date : String?
    var notice_id : String?
    var notice_name : String?
    var notice_number : String?
    var notice_title : String?
    var notice_type : String?
    var id : String?
    var message_content : String?
    var message_date : String?
    var name : String?
}
