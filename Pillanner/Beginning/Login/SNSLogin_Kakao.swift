//
//  LoginVC_KAKAO_Login.swift
//  Pillanner
//
//  Created by 윤규호 on 3/7/24.
//

import Foundation
import KakaoSDKUser
import FirebaseAuth
import UIKit

extension LoginViewController {
    @objc func kakaoLoginButtonTapped() {
        // 카카오톡 설치 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) {
            
            //카카오톡 앱을 통해 로그인
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                    print("카카오앱 에러")
                }
                else {
                    print("loginWithKakaoTalk() success.")
                    print("카카오톡 앱으로 실행")
                    //do something
                    _ = oauthToken
                    print("my kakao Token : ",oauthToken as Any)
                    self.signUpWithKakaoEmail()
                }
            }
        } else {
            // 설치 안되어있으면 카카오 웹뷰로 로그인
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print(error)
                    print("카카오웹! 에러;")
                }
                else {
                    print("loginWithKakaoTalk() success.")
                    print("카카오톡 앱이 없어용~~")
                    //do something
                    _ = oauthToken
                    self.signUpWithKakaoEmail()
                }
            }
        }
    }
    
    func signUpWithKakaoEmail() {
        UserApi.shared.me() {(user, error) in
            if let error = error {
                print(error)
            }
            else {
                print("me() success.")
                //do something
                _ = user
                
                Auth.auth().createUser(withEmail: (user?.kakaoAccount?.email)!, password: "123456") { result, error in
                    if let error = error {
                        let code = (error as NSError).code
                        print("firebase auth error code : ", code)
                        switch code {
                        case 17007 :
                            DataManager.shared.readUserData(userID: (user?.kakaoAccount?.email)!) { userData in
                                guard let userData = userData else { return }
                                if userData["SignUpPath"]! == "카카오" {
                                    UserDefaults.standard.set(userData["UID"]!, forKey: "UID")
                                    UserDefaults.standard.set(userData["ID"]!, forKey: "ID")
                                    UserDefaults.standard.set(userData["Password"]!, forKey: "Password")
                                    UserDefaults.standard.set(userData["Nickname"]!, forKey: "Nickname")
                                    UserDefaults.standard.set(userData["SignUpPath"]!, forKey: "SignUpPath")
                                    UserDefaults.standard.set(true, forKey: "isAutoLoginActivate")
                                    Auth.auth().signIn(withEmail: (user?.kakaoAccount?.email)!, password: "123456")
                                    let nextVC = TabBarController()
                                    nextVC.modalPresentationStyle = .fullScreen
                                    self.present(nextVC, animated: true)
                                } else {
                                    let alert = UIAlertController(title: "로그인 실패", message: "이미 가입된 이메일입니다.", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "확인", style: .cancel))
                                    self.present(alert, animated: true)
                                }
                            }
                        default : print(error.localizedDescription)
                        }
                    }
                    
                    if let result = result {
                        print(result)
                        print(result.user.uid)
                        UserDefaults.standard.set(true, forKey: "isAutoLoginActivate")
                        // Firestore DB에 회원 정보 저장
                        DataManager.shared.createUserData(
                            user: UserData(
                                UID: result.user.uid,
                                ID: (user?.kakaoAccount?.email)!,
                                password: "sns",
                                nickname: "아직 설정 전",
                                signUpPath: "카카오"
                            )
                        )
                        let nextVC = SNSLoginViewController()
                        nextVC.modalPresentationStyle = .fullScreen
                        self.present(nextVC, animated: true)
                    }
                }
            }
        }
    }
    
    // 카카오톡 로그아웃
    func kakaoLogout() {
        UserApi.shared.logout(completion: { (error) in
            if let error = error {
                print("로그아웃 에러: ", error)
            } else {
                print("카카오 로그아웃 성공")
            }
        })
    }
}
