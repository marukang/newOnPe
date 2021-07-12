//
//  ServerConnection.swift
//  VisionExample
//
//  Created by 신우진 on 2021/07/12.
//  Copyright © 2021 Complexion
//

import Foundation
import Alamofire

typealias responseReceiver = (_ requestName : String, _ response : Any) -> Void

public class ServerConnection
{
    let baseURL = "https://onpe.co.kr/"
    // MARK: ServerConnection 로그인 START
    func login(student_id : String, student_password : String, loginType : String = "E", completion : responseReceiver)
    {
        let targetUrl = baseURL + ""
        let parameters : Parameters = [
            "student_id" : "\(student_id)",
            "student_password" : "\(student_password)",
            "loginType" : "\(loginType)",
            "fcmtoken" : "\(userInformationClass.fcm_token)"
        ]

//        AF.request(targetUrl, method: .post, parameters: parameters, headers: nil).responseJSON { (response) in
//
//            switch response.result
//            {
//            case .success(let value):
//
//                print("++ ServerConnection[login] response : \(value)")
//
//                let dataJSon = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
//
//                break
//
//            case .failure(_):
//                break
//            }
//        }
    }
    // MARK: ServerConnection 로그인 END
}

