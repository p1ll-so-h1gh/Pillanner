//
//  UserInfoView.swift
//  Pillanner
//
//  Created by 김가빈 on 3/12/24.
//


import UIKit
import SnapKit

class UserInfoView: UIViewController, UITextFieldDelegate {
    
    private let withdrawalButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "회원 정보 관리"
        self.navigationController?.isNavigationBarHidden = false
        view.backgroundColor = .white
        
        configureWithdrawalButton()
            addView()
            setUpConstraint()
    }
    
    func configureWithdrawalButton() {
        withdrawalButton.setTitle("회원탈퇴", for: .normal)
        withdrawalButton.titleLabel?.font = FontLiteral.body(style: .regular)

        withdrawalButton.setTitleColor(UIColor.secondaryLabel, for: .normal)
        withdrawalButton.addTarget(self, action: #selector(handleWithdrawal), for: .touchUpInside)
        view.addSubview(withdrawalButton)
    }

    
    @objc func handleWithdrawal() {
        // Show logout alert
        let alert = UIAlertController(title: "회원탈퇴", message: "정말 회원탈퇴 하시겠습니까? 탈퇴시 필래너에 기록된 정보들이 모두 삭제됩니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "네", style: .destructive, handler: { _ in
            // Handle logout logic here
            print("Membership Withdrawal")
        }))
        alert.addAction(UIAlertAction(title: "아니오", style: .cancel, handler: nil))
        present(alert, animated: true)
    }

    var idTextFieldFlag: Bool = false
    var nameTextFieldFlag: Bool = false
    var phoneCertTextFieldFlag: Bool = false
    var certNumberTextFieldFlag: Bool = false
    
    var myVerificationID: String = ""
    var myIDToken: String = ""
    var limitTime: Int = 180 // 3분
    var availableGetCertNumberFlag: Bool = true // 인증번호 받고 나서 3분 동안만 false. false 상태에선 인증번호를 받을 수 없다.
    var availableSignUpFlag: Bool = false // 회원가입 가능 여부를 판별하는 변수. true : 가입 가능, false : 가입 불가능
    
    private let sidePaddingValue = 20
    private let topPaddingValue = 40
    private let buttonHeightValue = 35
    
    let idLabel: UILabel = {
        let label = UILabel()
        label.text = "이름(닉네임) 변경하기"
        label.font = FontLiteral.body(style: .bold)
        return label
    }()
    
    let idTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "변경할 이름(닉네임)을 입력해주세요 :)"
        textfield.font = FontLiteral.subheadline(style: .regular)
        return textfield
    }()
    
    let idTextFieldUnderLine: UIProgressView = {
        let line = UIProgressView(progressViewStyle: .bar)
        line.trackTintColor = .lightGray
        line.progressTintColor = .systemBlue
        line.transform = CGAffineTransform(scaleX: 1.0, y: 0.5)
        return line
    }()
    
    let idCheckButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("변경하기", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = .pointThemeColor2
        button.layer.cornerRadius = 5
        button.addTarget(target, action: #selector(IDCheckButtonClicked), for: .touchUpInside)
        return button
    }()
    
    
    let idCheckLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let nameTextFieldUnderLine: UIProgressView = {
        let line = UIProgressView(progressViewStyle: .bar)
        line.trackTintColor = .lightGray
        line.progressTintColor = .systemBlue
        line.transform = CGAffineTransform(scaleX: 1.0, y: 0.5)
        return line
    }()
    
    
    let phoneCertLabel: UILabel = {
        let label = UILabel()
        label.text = "휴대전화 번호인증"
        label.font = FontLiteral.body(style: .bold)
        return label
    }()
    
    let phoneCertTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "전화번호를 입력해주세요."
        textfield.font = FontLiteral.subheadline(style: .regular)
        return textfield
    }()
    
    let phoneCertTextFieldUnderLine: UIProgressView = {
        let line = UIProgressView(progressViewStyle: .bar)
        line.trackTintColor = .lightGray
        line.progressTintColor = .systemBlue
        line.transform = CGAffineTransform(scaleX: 1.0, y: 0.5)
        return line
    }()
    
    let getCertNumberButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("인증번호 받기", for: .normal) // 재전송
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = .pointThemeColor2
        button.layer.cornerRadius = 5
        button.addTarget(target, action: #selector(GetCertNumberButtonClicked), for: .touchUpInside)
        return button
    }()
    
    let ifPhoneNumberIsEmptyLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let certUIView: UIView = {
        let uiView = UIView()
        uiView.layer.cornerRadius = 5
        uiView.layer.borderColor = UIColor.lightGray.cgColor
        uiView.layer.borderWidth = 1
        return uiView
    }()
    
    let certContentStackView: UIStackView = {
        let stackView = UIStackView()
        return stackView
    }()
    
    let certNumberTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "인증번호 6자리 입력"
        textfield.font = FontLiteral.subheadline(style: .regular)
        return textfield
    }()
    
    let timerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        return label
    }()
    
    let certNumberDeleteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "xmark"), for: .normal)
        button.addTarget(target, action: #selector(CertNumberDeleteButtonClicked), for: .touchUpInside)
        return button
    }()
    
    let checkCertNumberButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("확인", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = .pointThemeColor2
        button.layer.cornerRadius = 5
        button.addTarget(target, action: #selector(CheckCertNumberButtonClicked), for: .touchUpInside)
        return button
    }()
    
    let certNumberAvailableLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()
    

 
    private func addView() {
        view.addSubview(idLabel)
        view.addSubview(idTextField)
        view.addSubview(idCheckButton)
        view.addSubview(idTextFieldUnderLine)
        view.addSubview(idCheckLabel)
        
        view.addSubview(nameTextFieldUnderLine)
        

        view.addSubview(phoneCertLabel)
        view.addSubview(phoneCertTextField)
        view.addSubview(phoneCertTextFieldUnderLine)
        view.addSubview(getCertNumberButton)
        view.addSubview(ifPhoneNumberIsEmptyLabel)
        view.addSubview(withdrawalButton)
        
        certUIView.addSubview(certContentStackView)
        certContentStackView.addArrangedSubview(certNumberTextField)
        certContentStackView.addArrangedSubview(timerLabel)
        certContentStackView.addArrangedSubview(certNumberDeleteButton)
        certContentStackView.addArrangedSubview(checkCertNumberButton)
        view.addSubview(certUIView)
        view.addSubview(certNumberAvailableLabel)
        
    }
    
    private func setUpConstraint() {
        idLabel.snp.makeConstraints({
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(topPaddingValue)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
        })
        idTextField.snp.makeConstraints({
            $0.top.equalTo(idLabel.snp.bottom).offset(10)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
            $0.right.equalTo(idCheckButton.snp.left).offset(-10)
        })
        idCheckButton.snp.makeConstraints({
            $0.centerY.equalTo(idTextField.snp.centerY).offset(-10)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-sidePaddingValue)
            $0.width.equalTo(100)
            $0.height.equalTo(buttonHeightValue)
        })
        idTextFieldUnderLine.snp.makeConstraints({
            $0.top.equalTo(idTextField.snp.bottom).offset(10)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
            $0.width.equalTo(idTextField.snp.width)
        })
        idCheckLabel.snp.makeConstraints({
            $0.top.equalTo(idTextFieldUnderLine.snp.bottom).offset(2)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
        })

        phoneCertLabel.snp.makeConstraints({
            $0.top.equalTo(idCheckLabel.snp.bottom).offset(topPaddingValue)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
        })
        phoneCertTextField.snp.makeConstraints({
            $0.top.equalTo(phoneCertLabel.snp.bottom).offset(10)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
            $0.right.equalTo(getCertNumberButton.snp.left).offset(-10)
        })
        phoneCertTextFieldUnderLine.snp.makeConstraints({
            $0.top.equalTo(phoneCertTextField.snp.bottom).offset(5)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
            $0.width.equalTo(phoneCertTextField.snp.width)
        })
        getCertNumberButton.snp.makeConstraints({
            $0.centerY.equalTo(phoneCertTextField.snp.centerY)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-sidePaddingValue)
            $0.width.equalTo(100)
            $0.height.equalTo(buttonHeightValue)
        })
        ifPhoneNumberIsEmptyLabel.snp.makeConstraints({
            $0.top.equalTo(phoneCertTextFieldUnderLine.snp.bottom).offset(1)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
        })
        certUIView.snp.makeConstraints({
            $0.top.equalTo(phoneCertTextFieldUnderLine.snp.bottom).offset(topPaddingValue)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-sidePaddingValue)
        })
        timerLabel.snp.makeConstraints({
            $0.width.equalTo(40)
            $0.height.equalTo(30)
        })
        certNumberDeleteButton.snp.makeConstraints({
            $0.width.height.equalTo(30)
        })
        checkCertNumberButton.snp.makeConstraints({
            $0.width.equalTo(50)
            $0.height.equalTo(buttonHeightValue)
        })
        certContentStackView.snp.makeConstraints({
            $0.top.left.equalToSuperview().offset(5)
            $0.right.bottom.equalToSuperview().offset(-5)
        })
        certNumberAvailableLabel.snp.makeConstraints({
            $0.top.equalTo(certUIView.snp.bottom).offset(1)
            $0.left.equalTo(sidePaddingValue)
        })
        
        withdrawalButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20) // Adjust the offset as needed
        }
    }
}


