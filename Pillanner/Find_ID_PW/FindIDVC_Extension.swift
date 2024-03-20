//
//  FindIDVC_Extension.swift
//  Pillanner
//
//  Created by 윤규호 on 3/20/24.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

extension FindIDViewController {
    @objc func dismissView() {
        navigationController?.popViewController(animated: true)
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
                //가상전화번호로 테스트하기 위한 코드 ---------------------------------------
                Auth.auth().settings?.isAppVerificationDisabledForTesting = true
                //------------------------------------------------------------------
                PhoneAuthProvider.provider()
                    .verifyPhoneNumber(formatPhoneNumberForFirebase(phoneCertTextField.text!), uiDelegate: nil) { (verificationID, error) in
                        if let error = error {
                            print("@@@@@@@@@@@@@@@@ 에러발생 @@@@@@@@@@@@@@@@@@")
                            self.ifPhoneNumberIsEmptyLabel.text = "전화번호를 다시 입력해주세요."
                            self.ifPhoneNumberIsEmptyLabel.textColor = .red
                            print(error.localizedDescription)
                            return
                        }
                        // 에러가 없다면 사용자에게 인증코드와 verifiacationID(인증 ID) 전달
                        print("@@@@@@@@@@@@@@@@@@@ 인증번호 발송 @@@@@@@@@@@@@@@@@@")
                        self.myVerificationID = verificationID!
                        self.availableFindIDFlag = false
                        self.getSetTime()
                        self.ifPhoneNumberIsEmptyLabel.text = ""
                        self.certNumberAvailableLabel.text = "인증번호가 발송되었습니다."
                        self.getCertNumberButton.setTitle("재전송", for: .normal)
                        self.getCertNumberButton.setTitleColor(UIColor.lightGray, for: .normal)
                        self.certNumberAvailableLabel.textColor = .systemBlue
                        self.certNumberAvailableLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
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
            getCertNumberButton.setTitleColor(UIColor.black, for: .normal)
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
                self.availableFindIDFlag = false
                self.certNumberTextField.text = ""
                // 인증번호 매칭 에러 - Alert
                let alert = UIAlertController(title: "인증 실패", message: "인증번호가 올바르지 않습니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default))
                self.present(alert, animated: true)
            }
            self.availableFindIDFlag = true
            self.timerLabel.isHidden = true
            self.limitTime = 180
            self.certNumberTextField.text = ""
            self.certNumberAvailableLabel.text = "인증번호가 확인되었습니다."
            self.certNumberAvailableLabel.textColor = .systemBlue
            self.certNumberAvailableLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        }
    }
    
    // 텍스트필드 위임자 선언
    func setUpTextFieldDelegate() {
        [nameTextField, phoneCertTextField, certNumberTextField] .forEach({
            $0.delegate = self
        })
    }
    
    // 키보드 외부 터치할 경우 키보드 숨김처리
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // 키보드 리턴 버튼 누를경우 키보드 숨김처리
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // 텍스트필드 언더라인 활성화 메서드
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.4) {
            switch(textField) {
            case self.nameTextField : self.nameTextFieldUnderLine.setProgress(1.0, animated: true)
            case self.phoneCertTextField : self.phoneCertTextFieldUnderLine.setProgress(1.0, animated: true)
            default : break
            }
        }
    }
    
    // 텍스트필드 언더라인 비활성화 메서드
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) {
            switch(textField) {
            case self.nameTextField : self.nameTextFieldUnderLine.setProgress(0.0, animated: true)
            case self.phoneCertTextField : self.phoneCertTextFieldUnderLine.setProgress(0.0, animated: true)
            default : break
            }
        }
    }
    
    // 인증번호 X 버튼
    @objc func CertNumberDeleteButtonClicked() {
        self.certNumberTextField.text = ""
    }
    
    // 아이디 찾기 버튼
    @objc func findIDButtonTapped() {
        // 인증번호 확인 완료 시
        if availableFindIDFlag {
            DataManager.shared.findIDUserData(userNickName: nameTextField.text!) { userID in
                guard let userID = userID else { return }
                let idAlert = UIAlertController(title: "ID 찾기", message: "회원님의 아이디는 [\(userID)]입니다.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "확인", style: .default, handler: { _ in
                    self.dismissView()
                })
                idAlert.addAction(okAction)
                self.present(idAlert, animated: true)
            }
        } else {
            let idAlert = UIAlertController(title: "찾기 실패", message: "입력 형식을 다시 확인해주세요.", preferredStyle: .alert)
            let failAction = UIAlertAction(title: "확인", style: .default)
            idAlert.addAction(failAction)
            self.present(idAlert, animated: true)
        }
    }
}
