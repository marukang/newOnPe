//
//  AFClass.swift
//  VisionExample
//
//  Created by Ik ju Song on 2021/01/28.
//  Copyright © 2021 Google Inc. All rights reserved.
//

import Foundation
import Alamofire
/**
 
 var result : Int = 0
 let parameters : Parameters = ["" : , "" :]
 
 AF.request(basURL + url, method: .post, parameters: parameters, headers: nil)
 .responseJSON {
 response in
 debugPrint("반응 : ",response)
 switch response.result {
 case .success(let value):
 //print("value : ",value)
 do{
 let dataJSon = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
 let getResult = try JSONDecoder().decode(_successFail.self, from: dataJSon)
 if getResult.success != nil{
     result = 0
     extensionClass.setTokenChange(token: (getResult.student_token ?? ""))
 } else {
     result = 1
 }
 
 
 } catch {
 
 print(error)
 }
 case .failure(let error):
 result = 2
 print("error 발생 : \(error)")
 break
 }
 }
 
 */

/**
 - 서버 통신 규칙
 0. viewController에서 AFClass의 함수를 실행시킨다.
 1.  AFClass에서 Alamofire 함수를 이용해서 서버와 통신한다.
 2.  AFProtocal Class에서 Delegate를 이용해 통신으로 인한 결과값을 viewController에 알려준다.
 */

public class ServerConnectionLegacy {
    //let basURL = "https://lllloooo.shop/"
    let basURL = "https://onpe.co.kr/"
    var delegate0 : AppLoginDelegate?
    var delegate1 : appOverlapCheckDelegate?
    var delegate2 : appidFindDelegate?
    var delegate3 : appPwFindDelegate?
    var delegate4 : appPwFindResultDelegate?
    var delegate5 : appMemberDefaultInformationChangeDelegate?
    var delegate6 : appMemberPushAgreementChangeDelegate?
    var delegate7 : appMemberMypageDelegate?
    var delegate8 : appCommunityGetStudentMessageDelegate?
    var delegate9 : appCommunitySendStudentMessageDelegate?
    var delegate10 : appCommunityGetStudentFaqDelegate?
    var delegate11 : appCommunityGetstudentContentListAdminDelegate?
    var delegate12 : appCommunityGetStudentCommunityDelegate?
    var delegate13 : appCommunityPostStudentCommunityDelegate?
    var delegate14 : appCommunityGetStudentCommunityListDelegate?
    var delegate15 : mainPageDelegate?
    var delegate16 : unitListPageDelegate?
    var delegate17 : exerciseTestPageDelegate?
    var delegate18 : appCommunityGetStudentMessageList?
    var delegate19 : appRecordGetClassProjectSubmitType?
    
    
    public func appMemberStudentResign(student_id : String, student_password : String ,student_token : String, url : String, _ completion : @escaping (Int, String) -> Void ){
        
        var result : Int = 0
        var result0 : String = ""
        let parameters : Parameters = ["student_id" : student_id, "student_password" :student_password, "student_token" :student_token]
        
        AF.request(basURL + url, method: .post, parameters: parameters, headers: nil)
            .responseJSON {
                response in
                debugPrint("반응 : ",response)
                switch response.result {
                case .success(let value):
                    //print("value : ",value)
                    do{
                        let dataJSon = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let getResult = try JSONDecoder().decode(_successFail.self, from: dataJSon)
                        if getResult.success != nil{
                            result = 0
                            result0 = getResult.success ?? ""
                            
                        } else {
                            result0 = getResult.fail ?? ""
                            result = 1
                        }
                        
                        print(getResult)
                        completion(result,result0)
                    } catch {
                        
                        print(error)
                    }
                case .failure(let error):
                    result = 2
                    print("error 발생 : \(error)")
                    break
                }
            }
        
        
        
    }
    
    public func appMemberGetMyNews(student_id : String, student_token : String, type : String , class_code : String?, url : String, completion : @escaping(Int, [pushList]?) -> Void ){
        var result : Int = 0
        var result1: [pushList]?
        var parameters : Parameters?
        if class_code == nil {
            parameters = ["student_id" : student_id, "student_token": student_token, "type" : type]
        } else {
            parameters = ["student_id" : student_id, "student_token": student_token, "type" : type, "class_code" : class_code!]
        }
        
        
        AF.request(basURL + url, method: .post, parameters: parameters, headers: nil)
            .responseJSON {
                response in
                debugPrint("반응 : ",response)
                switch response.result {
                case .success(let value):
                    //print("value : ",value)
                    do{
                        let dataJSon = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let getResult = try JSONDecoder().decode(_successFailPushList.self, from: dataJSon)
                        if getResult.success != nil{
                            result = 0
                            extensionClass.setTokenChange(token: (getResult.student_token ?? ""))
                            result1 = getResult.success
                        } else {
                            result = 1
                        }
                        
                        
                    } catch {
                        
                        print(error)
                    }
                case .failure(let error):
                    result = 2
                    print("error 발생 : \(error)")
                    break
                }
                completion(result, result1)
            }
    }
    public func appRecordGetClassProjectSubmitType(student_id : String, student_token : String, class_code : String, url : String){
        var result : Int = 0
        let parameters : Parameters = ["student_id" : student_id, "student_token" :student_token, "class_code" : class_code]
        var getTypeList : [submitAdressList] = []
        AF.request(basURL + url, method: .post, parameters: parameters, headers: nil)
            .responseJSON {
                response in
                debugPrint("반응 : ",response)
                switch response.result {
                case .success(let value):
                    //print("value : ",value)
                    do{
                        let dataJSon = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let getResult = try JSONDecoder().decode(_successFail.self, from: dataJSon)
                        if getResult.success != nil{
                            result = 0
                            extensionClass.setTokenChange(token: (getResult.student_token ?? ""))
                            if let data = getResult.success?.data(using: .utf8){
                                do {
                                    let getResult = try JSONDecoder().decode([submitAdressList].self, from: data)
                                    getTypeList.removeAll()
                                    getTypeList = getResult
                                }catch(let error){
                                    print(error)
                                }
                            }
                        } else {
                            result = 1
                        }
                        
                        
                    } catch {
                        
                        print(error)
                    }
                case .failure(let error):
                    result = 2
                    print("error 발생 : \(error)")
                    break
                }
                self.delegate19?.appRecordGetClassProjectSubmitType(result: result, getTypeList: getTypeList)
            }
    }
    public func appCurriculumStudentUpdateSubmitTask(student_id : String, student_token : String, class_code : String, unit_code : String, student_number : String, unit_class_type : String, unit_group_name : String?, url : String){
        var result : Int = 0
        var parameters : Parameters?
        if unit_class_type == "0"{
            parameters = ["student_id" :student_id , "student_token" :student_token, "class_code" : class_code, "unit_code" : unit_code, "student_number" : student_number, "unit_class_type" : unit_class_type]
        } else {
            parameters = ["student_id" :student_id , "student_token" :student_token, "class_code" : class_code, "unit_code" : unit_code, "student_number" : student_number, "unit_class_type" : unit_class_type, "unit_group_name" : unit_group_name!]
        }
            
        
        AF.request(basURL + url, method: .post, parameters: parameters, headers: nil)
            .responseJSON {
                response in
                debugPrint("반응 : ",response)
                switch response.result {
                case .success(let value):
                    //print("value : ",value)
                    do{
                        let dataJSon = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let getResult = try JSONDecoder().decode(_successFail.self, from: dataJSon)
                        if getResult.success != nil{
                            result = 0
                            extensionClass.setTokenChange(token: (getResult.student_token ?? ""))
                        } else {
                            result = 1
                        }
                        
                        
                    } catch {
                        
                        print(error)
                    }
                case .failure(let error):
                    result = 2
                    print("error 발생 : \(error)")
                    break
                }
                self.delegate17?.appCurriculumStudentUpdateSubmitTask(result: result)
            }
    }
    
    
    
