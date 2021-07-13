//
//  SceneDelegate.swift
//  newOnProject
//
//  Created by Ik ju Song on 2021/01/12.
//

import UIKit
import KakaoSDKAuth
import NaverThirdPartyLogin

class SceneDelegate: UIResponder, UIWindowSceneDelegate, AppLoginDelegate {
    func appLogin(result: Int) {
        
        var type = 1
        if result == 0 {
            type = 3
        } else {
            type = 1
        }
        var vc : UIViewController?
        
        if type == 1 {
            vc = loginViewController()
        } else if type == 2 {
            vc = CameraViewController()
        } else {
            vc = ViewController1()//3이라면 메인 페이지
            
        }
        //vc = CameraViewController()
        /*
        UIApplication.shared.statusBarStyle = .darkContent
        UIApplication.shared.setStatusBarStyle(.darkContent, animated: true)
        */
        
        self.window?.overrideUserInterfaceStyle = .light
        
        let rootNC = UINavigationController(rootViewController: vc!)
        
        self.window?.rootViewController = rootNC
        self.window?.makeKeyAndVisible()
    }
    

    var window: UIWindow?
    let AF = ServerConnectionLegacy()


    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>)
    {
        if let url = URLContexts.first?.url
        {
            if (AuthApi.isKakaoTalkLoginUrl(url))
            {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
        
        NaverThirdPartyLoginConnection.getSharedInstance()?.receiveAccessToken(URLContexts.first?.url)
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }

        self.window = UIWindow(windowScene: windowScene)
        
        let storyboard = UIStoryboard(name: "SplashViewStoryboard", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "Splash")
        let rootNC = UINavigationController(rootViewController: viewController)
        self.window?.rootViewController = rootNC
        self.window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        
    }

    func sceneDidBecomeActive(_ scene: UIScene) {

    }

    func sceneWillResignActive(_ scene: UIScene) {

    }

    func sceneWillEnterForeground(_ scene: UIScene) {

    }

    func sceneDidEnterBackground(_ scene: UIScene) {

    }
}

