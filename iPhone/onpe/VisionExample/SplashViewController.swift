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

class SplashViewController: UIViewController, AppLoginDelegate, GIDSignInDelegate {

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
    }

    func appLogin(result: Int) {
        
    }
    
    override var prefersStatusBarHidden: Bool
    {
        return true
    }
    
    @IBAction func onKakaoLoginTry(_ sender: Any)
    {
        
    }
    
    @IBAction func onGoogleLoginTry(_ sender: Any)
    {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func onNaverLoginTry(_ sender: Any)
    {
        
    }
    
    @IBAction func onEmailLoginTry(_ sender: Any)
    {
        
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
        print(">> [complexion] SplashViewController onGoogleLoginTry > sign success ")
        
        if error != nil {
            return
        }
        
        guard let authentication = user.authentication else { return }
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        print("++ [complexion] SplashViewController onGoogleLoginTry > sign user.userID \(user.userID ?? "")")
        print("++ [complexion] SplashViewController onGoogleLoginTry > sign user.name \(user.profile.name ?? "")")
        print("++ [complexion] SplashViewController onGoogleLoginTry > sign user.givenName \(user.profile.givenName ?? "")")
        print("++ [complexion] SplashViewController onGoogleLoginTry > sign user.email \(user.profile.email ?? "")")
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        print(">> [complexion] SplashViewController onGoogleLoginTry > sign error ")
        print(">> [complexion] SplashViewController onGoogleLoginTry > sign error \(error.debugDescription)")
    }
    
    func login(id : String, password :String, loginType : String)
    {
        let connection : ServerConnection = ServerConnection()
        connection.login(student_id: id, student_password: password, loginType: "") { (requestName, response) in
            
            
        }
    }
}