    public func appRecordUpdateStudentRecordImageConfirmation(student_id : String, student_token : String, class_code : String, unit_code : String, image_file_name : String, file : UIImage, url : String){
        
        var result : Int = 0
        
        let parameters : Parameters = ["student_id" : student_id, "student_token" : student_token, "class_code" : class_code, "unit_code" : unit_code, "image_file_name" : image_file_name]
        print(parameters)
        print(file)
        AF.upload(multipartFormData: {multipartFormData in
            //일반적인 json 파일
            for (key, value) in parameters {
                multipartFormData.append(Data("\(value)".utf8), withName: "\(key)")
            }
            print(file.jpegData(compressionQuality: 0.2)!)
            multipartFormData.append(file.jpegData(compressionQuality: 0.2)!, withName: "file", fileName: "\(image_file_name).jpg", mimeType: "image/jpg")
            print(multipartFormData)
            print("----------------")
        }, to: basURL + url)//<- url 입력
        .responseJSON {
            response in
            debugPrint("반응 : ",response)
            switch response.result {
            case .success(let value):
                //print("value : ",value)
                do{
                    let dataJSon = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                    let getResult = try JSONDecoder().decode(_successFail.self, from: dataJSon)
                    if getResult.success != nil{
                        result = 0
                        extensionClass.setTokenChange(token: (getResult.student_token ?? ""))
                    } else {
                        result = 1
                    }
                    
                    
                } catch {
                    print(error)
                }
            case .failure(let error):
                result = 2
                print("error 발생 : \(error)")
                break
            }
        }
        
        
    }
    
    public func appRecordCreateStudentClassRecord(student_id : String, student_token : String, class_code : String, unit_code : String, student_name : String, student_grade : String, student_group : String, student_number : String, student_participation : String, student_practice : String, url : String){
        
        var result : Int = 0
        let parameters : Parameters = ["student_id" : student_id, "student_token" :student_token, "class_code" : class_code, "unit_code" : unit_code, "student_name" : student_name, "student_grade" : student_grade, "student_group" : student_group, "student_number" : student_number, "student_participation" : student_participation, "student_practice" : student_practice]
        print(parameters)
        AF.request(basURL + url, method: .post, parameters: parameters, headers: nil)
            .responseJSON {
                response in
                debugPrint("반응 : ",response)
                switch response.result {
                case .success(let value):
                    //print("value : ",value)
                    do{
                        let dataJSon = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let getResult = try JSONDecoder().decode(_successFail.self, from: dataJSon)
                        if getResult.success != nil{
                            result = 0
                            extensionClass.setTokenChange(token: (getResult.student_token ?? ""))
                        } else {
                            result = 1
                        }
                        
                        
                    } catch {
                        
                        print(error)
                    }
                case .failure(let error):
                    result = 2
                    print("error 발생 : \(error)")
                    break
                }
            }
    
    }
    
    public func appRecordUpdateStudentRecord(student_id : String, student_token : String, class_code : String, unit_code : String, practice : String ,subjectType: String, content_use_time : String, unit_group_name : String?){
        
        var result : Int = 0
        var parameters : Parameters = [:]
        var url : String = ""
        print(subjectType)
        switch subjectType {
        case "실습":
            if let unit_group_name = unit_group_name {
                //그룹일경우
                parameters = ["student_id" : student_id, "student_token" :student_token, "class_code" : class_code, "unit_code" : unit_code, "class_practice" : practice, "content_use_time" : content_use_time, "unit_group_name" : unit_group_name]
            } else {
                parameters = ["student_id" : student_id, "student_token" :student_token, "class_code" : class_code, "unit_code" : unit_code, "class_practice" : practice, "content_use_time" : content_use_time]
            }
            
            url = "app/record/update_student_record_class_practice"
            break
        case "이론":
            if let unit_group_name = unit_group_name {
                //그룹일경우
                parameters = ["student_id" : student_id, "student_token" :student_token, "class_code" : class_code, "unit_code" : unit_code, "task_practice" : practice, "content_use_time" : content_use_time, "unit_group_name" : unit_group_name]
            } else {
                parameters = ["student_id" : student_id, "student_token" :student_token, "class_code" : class_code, "unit_code" : unit_code, "task_practice" : practice, "content_use_time" : content_use_time]
            }
            
            url = "app/record/update_student_record_task_practice"
            break
        case "평가":
            if let unit_group_name = unit_group_name {
                //그룹일경우
                parameters = ["student_id" : student_id, "student_token" :student_token, "class_code" : class_code, "unit_code" : unit_code, "evaluation_practice" : practice, "content_use_time" : content_use_time, "unit_group_name" : unit_group_name]
            } else {
                parameters = ["student_id" : student_id, "student_token" :student_token, "class_code" : class_code, "unit_code" : unit_code, "evaluation_practice" : practice, "content_use_time" : content_use_time]
            }
            
            url = "app/record/update_student_record_evaluation_practice"
            break
        default:
            print("error")
            return
        }
        print("parameters : ",parameters)
        print("url : ",url)
        AF.request(basURL + url, method: .post, parameters: parameters, headers: nil)
            .responseJSON {
                response in
                debugPrint("반응 : ",response)
                switch response.result {
                case .success(let value):
                    //print("value : ",value)
                    do{
                        let dataJSon = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let getResult = try JSONDecoder().decode(_successFail.self, from: dataJSon)
                        if getResult.success != nil{
                            result = 0
                            extensionClass.setTokenChange(token: (getResult.student_token ?? ""))
                        } else {
                            result = 1
                        }
                        
                        UserInformation.student_recent_exercise_date = extensionClass.DateToString(date: extensionClass.nowTimw(), type: 0)
                        print(result)
                        
                    } catch {
                        
                        print(error)
                    }
                case .failure(let error):
                    result = 2
                    print("error 발생 : \(error)")
                    break
                }
            }
        
    }
    
    public func appRecordGetStudentClassRecord(student_id : String, student_token : String, class_code : String, unit_code : String, url : String){
        var result : Int = 0
        let parameters : Parameters = ["student_id" : student_id, "student_token" :student_token, "class_code" : class_code, "unit_code" : unit_code]
        var recordDic : recordDic?
        AF.request(basURL + url, method: .post, parameters: parameters, headers: nil)
            .responseJSON {
                response in
                debugPrint("반응 : ",response)
                switch response.result {
                case .success(let value):
                    //print("value : ",value)
                    do{
                        let dataJSon = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let getResult = try JSONDecoder().decode(_successFailRecord.self, from: dataJSon)
                        if getResult.success != nil{
                            result = 0
                            recordDic = getResult.success
                            extensionClass.setTokenChange(token: (getResult.student_token ?? ""))
                        } else {
                            result = 1
                        }
                        
                        
                    } catch {
                        
                        print(error)
                    }
                case .failure(let error):
                    result = 2
                    print("error 발생 : \(error)")
                    break
                }
                self.delegate16?.appRecordGetStudentClassRecord(result: result, recordDic: recordDic ?? nil)
            }
    }
    
    public func appCurriculumStudentUpdateParticipation(student_id : String, student_token : String, class_code : String, unit_code : String, student_number : String, unit_class_type : String, unit_group_name : String, url : String){
        var result : Int = 0
        var parameters : Parameters?
        if unit_group_name == "0"{
            parameters = ["student_id" : student_id, "student_token" :student_token, "class_code" : class_code, "unit_code" : unit_code, "student_number" : student_number, "unit_class_type" : unit_class_type]
        } else {
            parameters = ["student_id" : student_id, "student_token" :student_token, "class_code" : class_code, "unit_code" : unit_code, "student_number" : student_number, "unit_class_type" : unit_class_type, "unit_group_name" : unit_group_name ]
        }
       
        
        AF.request(basURL + url, method: .post, parameters: parameters, headers: nil)
            .responseJSON {
                response in
                debugPrint("반응 : ",response)
                switch response.result {
                case .success(let value):
                    //print("value : ",value)
                    do{
                        let dataJSon = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let getResult = try JSONDecoder().decode(_successFail.self, from: dataJSon)
                        if getResult.success != nil{
                            result = 0
                            
                            extensionClass.setTokenChange(token: (getResult.student_token ?? ""))
                        } else {
                            result = 1
                        }
                        
                        
                    } catch {
                        
                        print(error)
                    }
                case .failure(let error):
                    result = 2
                    print("error 발생 : \(error)")
                    break
                }
                
            }
    }
    
