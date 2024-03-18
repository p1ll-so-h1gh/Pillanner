//
//  LoginVC_KAKAO_Login.swift
//  Pillanner
//
//  Created by 윤규호 on 3/7/24.
//

import Foundation
import KakaoSDKUser
import FirebaseAuth

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
                        print(error)
                    }
                    
                    if let result = result {
                        print(result)
                        print(result.user.uid)
                        
                        // Firestore DB에 회원 정보 저장
                        DataManager.shared.createUserData(
                            user: UserData(
                                UID: result.user.uid,
                                ID: (user?.kakaoAccount?.email)!,
                                password: "sns",
                                nickname: "아직 설정 전"
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
