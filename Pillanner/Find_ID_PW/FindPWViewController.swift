//
//  FindPWViewController.swift
//  Pillanner
//
//  Created by 윤규호 on 3/4/24.
//

import UIKit
import SnapKit

class FindPWViewController: UIViewController, UITextFieldDelegate {
    var myVerificationID: String = ""
    var myIDToken: String = ""
    var limitTime: Int = 180 // 3분
    var availableGetCertNumberFlag: Bool = true // 인증번호 받고 나서 3분 동안만 false. false 상태에선 인증번호를 받을 수 없다.
    var availableSetUpNewPassWordFlag: Bool = false // 개인정보 확인 절차 Flag (이름, 아이디, 번호 인증까지 완료되면 true)
    
    private let sidePaddingValue = 20
    private let topPaddingValue = 30
    
    let NameLabel: UILabel = {
        let label = UILabel()
        label.text = "이름"
        label.font = FontLiteral.body(style: .bold)
        return label
    }()
    
    let NameTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "이름을 입력해주세요."
        textfield.font = FontLiteral.subheadline(style: .regular)
        return textfield
    }()
    
    let NameTextFieldUnderLine: UIProgressView = {
        let line = UIProgressView(progressViewStyle: .bar)
        line.trackTintColor = .lightGray
        line.progressTintColor = .systemBlue
        line.transform = CGAffineTransform(scaleX: 1.0, y: 0.5)
        return line
    }()
    
    let IDLabel: UILabel = {
        let label = UILabel()
        label.text = "아이디"
        label.font = FontLiteral.body(style: .bold)
        return label
    }()
    
    let IDTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "아이디를 입력해주세요."
        textfield.font = FontLiteral.subheadline(style: .regular)
        return textfield
    }()
    
    let IDTextFieldUnderLine: UIProgressView = {
        let line = UIProgressView(progressViewStyle: .bar)
        line.trackTintColor = .lightGray
        line.progressTintColor = .systemBlue
        line.transform = CGAffineTransform(scaleX: 1.0, y: 0.5)
        return line
    }()
    
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
        return label
    }()
    
    let NewPassWordLabel: UILabel = {
        let label = UILabel()
        label.text = "새로운 비밀번호"
        label.font = FontLiteral.body(style: .bold)
        return label
    }()
    
    let NewPassWordTextField: UITextField = {
        let textfield = UITextField()
        textfield.isSecureTextEntry = true
        textfield.placeholder = "8-16 자리 영 대/소문자, 숫자, 특수문자 조합"
        textfield.font = FontLiteral.subheadline(style: .regular)
        return textfield
    }()
    
    let NewPassWordToggleButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "eyeOpen"), for: .normal)
        button.addTarget(target, action: #selector(NewPassWordToggleButtonClicked), for: .touchUpInside)
        return button
    }()
    
    let NewPassWordTextFieldUnderLine: UIProgressView = {
        let line = UIProgressView(progressViewStyle: .bar)
        line.trackTintColor = .lightGray
        line.progressTintColor = .systemBlue
        line.transform = CGAffineTransform(scaleX: 1.0, y: 0.5)
        return line
    }()
    
    let NewPassWordCheckLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let NewPassWordReLabel: UILabel = {
        let label = UILabel()
        label.text = "새로운 비밀번호 재입력"
        label.font = FontLiteral.body(style: .bold)
        return label
    }()
    
    let NewPassWordReTextField: UITextField = {
        let textfield = UITextField()
        textfield.isSecureTextEntry = true
        textfield.placeholder = "8-16 자리 영 대/소문자, 숫자, 특수문자 조합"
        textfield.font = FontLiteral.subheadline(style: .regular)
        return textfield
    }()
    
    let NewPassWordReToggleButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "eyeOpen"), for: .normal)
        button.addTarget(target, action: #selector(NewPassWordReToggleButtonClicked), for: .touchUpInside)
        return button
    }()
    
    let NewPassWordReTextFieldUnderLine: UIProgressView = {
        let line = UIProgressView(progressViewStyle: .bar)
        line.trackTintColor = .lightGray
        line.progressTintColor = .systemBlue
        line.transform = CGAffineTransform(scaleX: 1.0, y: 0.5)
        return line
    }()
    
    let NewPassWordCorrectLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let SetUpNewPassWordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("비밀번호 재설정", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = .mainThemeColor
        button.layer.cornerRadius = 5
        button.addTarget(target, action: #selector(SetUpNewPassWordButtonClicked), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    
        setUpTextFieldDelegate()
        addView()
        setUpConstraint()
    }
    
    private func addView() {
        view.addSubview(IDLabel)
        view.addSubview(IDTextField)
        view.addSubview(IDTextFieldUnderLine)
        
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
        
        view.addSubview(NameLabel)
        view.addSubview(NameTextField)
        view.addSubview(NameTextFieldUnderLine)
        
        view.addSubview(NewPassWordLabel)
        view.addSubview(NewPassWordTextField)
        view.addSubview(NewPassWordToggleButton)
        view.addSubview(NewPassWordTextFieldUnderLine)
        view.addSubview(NewPassWordCheckLabel)
        
        view.addSubview(NewPassWordReLabel)
        view.addSubview(NewPassWordReTextField)
        view.addSubview(NewPassWordReToggleButton)
        view.addSubview(NewPassWordReTextFieldUnderLine)
        view.addSubview(NewPassWordCorrectLabel)
        
        view.addSubview(SetUpNewPassWordButton)
    }
    
    private func setUpConstraint() {
        // 이름 입력부분
        NameLabel.snp.makeConstraints({
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(topPaddingValue)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
        })
        NameTextField.snp.makeConstraints({
            $0.top.equalTo(NameLabel.snp.bottom).offset(5)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-sidePaddingValue)
        })
        NameTextFieldUnderLine.snp.makeConstraints({
            $0.top.equalTo(NameTextField.snp.bottom).offset(5)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
            $0.width.equalTo(NameTextField.snp.width)
        })
        // 아이디 입력부분
        IDLabel.snp.makeConstraints({
            $0.top.equalTo(NameTextField.snp.bottom).offset(topPaddingValue)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
        })
        IDTextField.snp.makeConstraints({
            $0.top.equalTo(IDLabel.snp.bottom).offset(5)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-sidePaddingValue)
        })
        IDTextFieldUnderLine.snp.makeConstraints({
            $0.top.equalTo(IDTextField.snp.bottom).offset(5)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
            $0.width.equalTo(IDTextField.snp.width)
        })
        // 휴대전화번호 인증부분
        PhoneCertLabel.snp.makeConstraints({
            $0.top.equalTo(IDTextField.snp.bottom).offset(topPaddingValue)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
        })
        PhoneCertTextField.snp.makeConstraints({
            $0.top.equalTo(PhoneCertLabel.snp.bottom).offset(5)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-sidePaddingValue)
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
        // 인증번호 입력부분
        CertUIView.snp.makeConstraints({
            $0.top.equalTo(PhoneCertTextFieldUnderLine.snp.bottom).offset(topPaddingValue)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-sidePaddingValue)
        })
        timerLabel.snp.makeConstraints({
            $0.width.equalTo(40)
            $0.height.equalTo(30)
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
        // 새로운 비밀번호 입력부분
        NewPassWordLabel.snp.makeConstraints({
            $0.top.equalTo(CertUIView.snp.bottom).offset(topPaddingValue)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
        })
        NewPassWordTextField.snp.makeConstraints({
            $0.top.equalTo(NewPassWordLabel.snp.bottom).offset(5)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-sidePaddingValue)
        })
        NewPassWordToggleButton.snp.makeConstraints({
            $0.centerY.equalTo(NewPassWordTextField.snp.centerY)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-sidePaddingValue)
            $0.width.height.equalTo(20)
        })
        NewPassWordTextFieldUnderLine.snp.makeConstraints({
            $0.top.equalTo(NewPassWordTextField.snp.bottom).offset(5)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
            $0.width.equalTo(NewPassWordTextField.snp.width)
        })
        NewPassWordCheckLabel.snp.makeConstraints({
            $0.top.equalTo(NewPassWordTextFieldUnderLine.snp.bottom).offset(1)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
        })
        // 새로운 비밀번호 재입력부분
        NewPassWordReLabel.snp.makeConstraints({
            $0.top.equalTo(NewPassWordTextField.snp.bottom).offset(topPaddingValue)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
        })
        NewPassWordReTextField.snp.makeConstraints({
            $0.top.equalTo(NewPassWordReLabel.snp.bottom).offset(5)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-sidePaddingValue)
        })
        NewPassWordReToggleButton.snp.makeConstraints({
            $0.centerY.equalTo(NewPassWordReTextField.snp.centerY)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-sidePaddingValue)
            $0.width.height.equalTo(20)
        })
        NewPassWordReTextFieldUnderLine.snp.makeConstraints({
            $0.top.equalTo(NewPassWordReTextField.snp.bottom).offset(5)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
            $0.width.equalTo(NewPassWordReTextField.snp.width)
        })
        NewPassWordCorrectLabel.snp.makeConstraints({
            $0.top.equalTo(NewPassWordReTextFieldUnderLine.snp.bottom).offset(1)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
        })
        // 비밀번호 재설정 버튼
        SetUpNewPassWordButton.snp.makeConstraints({
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-sidePaddingValue)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
            $0.height.equalTo(50)
        })
    }
}