    public func appCurriculumStudentGetCurriculum(student_id : String, student_token : String, class_code : String, unit_code : String, url : String){
        var result : Int = 0
        let parameters : Parameters = ["student_id" : student_id, "student_token" : student_token, "class_code" : class_code, "unit_code" : unit_code]
        var unitList : [UnitList] = []
        AF.request(basURL + url, method: .post, parameters: parameters, headers: nil)
            .responseJSON {
                response in
                debugPrint("반응 : ",response)
                switch response.result {
                case .success(let value):
                    //print("value : ",value)
                    do{
                        let dataJSon = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let getResult = try JSONDecoder().decode(_successFailunit.self, from: dataJSon)
                        if getResult.success != nil{
                            result = 0
                            extensionClass.setTokenChange(token: (getResult.student_token ?? ""))
                            unitList = getResult.success ?? []
                        } else {
                            result = 1
                        }
                        
                        
                    } catch {
                        
                        print(error)
                    }
                case .failure(let error):
                    result = 2
                    print("error 발생 : \(error)")
                    break
                }
                self.delegate16?.appCurriculumStudentGetCurriculum(result: result, unitList: unitList)
            }
    }
    public func appClassGetContentList(student_id : String, student_token : String, content_code : String, url : String){
        var result : Int = 0
        let parameters : Parameters = ["student_id" : student_id, "student_token" :student_token, "content_code": content_code]
        var success : String?
        AF.request(basURL + url, method: .post, parameters: parameters, headers: nil)
            .responseJSON {
                response in
                debugPrint("반응 : ",response)
                switch response.result {
                case .success(let value):
                    //print("value : ",value)
                    do{
                        let dataJSon = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let getResult = try JSONDecoder().decode(_successFail.self, from: dataJSon)
                        if getResult.success != nil{
                            result = 0
                            success = getResult.success
                            extensionClass.setTokenChange(token: (getResult.student_token ?? ""))
                            
                            
                        } else {
                            result = 1
                        }
                        
                        
                    } catch {
                        
                        print(error)
                    }
                case .failure(let error):
                    result = 2
                    print("error 발생 : \(error)")
                    break
                }
                self.delegate17?.appClassGetContentList(result: result, exerciseContentStr: success)
            }
    }
    
    public func appClassGetClassUnitList(student_id : String, student_token : String, class_code : String , url :String){
        var result : Int = 0
        let parameters : Parameters = ["student_id" : student_id, "student_token" :student_token, "class_code" : class_code]
        var ClassListStr : String = ""
        var fail : String = ""
        //var fail : String = ""
        AF.request(basURL + url, method: .post, parameters: parameters, headers: nil)
            .responseJSON {
                response in
                debugPrint("반응 : ",response)
                switch response.result {
                case .success(let value):
                    //print("value : ",value)
                    do{
                        let dataJSon = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let getResult = try JSONDecoder().decode(_successFailClass.self, from: dataJSon)
                        if getResult.success != nil {
                            result = 0
                            extensionClass.setTokenChange(token: (getResult.student_token ?? ""))
                            ClassListStr = getResult.success ?? ""
                            
                        } else {
                            fail = getResult.fail ?? ""
                            result = 1
                        }
                        
                        
                    } catch {
                        
                        print(error)
                    }
                case .failure(let error):
                    result = 2
                    print("error 발생 : \(error)")
                    break
                }
                self.delegate15?.appClassGetClassUnitList(result: result, ClassListStr: ClassListStr, fail: fail)
            }
    }
    
    public func appClassStudentClassUpdate(student_id : String, student_token : String, class_code : String, student_classcode : String, url : String){
        var result : Int = 0
        let parameters : Parameters = ["student_id" : student_id, "student_token" :student_token, "class_code" : class_code, "student_classcode" : student_classcode]
        
        AF.request(basURL + url, method: .post, parameters: parameters, headers: nil)
            .responseJSON {
                response in
                debugPrint("반응 : ",response)
                switch response.result {
                case .success(let value):
                    //print("value : ",value)
                    do{
                        let dataJSon = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let getResult = try JSONDecoder().decode(_successFail.self, from: dataJSon)
                        if getResult.success != nil{
                            result = 0
                            extensionClass.setTokenChange(token: (getResult.student_token ?? ""))
                        } else {
                            result = 1
                        }
                        
                        
                    } catch {
                        
                        print(error)
                    }
                case .failure(let error):
                    result = 2
                    print("error 발생 : \(error)")
                    break
                }
                self.delegate15?.appClassStudentClassUpdate(result : result)
            }
    }
    public func appCommunityCreateStudentCommunityCommentList(student_id : String, student_token : String, student_name : String, community_number: Int, comment_content : String , url : String){
        var result : Int = 0
        let parameters : Parameters = ["student_id" : student_id, "student_token" : student_token, "student_name" : student_name, "community_number" : community_number, "comment_content" : comment_content]
        
        AF.request(basURL + url, method: .post, parameters: parameters, headers: nil)
            .responseJSON {
                response in
                debugPrint("반응 : ",response)
                switch response.result {
                case .success(let value):
                    //print("value : ",value)
                    do{
                        let dataJSon = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let getResult = try JSONDecoder().decode(_successFail.self, from: dataJSon)
                        if getResult.success != nil{
                            result = 0
                            extensionClass.setTokenChange(token: (getResult.student_token ?? ""))
                        } else {
                            result = 1
                        }
                        
                        
                    } catch {
                        
                        print(error)
                    }
                case .failure(let error):
                    result = 2
                    print("error 발생 : \(error)")
                    break
                }
                self.delegate12?.appCommunityCreateStudentCommunityCommentList(result: result)
            }
    }
    
    public func appCommunityGetStudentCommunityList(student_id :String, student_token : String ,student_class_code : String, url : String){
        var result : Int = 0
        let parameters : Parameters = ["student_id" : student_id, "student_token" : student_token, "student_class_code" : student_class_code]
        var success : [CommunityList]?
        AF.request(basURL + url, method: .post, parameters: parameters, headers: nil)
            .responseJSON {
                response in
                debugPrint("반응 : ",response)
                switch response.result {
                case .success(let value):
                    //print("value : ",value)
                    do{
                        let dataJSon = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let getResult = try JSONDecoder().decode(_successFailCommunityList.self, from: dataJSon)
                        if getResult.success != nil{
                            result = 0
                            extensionClass.setTokenChange(token: (getResult.student_token ?? ""))
                            success = getResult.success
                        } else {
                            result = 1
                        }
                        
                        
                    } catch {
                        
                        print(error)
                    }
                case .failure(let error):
                    result = 2
                    print("error 발생 : \(error)")
                    break
                }
                self.delegate14?.appCommunityGetStudentCommunityList(result: result, CommunityList: success ?? nil)
            }
    }
    
