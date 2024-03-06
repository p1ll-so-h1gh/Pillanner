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
    
    // 인증번호 받기 버튼 메서드
    @objc func GetCertNumberButtonClicked(_ sender: UIButton) {
        timerLabel.isHidden = false
        if availableGetCertNumberFlag == true {
            getSetTime()
            CertNumberAvailableLabel.text = "인증번호가 발송되었습니다."
            CertNumberAvailableLabel.textColor = .systemBlue
            CertNumberAvailableLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
            //가상전화번호로 테스트하기 위한 코드 ---------------------------------------
            //Auth.auth().settings?.isAppVerificationDisabledForTesting = true
            //------------------------------------------------------------------
            PhoneAuthProvider.provider()
                .verifyPhoneNumber(PhoneCertTextField.text!, uiDelegate: nil) { (verificationID, error) in
                    if let error = error {
                        print("@@@@@@@@@@@@@@@@ 에러발생 @@@@@@@@@@@@@@@@@@")
                        print(error.localizedDescription)
                        return
                    }
                    // 에러가 없다면 사용자에게 인증코드와 verifiacationID(인증 ID) 전달
                    print("인증성공 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
                    print("사용자 veriID by String", String(verificationID!))
                    //print("사용자 veriID Origin", verificationID)
                    self.myVerificationID = verificationID!
                }
        }
    }
    
    // 인증번호 X 버튼
    @objc func CertNumberDeleteButtonClicked() {
        self.CertNumberTextField.text = ""
    }
    
    // 인증번호 타이머 감소 메서드
    @objc func getSetTime() {
        secToTime(sec: limitTime)
        limitTime -= 1
    }
    
    // 인증번호 타이머 세팅 메서드
    func secToTime(sec: Int) {
        availableGetCertNumberFlag = false
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
            CertNumberAvailableLabel.text = "인증번호 유효시간이 초과했습니다."
            CertNumberAvailableLabel.textColor = .red
            CertNumberAvailableLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        }
    }
    
    // 인증번호 확인 버튼
    @objc func CheckCertNumberButtonClicked() {
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: myVerificationID,
            verificationCode: self.CertNumberTextField.text!
        )
        Auth.auth().signIn(with: credential) { authData, error in
            if let error = error {
                print("errorCode: \(error)")
                print("인증번호가 일치하지 않습니다.")
                self.CertNumberTextField.text = ""
                // 인증번호 매칭 에러 - Alert
                let alert = UIAlertController(title: "인증 실패", message: "인증번호가 올바르지 않습니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default))
                self.present(alert, animated: true)
            }
            // 성공시 Current IDTokenRefresh 처리
            print("Current IDTokenRefresh 처리중...")
            let currentUser = Auth.auth().currentUser
            currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                if let error = error {
                    print(error)
                    return
                }
                // FirebaseidToken 받기 완료
                self.myIDToken = idToken!
                self.timerLabel.isHidden = true
                self.limitTime = 180
                self.CertNumberTextField.text = ""
                self.CertNumberAvailableLabel.text = "인증번호가 확인되었습니다."
                self.CertNumberAvailableLabel.textColor = .systemBlue
                self.CertNumberAvailableLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
                
                self.availableSetUpNewPassWordFlag = true
                print("myIDToken = ", idToken!)
            }
        }
    }
    
    // 새로운 비밀번호 토글 버튼
    @objc func NewPassWordToggleButtonClicked() {
        if NewPassWordTextField.isSecureTextEntry == true {
            NewPassWordTextField.isSecureTextEntry = false
            NewPassWordToggleButton.setImage(UIImage(named: "eyeClose"), for: .normal)
        } else {
            NewPassWordTextField.isSecureTextEntry = true
            NewPassWordToggleButton.setImage(UIImage(named: "eyeOpen"), for: .normal)
        }
    }
    
    // 새로운 비밀번호 재입력 토글 버튼
    @objc func NewPassWordReToggleButtonClicked() {
        if NewPassWordReTextField.isSecureTextEntry == true {
            NewPassWordReTextField.isSecureTextEntry = false
            NewPassWordReToggleButton.setImage(UIImage(named: "eyeClose"), for: .normal)
        } else {
            NewPassWordReTextField.isSecureTextEntry = true
            NewPassWordReToggleButton.setImage(UIImage(named: "eyeOpen"), for: .normal)
        }
    }
    
    // 새로운 비밀번호 재입력 필드의 텍스트가 변경될 때마다 호출되는 메서드
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == NewPassWordReTextField {
            // 변경된 텍스트를 포함하여 비밀번호가 일치하는지 확인
            let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
            let fullPassword = NewPassWordTextField.text ?? ""
            let reenteredPassword = updatedString
            if fullPassword == reenteredPassword {
                NewPassWordCorrectLabel.text = "비밀번호가 일치합니다."
                NewPassWordCorrectLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
                NewPassWordCorrectLabel.textColor = .systemBlue
            } else {
                NewPassWordCorrectLabel.text = "비밀번호가 일치하지 않습니다."
                NewPassWordCorrectLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
                NewPassWordCorrectLabel.textColor = .red
            }
        }
        if textField == NewPassWordTextField {
            let password = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
            if DataManager.shared.isValidPassword(password: password) {
                NewPassWordCheckLabel.text = "사용가능한 비밀번호입니다."
                NewPassWordCheckLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
                NewPassWordCheckLabel.textColor = .systemBlue
            }else {
                NewPassWordCheckLabel.text = "올바르지 않은 형식입니다. (영문자+숫자+특수문자, 8~16자)"
                NewPassWordCheckLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
                NewPassWordCheckLabel.textColor = .red
            }
        }
        return true
    }
    
    // 텍스트필드 위임자 선언
    func setUpTextFieldDelegate() {
        [IDTextField, NameTextField, NewPassWordTextField, NewPassWordReTextField, PhoneCertTextField, CertNumberTextField] .forEach({
            $0.delegate = self
        })
    }
    
    // 텍스트필드 언더라인 활성화 메서드
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.4) {
            switch(textField) {
            case self.IDTextField : self.IDTextFieldUnderLine.setProgress(1.0, animated: true)
            case self.NameTextField : self.NameTextFieldUnderLine.setProgress(1.0, animated: true)
            case self.NewPassWordTextField : self.NewPassWordTextFieldUnderLine.setProgress(1.0, animated: true)
            case self.NewPassWordReTextField : self.NewPassWordReTextFieldUnderLine.setProgress(1.0, animated: true)
            case self.PhoneCertTextField : self.PhoneCertTextFieldUnderLine.setProgress(1.0, animated: true)
            default : break
            }
        }
    }
    
    // 텍스트필드 언더라인 비활성화 메서드
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) {
            switch(textField) {
            case self.IDTextField : self.IDTextFieldUnderLine.setProgress(0.0, animated: true)
            case self.NameTextField : self.NameTextFieldUnderLine.setProgress(0.0, animated: true)
            case self.NewPassWordTextField : self.NewPassWordTextFieldUnderLine.setProgress(0.0, animated: true)
            case self.NewPassWordReTextField : self.NewPassWordReTextFieldUnderLine.setProgress(0.0, animated: true)
            case self.PhoneCertTextField : self.PhoneCertTextFieldUnderLine.setProgress(0.0, animated: true)
            default : break
            }
        }
    }
    
    // 비밀번호 재설정 버튼
    @objc func SetUpNewPassWordButtonClicked() {
        if availableSetUpNewPassWordFlag == true {
            // 비밀번호 재설정
            DataManager.shared.updateUserData(userID: IDTextField.text!, newPassword: NewPassWordTextField.text!, newName: NameTextField.text!)
        }
    }
}
