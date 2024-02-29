//
//  JoinUsVC+Extension.swift
//  Pillanner
//
//  Created by 윤규호 on 2/26/24.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth

extension JoinUsViewController {
    
    // ID 중복체크 버튼 로직 (firestore 내부 필드 값과 비교)
    @objc func IDCheckButtonClicked(_ sender: UIButton) {
        guard let id = IDTextField.text, !id.isEmpty else {
            IDCheckLabel.text = "아이디를 입력해주세요."
            IDCheckLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
            IDCheckLabel.textColor = .red
            availableSignUpFlag = false
            return
        }
        
        let usersCollection = DataManager.shared.db.collection("Users")
        let query = usersCollection.whereField("ID", isEqualTo: id)
        
        query.getDocuments { (snapshot, error) in
            guard let snapshot = snapshot, !snapshot.isEmpty else {
                if DataManager.shared.isValidID(id: self.IDTextField.text!){
                    // 아이디가 사용가능한 경우
                    self.IDCheckLabel.text = "사용 가능한 아이디입니다."
                    self.IDCheckLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
                    self.IDCheckLabel.textColor = .systemBlue
                    self.availableSignUpFlag = true
                } else {
                    // 아이디가 형식에 맞지 않는 경우
                    self.IDCheckLabel.text = "올바르지 않은 형식입니다. (영문자+숫자, 5~16자)"
                    self.IDCheckLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
                    self.IDCheckLabel.textColor = .red
                    self.availableSignUpFlag = false
                }
                return
            }
            
            // 아이디가 이미 존재하는 경우,
            self.IDCheckLabel.text = "이미 사용중인 아이디입니다."
            self.IDCheckLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
            self.IDCheckLabel.textColor = .red
            self.availableSignUpFlag = false
        }
    }
    
    // 인증번호 받기 버튼 로직
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
    
    @objc func getSetTime() {
        secToTime(sec: limitTime)
        limitTime -= 1
    }
    
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
                print("myIDToken = ", idToken!)
            }
            
        }
    }
    
    @objc func PassWordToggleButtonClicked() {
        if PassWordTextField.isSecureTextEntry == true {
            PassWordTextField.isSecureTextEntry = false
            PassWordToggleButton.setImage(UIImage(named: "eyeClose"), for: .normal)
        } else {
            PassWordTextField.isSecureTextEntry = true
            PassWordToggleButton.setImage(UIImage(named: "eyeOpen"), for: .normal)
        }
    }
    @objc func PassWordReToggleButtonClicked() {
        if PassWordReTextField.isSecureTextEntry == true {
            PassWordReTextField.isSecureTextEntry = false
            PassWordReToggleButton.setImage(UIImage(named: "eyeClose"), for: .normal)
        } else {
            PassWordReTextField.isSecureTextEntry = true
            PassWordReToggleButton.setImage(UIImage(named: "eyeOpen"), for: .normal)
        }
    }
    
    // 비밀번호 재입력 필드의 텍스트가 변경될 때마다 호출되는 메서드
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == PassWordReTextField {
            // 변경된 텍스트를 포함하여 비밀번호가 일치하는지 확인
            let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
            let fullPassword = PassWordTextField.text ?? ""
            let reenteredPassword = updatedString
            if fullPassword == reenteredPassword {
                PassWordCorrectLabel.text = "비밀번호가 일치합니다."
                PassWordCorrectLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
                PassWordCorrectLabel.textColor = .systemBlue
                availableSignUpFlag = true
            } else {
                PassWordCorrectLabel.text = "비밀번호가 일치하지 않습니다."
                PassWordCorrectLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
                PassWordCorrectLabel.textColor = .red
                availableSignUpFlag = false
            }
        }
        if textField == PassWordTextField {
            let password = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
            if DataManager.shared.isValidPassword(password: password) {
                PassWordCheckLabel.text = "사용가능한 비밀번호입니다."
                PassWordCheckLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
                PassWordCheckLabel.textColor = .systemBlue
                availableSignUpFlag = true
            }else {
                PassWordCheckLabel.text = "올바르지 않은 형식입니다. (영문자+숫자+특수문자, 8~16자)"
                PassWordCheckLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
                PassWordCheckLabel.textColor = .red
                availableSignUpFlag = false
            }
        }
        return true
    }
    
    func setUpTextFieldDelegate() {
        [IDTextField, NameTextField, PassWordTextField, PassWordReTextField, PhoneCertTextField, CertNumberTextField] .forEach({
            $0.delegate = self
        })
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.4) {
            switch(textField) {
            case self.IDTextField : self.IDTextFieldUnderLine.setProgress(1.0, animated: true)
            case self.NameTextField : self.NameTextFieldUnderLine.setProgress(1.0, animated: true)
            case self.PassWordTextField : self.PassWordTextFieldUnderLine.setProgress(1.0, animated: true)
            case self.PassWordReTextField : self.PassWordReTextFieldUnderLine.setProgress(1.0, animated: true)
            case self.PhoneCertTextField : self.PhoneCertTextFieldUnderLine.setProgress(1.0, animated: true)
            default : break
            }
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) {
            switch(textField) {
            case self.IDTextField : self.IDTextFieldUnderLine.setProgress(0.0, animated: true)
            case self.NameTextField : self.NameTextFieldUnderLine.setProgress(0.0, animated: true)
            case self.PassWordTextField : self.PassWordTextFieldUnderLine.setProgress(0.0, animated: true)
            case self.PassWordReTextField : self.PassWordReTextFieldUnderLine.setProgress(0.0, animated: true)
            case self.PhoneCertTextField : self.PhoneCertTextFieldUnderLine.setProgress(0.0, animated: true)
            default : break
            }
        }
    }
    
    // 인증번호 X 버튼
    @objc func CertNumberDeleteButtonClicked() {
        self.CertNumberTextField.text = ""
    }
    
    // 다음 페이지 넘어가는 버튼 로직 (회원가입이 되는 상태인지를 판별하고 Firestore DB 에 해당 값들 저장)
    @objc func NextPageButtonClicked() {
        if availableSignUpFlag && !IDTextField.text!.isEmpty && !NameTextField.text!.isEmpty && !PassWordTextField.text!.isEmpty && !PassWordReTextField.text!.isEmpty && !PhoneCertTextField.text!.isEmpty {
            
            DataManager.shared.createUserData(
                user: UserData(
                    ID: IDTextField.text!,
                    password: PassWordTextField.text!,
                    name: NameTextField.text!,
                    phoneNumber: PhoneCertTextField.text!,
                    mealTime: []
                )
            )
        }else {
            print("입력 형식을 다시 확인해주세요.")
            // 인증번호 매칭 에러 - Alert
            let alert = UIAlertController(title: "가입 실패", message: "입력 형식을 다시 확인해주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            self.present(alert, animated: true)
        }
    }
}