    public func appCommunityCreateStudentCommunity(student_id : String, student_token : String, student_name : String, student_class_code: String, community_title : String, community_text : String, community_file : [UIImage]?  ,url : String){
        var result : Int = 0
        let parameters : Parameters = ["student_id" : student_id, "student_token" :student_token, "student_name" : student_name, "student_class_code" : student_class_code, "community_title" : community_title, "community_text" : community_text]
        //print(parameters)
        var imageData : [Data] = []
        imageData.removeAll()
        var communityFileInsertNameList : [String] = []
        communityFileInsertNameList.removeAll()
        var i = 0
        
        //새로 추가할 이미지 여기 코드 통과
        if let image = community_file {
            for value in image {
                imageData.append(value.jpegData(compressionQuality: 0.2)!)
                communityFileInsertNameList.append("\(extensionClass.nowTimw())\(i).jpg")
                i += 1
            }
        }
        
        AF.upload(multipartFormData: { multipartFormData in
            
            for (key, value) in parameters {
                multipartFormData.append(Data("\(value)".utf8), withName: "\(key)")
            }
            
            if imageData.count > 0 {
                var i = 0
                for value in imageData {
                    print(value)
                    multipartFormData.append(value, withName: "community_file[]", fileName: communityFileInsertNameList[i], mimeType: "image/jpg")
                    
                    //추가되는 파일
                    print(communityFileInsertNameList[i])
                    multipartFormData.append(Data("\(communityFileInsertNameList[i])".utf8), withName: "community_file_name")
                    i += 1
                }
            }
            
        }, to: basURL + url)//<- url 입력
        .responseJSON {
            response in
            //debugPrint("반응 : ",response)
            switch response.result {
            case .success(let value):
                //print("value : ",value)
                do{
                    let dataJSon = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                    let getResult = try JSONDecoder().decode(_successFail.self, from: dataJSon)
                    if getResult.success != nil{
                        result = 0
                        extensionClass.setTokenChange(token: (getResult.student_token ?? ""))
                    } else {
                        result = 1
                    }
                    
                    
                } catch {
                    print(error)
                }
            case .failure(let error):
                result = 2
                print("error 발생 : \(error)")
                break
            }
            
            self.delegate9?.appCommunityCreateStudentCommunity(result: result)
            
        }
    }
    
    //삭제
    public func appCommunityUpdateStudentCommunity(student_id : String, student_token : String, community_title : String, community_text : String, community_number : String, community_file1 : String?, community_file2 : String?, community_new_file : [UIImage]? ,community_file_delete_name : [String]?, url : String){
        var result : Int = 0
        
        let parameters : Parameters = ["student_id" : student_id, "student_token" : student_token, "community_title" : community_title, "community_text" : community_text, "community_number" : community_number]
        
        
        
        //var image : [UIImage]? = community_new_file ?? nil
        
        var imageData : [Data] = []
        imageData.removeAll()
        var communityFileInsertNameList : [String] = []
        
        var i = 0
        if let image = community_new_file {
            for value in image {
                imageData.append(value.jpegData(compressionQuality: 0.2)!)
                communityFileInsertNameList.append("\(extensionClass.nowTimw())\(i).jpg")
                
                i += 1
            }
        }
        
        AF.upload(multipartFormData: {multipartFormData in
            //일반적인 json 파일
            for (key, value) in parameters {
                multipartFormData.append(Data("\(value)".utf8), withName: "\(key)")
            }
            
            
            
            
            var list : [String] = []
            var i = 0
            var communityFile1Bool = false
            var communityFile2Bool = false
            
            
            if let community_file1 = community_file1 {
                list.append(community_file1)
                multipartFormData.append(Data(community_file1.utf8), withName: "community_file1")
                i += 1
                communityFile1Bool = true
            }
            if let community_file2 = community_file2 {
                list.append(community_file2)
                multipartFormData.append(Data(community_file2.utf8), withName: "community_file2")
                i += 1
                communityFile2Bool = true
            }
            
            for value in communityFileInsertNameList {
                if i == 2 {
                    break
                } else {
                    
                    if !communityFile1Bool {
                        communityFile1Bool = true
                        list.append(value)
                        multipartFormData.append(Data(value.utf8), withName: "community_file1")
                        continue
                    }
                    
                    
                    if !communityFile2Bool{
                        communityFile2Bool = true
                        list.append(value)
                        multipartFormData.append(Data(value.utf8), withName: "community_file2")
                        continue
                        
                    }
                    
                }
            }
            
            print("기존 파일 확인 리스트 : ",list)
            
            
             if imageData.count > 0 {
                var i = 0
                for value in imageData {
                    print(value)
                    multipartFormData.append(value, withName: "community_new_file[]", fileName: communityFileInsertNameList[i], mimeType: "image/jpg")
                    
                    //추가되는 파일
                    multipartFormData.append(Data("\(communityFileInsertNameList[i])".utf8), withName: "community_file_insert_name")
                    i += 1
                }
            }
            
            if community_file_delete_name?.count ?? 0 > 0 {
                for value in community_file_delete_name! {
                    print(value)
                    multipartFormData.append(Data("\(value)".utf8), withName: "community_file_delete_name")
                }
            }
            
            
            
            print(multipartFormData)
            print("----------------")
        }, to: basURL + url)//<- url 입력
        .responseJSON {
            response in
            //debugPrint("반응 : ",response)
            switch response.result {
            case .success(let value):
                //print("value : ",value)
                do{
                    let dataJSon = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                    let getResult = try JSONDecoder().decode(_successFail.self, from: dataJSon)
                    if getResult.success != nil{
                        result = 0
                        extensionClass.setTokenChange(token: (getResult.student_token ?? ""))
                    } else {
                        result = 1
                    }
                    
                    
                } catch {
                    print(error)
                }
            case .failure(let error):
                result = 2
                print("error 발생 : \(error)")
                break
            }
            self.delegate9?.appCommunityUpdateStudentCommunity(result : result)
            
        }
    }
    
    public func appCommunityDeleteStudentCommunity(student_id : String, student_token : String, community_number : String, url : String){
        var result : Int = 0
        let parameters : Parameters = ["student_id" : student_id, "student_token" :student_token, "community_number" : community_number]
        
        AF.request(basURL + url, method: .post, parameters: parameters, headers: nil)
            .responseJSON {
                response in
                //debugPrint("반응 : ",response)
                switch response.result {
                case .success(let value):
                    //print("value : ",value)
                    do{
                        let dataJSon = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let getResult = try JSONDecoder().decode(_successFail.self, from: dataJSon)
                        if getResult.success != nil{
                            result = 0
                            extensionClass.setTokenChange(token: (getResult.student_token ?? ""))
                        } else {
                            result = 1
                        }
                        
                        
                    } catch {
                        
                        print(error)
                    }
                case .failure(let error):
                    result = 2
                    print("error 발생 : \(error)")
                    break
                }
                self.delegate13?.appCommunityDeleteStudentCommunity(result: result)
            }
    }
    
    public func appCommunityGetstudentContentListAdmin(student_id : String, student_token : String, url : String){
        var result : Int = 0
        let parameters : Parameters = ["student_id" : student_id, "student_token" : student_token]
        
        AF.request(basURL + url, method: .post, parameters: parameters, headers: nil)
            .responseJSON {
                response in
                debugPrint("반응 : ",response)
                switch response.result {
                case .success(let value):
                    //print("value : ",value)
                    do{
                        let dataJSon = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let getResult = try JSONDecoder().decode(_successFailContent.self, from: dataJSon)
                        if getResult.success != nil{
                            result = 0
                            extensionClass.setTokenChange(token: (getResult.student_token ?? ""))
                        } else {
                            result = 1
                        }
                        
                        self.delegate11?.appCommunityGetstudentContentListAdmin(result: result, content: getResult.success ?? nil)
                    } catch {
                        
                        print(error)
                    }
                case .failure(let error):
                    result = 2
                    self.delegate11?.appCommunityGetstudentContentListAdmin(result: result, content: nil)
                    print("error 발생 : \(error)")
                    break
                }
            }
    }
    
