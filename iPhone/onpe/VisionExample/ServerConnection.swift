//
//  ServerConnection.swift
//  VisionExample
//
//  Created by 신우진 on 2021/07/12.
//  Copyright © 2021 Complexion
//

import Foundation
import Alamofire

typealias responseReceiver = (_ responseCode : Int, _ response : Any?) -> Void

public class ServerConnection
{
    let baseURL = "https://onpe.co.kr/staging/"
    // MARK: ServerConnection 로그인 START
    func login(student_id : String, student_password : String, loginType : String = "E", student_name : String,
               student_email : String, student_push_agreement : String, student_phone_number : String, completion : @escaping responseReceiver)
    {
 
        let targetUrl = baseURL + "app/sns_login"
        let parameters : Parameters = [
            "student_id" : "\(student_id)",
            "student_password" : "\(student_password)",
            "loginType" : "\(loginType)",
            "fcmtoken" : "\(UserInformation.fcm_token)",
            "student_name" : "\(student_name)",
            "student_email" : "\(student_email)",
            "student_push_agreement" : "\(student_push_agreement)",
            "student_phone_number" : "\(student_phone_number)"
        ]

        AF.request(targetUrl, method: .post, parameters: parameters, headers: nil).responseJSON { (response) in
            
            switch(response.result)
            {
            case .success(let value):
                
                print("++ ServerConnection[login] response : \(value)")
                
                completion(1, value)
                break
                
            case .failure(_):
                
                completion(0, nil)
                break;
            }
        }

    }
    // MARK: ServerConnection 로그인 END
    
    func appAutoLogin(student_id: String, student_token : String, completion : @escaping responseReceiver)
    {
        let targetUrl = baseURL + "app/login"
        let parameters : Parameters = [
            "student_id" : "\(student_id)",
            "student_token" : "\(student_token)",
            "fcmtoken" : "\(UserInformation.fcm_token)"
        ]
        
        AF.request(targetUrl, method: .post, parameters: parameters, headers: nil).responseJSON { (response) in
            
            switch(response.result)
            {
            case .success(let value):
                
                print("++ ServerConnection[appAutoLogin] response : \(value)")
                
                completion(1, value)
                break
                
            case .failure(_):
                
                completion(0, nil)
                break;
            }
        }
    }
}

