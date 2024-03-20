//
//  FindPWVC_Extension.swift
//  Pillanner
//
//  Created by 윤규호 on 3/4/24.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth

extension FindPWViewController {
    // Firebase 인증용 번호로 전환하는 메서드 (ex, 01012341234 -> +821012341234)
    func formatPhoneNumberForFirebase(_ phoneNumber: String) -> String {
        var formattedPhoneNumber = phoneNumber
        // 번호가 010으로 시작하는지 확인
        if formattedPhoneNumber.hasPrefix("010") {
            formattedPhoneNumber.insert(contentsOf: "+82", at: formattedPhoneNumber.startIndex)
        }
        return formattedPhoneNumber
    }
    
    // 인증번호 받기/재전송 버튼 메서드
    @objc func GetCertNumberButtonClicked(_ sender: UIButton) {
        if !phoneCertTextField.text!.isEmpty && availableGetCertNumberFlag == true {
            getCertNumberButton.setTitle("재전송", for: .normal)
            timerLabel.isHidden = false
            if availableGetCertNumberFlag == true {
                //가상전화번호로 테스트하기 위한 코드 ---------------------------------------
                Auth.auth().settings?.isAppVerificationDisabledForTesting = true
                //------------------------------------------------------------------
                PhoneAuthProvider.provider()
                    .verifyPhoneNumber(formatPhoneNumberForFirebase(phoneCertTextField.text!), uiDelegate: nil) { (verificationID, error) in
                        if let error = error {
                            print("@@@@@@@@@@@@@@@@ 에러발생 @@@@@@@@@@@@@@@@@@")
                            self.ifPhoneNumberIsEmptyLabel.text = "전화번호를 다시 입력해주세요."
                            print(error.localizedDescription)
                            return
                        }
                        // 에러가 없다면 사용자에게 인증코드와 verifiacationID(인증 ID) 전달
                        print("@@@@@@@@@@@@@@@@@@@ 인증번호 발송 @@@@@@@@@@@@@@@@@@")
                        self.getSetTime()
                        self.ifPhoneNumberIsEmptyLabel.text = ""
                        self.certNumberAvailableLabel.text = "인증번호가 발송되었습니다."
                        self.certNumberAvailableLabel.textColor = .systemBlue
                        self.certNumberAvailableLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
                        self.myVerificationID = verificationID!
                    }
            }
        }else {
            ifPhoneNumberIsEmptyLabel.text = "번호가 입력되지 않았습니다."
            ifPhoneNumberIsEmptyLabel.textColor = .red
            ifPhoneNumberIsEmptyLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
            
        }
    }
    
    // 인증번호 X 버튼
    @objc func CertNumberDeleteButtonClicked() {
        self.certNumberTextField.text = ""
    }
    
    // 인증번호 타이머 감소 메서드
    @objc func getSetTime() {
        secToTime(sec: limitTime)
        limitTime -= 1
    }
    
    // 타이머 중지 메서드
    func stopTimer() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(getSetTime), object: nil)
    }
    
    // 인증번호 타이머 세팅 메서드
    func secToTime(sec: Int) {
        let minute = (sec % 3600) / 60
        let second = (sec % 3600) % 60
        
        if second < 10 {
            timerLabel.text = String(minute) + ":" + "0"+String(second)
        } else {
            timerLabel.text = String(minute) + ":" + String(second)
        }
        
        if limitTime != 0 {
            perform(#selector(getSetTime), with: nil, afterDelay: 1.0)
        } else if limitTime == 0 {
            timerLabel.isHidden = true
            limitTime = 180
            availableGetCertNumberFlag = true
            certNumberAvailableLabel.text = "인증번호 유효시간이 초과했습니다."
            certNumberAvailableLabel.textColor = .red
            certNumberAvailableLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        }
    }
    
    // 인증번호 확인 버튼
    @objc func CheckCertNumberButtonClicked() {
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: myVerificationID,
            verificationCode: self.certNumberTextField.text!
        )
        Auth.auth().signIn(with: credential) { authData, error in
            if let error = error {
                print("errorCode: \(error)")
                print("인증번호가 일치하지 않습니다.")
                self.certNumberTextField.text = ""
                // 인증번호 매칭 에러 - Alert
                let alert = UIAlertController(title: "인증 실패", message: "인증번호가 올바르지 않습니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default))
                self.present(alert, animated: true)
            }else {
                // 성공시 Current IDTokenRefresh 처리
                print("Current IDTokenRefresh 처리중...")
                let currentUser = Auth.auth().currentUser
                currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                    if let error = error {
                        print(error)
                        return
                    }
                    // FirebaseidToken 받기 완료 (Authentication)
                    self.stopTimer()
                    self.myIDToken = idToken!
                    self.timerLabel.isHidden = true
                    self.limitTime = 10
                    self.availableGetCertNumberFlag = false
                    self.certNumberAvailableLabel.text = "인증번호가 확인되었습니다."
                    self.certNumberAvailableLabel.textColor = .systemBlue
                    self.certNumberAvailableLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
                }
            }
            
        }
    }

    @objc func findPWButtonTapped() {

    }

