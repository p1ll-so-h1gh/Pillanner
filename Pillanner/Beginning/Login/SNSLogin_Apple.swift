//
//  LoginVC_APPLE_Login.swift
//  Pillanner
//
//  Created by 윤규호 on 3/7/24.
//

import Foundation
import AuthenticationServices
import CryptoKit
import FirebaseAuth

extension LoginViewController {
    @objc func appleLoginButtonTapped() {
        
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        // request 요청을 했을 때 none가 포함되어서 릴레이 공격을 방지
        // 추후 파베에서도 무결성 확인을 할 수 있게끔 함
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
        
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            
            // Initialize a Firebase credential, including the user's full name.
            let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                           rawNonce: nonce,
                                                           fullName: appleIDCredential.fullName)
            // Sign in with Firebase.
            Auth.auth().signIn(with: credential) { (result, error) in
                if let error = error {
                    let code = (error as NSError).code
                    print("firebase auth error code : ", code)
                }
                print("애플 로그인에 성공했습니다.")
                print("appleIDCredential : ", appleIDCredential)
                UserDefaults.standard.set(true, forKey: "isAutoLoginActivate")
                // Firestore DB에 회원 정보 저장
                DataManager.shared.createUserData(
                    user: UserData(
                        UID: result!.user.uid,
                        ID: result!.user.email!,
                        password: "sns",
                        nickname: "(이름 없음)",
                        signUpPath: "애플"
                    )
                )
                let nextVC = SNSLoginViewController()
                nextVC.modalPresentationStyle = .fullScreen
                self.present(nextVC, animated: true)
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    // Apple Login 관련
    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    // Apple 로그아웃 (Firebase)
    func appleFirebaseLogout() {
        do {
            try Auth.auth().signOut()
            print("Firebase Apple 로그아웃")
        } catch let error {
            print("Firebase Apple 로그아웃 에러: ", error.localizedDescription)
        }
    }
}
