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

extension SignUpViewController {

    @objc func dismissView() {
        navigationController?.popViewController(animated: true)
    }

    // ID 중복체크 버튼 메서드 (firestore 내부 필드 값과 비교)
    @objc func IDCheckButtonClicked(_ sender: UIButton) {
        guard let id = idTextField.text, !id.isEmpty else {
            idCheckLabel.text = "아이디를 입력해주세요."
            idCheckLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
            idCheckLabel.textColor = .red
            availableSignUpFlag = false
            return
        }
        
        let usersCollection = DataManager.shared.db.collection("Users")
        let query = usersCollection.whereField("ID", isEqualTo: id)
        
        query.getDocuments { (snapshot, error) in
            guard let snapshot = snapshot, !snapshot.isEmpty else {
                if DataManager.shared.isValidID(id: self.idTextField.text!){
                    // 아이디가 사용가능한 경우
                    self.idCheckLabel.text = "사용 가능한 아이디입니다."
                    self.idCheckButton.setTitleColor(UIColor.lightGray, for: .normal)
                    self.idCheckLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
                    self.idCheckLabel.textColor = .systemBlue
                    self.availableSignUpFlag = true
                } else {
                    // 아이디가 형식에 맞지 않는 경우
                    self.idCheckLabel.text = "올바르지 않은 형식입니다. (영문자+숫자, 5~16자)"
                    self.idCheckButton.setTitleColor(UIColor.black, for: .normal)
                    self.idCheckLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
                    self.idCheckLabel.textColor = .red
                    self.availableSignUpFlag = false
                }
                return
            }
            
            // 아이디가 이미 존재하는 경우,
            self.idCheckLabel.text = "이미 사용중인 아이디입니다."
            self.idCheckLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
            self.idCheckLabel.textColor = .red
            self.availableSignUpFlag = false
        }
    }
    
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
            timerLabel.isHidden = false
            if availableGetCertNumberFlag == true {
                // 가상번호 테스트용 코드 (에러수정 시 사용예정)==============================
                Auth.auth().settings?.isAppVerificationDisabledForTesting = true
                //=================================================================
                PhoneAuthProvider.provider()
                    .verifyPhoneNumber(formatPhoneNumberForFirebase(phoneCertTextField.text!), uiDelegate: nil) { (verificationID, error) in
                        if let error = error {
                            print("@@@@@@@@@@@@@@@@ 에러발생 @@@@@@@@@@@@@@@@@@")
                            self.ifPhoneNumberIsEmptyLabel.text = "전화번호를 다시 입력해주세요."
                            self.ifPhoneNumberIsEmptyLabel.textColor = .red
                            print(error.localizedDescription)
                            return
                        }
                        // 에러가 없다면 사용자에게 인증코드와 verificationID(인증 ID) 전달
                        print("@@@@@@@@@@@@@@@@@@@ 인증번호 발송 @@@@@@@@@@@@@@@@@@")
                        self.getSetTime()
                        self.ifPhoneNumberIsEmptyLabel.text = ""
                        self.certNumberAvailableLabel.text = "인증번호가 발송되었습니다."
                        self.getCertNumberButton.setTitle("재전송", for: .normal)
                        self.getCertNumberButton.isEnabled = false
                        self.certNumberAvailableLabel.textColor = .systemBlue
                        self.certNumberAvailableLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
                        UserDefaults.standard.setValue(verificationID!, forKey: "firebaseVerificationID")
                    }
            }
        } else if phoneCertTextField.text!.isEmpty {
            ifPhoneNumberIsEmptyLabel.text = "번호가 입력되지 않았습니다."
            ifPhoneNumberIsEmptyLabel.textColor = .red
            ifPhoneNumberIsEmptyLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        }
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
            getCertNumberButton.isEnabled = true
            certNumberAvailableLabel.text = "인증번호 유효시간이 초과했습니다."
            certNumberAvailableLabel.textColor = .red
            certNumberAvailableLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        }
    }
    
    // 인증번호 확인 버튼
    @objc func CheckCertNumberButtonClicked() {
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: UserDefaults.standard.string(forKey: "firebaseVerificationID")!,
            verificationCode: self.certNumberTextField.text!
        )
        Auth.auth().signIn(with: credential) { authData, error in
            if let error = error {
                print("errorCode: \(error)")
                let code = (error as NSError).code
                switch code {
                case 17051 :
                    let alert = UIAlertController(title: "전화번호 인증", message: "처리중입니다.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default))
                    self.present(alert, animated: true)
                case 17044 :
                    self.certNumberTextField.text = ""
                    // 인증번호 매칭 에러 - Alert
                    let alert = UIAlertController(title: "인증 실패", message: "인증번호가 올바르지 않습니다.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default))
                    self.present(alert, animated: true)
                default : print(error.localizedDescription)
                }
            } else {
                guard let authData = authData else { return }
                self.myUID = authData.user.uid // 가입하기 버튼 눌렀을 때 넣어줄 UID값 미리 받는 부분
                UserDefaults.standard.setValue(self.certNumberTextField.text!, forKey: "firebaseVerificationCode")
                // 성공시 Current IDTokenRefresh 처리
                let currentUser = Auth.auth().currentUser
                currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                    if let error = error {
                        print(error)
                        return
                    }
                    // FirebaseidToken 받기 완료 (Authentication)
                    self.stopTimer()
                    self.timerLabel.isHidden = true
                    self.limitTime = 180
                    self.availableGetCertNumberFlag = false
                    self.certNumberAvailableLabel.text = "인증번호가 확인되었습니다."
                    self.certNumberAvailableLabel.textColor = .systemBlue
                    self.certNumberAvailableLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
                }
            }
        }
    }
    
    // 비밀번호 토글 버튼
    @objc func PassWordToggleButtonClicked() {
        if passwordTextField.isSecureTextEntry == true {
            passwordTextField.isSecureTextEntry = false
            passwordToggleButton.setImage(UIImage(named: "eyeClose"), for: .normal)
        } else {
            passwordTextField.isSecureTextEntry = true
            passwordToggleButton.setImage(UIImage(named: "eyeOpen"), for: .normal)
        }
    }
    
    // 비밀번호 재입력 토글 버튼
    @objc func PassWordReToggleButtonClicked() {
        if passwordReTextField.isSecureTextEntry == true {
            passwordReTextField.isSecureTextEntry = false
            passwordReToggleButton.setImage(UIImage(named: "eyeClose"), for: .normal)
        } else {
            passwordReTextField.isSecureTextEntry = true
            passwordReToggleButton.setImage(UIImage(named: "eyeOpen"), for: .normal)
        }
    }
    
    // 비밀번호 재입력 필드의 텍스트가 변경될 때마다 호출되는 메서드
    func TextField(_ TextField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if TextField == passwordReTextField {
            // 변경된 텍스트를 포함하여 비밀번호가 일치하는지 확인
            let updatedString = (TextField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
            let fullPassword = passwordTextField.text ?? ""
            let reenteredPassword = updatedString
            if fullPassword == reenteredPassword {
                passwordCorrectLabel.text = "비밀번호가 일치합니다."
                passwordCorrectLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
                passwordCorrectLabel.textColor = .systemBlue
                availableSignUpFlag = true
            } else {
                passwordCorrectLabel.text = "비밀번호가 일치하지 않습니다."
                passwordCorrectLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
                passwordCorrectLabel.textColor = .red
                availableSignUpFlag = false
            }
        }
        if TextField == passwordTextField {
            let password = (TextField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
            if DataManager.shared.isValidPassword(password: password) {
                passwordCheckLabel.text = "사용가능한 비밀번호입니다."
                passwordCheckLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
                passwordCheckLabel.textColor = .systemBlue
                availableSignUpFlag = true
            }else {
                passwordCheckLabel.text = "올바르지 않은 형식입니다. (영문자+숫자+특수문자, 8~16자)"
                passwordCheckLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
                passwordCheckLabel.textColor = .red
                availableSignUpFlag = false
            }
        }
        return true
    }
    
    // 텍스트필드 위임자 선언
    func setUpTextFieldDelegate() {
        [idTextField, nameTextField, passwordTextField, passwordReTextField, phoneCertTextField, certNumberTextField] .forEach({
            $0.delegate = self
        })
    }
    
    // 키보드 외부 터치할 경우 키보드 숨김처리
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // 키보드 리턴 버튼 누를경우 키보드 숨김처리
    func TextFieldShouldReturn(_ TextField: UITextField) -> Bool {
        TextField.resignFirstResponder()
        return true
    }
    
    // 텍스트필드 언더라인 활성화 메서드
    func TextFieldDidBeginEditing(_ TextField: UITextField) {
        UIView.animate(withDuration: 0.4) {
            switch(TextField) {
            case self.idTextField : self.idTextFieldUnderline.setProgress(1.0, animated: true)
            case self.nameTextField : self.nameTextFieldUnderline.setProgress(1.0, animated: true)
            case self.passwordTextField : self.passwordTextFieldUnderline.setProgress(1.0, animated: true)
            case self.passwordReTextField : self.passwordReTextFieldUnderline.setProgress(1.0, animated: true)
            case self.phoneCertTextField : self.phoneCertTextFieldUnderline.setProgress(1.0, animated: true)
            default : break
            }
        }
    }
    
    // 텍스트필드 언더라인 비활성화 메서드
    func TextFieldDidEndEditing(_ TextField: UITextField) {
        UIView.animate(withDuration: 0.3) {
            switch(TextField) {
            case self.idTextField : self.idTextFieldUnderline.setProgress(0.0, animated: true)
            case self.nameTextField : self.nameTextFieldUnderline.setProgress(0.0, animated: true)
            case self.passwordTextField : self.passwordTextFieldUnderline.setProgress(0.0, animated: true)
            case self.passwordReTextField : self.passwordReTextFieldUnderline.setProgress(0.0, animated: true)
            case self.phoneCertTextField : self.phoneCertTextFieldUnderline.setProgress(0.0, animated: true)
            default : break
            }
        }
    }
    
    // 인증번호 X 버튼
    @objc func CertNumberDeleteButtonClicked() {
        self.certNumberTextField.text = ""
    }
    
    // 텍스트필드가 값이 입력되어 있는지를 검사하는 메서드. (true 조건 : 텍스트필드가 비어있지 않고 공백을 포함하지 않을 경우)
    func updateFlagsBasedOnTextFields() {
        idTextFieldFlag = !idTextField.text!.isEmpty
        nameTextFieldFlag = !nameTextField.text!.isEmpty
        passwordTextFieldFlag = !passwordTextField.text!.isEmpty
        passwordReTextFieldFlag = !passwordReTextField.text!.isEmpty
        phoneCertTextFieldFlag = !phoneCertTextField.text!.isEmpty
        certNumberTextFieldFlag = !certNumberTextField.text!.isEmpty
    }
    
    func unavailableSignUp() {
        if !idTextFieldFlag {
            idLabel.textColor = .red
        }else {
            idLabel.textColor = .black
        }
        if !nameTextFieldFlag {
            nameLabel.textColor = .red
        }else {
            nameLabel.textColor = .black
        }
        if !passwordTextFieldFlag {
            passwordLabel.textColor = .red
        }else {
            passwordLabel.textColor = .black
        }
        if !passwordReTextFieldFlag {
            passwordReLabel.textColor = .red
        }else {
            passwordReLabel.textColor = .black
        }
        if !phoneCertTextFieldFlag {
            phoneCertLabel.textColor = .red
        }else {
            phoneCertLabel.textColor = .black
        }
    }
    
    
    // 가입 하기 버튼 로직 (회원가입이 되는 상태인지를 판별하고 Firestore DB 에 해당 값들 저장)
    @objc func SignUpButtonClicked() {
        // 각각의 flag 변수 값 업데이트
        updateFlagsBasedOnTextFields()
        
        if availableSignUpFlag && !idTextField.text!.isEmpty && !nameTextField.text!.isEmpty && !passwordTextField.text!.isEmpty && !passwordReTextField.text!.isEmpty && !phoneCertTextField.text!.isEmpty {
            
            // Firestore DB에 회원 정보 저장
            
            DataManager.shared.createUserData(user: UserData(
                UID: self.myUID,
                ID: idTextField.text!,
                password: passwordTextField.text!,
                nickname: nameTextField.text!,
                signUpPath: "일반회원가입"
            )
            )
            // 회원가입 완료 - Alert
            let alert = UIAlertController(title: "가입 성공", message: "회원가입이 완료되었습니다 !", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
                let initialSetUpStartVC = UINavigationController(rootViewController: InitialSetupStartViewController(nickName: self.nameTextField.text!))
                initialSetUpStartVC.modalPresentationStyle = .fullScreen
                self.present(initialSetUpStartVC, animated: true)
            })
            self.present(alert, animated: true)
            
        }else {
            unavailableSignUp()
            // 인증번호 매칭 에러 - Alert
            let alert = UIAlertController(title: "가입 실패", message: "입력 형식을 다시 확인해주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            self.present(alert, animated: true)
        }
    }
}