//    // 새로운 비밀번호 토글 버튼
//    @objc func NewPassWordToggleButtonClicked() {
//        if newPassWordTextField.isSecureTextEntry == true {
//            newPassWordTextField.isSecureTextEntry = false
//            newPassWordToggleButton.setImage(UIImage(named: "eyeClose"), for: .normal)
//        } else {
//            newPassWordTextField.isSecureTextEntry = true
//            newPassWordToggleButton.setImage(UIImage(named: "eyeOpen"), for: .normal)
//        }
//    }
//    
//    // 새로운 비밀번호 재입력 토글 버튼
//    @objc func NewPassWordReToggleButtonClicked() {
//        if newPassWordReTextField.isSecureTextEntry == true {
//            newPassWordReTextField.isSecureTextEntry = false
//            newPassWordReToggleButton.setImage(UIImage(named: "eyeClose"), for: .normal)
//        } else {
//            newPassWordReTextField.isSecureTextEntry = true
//            newPassWordReToggleButton.setImage(UIImage(named: "eyeOpen"), for: .normal)
//        }
//    }
//    
//    // 새로운 비밀번호 재입력 필드의 텍스트가 변경될 때마다 호출되는 메서드
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if textField == newPassWordReTextField {
//            // 변경된 텍스트를 포함하여 비밀번호가 일치하는지 확인
//            let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
//            let fullPassword = newPassWordTextField.text ?? ""
//            let reenteredPassword = updatedString
//            if fullPassword == reenteredPassword {
//                newPassWordCorrectLabel.text = "비밀번호가 일치합니다."
//                newPassWordCorrectLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
//                newPassWordCorrectLabel.textColor = .systemBlue
//            } else {
//                newPassWordCorrectLabel.text = "비밀번호가 일치하지 않습니다."
//                newPassWordCorrectLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
//                newPassWordCorrectLabel.textColor = .red
//            }
//        }
//        if textField == newPassWordTextField {
//            let password = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
//            if DataManager.shared.isValidPassword(password: password) {
//                newPassWordCheckLabel.text = "사용가능한 비밀번호입니다."
//                newPassWordCheckLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
//                newPassWordCheckLabel.textColor = .systemBlue
//            }else {
//                newPassWordCheckLabel.text = "올바르지 않은 형식입니다. (영문자+숫자+특수문자, 8~16자)"
//                newPassWordCheckLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
//                newPassWordCheckLabel.textColor = .red
//            }
//        }
//        return true
//    }
//    
//    // 텍스트필드 위임자 선언
//    func setUpTextFieldDelegate() {
//        [idTextField, nameTextField, newPassWordTextField, newPassWordReTextField, phoneCertTextField, certNumberTextField] .forEach({
//            $0.delegate = self
//        })
//    }
//    
//    // 텍스트필드 언더라인 활성화 메서드
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        UIView.animate(withDuration: 0.4) {
//            switch(textField) {
//            case self.idTextField : self.idTextFieldUnderLine.setProgress(1.0, animated: true)
//            case self.nameTextField : self.nameTextFieldUnderLine.setProgress(1.0, animated: true)
//            case self.newPassWordTextField : self.newPassWordTextFieldUnderLine.setProgress(1.0, animated: true)
//            case self.newPassWordReTextField : self.newPassWordReTextFieldUnderLine.setProgress(1.0, animated: true)
//            case self.phoneCertTextField : self.phoneCertTextFieldUnderLine.setProgress(1.0, animated: true)
//            default : break
//            }
//        }
//    }
//    
//    // 텍스트필드 언더라인 비활성화 메서드
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        UIView.animate(withDuration: 0.3) {
//            switch(textField) {
//            case self.idTextField : self.idTextFieldUnderLine.setProgress(0.0, animated: true)
//            case self.nameTextField : self.nameTextFieldUnderLine.setProgress(0.0, animated: true)
//            case self.newPassWordTextField : self.newPassWordTextFieldUnderLine.setProgress(0.0, animated: true)
//            case self.newPassWordReTextField : self.newPassWordReTextFieldUnderLine.setProgress(0.0, animated: true)
//            case self.phoneCertTextField : self.phoneCertTextFieldUnderLine.setProgress(0.0, animated: true)
//            default : break
//            }
//        }
//    }
//    
//    // 비밀번호 재설정 버튼
//    @objc func SetUpNewPassWordButtonClicked() {
//        if availableSetUpNewPassWordFlag == true {
//            // 비밀번호 재설정
//            DataManager.shared.updateUserData(userID: idTextField.text!, changedPassword: newPassWordTextField.text!, changedName: nameTextField.text!)
//        }else {
//            // 인증번호 매칭 에러 - Alert
//            let alert = UIAlertController(title: "비밀번호 재설정 실패", message: "입력 형식을 다시 확인해주세요.", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "확인", style: .default))
//            self.present(alert, animated: true)
//        }
//    }
}
