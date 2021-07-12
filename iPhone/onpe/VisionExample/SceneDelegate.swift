//
//  SceneDelegate.swift
//  newOnProject
//
//  Created by Ik ju Song on 2021/01/12.
//

import UIKit


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


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }

        self.window = UIWindow(windowScene: windowScene)
        
        // let viewController : UIViewController = SplashViewController()
        let storyboard = UIStoryboard(name: "SplashViewStoryboard", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "Splash")
        let rootNC = UINavigationController(rootViewController: viewController)
        // self.window?.overrideUserInterfaceStyle = .light
        self.window?.rootViewController = rootNC
        self.window?.makeKeyAndVisible()
        
        //userInformationClass.preferences.removeObject(forKey: userInformationClass.autoLoginKey)
//        if (userInformationClass.preferences.object(forKey: userInformationClass.autoLoginKey) != nil) {
//            //자동로그인 일때
//            let autoLoginDic : [String : String] = userInformationClass.preferences.object(forKey: userInformationClass.autoLoginKey) as! [String : String]
//            userInformationClass.fcm_token = autoLoginDic["fcm_token"] ?? ""
//
//            print("++ [complexion] scene (1) 토큰 : \(userInformationClass.access_token)")
//            print("++ [complexion] scene (1) ")
//
//            AF.appAutoLogin(student_id: autoLoginDic["student_id"]!, student_token: autoLoginDic["student_token"]!, url: "app/login")
//        }
//        else
//        {
//
//            print("++ [complexion] scene (2) ")
//            //자동로그인이 아닐때
//            var vc : UIViewController?
//            var type = 1
//            if type == 1 {
//                vc = loginViewController()
//            } else if type == 2 {
//                vc = CameraViewController()
//            } else {
//                vc = ViewController1()
//            }
//            //vc = CameraViewController()
//            /*
//            UIApplication.shared.statusBarStyle = .darkContent
//            UIApplication.shared.setStatusBarStyle(.darkContent, animated: true)
//            */
//
//            self.window?.overrideUserInterfaceStyle = .light
//
//            let rootNC = UINavigationController(rootViewController: vc!)
//
//            self.window?.rootViewController = rootNC
//            self.window?.makeKeyAndVisible()
//        }
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

