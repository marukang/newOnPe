//
//  SceneDelegate.swift
//  newOnProject
//

import UIKit
import KakaoSDKAuth
import NaverThirdPartyLogin

class SceneDelegate: UIResponder, UIWindowSceneDelegate
{
    var window: UIWindow?

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

