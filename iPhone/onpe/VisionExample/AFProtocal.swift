//
//  File.swift
//  VisionExample
//
//  Created by Ik ju Song on 2021/01/28.
//  Copyright © 2021 Google Inc. All rights reserved.
//

import Foundation

protocol AppLoginDelegate {
    func appLogin(result : Int)
}
protocol appOverlapCheckDelegate {
    func appIdOverlapCheck(result : Int)
    func appEmailOverlapCheck(result : String)
    func appSignUp(result : Int)
}

protocol appidFindDelegate {
    func appIdFind(result : Int, id : String)
}
protocol appPwFindDelegate {
    func appPwFind(result : Int)
}
protocol appPwFindResultDelegate {
    func appPwFindResult(result : Int)
}
protocol appMemberDefaultInformationChangeDelegate {
    func appMemberDefaultInformationChange(result : Int)
}
protocol appMemberPushAgreementChangeDelegate {
    func appMemberPushAgreementChange(result : Int)
}
protocol appMemberMypageDelegate {
    func appMemberClassInformationChange(result : Int)
    func appMemberProfileChange(result : Int, imageUrl : String)
    func appMemberDefaultInformationChange1(result : Int)
    func appMemberPasswordInformationChange(result : Int)
}
protocol appCommunityGetStudentMessageDelegate {
    func appCommunityGetStudentMessage(result : Int, message_title : String, message_text : String, message_name : String, message_date : String, message_comment_state : String, message_comment_date : String, message_comment : String, message_teacher_name : String)
    func appCommunityUpdateStudentMessage(result : Int)
    func appCommunityDeleteStudentMessage(result : Int)
}

protocol appCommunitySendStudentMessageDelegate {
    func appCommunitySendStudentMessage(result : Int)
    func appCommunityUpdateStudentCommunity(result : Int)
    func appCommunityCreateStudentCommunity(result : Int)
}

protocol appCommunityUpdateStudentMessageDelegate {
    
}

protocol appCommunityGetStudentCommunityDelegate {
    func appCommunityGetStudentCommunity(result : Int, community : Community?)
    func appCommunityGetStudentCommunityCommentList(result : Int, commentList : [CommentList]?)
    func appCommunityDeleteStudentCommunityCommentList(result : Int, indexpath: Int)
    func appCommunityCreateStudentCommunityCommentList(result : Int)
    
}

protocol appCommunityGetStudentFaqDelegate {
    func appCommunityGetStudentFaq(result : Int, faq : [Faq]?)
}

protocol appCommunityGetstudentContentListAdminDelegate{
    func appCommunityGetstudentContentListAdmin(result : Int, content : [Content]?)
}

protocol appCommunityPostStudentCommunityDelegate {
    func appCommunityDeleteStudentCommunity(result : Int)
}
protocol appCommunityGetStudentCommunityListDelegate {
    func appCommunityGetStudentCommunityList(result : Int , CommunityList : [CommunityList]? )
}

protocol mainPageDelegate {
    func appClassStudentClassUpdate(result : Int)
    func appClassGetClassUnitList(result : Int, ClassListStr : String, fail : String?)
}
protocol unitListPageDelegate {
    func appCurriculumStudentGetCurriculum(result : Int, unitList : [UnitList])
    func appRecordGetStudentClassRecord(result : Int, recordDic : recordDic?)
}

protocol exerciseTestPageDelegate {
    func appClassGetContentList(result : Int, exerciseContentStr : String?)
    func appCurriculumStudentUpdateSubmitTask(result : Int)
    
    
}

protocol appCommunityGetStudentMessageList  {
    func appCommunityGetStudentMessageList(result : Int, getMessageList : [MessageList]?)
}
protocol appRecordGetClassProjectSubmitType {
    func appRecordGetClassProjectSubmitType(result : Int, getTypeList : [submitAdressList]?)
}

