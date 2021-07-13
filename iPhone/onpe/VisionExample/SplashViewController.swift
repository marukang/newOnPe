//
//  SplashViewController.swift
//  VisionExample
//
//  Created by 신우진 on 2021/07/09.
//  Copyright © 2021 Google Inc. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import NaverThirdPartyLogin
import Alamofire

class SplashViewController: UIViewController, AppLoginDelegate, GIDSignInDelegate, NaverThirdPartyLoginConnectionDelegate {
    
    @IBOutlet weak var mSnsLoginButtonK: UIButton! // 카카오 버튼
    @IBOutlet weak var mSnsLoginButtonG: UIButton!
    @IBOutlet weak var mSnsLoginButtonN: UIButton!
    @IBOutlet weak var mSnsLoginButtonE: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = true
        
        print("++ [complexion] SplashViewController viewDidLoad ")
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
        
        NaverThirdPartyLoginConnection.getSharedInstance()?.delegate = self
        
        if (UserInformation.preferences.object(forKey: UserInformation.autoLoginKey) != nil) //자동로그인 일때
        {
            let autoLoginDic : [String : String] = UserInformation.preferences.object(forKey: UserInformation.autoLoginKey)
                as! [String : String]
            UserInformation.fcm_token = autoLoginDic["fcm_token"] ?? ""

            print("++ [complexion] SplashViewController viewDidLoad 토큰 : \(UserInformation.access_token)")
            print("++ [complexion] SplashViewController viewDidLoad ")

            let serverConnection : ServerConnection = ServerConnection()
            serverConnection.appAutoLogin(student_id: autoLoginDic["student_id"]!, student_token: autoLoginDic["student_token"]!)
            { (responseCode, response) in
                
            }
        }
    }

    func appLogin(result: Int)
    {
        
    }
    
    override var prefersStatusBarHidden: Bool
    {
        return true
    }
    
    @IBAction func onKakaoLoginTry(_ sender: Any)
    {
        // 카카오톡 설치 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable())
        {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                
                if let error = error
                {
                    print("-- [complexion] SplashViewController onKakaoLoginTry onError (1) error \(error)")
                }
                else
                {
                    UserApi.shared.me { (user, error) in
                        
                        let userEmail = user?.kakaoAccount?.email ?? ""
                        let userId = userEmail.split(separator: "@")[0]
                        let userName = user?.kakaoAccount?.legalName ?? ""
                        let userPhoneNumber = user?.kakaoAccount?.phoneNumber ?? ""

                        print("++ [complexion] SplashViewController onKakaoLoginTry(1) > sign userId \(userId)")
                        print("++ [complexion] SplashViewController onKakaoLoginTry(1) > sign userEmail \(userEmail)")
                        print("++ [complexion] SplashViewController onKakaoLoginTry(1) > sign userName \(userName)")
                        print("++ [complexion] SplashViewController onKakaoLoginTry(1) > sign userPhoneNumber \(userPhoneNumber)")

                        self.login(id: String(userId), password: "", type: "K", name: userName, email: userEmail, push_agreement: "Y", phone_number: userPhoneNumber)
                    }
                }
            }
        }
        else
        {
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                
                if let error = error
                {
                    print("-- [complexion] SplashViewController onKakaoLoginTry onError (2)  error \(error)")
                }
                else
                {
                    UserApi.shared.me { (user, error) in
                        
                        let userEmail = user?.kakaoAccount?.email ?? ""
                        let userId = userEmail.split(separator: "@")[0]
                        let userName = user?.kakaoAccount?.legalName ?? ""
                        let userPhoneNumber = user?.kakaoAccount?.phoneNumber ?? ""

                        print("++ [complexion] SplashViewController onKakaoLoginTry(2) > sign userId \(userId)")
                        print("++ [complexion] SplashViewController onKakaoLoginTry(2) > sign userEmail \(userEmail)")
                        print("++ [complexion] SplashViewController onKakaoLoginTry(2) > sign userName \(userName)")
                        print("++ [complexion] SplashViewController onKakaoLoginTry(2) > sign userPhoneNumber \(userPhoneNumber)")

                        self.login(id: String(userId), password: "", type: "K", name: userName, email: userEmail, push_agreement: "Y", phone_number: userPhoneNumber)
                    }
                }
            }
        }
    }
    
    @IBAction func onGoogleLoginTry(_ sender: Any)
    {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func onNaverLoginTry(_ sender: Any)
    {
        NaverThirdPartyLoginConnection.getSharedInstance()?.requestThirdPartyLogin()
    }
    
    @IBAction func onEmailLoginTry(_ sender: Any)
    {
        
    }
    // MARK: NAVER LOGIN DECLARE START
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() // 로그인에 성공한 경우 호출
    {
        guard (NaverThirdPartyLoginConnection.getSharedInstance()?.isValidAccessTokenExpireTimeNow()) != nil else {
            return
        }
        
        guard let loginTokenType = NaverThirdPartyLoginConnection.getSharedInstance()?.tokenType else { return }
        guard let loginAccessToken = NaverThirdPartyLoginConnection.getSharedInstance()?.accessToken else { return }
        
        let urlStr = "https://openapi.naver.com/v1/nid/me"
        let url = URL(string: urlStr)!
        let authorization = "\(loginTokenType) \(loginAccessToken)"
        let request = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": authorization])
              
        request.responseJSON { response in
            
            guard let result = response.value as? [String: Any] else { return }
            guard let object = result["response"] as? [String: Any] else { return }
            guard let userName = object["name"] as? String else { return }
            guard let userEmail = object["email"] as? String else { return }
            // guard let id = object["id"] as? String else { return }
            let userId = userEmail.split(separator: "@")[0]
        
            print("++ [complexion] SplashViewController onNaverLoginTry > sign userId \(userId)")
            print("++ [complexion] SplashViewController onNaverLoginTry > sign user.name \(userName)")
            print("++ [complexion] SplashViewController onNaverLoginTry > sign user.email \(userEmail)")

            self.login(id: String(userId), password: "", type: "N", name: userName, email: userEmail, push_agreement: "Y", phone_number: "")
        }
    }
    
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken()
    {
        
    }
    
    func oauth20ConnectionDidFinishDeleteToken()
    {
        
    }
    
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!)
    {
        
    }
    // MARK: NAVER LOGIN DECLARE END
    // ====================================================================================================
    
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {

        if error != nil {
            return
        }
        
        guard let authentication = user.authentication else { return }
        
        _ = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        let userId = user.profile.email.split(separator: "@")[0]
        
        print("++ [complexion] SplashViewController onGoogleLoginTry(1) > sign userId \(userId)")
        print("++ [complexion] SplashViewController onGoogleLoginTry(1) > sign user.name \(user.profile.name ?? "")")
        print("++ [complexion] SplashViewController onGoogleLoginTry(1) > sign user.givenName \(user.profile.givenName ?? "")")
        print("++ [complexion] SplashViewController onGoogleLoginTry(1) > sign user.email \(user.profile.email ?? "")")

        login(id: String(userId), password: "", type: "G", name: user.profile.name, email: user.profile.email, push_agreement: "Y", phone_number: "")
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if error != nil  {
            print("-- [complexion] SplashViewController onGoogleLoginTry > sign error \(error.debugDescription)")
            return
        }
        
        let userId = user.profile.email.split(separator: "@")[0]
        
        print("++ [complexion] SplashViewController onGoogleLoginTry(2) > sign userId \(userId)")
        print("++ [complexion] SplashViewController onGoogleLoginTry(2) > sign user.name \(user.profile.name ?? "")")
        print("++ [complexion] SplashViewController onGoogleLoginTry(2) > sign user.givenName \(user.profile.givenName ?? "")")
        print("++ [complexion] SplashViewController onGoogleLoginTry(2) > sign user.email \(user.profile.email ?? "")")

        login(id: String(userId), password: "", type: "G", name: user.profile.name, email: user.profile.email, push_agreement: "Y", phone_number: "")
    }
    
    func login(id : String, password :String, type : String, name : String, email : String, push_agreement : String, phone_number : String)
    {
        let connection : ServerConnection = ServerConnection()
        connection.login(student_id: id, student_password: password, loginType: type,
                         student_name : name, student_email: email, student_push_agreement: push_agreement, student_phone_number: phone_number)
        { (responseCode, response) in
            
            print("++ [complexion] SplashViewController login responseCode : \(responseCode)")
            print("++ [complexion] SplashViewController login response : \(String(describing: response))")
            
            if (responseCode > 0)
            {
                
            }
        }
    }
}