    public func appCommunityGetStudentFaq(student_id : String, student_token : String, url : String){
        var result : Int = 0
        let parameters : Parameters = ["student_id" : student_id, "student_token" :student_token]
        
        AF.request(basURL + url, method: .post, parameters: parameters, headers: nil)
            .responseJSON {
                response in
                //debugPrint("반응 : ",response)
                switch response.result {
                case .success(let value):
                    //print("value : ",value)
                    do{
                        let dataJSon = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let getResult = try JSONDecoder().decode(_successFailFaq.self, from: dataJSon)
                        if getResult.success != nil{
                            result = 0
                            extensionClass.setTokenChange(token: (getResult.student_token ?? ""))
                            
                        } else {
                            result = 1
                        }
                        self.delegate10?.appCommunityGetStudentFaq(result: result, faq: getResult.success ?? nil)
                        
                    } catch {
                        
                        print(error)
                    }
                case .failure(let error):
                    result = 2
                    self.delegate10?.appCommunityGetStudentFaq(result: result, faq: nil)
                    print("error 발생 : \(error)")
                    break
                }
            }
    }
    
    public func appCommunityDeleteStudentCommunityCommentList(student_id : String, student_token : String, comment_number : Int, community_number : Int, indexpath : Int ,url : String){
        var result : Int = 0
        let parameters : Parameters = ["student_id" : student_id, "student_token" : student_token, "comment_number" : comment_number, "community_number" : community_number]
        print(parameters)
        AF.request(basURL + url, method: .post, parameters: parameters, headers: nil)
            .responseJSON {
                response in
                debugPrint("반응 : ",response)
                switch response.result {
                case .success(let value):
                    //print("value : ",value)
                    do{
                        let dataJSon = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let getResult = try JSONDecoder().decode(_successFail.self, from: dataJSon)
                        if getResult.success != nil{
                            result = 0
                            extensionClass.setTokenChange(token: (getResult.student_token ?? ""))
                        } else {
                            result = 1
                        }
                        
                        
                    } catch {
                        
                        print(error)
                    }
                case .failure(let error):
                    result = 2
                    print("error 발생 : \(error)")
                    break
                }
                self.delegate12?.appCommunityDeleteStudentCommunityCommentList(result: result, indexpath: indexpath)
            }
        
    }
    
    //해당 함수는 appCommunityGetStudentCommunity 함수가 실행되고 delegate를 통해서 0을 반환 받으면 실행되는 댓글 불러오기 함수이다.
    public func appCommunityGetStudentCommunityCommentList(student_id : String, student_token : String, community_number : Int, url : String){
        var result : Int = 0
        let parameters : Parameters = ["student_id" : student_id, "student_token" :student_token, "community_number" : String(community_number)]
        var commentList : [CommentList]?
        //print("parameters : ",parameters)
        //print(basURL + url)
        AF.request(basURL + url, method: .post, parameters: parameters, headers: nil)
            .responseJSON {
                response in
                debugPrint("반응 : ",response)
                switch response.result {
                case .success(let value):
                    //print("value : ",value)
                    do{
                        let dataJSon = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let getResult = try JSONDecoder().decode(_successFailCommentList.self, from: dataJSon)
                        if getResult.success != nil{
                            result = 0
                            extensionClass.setTokenChange(token: (getResult.student_token ?? ""))
                            commentList = getResult.success
                        } else {
                            result = 1
                        }
                       
                        
                    } catch {
                        
                        print(error)
                    }
                case .failure(let error):
                    
                    result = 2
                    print("error 발생 : \(error)")
                    break
                }
                print(result)
                self.delegate12?.appCommunityGetStudentCommunityCommentList(result: result, commentList: commentList ?? nil)
            
            }
    }
    
    //커뮤니티관련 상세보기
    public func appCommunityGetStudentCommunity(student_id : String, student_token : String, community_number : Int, url : String){
        var result : Int = 0
        let parameters : Parameters = ["student_id" : student_id, "student_token" :student_token, "community_number" : String(community_number)]
        //print("parameters : ",parameters)
        //print(basURL + url)
        AF.request(basURL + url, method: .post, parameters: parameters, headers: nil)
            .responseJSON {
                response in
//                debugPrint("반응 : ",response)
                switch response.result {
                case .success(let value):
                    //print("value : ",value)
                    do{
                        let dataJSon = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let getResult = try JSONDecoder().decode(_successFailCommunity.self, from: dataJSon)
                        if getResult.success != nil{
                            result = 0
                            extensionClass.setTokenChange(token: (getResult.student_token ?? ""))
                        } else {
                            result = 1
                        }
                        self.delegate12?.appCommunityGetStudentCommunity(result: result, community: getResult.success ?? nil)
                        
                    } catch {
                        
                        print(error)
                    }
                case .failure(let error):
                    self.delegate12?.appCommunityGetStudentCommunity(result: result, community: nil)
                    result = 2
                    print("error 발생 : \(error)")
                    break
                }
            }
    }
    
    
    public func appCommunityDeleteStudentMessage(student_id : String, student_token : String, student_message_number : Int, url : String){
        var result : Int = 0
        let parameters : Parameters = ["student_id" : student_id, "student_token" :student_token, "student_message_number" : student_message_number]
        
        AF.request(basURL + url, method: .post, parameters: parameters, headers: nil)
            .responseJSON {
                response in
                //debugPrint("반응 : ",response)
                switch response.result {
                case .success(let value):
                    //print("value : ",value)
                    do{
                        let dataJSon = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let getResult = try JSONDecoder().decode(_successFail.self, from: dataJSon)
                        if getResult.success != nil{
                            result = 0
                            extensionClass.setTokenChange(token: (getResult.student_token ?? ""))
                        } else {
                            result = 1
                        }
                        
                        
                    } catch {
                        
                        print(error)
                    }
                case .failure(let error):
                    result = 2
                    print("error 발생 : \(error)")
                    break
                }
                self.delegate8?.appCommunityDeleteStudentMessage(result : result)
            }
    }
    
    public func appCommunityUpdateStudentMessage(student_id : String, student_token : String, student_message_number :
                                                 Int,student_message_title : String, student_message_text : String, url : String){
        var result : Int = 0
        let parameters : Parameters = ["student_id" : student_id, "student_token" :student_token, "student_message_number" : student_message_number, "student_message_title" : student_message_title, "student_message_text" : student_message_text]
        
        AF.request(basURL + url, method: .post, parameters: parameters, headers: nil)
            .responseJSON {
                response in
                //debugPrint("반응 : ",response)
                switch response.result {
                case .success(let value):
                    //print("value : ",value)
                    do{
                        let dataJSon = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let getResult = try JSONDecoder().decode(_successFail.self, from: dataJSon)
                        if getResult.success != nil{
                            result = 0
                            extensionClass.setTokenChange(token: (getResult.student_token ?? ""))
                        } else {
                            result = 1
                        }
                        
                        
                    } catch {
                        
                        print(error)
                    }
                case .failure(let error):
                    result = 2
                    print("error 발생 : \(error)")
                    break
                }
                self.delegate8?.appCommunityUpdateStudentMessage(result : result)
            }
    }
    
