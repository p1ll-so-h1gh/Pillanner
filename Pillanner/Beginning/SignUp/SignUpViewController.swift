//
//  JoinUsViewController.swift
//  Pillanner
//
//  Created by 영현 on 2/22/24.
//

import UIKit
import SnapKit

class SignUpViewController: UIViewController, UITextFieldDelegate, KeyboardEvent {
    var transformView: UIView { return self.view }
    
    var idTextFieldFlag: Bool = false
    var nameTextFieldFlag: Bool = false
    var passwordTextFieldFlag: Bool = false
    var passwordReTextFieldFlag: Bool = false
    var phoneCertTextFieldFlag: Bool = false
    var certNumberTextFieldFlag: Bool = false
    
    var myUID: String = ""
    var limitTime: Int = 180 // 3분
    var availableGetCertNumberFlag: Bool = true // 인증번호 받고 나서 3분 동안만 false. false 상태에선 인증번호를 받을 수 없다.
    var availableSignUpFlag: Bool = false // 회원가입 가능 여부를 판별하는 변수. true : 가입 가능, false : 가입 불가능
    
    private let sidePaddingValue = 20
    private let paddingBetweenComponents = 40
    private let buttonHeightValue = 35

    private lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(named: "leftmove")?.withRenderingMode(.alwaysOriginal).withTintColor(.black),
                                     style: .plain,
                                     target: self,
                                     action: #selector(dismissView)
        )
        return button
    }()
    
    // moduled components
    let textfieldUnderline: UIProgressView = {
        let line = UIProgressView(progressViewStyle: .bar)
        line.trackTintColor = .lightGray
        line.progressTintColor = .systemBlue
        line.transform = CGAffineTransform(scaleX: 1.0, y: 0.5)
        return line
    }()
    
    

    let idLabel: UILabel = {
        let label = UILabel()
        label.text = "아이디"
        label.font = FontLiteral.body(style: .bold)
        return label
    }()
    
    let idTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "5-16 자리 영 대/소문자, 숫자 조합"
        textfield.font = FontLiteral.subheadline(style: .regular)
        return textfield
    }()
    
    lazy var idTextFieldUnderline = self.textfieldUnderline
    
//    let idTextFieldUnderLine: UIProgressView = {
//        let line = UIProgressView(progressViewStyle: .bar)
//        line.trackTintColor = .lightGray
//        line.progressTintColor = .systemBlue
//        line.transform = CGAffineTransform(scaleX: 1.0, y: 0.5)
//        return line
//    }()
    
    let idCheckButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("중복확인", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = .mainThemeColor
        button.layer.cornerRadius = 5
        button.addTarget(target, action: #selector(IDCheckButtonClicked), for: .touchUpInside)
        return button
    }()
    
    let idCheckLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임(이름)"
        label.font = FontLiteral.body(style: .bold)
        return label
    }()
    
    let nameTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "이름을 입력해주세요."
        textfield.font = FontLiteral.subheadline(style: .regular)
        return textfield
    }()
    
    lazy var nameTextFieldUnderline = textfieldUnderline
    
//    let nameTextFieldUnderLine: UIProgressView = {
//        let line = UIProgressView(progressViewStyle: .bar)
//        line.trackTintColor = .lightGray
//        line.progressTintColor = .systemBlue
//        line.transform = CGAffineTransform(scaleX: 1.0, y: 0.5)
//        return line
//    }()
    
    let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호"
        label.font = FontLiteral.body(style: .bold)
        return label
    }()
    
    let passwordTextField: UITextField = {
        let textfield = UITextField()
        textfield.isSecureTextEntry = true
        textfield.placeholder = "8-16 자리 영 대/소문자, 숫자, 특수문자 조합"
        textfield.font = FontLiteral.subheadline(style: .regular)
        return textfield
    }()
    
    let passwordToggleButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "eyeOpen"), for: .normal)
        button.addTarget(target, action: #selector(PassWordToggleButtonClicked), for: .touchUpInside)
        return button
    }()
    
    lazy var passwordTextFieldUnderline = textfieldUnderline

