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
        
        let usersCollection = myDB.db.collection("Users")
        let query = usersCollection.whereField("ID", isEqualTo: id)
        
        query.getDocuments { (snapshot, error) in
            guard let snapshot = snapshot, !snapshot.isEmpty else {
                if self.myDB.isValidID(id: self.IDTextField.text!){
                    // 아이디가 사용가능한 경우
                    self.IDCheckLabel.text = "사용 가능한 아이디입니다."
                    print(self.myDB.isValidID(id: self.IDTextField.text!))
                    self.IDCheckLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
                    self.IDCheckLabel.textColor = .systemBlue
                    self.availableSignUpFlag = true
                } else {
                    // 아이디가 형식에 맞지 않는 경우
                    self.IDCheckLabel.text = "올바르지 않은 형식입니다. (영문자+숫자, 5~16자)"
                    print(self.myDB.isValidID(id: self.IDTextField.text!))
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
            if myDB.isValidPassword(password: password) {
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
    
    // 다음 페이지 넘어가는 버튼 로직 (회원가입이 되는 상태인지를 판별하고 Firestore DB 에 해당 값들 저장)
    @objc func NextPageButtonClicked() {
        if availableSignUpFlag && !IDTextField.text!.isEmpty && !NameTextField.text!.isEmpty && !PassWordTextField.text!.isEmpty && !PassWordReTextField.text!.isEmpty && !PhoneCertTextField.text!.isEmpty {
            myDB.setUserData(id: IDTextField.text!, name: NameTextField.text!, password: PassWordTextField.text!, phoneNumber: PhoneCertTextField.text!)
        }else {
            print("입력 형식을 다시 확인해주세요.")
        }
    }
}