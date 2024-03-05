//
//  FindIDViewController.swift
//  Pillanner
//
//  Created by 윤규호 on 3/4/24.
//

import UIKit
import SnapKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class FindIDViewController: UIViewController, UITextFieldDelegate {
    var myVerificationID: String = ""
    var myIDToken: String = ""
    var limitTime: Int = 180 // 3분
    var availableGetCertNumberFlag: Bool = true // 인증번호 받고 나서 3분 동안만 false. false 상태에선 인증번호를 받을 수 없다.
    
    private let sidePaddingValue = 20
    private let topPaddingValue = 30
    
    let PhoneCertLabel: UILabel = {
        let label = UILabel()
        label.text = "휴대전화 번호인증"
        label.font = FontLiteral.body(style: .bold)
        return label
    }()
    
    let PhoneCertTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "전화번호를 입력해주세요."
        textfield.font = FontLiteral.subheadline(style: .regular)
        return textfield
    }()
    
    let PhoneCertTextFieldUnderLine: UIProgressView = {
        let line = UIProgressView(progressViewStyle: .bar)
        line.trackTintColor = .lightGray
        line.progressTintColor = .systemBlue
        line.transform = CGAffineTransform(scaleX: 1.0, y: 0.5)
        return line
    }()
    
    let GetCertNumberButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("인증번호 받기", for: .normal) // 재전송
        button.setTitleColor(UIColor.lightGray, for: .normal)
        button.backgroundColor = .mainThemeColor
        button.layer.cornerRadius = 5
        button.addTarget(target, action: #selector(GetCertNumberButtonClicked), for: .touchUpInside)
        return button
    }()
    
    let CertUIView: UIView = {
        let uiView = UIView()
        uiView.layer.cornerRadius = 5
        uiView.layer.borderColor = UIColor.lightGray.cgColor
        uiView.layer.borderWidth = 1
        return uiView
    }()
    
    let CertContentStackView: UIStackView = {
        let stackView = UIStackView()
        return stackView
    }()
    
    let CertNumberTextField: UITextField = {
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
    
    let CertNumberDeleteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "xmark"), for: .normal)
        button.addTarget(target, action: #selector(CertNumberDeleteButtonClicked), for: .touchUpInside)
        return button
    }()
    
    let CheckCertNumberButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("확인", for: .normal)
        button.setTitleColor(UIColor.lightGray, for: .normal)
        button.backgroundColor = .mainThemeColor
        button.layer.cornerRadius = 5
        button.addTarget(target, action: #selector(CheckCertNumberButtonClicked), for: .touchUpInside)
        return button
    }()
    
    let CertNumberAvailableLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "이름"
        label.font = FontLiteral.body(style: .bold)
        return label
    }()
    
    let nameTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "이름을 입력해주세요."
        textfield.font = FontLiteral.subheadline(style: .regular)
        return textfield
    }()
    
    let nameTextFieldUnderLine: UIProgressView = {
        let line = UIProgressView(progressViewStyle: .bar)
        line.trackTintColor = .lightGray
        line.progressTintColor = .systemBlue
        line.transform = CGAffineTransform(scaleX: 1.0, y: 0.5)
        return line
    }()
    
    let birthLabel: UILabel = {
        let label = UILabel()
        label.text = "생년월일 입력"
        label.font = FontLiteral.body(style: .bold)
        return label
    }()
    
    let birthTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "생년월일 6자리를 입력해주세요."
        textfield.font = FontLiteral.subheadline(style: .regular)
        return textfield
    }()
    
    let birthTextFieldUnderLine: UIProgressView = {
        let line = UIProgressView(progressViewStyle: .bar)
        line.trackTintColor = .lightGray
        line.progressTintColor = .systemBlue
        line.transform = CGAffineTransform(scaleX: 1.0, y: 0.5)
        return line
    }()
    
    let findIDButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("아이디 찾기", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = .mainThemeColor
        button.layer.cornerRadius = 5
        button.addTarget(target, action: #selector(findIDButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        addView()
        setContstraints()
    }
    
    private func addView() {
        view.addSubview(PhoneCertLabel)
        view.addSubview(PhoneCertTextField)
        view.addSubview(PhoneCertTextFieldUnderLine)
        view.addSubview(GetCertNumberButton)
        
        CertUIView.addSubview(CertContentStackView)
        CertContentStackView.addArrangedSubview(CertNumberTextField)
        CertContentStackView.addArrangedSubview(timerLabel)
        CertContentStackView.addArrangedSubview(CertNumberDeleteButton)
        CertContentStackView.addArrangedSubview(CheckCertNumberButton)
        view.addSubview(CertUIView)
        view.addSubview(CertNumberAvailableLabel)
        
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(nameTextFieldUnderLine)
        view.addSubview(birthLabel)
        view.addSubview(birthTextField)
        view.addSubview(birthTextFieldUnderLine)
        
        view.addSubview(findIDButton)
    }
    
    private func setContstraints() {
        PhoneCertLabel.snp.makeConstraints({
            $0.top.equalToSuperview().offset(100)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
        })
        PhoneCertTextField.snp.makeConstraints({
            $0.top.equalTo(PhoneCertLabel.snp.bottom).offset(5)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
            $0.right.equalTo(GetCertNumberButton.snp.left).offset(-sidePaddingValue)
        })
        PhoneCertTextFieldUnderLine.snp.makeConstraints({
            $0.top.equalTo(PhoneCertTextField.snp.bottom).offset(5)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
            $0.width.equalTo(PhoneCertTextField.snp.width)
        })
        GetCertNumberButton.snp.makeConstraints({
            $0.centerY.equalTo(PhoneCertTextField.snp.centerY)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-sidePaddingValue)
            $0.width.equalTo(100)
        })
        CertUIView.snp.makeConstraints({
            $0.top.equalTo(PhoneCertTextFieldUnderLine.snp.bottom).offset(topPaddingValue)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-sidePaddingValue)
        })
        timerLabel.snp.makeConstraints({
            $0.width.height.equalTo(40)
        })
        CertNumberDeleteButton.snp.makeConstraints({
            $0.width.height.equalTo(30)
        })
        CheckCertNumberButton.snp.makeConstraints({
            $0.width.equalTo(50)
        })
        CertContentStackView.snp.makeConstraints({
            $0.top.left.equalToSuperview().offset(5)
            $0.right.bottom.equalToSuperview().offset(-5)
        })
        CertNumberAvailableLabel.snp.makeConstraints({
            $0.top.equalTo(CertUIView.snp.bottom).offset(1)
            $0.left.equalTo(sidePaddingValue)
        })
        //이름
        nameLabel.snp.makeConstraints({
            $0.top.equalTo(CertContentStackView.snp.bottom).offset(topPaddingValue)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
        })
        nameTextField.snp.makeConstraints({
            $0.top.equalTo(nameLabel.snp.bottom).offset(5)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-sidePaddingValue)
        })
        nameTextFieldUnderLine.snp.makeConstraints({
            $0.top.equalTo(nameTextField.snp.bottom).offset(5)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
            $0.width.equalTo(nameTextField.snp.width)
        })
        //생년월일
        birthLabel.snp.makeConstraints({
            $0.top.equalTo(nameTextFieldUnderLine.snp.bottom).offset(topPaddingValue)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
        })
        birthTextField.snp.makeConstraints({
            $0.top.equalTo(birthLabel.snp.bottom).offset(5)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-sidePaddingValue)
        })
        birthTextFieldUnderLine.snp.makeConstraints({
            $0.top.equalTo(birthTextField.snp.bottom).offset(5)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
            $0.width.equalTo(birthTextField.snp.width)
        })
        findIDButton.snp.makeConstraints({
            $0.top.equalTo(birthTextFieldUnderLine.snp.bottom).offset(topPaddingValue)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-sidePaddingValue)
        })
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
    
    // 인증번호 X 버튼
    @objc func CertNumberDeleteButtonClicked() {
        self.CertNumberTextField.text = ""
    }
    
//    @objc func findIDButtonTapped(name: String, birth: String) {
    @objc func findIDButtonTapped() {
        // 전화번호가 회원정보(서버)에 저장되어있고, 인증이 성공했으며, 같은 문서에 이름이 정확하게 기입되어있을 떄, 아이디 알려주기
        var idAlert = UIAlertController(title: "결과", message: "회원님의 아이디는 입니다.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        idAlert.addAction(okAction)
        present(idAlert, animated: true)
    }
}
