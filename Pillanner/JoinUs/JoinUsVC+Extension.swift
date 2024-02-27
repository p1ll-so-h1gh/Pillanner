//
//  JoinUsVC+Extension.swift
//  Pillanner
//
//  Created by 윤규호 on 2/26/24.
//

import Foundation
import Firebase
import FirebaseAuth

extension JoinUsViewController {
    @objc func IDCheckButtonClicked(_ sender: UIButton) {
        if IDTextField.text == "" {
            IDCheckLabel.text = "아이디를 입력해주세요."
            IDCheckLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
            IDCheckLabel.textColor = .red
        }
        else if IDList.contains(IDTextField.text!) {
            IDCheckLabel.text = "이미 사용중인 아이디입니다."
            IDCheckLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
            IDCheckLabel.textColor = .red
        }else {
            IDCheckLabel.text = "사용 가능한 아이디입니다."
            IDCheckLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
            IDCheckLabel.textColor = .systemBlue
        }
    }
    
    @objc func GetCertNumberButtonClicked(_ sender: UIButton) {
        myPhoneNumber = PhoneCertTextField.text!
        
        //가상전화번호로 테스트하기 위한 코드 ---------------------------------------
        Auth.auth().settings?.isAppVerificationDisabledForTesting = true
        //------------------------------------------------------------------
        PhoneAuthProvider.provider()
            .verifyPhoneNumber(myPhoneNumber, uiDelegate: nil) { (verificationID, error) in
                if let error = error {
                    print("@@@@@@@@@@@@@@@@ 에러발생 @@@@@@@@@@@@@@@@@@")
                    print(error.localizedDescription)
                    return
                }
                // 에러가 없다면 사용자에게 인증코드와 verifiacationID(인증 ID) 전달
                print("11111")
                
            }
    }
}
