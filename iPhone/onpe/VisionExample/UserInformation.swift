//
//  userInformationClass.swift
//  VisionExample
//
//  Created by Ik ju Song on 2021/01/28.
//  Copyright © 2021 Google Inc. All rights reserved.
//

import Foundation

public class UserInformation {
    public static var student_id : String = ""
    public static var student_name : String = ""
    public static var student_email : String = ""
    public static var student_phone : String = ""
    public static var student_push_agreement : String = ""
    public static var student_email_agreement : String = ""
    public static var student_message_agreement : String = ""
    public static var student_image_url : String = ""
    public static var student_content : String = ""
    public static var student_tall : String = ""
    public static var student_weight : String = ""
    public static var student_age : String = ""
    public static var student_sex : String = ""
    public static var student_school : String = ""
    public static var student_level : String = ""
    public static var student_class : String = ""
    public static var student_number : String = ""
    public static var student_state : String = ""
    public static var news_state : String = ""
    public static var new_messgae_state : String = ""
    public static var student_classcode : [[String:String]] = []
    public static var student_classcodeList : [String] = []
    public static var student_classcodeNameList : [String] = []
    public static var student_create_date : String = ""
    public static var student_recent_join_date : String = ""
    public static var student_recent_exercise_date : String = ""
    
    public static var access_token : String = ""
    public static var fcm_token : String = ""
    
    
    public static let preferences = UserDefaults.standard
    public static let autoLoginKey = "com.funidea.onPhysicaleducation.autoLoginKey"
    public static let unitListKey = "com.funidea.onPhysicaleducation.unitListKey"
    
    public static var recordCheckBool = false// 해당 값이 true가 되다면 운동 완료후 기록화인 버튼을 누른것이다. true이면  운동리스트 화면에서 결과보기 페이지로 바로 넘어간다.
}
