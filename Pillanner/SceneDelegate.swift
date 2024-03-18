//
//  SceneDelegate.swift
//  Pillanner
//
//  Created by 영현 on 2/20/24.
//

import UIKit
import KakaoSDKAuth
import NaverThirdPartyLogin

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        guard let windowScene = (scene as? UIWindowScene) else { return }
        print("====================================================================")
        print("UserDefaults UID : ", UserDefaults.standard.string(forKey: "UID") ?? "nil")
        print("UserDefaults ID : ", UserDefaults.standard.string(forKey: "ID") ?? "nil")
        print("UserDefaults Password : ", UserDefaults.standard.string(forKey: "Password") ?? "nil")
        print("UserDefaults Nickname : ", UserDefaults.standard.string(forKey: "Nickname") ?? "nil")
        print("UserDefaults 자동로그인 : ", UserDefaults.standard.bool(forKey: "isAutoLoginActivate")) // true : 자동 로그인 체크
        print("====================================================================")
        window = UIWindow(windowScene: windowScene)
        let password = UserDefaults.standard.string(forKey: "Password") ?? nil
        let startVC: UIViewController
        let autoLoginActivate: Bool = UserDefaults.standard.bool(forKey: "isAutoLoginActivate")
        
        if autoLoginActivate { // 자동로그인 On
            startVC = CustomLaunchScreenViewController(message: "알약, 달력 넘기듯 간편하게", status: true) // 런치스크린 -> 메인탭바뷰컨으로 이동
        } else { // 자동로그인 Off
            startVC = CustomLaunchScreenViewController(message: "알약, 달력 넘기듯 간편하게", status: false) // 런치스크린 -> 로그인뷰컨으로 이동
        }
        
        window?.rootViewController = startVC
        window?.makeKeyAndVisible()
    }

    // 카카오톡 SDK 초기화
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }

        // 네이버
        NaverThirdPartyLoginConnection
            .getSharedInstance()?
            .receiveAccessToken(URLContexts.first?.url)
    }


    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