    public func appCommunitySendStudentMessage(student_id : String, student_token : String, student_name : String, student_class_code : String, student_message_title : String, student_message_text : String, url : String){
        var result : Int = 0
        let parameters : Parameters = ["student_id" : student_id, "student_token" :student_token , "student_name" : student_name, "student_class_code" : student_class_code, "student_message_title" : student_message_title, "student_message_text" : student_message_text]
        
        AF.request(basURL + url, method: .post, parameters: parameters, headers: nil)
            .responseJSON {
                response in
                //debugPrint("반응 : ",response)
                switch response.result {
                case .success(let value):
                    //print("value : ",value)
                    do{
                        let dataJSon = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let getResult = try JSONDecoder().decode(_successFail.self, from: dataJSon)
                        if getResult.success != nil{
                            result = 0
                            extensionClass.setTokenChange(token: (getResult.student_token ?? ""))
                        } else {
                            result = 1
                        }
                        
                        
                    } catch {
                        
                        print(error)
                    }
                case .failure(let error):
                    result = 2
                    print("error 발생 : \(error)")
                    break
                }
                self.delegate9?.appCommunitySendStudentMessage(result : result)
            }
    }
    public func appCommunityGetStudentMessageList(student_id : String, student_token : String, student_class_code : String, url : String){
        var result : Int = 0
        let parameters : Parameters = ["student_id" : student_id, "student_token" :student_token , "student_class_code" : student_class_code]
        var getMessageList : [MessageList]?
        AF.request(basURL + url, method: .post, parameters: parameters, headers: nil)
            .responseJSON {
                response in
                debugPrint("반응 : ",response)
                switch response.result {
                case .success(let value):
                    //print("value : ",value)
                    do{
                        let dataJSon = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let getResult = try JSONDecoder().decode(_successFailMessageList.self, from: dataJSon)
                        if getResult.success != nil{
                            result = 0
                            extensionClass.setTokenChange(token: (getResult.student_token ?? ""))
                            getMessageList = getResult.success
                        } else {
                            result = 1
                        }
                        
                        
                    } catch {
                        
                        print(error)
                    }
                case .failure(let error):
                    result = 2
                    print("error 발생 : \(error)")
                    break
                }
                self.delegate18?.appCommunityGetStudentMessageList(result: result, getMessageList: getMessageList ?? nil)
            }
    }
    public func appCommunityGetStudentMessage(student_id : String, student_token : String, message_number : Int, url : String){
        var result : Int = 0
        
        let parameters : Parameters = ["student_id" : student_id, "student_token" :student_token, "message_number" : message_number]
        
        AF.request(basURL + url, method: .post, parameters: parameters, headers: nil)
            .responseJSON {
                response in
                //debugPrint("반응 : ",response)
                switch response.result {
                case .success(let value):
                //    print("value : ",value)
                    do{
                        let dataJSon = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let getResult = try JSONDecoder().decode(_successFailMessage.self, from: dataJSon)
                        
                        if getResult.success != nil{
                            result = 0
                            
                            extensionClass.setTokenChange(token: (getResult.student_token ?? ""))
                        } else {
                            result = 1
                        }
                        self.delegate8?.appCommunityGetStudentMessage(result: result, message_title: getResult.success?.messageTitle ?? "", message_text: getResult.success?.messageText ?? "", message_name: getResult.success?.messageName ?? "", message_date: getResult.success?.messageDate ?? "", message_comment_state: getResult.success?.messageCommentState ?? "", message_comment_date: getResult.success?.messageCommentDate ?? "", message_comment: getResult.success?.messageComment ?? "", message_teacher_name: getResult.success?.messageTeacherName ?? "")
                        
                    } catch {
                        result = 2
                        print(error)
                    }
                case .failure(let error):
                    result = 2
                    print("error 발생 : \(error)")
                    break
                }
                
            }
    }
    
    public func appMemberPasswordInformationChange(student_id : String, student_token : String, student_password_before : String, student_password_new : String, url : String){
        var result : Int = 0
        let parameters : Parameters = ["student_id" : student_id, "student_token" : student_token, "student_password_before" : student_password_before, "student_password_new" : student_password_new]
        
        AF.request(basURL + url, method: .post, parameters: parameters, headers: nil)
            .responseJSON {
                response in
                //debugPrint("반응 : ",response)
                switch response.result {
                case .success(let value):
                    //print("value : ",value)
                    do{
                        let dataJSon = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let getResult = try JSONDecoder().decode(_successFail.self, from: dataJSon)
                        if getResult.success != nil{
                            result = 0
                            extensionClass.setTokenChange(token: (getResult.student_token ?? ""))
                        } else {
                            result = 1
                        }
                        
                        
                    } catch {
                        print(error)
                    }
                case .failure(let error):
                    result = 2
                    print("error 발생 : \(error)")
                    break
                }
                self.delegate7?.appMemberPasswordInformationChange(result : result)
            }
    }
    