//    let passwordTextFieldUnderLine: UIProgressView = {
//        let line = UIProgressView(progressViewStyle: .bar)
//        line.trackTintColor = .lightGray
//        line.progressTintColor = .systemBlue
//        line.transform = CGAffineTransform(scaleX: 1.0, y: 0.5)
//        return line
//    }()
    
    let passwordCheckLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let passwordReLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호 재입력"
        label.font = FontLiteral.body(style: .bold)
        return label
    }()
    
    let passwordReTextField: UITextField = {
        let textfield = UITextField()
        textfield.isSecureTextEntry = true
        textfield.placeholder = "8-16 자리 영 대/소문자, 숫자, 특수문자 조합"
        textfield.font = FontLiteral.subheadline(style: .regular)
        return textfield
    }()
    
    let passwordReToggleButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "eyeOpen"), for: .normal)
        button.addTarget(target, action: #selector(PassWordReToggleButtonClicked), for: .touchUpInside)
        return button
    }()
    
    lazy var passwordReTextFieldUnderline = textfieldUnderline
    
//    let passwordReTextFieldUnderLine: UIProgressView = {
//        let line = UIProgressView(progressViewStyle: .bar)
//        line.trackTintColor = .lightGray
//        line.progressTintColor = .systemBlue
//        line.transform = CGAffineTransform(scaleX: 1.0, y: 0.5)
//        return line
//    }()
    
    let passwordCorrectLabel: UILabel = {
        let label = UILabel()
        return label
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
    
    lazy var phoneCertTextFieldUnderline = textfieldUnderline
    
//    let phoneCertTextFieldUnderLine: UIProgressView = {
//        let line = UIProgressView(progressViewStyle: .bar)
//        line.trackTintColor = .lightGray
//        line.progressTintColor = .systemBlue
//        line.transform = CGAffineTransform(scaleX: 1.0, y: 0.5)
//        return line
//    }()
    
    let getCertNumberButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("인증번호 받기", for: .normal) // 재전송
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = .mainThemeColor
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
        button.backgroundColor = .mainThemeColor
        button.layer.cornerRadius = 5
        button.addTarget(target, action: #selector(CheckCertNumberButtonClicked), for: .touchUpInside)
        return button
    }()
    
    let certNumberAvailableLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("회원가입 하기", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = .mainThemeColor
        button.layer.cornerRadius = 5
        button.addTarget(target, action: #selector(SignUpButtonClicked), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "회원 가입"
        
        setUpTextFieldDelegate()
        addView()
        setUpConstraint()
        setupKeyboardEvent()
        
        navigationItem.leftBarButtonItem = backButton
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // KeyboardEvent의 removeKeyboardObserver
        removeKeyboardObserver()
    }
    
    private func addView() {
        view.addSubview(idLabel)
        view.addSubview(idTextField)
        view.addSubview(idCheckButton)
        view.addSubview(idTextFieldUnderline)
        view.addSubview(idCheckLabel)
        
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(nameTextFieldUnderline)
        
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        view.addSubview(passwordToggleButton)
        view.addSubview(passwordTextFieldUnderline)
        view.addSubview(passwordCheckLabel)
        
        view.addSubview(passwordReLabel)
        view.addSubview(passwordReTextField)
        view.addSubview(passwordReToggleButton)
        view.addSubview(passwordReTextFieldUnderline)
        view.addSubview(passwordCorrectLabel)
        
        view.addSubview(phoneCertLabel)
        view.addSubview(phoneCertTextField)
        view.addSubview(phoneCertTextFieldUnderline)
        view.addSubview(getCertNumberButton)
        view.addSubview(ifPhoneNumberIsEmptyLabel)
        
        certUIView.addSubview(certContentStackView)
        certContentStackView.addArrangedSubview(certNumberTextField)
        certContentStackView.addArrangedSubview(timerLabel)
        certContentStackView.addArrangedSubview(certNumberDeleteButton)
        certContentStackView.addArrangedSubview(checkCertNumberButton)
        view.addSubview(certUIView)
        view.addSubview(certNumberAvailableLabel)
        
        view.addSubview(signUpButton)
    }
    
    private func setUpConstraint() {
        idLabel.snp.makeConstraints({
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(paddingBetweenComponents)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
        })
        idTextField.snp.makeConstraints({
            $0.top.equalTo(idLabel.snp.bottom).offset(5)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
            $0.right.equalTo(idCheckButton.snp.left).offset(-10)
        })
        idCheckButton.snp.makeConstraints({
            $0.centerY.equalTo(idTextField.snp.centerY).offset(-5)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-sidePaddingValue)
            $0.width.equalTo(100)
            $0.height.equalTo(buttonHeightValue)
        })
        idTextFieldUnderline.snp.makeConstraints({
            $0.top.equalTo(idTextField.snp.bottom).offset(5)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
            $0.width.equalTo(idTextField.snp.width)
        })
        idCheckLabel.snp.makeConstraints({
            $0.top.equalTo(idTextFieldUnderline.snp.bottom).offset(1)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
        })
        nameLabel.snp.makeConstraints({
            $0.top.equalTo(idTextField.snp.bottom).offset(paddingBetweenComponents)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
        })
        nameTextField.snp.makeConstraints({
            $0.top.equalTo(nameLabel.snp.bottom).offset(5)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-sidePaddingValue)
        })
        nameTextFieldUnderline.snp.makeConstraints({
            $0.top.equalTo(nameTextField.snp.bottom).offset(5)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-sidePaddingValue)
        })
        passwordLabel.snp.makeConstraints({
            $0.top.equalTo(nameTextFieldUnderline.snp.bottom).offset(paddingBetweenComponents)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
        })
        passwordTextField.snp.makeConstraints({
            $0.top.equalTo(passwordLabel.snp.bottom).offset(5)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-sidePaddingValue)
        })
        passwordToggleButton.snp.makeConstraints({
            $0.centerY.equalTo(passwordTextField.snp.centerY)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-sidePaddingValue)
            $0.width.height.equalTo(20)
        })
        passwordTextFieldUnderline.snp.makeConstraints({
            $0.top.equalTo(passwordTextField.snp.bottom).offset(5)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-sidePaddingValue)
        })
        passwordCheckLabel.snp.makeConstraints({
            $0.top.equalTo(passwordTextFieldUnderline.snp.bottom).offset(1)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
        })
        passwordReLabel.snp.makeConstraints({
            $0.top.equalTo(passwordTextFieldUnderline.snp.bottom).offset(paddingBetweenComponents)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
        })
        passwordReTextField.snp.makeConstraints({
            $0.top.equalTo(passwordReLabel.snp.bottom).offset(5)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-sidePaddingValue)
        })
        passwordReToggleButton.snp.makeConstraints({
            $0.centerY.equalTo(passwordReTextField.snp.centerY)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-sidePaddingValue)
            $0.width.height.equalTo(20)
        })
        passwordReTextFieldUnderline.snp.makeConstraints({
            $0.top.equalTo(passwordReTextField.snp.bottom).offset(5)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-sidePaddingValue)
        })
        passwordCorrectLabel.snp.makeConstraints({
            $0.top.equalTo(passwordReTextFieldUnderline.snp.bottom).offset(1)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
        })
        phoneCertLabel.snp.makeConstraints({
            $0.top.equalTo(passwordReTextFieldUnderline.snp.bottom).offset(paddingBetweenComponents)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
        })
        phoneCertTextField.snp.makeConstraints({
            $0.top.equalTo(phoneCertLabel.snp.bottom).offset(5)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
            $0.right.equalTo(getCertNumberButton.snp.left).offset(-10)
        })
        phoneCertTextFieldUnderline.snp.makeConstraints({
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
            $0.top.equalTo(phoneCertTextFieldUnderline.snp.bottom).offset(1)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
        })
        certUIView.snp.makeConstraints({
            $0.top.equalTo(phoneCertTextFieldUnderline.snp.bottom).offset(paddingBetweenComponents)
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
        signUpButton.snp.makeConstraints({
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-sidePaddingValue)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
            $0.height.equalTo(50)
        })
    }
}