import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth

extension UserInfoView {
    
    // ID 중복체크 버튼 메서드 (firestore 내부 필드 값과 비교)
    @objc func IDCheckButtonClicked(_ sender: UIButton) {
        guard let id = idTextField.text, !id.isEmpty else {
            idCheckLabel.text = "변경할 이름(닉네임)을 입력해주세요."
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
                        self.getSetTime()
                        self.ifPhoneNumberIsEmptyLabel.text = ""
                        self.certNumberAvailableLabel.text = "인증번호가 발송되었습니다."
                        self.getCertNumberButton.setTitle("재전송", for: .normal)
                        self.getCertNumberButton.setTitleColor(UIColor.lightGray, for: .normal)
                        self.certNumberAvailableLabel.textColor = .systemBlue
                        self.certNumberAvailableLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
                        self.myVerificationID = verificationID!
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
                self.certNumberTextField.text = ""
                // 인증번호 매칭 에러 - Alert
                let alert = UIAlertController(title: "인증 실패", message: "인증번호가 올바르지 않습니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default))
                self.present(alert, animated: true)
            } else {
                // 성공시 Current IDTokenRefresh 처리
                print("Current IDTokenRefresh 처리중...")
                let currentUser = Auth.auth().currentUser
                currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                    if let error = error {
                        print(error)
                        return
                    }
            
                    self.stopTimer()
                    self.myIDToken = idToken!
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
    
    // 키보드 외부 터치할 경우 키보드 숨김처리
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // 텍스트필드 언더라인 활성화 메서드
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.4) {
            switch(textField) {
            case self.idTextField : self.idTextFieldUnderLine.setProgress(1.0, animated: true)
            case self.phoneCertTextField : self.phoneCertTextFieldUnderLine.setProgress(1.0, animated: true)
            default : break
            }
        }
    }
    
    // 텍스트필드 언더라인 비활성화 메서드
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) {
            switch(textField) {
            case self.idTextField : self.idTextFieldUnderLine.setProgress(0.0, animated: true)
            case self.phoneCertTextField : self.phoneCertTextFieldUnderLine.setProgress(0.0, animated: true)
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

        
        phoneCertTextFieldFlag = !phoneCertTextField.text!.isEmpty
        certNumberTextFieldFlag = !certNumberTextField.text!.isEmpty
    }
    
    func unavailableSignUp() {
        if !idTextFieldFlag {
            idLabel.textColor = .red
            
        }else {
            idLabel.textColor = .black
            
        }
     
        if !phoneCertTextFieldFlag {
            phoneCertLabel.textColor = .red
            
        }else {
            phoneCertLabel.textColor = .black
            
        }
        if !certNumberTextFieldFlag {
            
        }else {
            
        }
    }
    
}
