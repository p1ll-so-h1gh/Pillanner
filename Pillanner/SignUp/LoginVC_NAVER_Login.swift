//
//  LoginVC_NAVER_Login.swift
//  ExCalendar
//
//  Created by Joseph on 3/9/24.
//

import Foundation
import FirebaseAuth
import NaverThirdPartyLogin
import Alamofire

private let naverLoginInstance = NaverThirdPartyLoginConnection.getSharedInstance()

extension LoginViewController: NaverThirdPartyLoginConnectionDelegate {

    @objc func naverLoginButtonTapped() {
        naverLoginInstance?.delegate = self
        naverLoginInstance?.requestThirdPartyLogin()
    }

    @objc func naverDisconnectButtonTapped() {
        // 네이버 연결 끊기
        naverLoginInstance?.requestDeleteToken()
    }

    // 로그인에 성공했을 경우
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        guard let accessToken = naverLoginInstance?.accessToken else {
            return
        }
        print("Naver Login 성공")

        // 사용자 정보 가져오기 및 Firebase에 등록
        getInfo()
    }

    // RESTful API, id 가져오기
    func getInfo() {
        guard let isValidAccessToken = naverLoginInstance?.isValidAccessTokenExpireTimeNow() else { return }

        if !isValidAccessToken {
            return
        }

        guard let tokenType = naverLoginInstance?.tokenType else { return }
        guard let accessToken = naverLoginInstance?.accessToken else { return }
        guard let refreshToken = naverLoginInstance?.refreshToken else { return }

        let urlStr = "https://openapi.naver.com/v1/nid/me"
        let url = URL(string: urlStr)!

        let authorization = "\(tokenType) \(accessToken)"

        let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": authorization])

        req.responseJSON { response in
            guard let result = response.value as? [String: Any],
                  let object = result["response"] as? [String: Any],
                  let email = object["email"] as? String 
            else {
                return
            }
            // Firebase에 사용자 등록
            Auth.auth().createUser(withEmail: email, password: "123456") { result, error in
                if let error = error {
                    print("Firebase 사용자 등록 오류: \(error)")
                    return
                }

                if let result = result {
                    print("Firebase 사용자 등록 성공: \(result.user.uid)")
                    
                    self.mySNSLoginViewController.myUID = result.user.uid
                    // Firestore DB에 회원 정보 저장
                    DataManager.shared.createUserData(
                        user: UserData(
                            ID: email,
                            password: "sns",
                            name: "아직 설정 전",
                            phoneNumber: "추후 삭제될 필드(저장 불필요)"
                        )
                    )
                    self.navigationController?.pushViewController(SNSLoginViewController(), animated: true)
                }
            }
        }
    }


    // 로그인 버튼을 눌렀을 경우 열게 될 브라우저
    func oauth20ConnectionDidOpenInAppBrowser(forOAuth request: URLRequest!) {

    }

    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        // 리프레시 토큰 처리
    }

    func oauth20ConnectionDidFinishDeleteToken() {
        // 토큰 삭제 처리
    }

    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        // 로그인 실패 처리
    }

    func oauth20ConnectionDidReceiveAccessToken(_ accessToken: String!, tokenType: String!, expiresIn: String!) {
        // 액세스 토큰 수신 처리
    }

}
