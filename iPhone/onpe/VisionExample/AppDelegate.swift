//
//  AppDelegate.swift
//  newOnProject
//
//  Created by Ik ju Song on 2021/01/12.
//

import UIKit
import Firebase
import UserNotificationsUI
import GoogleSignIn
import KakaoSDKAuth
import KakaoSDKCommon
import NaverThirdPartyLogin

@main
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate
{
    
    let mServerConnection = ServerConnectionLegacy()
    let gcmMessageIDKey = "gcm.message_id"

    var orientationLock = UIInterfaceOrientationMask.all
    var window: UIWindow?
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
        if error != nil {
            return
        }
        
        guard let authentication = user.authentication else { return }
        
        _ = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
    }
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if (AuthApi.isKakaoTalkLoginUrl(url))
        {
            return AuthController.handleOpenUrl(url: url)
        }
        
        return ((GIDSignIn.sharedInstance()?.handle(url)) != nil)
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        if #available(iOS 13, *)
        {
            
        }
        else
        {
            let window = UIWindow(frame: UIScreen.main.bounds)
            window.rootViewController = SplashViewController()
            
            self.window = window
            window.makeKeyAndVisible()
        }
        
        KakaoSDKCommon.initSDK(appKey: "ae7f17bd4bbf675f593937ddae719269")
        
        let naverInstance = NaverThirdPartyLoginConnection.getSharedInstance()
        naverInstance?.isNaverAppOauthEnable = true
        naverInstance?.isInAppOauthEnable = true
        naverInstance?.isOnlyPortraitSupportedInIphone()
        naverInstance?.serviceUrlScheme = kServiceAppUrlScheme
        naverInstance?.consumerKey = kConsumerKey
        naverInstance?.consumerSecret = kConsumerSecret
        naverInstance?.appName = kServiceAppName
        
        //----------------------------push ?????? ?????? ??????--------------------
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance()?.delegate = self
        
        Messaging.messaging().delegate = self

        if #available(iOS 10.0, *)
        {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self

            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in })
        }
        else
        {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        
        
        //--------------------------------------------------------------------
    
        
        
        // Thread.sleep(forTimeInterval: 1)
        // Override point for customization after application launch.
        UINavigationBar.appearance().isTranslucent = false
        
         
        //UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.clear], for: .normal)
         
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.clear], for: UIControl.State.highlighted)
        UINavigationBar.appearance().tintColor = .black
        
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("push : ",userInfo)
        if let messageID = userInfo[gcmMessageIDKey] {
              print("Message ID: \(messageID)")
            }

            // Print full message.
        print(userInfo)
        
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
    }
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }
    
    struct AppUtility {

        static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                delegate.orientationLock = orientation
            }
        }

        /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
        static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
            
            self.lockOrientation(orientation)
            UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
            UINavigationController.attemptRotationToDeviceOrientation()
        }
    }
}

//-----push ?????? ?????? ??????---------
extension AppDelegate : MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        //let autoLoginDic : [String : String] = userInformationClass.preferences.object(forKey: userInformationClass.autoLoginKey) as? [String : String] ?? ["":""]
        if let autoLoginDic = UserInformation.preferences.object(forKey: UserInformation.autoLoginKey) as? [String : String] {
            if fcmToken != (autoLoginDic["fcm_token"] ?? ""){
                //?????? ??????. ????????? ????????????.
                UserInformation.fcm_token = fcmToken ?? ""
                //?????? sceneDelegate?????? ?????? ???????????? ????????? ????????? ????????? ?????? ????????? ????????????.
                //??? ???????????? ????????? ?????? ??????
                mServerConnection.appAutoLogin(student_id: UserInformation.student_id, student_token: UserInformation.access_token, url: "app/login")
            } else {
                //?????? ????????? ?????????????????? ????????? ????????? ????????? ?????????.
                //????????? ?????? ?????? ?????? ?????????????????? ????????? ??? ????????????
                UserInformation.fcm_token = fcmToken ?? ""
            }
        } else {
            UserInformation.fcm_token = fcmToken ?? ""
        }
        
        
        print(UserInformation.fcm_token)
        
        let dataDict:[String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    // Receive displayed notifications for iOS 10 devices.
      func userNotificationCenter(_ center: UNUserNotificationCenter,
                                  willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        print("push : ",notification.request.content)
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
          print("Message ID: \(messageID)")
        }

        // Print full message.
        print("???????? : ",userInfo)
        for value in userInfo {
            print("?????? : ",value)
        }
        
       
        //print("?????? : ",UNNotificationPresentationOptions.alert)
        // Change this to your preferred presentation option
        completionHandler([[.alert, .sound]])
      }

      func userNotificationCenter(_ center: UNUserNotificationCenter,
                                  didReceive response: UNNotificationResponse,
                                  withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
          print("Message ID: \(messageID)")
        }

        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print full message.
        print(userInfo)

        completionHandler()
      }
}
