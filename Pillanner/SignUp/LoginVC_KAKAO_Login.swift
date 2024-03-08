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
                    print("my kakao Token : ",oauthToken)
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
                print("카카오 닉네임 : ", user?.kakaoAccount?.profile?.nickname)
                print("카카오 이메일 : ", user?.kakaoAccount?.email)
                print("카카오 UserData : ", user?.kakaoAccount)
                
                Auth.auth().createUser(withEmail: (user?.kakaoAccount?.email)!, password: "123123") { result, error in
                    if let error = error {
                        print(error)
                    }
                    
                    if let result = result {
                        print(result)
                        print(result.user.uid)
                    }
                }
            }
        }
    }
}