    public func appMemberProfileChange(student_id : String, student_token : String, file : UIImage, url : String){
        var result : Int = 0
        let parameters : Parameters = ["student_id" : student_id, "student_token" : student_token]
        
        let image : UIImage = file
        let imageData = image.jpegData(compressionQuality: 0.2)!
        
        
        AF.upload(multipartFormData: {multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append(Data("\(value)".utf8), withName: "\(key)")
            }
            multipartFormData.append(imageData, withName: "file", fileName: "\(UserInformation.student_id).jpg", mimeType: "image/jpg")
            print(multipartFormData)
        }, to: basURL + url)//<- url 입력
        .responseJSON {
            response in
            //debugPrint("반응 : ",response)
            switch response.result {
            case .success(let value):
                //print("value : ",value)
                do{
                    let dataJSon = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                    let getResult = try JSONDecoder().decode(_successFail.self, from: dataJSon)
                    if getResult.success != nil{
                        result = 0
                        extensionClass.setTokenChange(token: (getResult.student_token ?? ""))
                    } else {
                        result = 1
                    }
                    
                    
                } catch {
                    print(error)
                }
            case .failure(let error):
                result = 2
                print("error 발생 : \(error)")
                break
            }
            
            self.delegate7?.appMemberProfileChange(result: result, imageUrl: "https://lllloooo.shop/resources/student_profile/\(UserInformation.student_id).jpg")
            
        }
        
        
        
    }
    
    public func appMemberClassInformationChange(student_id : String, student_level : String, student_class : String, student_number : String, student_token : String, url : String){
        
        var result : Int = 0
        let parameters : Parameters = ["student_id" : student_id, "student_level" : student_level, "student_class" : student_class, "student_number":student_number, "student_token" : student_token]
        
        AF.request(basURL + url, method: .post, parameters: parameters, headers: nil)
            .responseJSON {
                response in
                //debugPrint("반응 : ",response)
                switch response.result {
                case .success(let value):
                    //print("value : ",value)
                    do{
                        let dataJSon = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let getResult = try JSONDecoder().decode(_successFail.self, from: dataJSon)
                        if getResult.success != nil{
                            result = 0
                            extensionClass.setTokenChange(token: (getResult.student_token ?? ""))
                        } else {
                            result = 1
                        }
                        
                        
                    } catch {
                        print(error)
                    }
                case .failure(let error):
                    result = 2
                    print("error 발생 : \(error)")
                    break
                }
                self.delegate7?.appMemberClassInformationChange(result: result)
            }
        
    }
    
    public func appMemberPushAgreementChange(student_id : String, student_push_agreement : String, student_token : String ,url: String){
        
        var result : Int = 0
        let parameters : Parameters = ["student_id" : student_id, "student_push_agreement" : student_push_agreement, "student_token" : student_token]
        
        AF.request(basURL + url, method: .post, parameters: parameters, headers: nil)
            .responseJSON {
                response in
                //debugPrint("반응 : ",response)
                switch response.result {
                case .success(let value):
                    //print("value : ",value)
                    do{
                        let dataJSon = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let getResult = try JSONDecoder().decode(_successFail.self, from: dataJSon)
                        if getResult.success != nil{
                            result = 0
                            extensionClass.setTokenChange(token: (getResult.student_token ?? ""))
                        } else {
                            result = 1
                        }
                        
                        
                    } catch {
                        print(error)
                    }
                case .failure(let error):
                    result = 2
                    print("error 발생 : \(error)")
                    break
                }
                self.delegate6?.appMemberPushAgreementChange(result: result)
            }
        
    }
    
    public func appMemberDefualtInformationChange(student_id : String, student_token : String, student_content : String, student_tall : String, student_weight : String, student_age : String, student_sex : String, url : String){
        var result : Int = 0
        var parameters : Parameters?
        if student_sex != ""{
             parameters = ["student_id" :  student_id, "student_token" : student_token, "student_content" : student_content, "student_tall" : student_tall, "student_weight" : student_weight, "student_age" : student_age, "student_sex" : student_sex]
        } else {
            parameters = ["student_id" :  student_id, "student_token" : student_token, "student_content" : student_content, "student_tall" : student_tall, "student_weight" : student_weight, "student_age" : student_age]
        }
        AF.request(basURL + url, method: .post, parameters: parameters!, headers: nil)
            .responseJSON {
                response in
                debugPrint("반응 : ",response)
                switch response.result {
                case .success(let value):
                    //print("value : ",value)
                    do{
                        let dataJSon = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let getResult = try JSONDecoder().decode(_successFail.self, from: dataJSon)
                        if getResult.success != nil{
                            result = 0
                            extensionClass.setTokenChange(token: (getResult.student_token ?? ""))
                            
                            
                        } else {
                            result = 1
                        }
                        
                        
                    } catch {
                        print(error)
                    }
                case .failure(let error):
                    result = 2
                    print("error 발생 : \(error)")
                    break
                }
                if student_sex != ""{
                    //최초 기초정보 입력했을때 입력했을때
                    self.delegate5?.appMemberDefaultInformationChange(result: result)
                } else {
                    //마이페이지 에서 정보 바꿀때
                    self.delegate7?.appMemberDefaultInformationChange1(result: result)
                }
                
            }
    }
    
    public func appFindChangePw(student_email : String, student_password : String, authentication_code : String, url : String){
        var result : Int = 0
        let parameters : Parameters = ["student_email" :  student_email, "student_password" : student_password, "authentication_code" : authentication_code]
        
        AF.request(basURL + url, method: .post, parameters: parameters, headers: nil)
            .responseJSON {
                response in
                //debugPrint("반응 : ",response)
                switch response.result {
                case .success(let value):
                    //print("value : ",value)
                    do{
                        let dataJSon = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let getResult = try JSONDecoder().decode(_successFail.self, from: dataJSon)
                        
                        if getResult.success != nil {
                            result = 0
                        } else {
                            result = 1
                        }
                        
                        
                    } catch {
                        print(error)
                    }
                case .failure(let error):
                    result = 2
                    print("error 발생 : \(error)")
                    break
                }
                self.delegate4?.appPwFindResult(result : result)
            }
    }
    
    public func appFindPw(student_id : String, student_name : String, student_email : String, url : String){
        
        let parameters : Parameters = ["student_id" :  student_id, "student_name" : student_name, "student_email" : student_email]
        var result : Int = 0
        AF.request(basURL + url, method: .post, parameters: parameters, headers: nil)
            .responseJSON {
                response in
                //debugPrint("반응 : ",response)
                switch response.result {
                case .success(let value):
                    //print("value : ",value)
                    do{
                        let dataJSon = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let getResult = try JSONDecoder().decode(_successFail.self, from: dataJSon)
                        if getResult.success != nil {
                            result = Int(getResult.success ?? "0") ?? 0
                        } else {
                            result = 1
                        }
                        
                        
                    } catch {
                        print(error)
                    }
                case .failure(let error):
                    result = 2
                    print("error 발생 : \(error)")
                    break
                }
                self.delegate3?.appPwFind(result: result)
            }
        
    }
    
    public func appFindId(student_name : String, student_email : String, url : String){
        /**
         아이디 찾기
         result -> 0 성공 , id -> 이용자 아이디 입력
         result -> 1 아이디 또는 잘못된 입력
         result -> 2 인터넷 접속 오류
         */
        let parameters : Parameters = ["student_name" :  student_name, "student_email" : student_email]
        var result : Int = 0
        var id : String = ""
        AF.request(basURL + url, method: .post, parameters: parameters, headers: nil)
            .responseJSON {
                response in
                //debugPrint("반응 : ",response)
                switch response.result {
                case .success(let value):
                    //print("value : ",value)
                    do{
                        let dataJSon = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let getResult = try JSONDecoder().decode(_successFail.self, from: dataJSon)
                        if getResult.success != nil {
                            result = 0
                            id = getResult.success ?? ""
                        } else {
                            result = 1
                        }
                        
                        
                    } catch {
                        print(error)
                    }
                case .failure(let error):
                    result = 2
                    print("error 발생 : \(error)")
                    break
                }
                self.delegate2?.appIdFind(result: result, id : id)
            }
        
    }
    
    public func appSignUp(student_id : String, student_password : String, student_email : String, student_name : String, authentication_code : String, student_phone_number : String, student_push_agreement : String , url : String){
        /**
         - 앱 회원가입 통신 함수
         result -> 0 회원가입 완료
         result - > 1  회원가입 실패
         result - > 2  서버통신 실패
         */
        
        var result : Int = 0
        var parameters : Parameters = [:]
        if student_phone_number == ""{
            parameters = ["student_id" : "\(student_id)", "student_password" : "\(student_password)", "student_email" : student_email, "student_name" : student_name, "authentication_code" : authentication_code, "student_push_agreement" : student_push_agreement]
        } else {
            parameters = ["student_id" : "\(student_id)", "student_password" : "\(student_password)", "student_email" : student_email, "student_name" : student_name, "authentication_code" : authentication_code, "student_phone_number" : student_phone_number, "student_push_agreement" : student_push_agreement]
        }
        
        AF.request(basURL + url, method: .post, parameters: parameters, headers: nil)
            .responseJSON {
                response in
                debugPrint("반응 : ",response)
                switch response.result {
                case .success(let value):
                    //print("value : ",value)
                    do{
                        let dataJSon = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let getResult = try JSONDecoder().decode(_successFail.self, from: dataJSon)
                        if getResult.success != nil{
                            result = 0
                        } else {
                            result = 1
                        }
                        
                        
                    } catch {
                        print(error)
                    }
                case .failure(let error):
                    result = 2
                    print("error 발생 : \(error)")
                    break
                }
                
                self.delegate1?.appSignUp(result : result)
                
            }
    }
    
    public func appEmailOverlapCheck(student_email : String, url : String){
        /**
         - email 중보 검사
         result -> 0 중복 아님
         result - > 1 중복
         result -> 2 인터넷 불안정
         */
        let parameters : Parameters = ["student_email" : "\(student_email)"]
        var result : String = "0"
        AF.request(basURL + url, method: .post, parameters: parameters, headers: nil)
            .responseJSON {
                response in
                //debugPrint("반응 : ",response)
                switch response.result {
                case .success(let value):
                    //print("value : ",value)
                    do{
                        let dataJSon = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let getResult = try JSONDecoder().decode(_successFail.self, from: dataJSon)
                        if getResult.success != nil{
                            result = getResult.success!
                        }
                        
                        if getResult.fail != nil {
                            if getResult.fail == "email_overlap"{
                                result = "1"
                            } else {
                                result = "2"
                            }
                        }
                        
                        
                    } catch {
                        print(error)
                    }
                case .failure(let error):
                    result = "2"
                    print("error 발생 : \(error)")
                    break
                }
                self.delegate1?.appEmailOverlapCheck(result: result)
            }
    }
    
    
    public func appIdOverlapCheck(student_id : String, url : String){
        /**
         - 아이디 중보 검사
         result -> 0 중복 아님
         result - > 1 중복
         result -> 2 인터넷 불안정
         */
        let parameters : Parameters = ["student_id" : "\(student_id)"]
        var result : Int = 0
        AF.request(basURL + url, method: .post, parameters: parameters, headers: nil)
            .responseJSON {
                response in
                //debugPrint("반응 : ",response)
                switch response.result {
                case .success(let value):
                    print("value : ",value)
                    
                    do{
                        let dataJSon = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let getResult = try JSONDecoder().decode(_successFail.self, from: dataJSon)
                        if getResult.success == "n"{
                            result = 0
                        } else if getResult.success == "y" {
                            result = 1
                        } else {
                            result = 2
                        }
                        self.delegate1?.appIdOverlapCheck(result: result)
                        
                    } catch {
                        print(error)
                    }
                case .failure(let error):
                    result = 2
                    print("error 발생 : \(error)")
                    break
                }
            }
    }
    
    public func appAutoLogin(student_id: String, student_token : String, url : String){
        //로그인 함수
        //아이디 비밀번호 일치 result -> 0
        //불일치, 토큰 - > 1
        var result : Int = 3
        let parameters : Parameters = ["student_id" : "\(student_id)", "student_token" : "\(student_token)", "fcmtoken" : "\(UserInformation.fcm_token)"]
        
        AF.request(basURL + url, method: .post, parameters: parameters, headers: nil)
            .responseJSON
            {
                response in
                //debugPrint("반응 : ",response)
                switch response.result
                {
                case .success(let value):
                    
                    print("++ [complexion] appAutoLogin : \(value)")
                    
                    do
                    {
                        let dataJSon = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let getResult = try JSONDecoder().decode(userInformation.self, from: dataJSon)
                        
                        if getResult.fail == nil {
                            result = 0
                            UserInformation.access_token = getResult.access_token ?? ""
                            
                            UserInformation.student_id = getResult.student_id ?? ""
                            UserInformation.student_name = getResult.student_name ?? ""
                            UserInformation.student_email = getResult.student_email ?? ""
                            UserInformation.student_phone = getResult.student_phone ?? ""
                            UserInformation.student_push_agreement = getResult.student_push_agreement ?? ""
                            UserInformation.student_email_agreement = getResult.student_email_agreement ?? ""
                           
                            if getResult.student_image_url != nil {
                                UserInformation.student_image_url = self.basURL +  getResult.student_image_url!
                            } else {
                                UserInformation.student_image_url = ""
                            }
                            
                            UserInformation.student_content = getResult.student_content ?? ""
                            UserInformation.student_tall = getResult.student_tall ?? ""
                            UserInformation.student_weight = getResult.student_weight ?? ""
                            UserInformation.student_age = getResult.student_age ?? ""
                            UserInformation.student_sex = getResult.student_sex ?? ""
                            UserInformation.student_school = getResult.student_school ?? ""
                            UserInformation.student_level = getResult.student_level ?? ""
                            UserInformation.student_class = getResult.student_class ?? ""
                            UserInformation.student_number = getResult.student_number ?? ""
                            UserInformation.news_state = getResult.news_state ?? ""
                            UserInformation.new_messgae_state = getResult.new_messgae_state ?? ""

                            if let data = getResult.student_classcode?.data(using: .utf8) {
                                
                                do {
                                    if let jsonDic = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String:String]]{
                                        print(jsonDic)
                                        UserInformation.student_classcode = jsonDic
                                        
                                        for index in jsonDic {
                                            for (key,value) in index{
                                                UserInformation.student_classcodeList.append(key)
                                                UserInformation.student_classcodeNameList.append(value)
                                            }
                                        }
                                        UserInformation.student_classcodeList.reverse()
                                        UserInformation.student_classcodeNameList.reverse()
                                       /*
                                        print(userInformationClass.student_classcodeList)
                                        print(userInformationClass.student_classcodeNameList)
                                        */
                                        
                                        
                                    }
                                    
                                } catch let error {
                                    print(error)
                                }
                            }
                            
                            UserInformation.student_create_date = getResult.student_create_date ?? ""
                            UserInformation.student_recent_join_date = getResult.student_recent_join_date ?? ""
                            UserInformation.student_recent_exercise_date = getResult.student_recent_exercise_date ?? ""
                            
                            
                            let autoPramater : [String : String] = ["student_id" : UserInformation.student_id, "student_token" : UserInformation.access_token, "fcm_token" : UserInformation.fcm_token]
                            UserInformation.preferences.set(autoPramater, forKey: UserInformation.autoLoginKey)
                            
                        }
                        else
                        {
                            result = 1
                        }
                        
                        
                    }
                    catch
                    {
                        print(error)
                    }
                    
                case .failure(let error):
                    result = 2
                    print("error 발생 : \(error)")
                    break
                }
                
                self.delegate0?.appLogin(result: result)
            }
        
    }
    
    
    public func appLogin(student_id: String, student_password : String, url : String, _ completion : @escaping(Int?) -> Void){
        //로그인 함수
        //아이디 비밀번호 일치 result -> 0
        //불일치, 토큰 - > 1
        //인터넷 불안정 - > 2
        var result : Int = 3
        let parameters : Parameters = ["student_id" : "\(student_id)", "student_password" : "\(student_password)", "fcmtoken" : "\(UserInformation.fcm_token)"]
        
        AF.request(basURL + url, method: .post, parameters: parameters, headers: nil)
            .responseJSON
            {
                response in
                //debugPrint("반응 : ",response)
                switch response.result
                {
                case .success(let value):
                    print("value : ",value)
                    do{
                        
                        let dataJSon = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let getResult = try JSONDecoder().decode(userInformation.self, from: dataJSon)
                        
                        if getResult.fail == nil {
                            result = 0
                            UserInformation.access_token = getResult.access_token ?? ""
                            print("처음 토큰 : ", UserInformation.access_token)
                            UserInformation.student_id = getResult.student_id ?? ""
                            UserInformation.student_name = getResult.student_name ?? ""
                            UserInformation.student_email = getResult.student_email ?? ""
                            UserInformation.student_phone = getResult.student_phone ?? ""
                            UserInformation.student_push_agreement = getResult.student_push_agreement ?? ""
                            UserInformation.student_email_agreement = getResult.student_email_agreement ?? ""
                            
                            if getResult.student_image_url != nil {
                                UserInformation.student_image_url = self.basURL +  getResult.student_image_url!
                            } else {
                                UserInformation.student_image_url = ""
                            }
                            
                            UserInformation.student_content = getResult.student_content ?? ""
                            UserInformation.student_tall = getResult.student_tall ?? ""
                            UserInformation.student_weight = getResult.student_weight ?? ""
                            UserInformation.student_age = getResult.student_age ?? ""
                            UserInformation.student_sex = getResult.student_sex ?? ""
                            UserInformation.student_school = getResult.student_school ?? ""
                            UserInformation.student_level = getResult.student_level ?? ""
                            UserInformation.student_class = getResult.student_class ?? ""
                            UserInformation.student_number = getResult.student_number ?? ""
                            
                            
                            UserInformation.news_state = getResult.news_state ?? ""
                            UserInformation.new_messgae_state = getResult.new_messgae_state ?? ""
                            if let data = getResult.student_classcode?.data(using: .utf8){
                                do {
                                    if let jsonDic = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String:String]]{
                                        print(jsonDic)
                                        UserInformation.student_classcode = jsonDic
                                        for index in jsonDic {
                                            for (key,value) in index{
                                                UserInformation.student_classcodeList.append(key)
                                                UserInformation.student_classcodeNameList.append(value)
                                            }
                                        }
                                        UserInformation.student_classcodeList.reverse()
                                        UserInformation.student_classcodeNameList.reverse()
                                        //print(jsonDic)
                                        
                                    }
                                    
                                } catch let error {
                                     
                                }
                            }
                            
                            UserInformation.student_create_date = getResult.student_create_date ?? ""
                            UserInformation.student_recent_join_date = getResult.student_recent_join_date ?? ""
                            UserInformation.student_recent_exercise_date = getResult.student_recent_exercise_date ?? ""
                            
                            
                            let autoPramater : [String : String] = ["student_id" : UserInformation.student_id, "student_token" : UserInformation.access_token, "fcm_token" : UserInformation.fcm_token]
                            UserInformation.preferences.set(autoPramater, forKey: UserInformation.autoLoginKey)
                            
                        } else {
                            result = 1
                        }
                        
                        
                    } catch {
                        print(error)
                    }
                case .failure(let error):
                    result = 2
                    print("error 발생 : \(error)")
                    break
                }
                completion(result)
                //self.delegate0?.appLogin(result: result)
            }
        
    }
}
