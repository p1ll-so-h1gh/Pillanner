//
//  JoinUsViewController.swift
//  Pillanner
//
//  Created by 영현 on 2/22/24.
//

import UIKit
import SnapKit

class JoinUsViewController: UIViewController, UITextFieldDelegate {
    var myVerificationID: String = ""
    var myIDToken: String = ""
    var limitTime: Int = 180 // 3분
    var availableGetCertNumberFlag: Bool = true // 인증번호 받고 나서 3분 동안만 false. false 상태에선 인증번호를 받을 수 없다.
    var availableSignUpFlag: Bool = false // 회원가입 가능 여부를 판별하는 변수. true : 가입 가능, false : 가입 불가능
    
    private let sidePaddingValue = 20
    private let topPaddingValue = 30
    
    let IDLabel: UILabel = {
        let label = UILabel()
        label.text = "아이디"
        label.font = FontLiteral.body(style: .bold)
        return label
    }()
    
    let IDTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "5-16 자리 영 대/소문자, 숫자 조합"
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
    
    let IDCheckButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("중복확인", for: .normal)
        button.setTitleColor(UIColor.lightGray, for: .normal)
        button.backgroundColor = .mainThemeColor
        button.layer.cornerRadius = 5
        button.addTarget(target, action: #selector(IDCheckButtonClicked), for: .touchUpInside)
        return button
    }()
    
    let IDCheckLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let NameLabel: UILabel = {
        let label = UILabel()
        label.text = "이름 입력"
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
    
    let PassWordLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호"
        label.font = FontLiteral.body(style: .bold)
        return label
    }()
    
    let PassWordTextField: UITextField = {
        let textfield = UITextField()
        textfield.isSecureTextEntry = true
        textfield.placeholder = "8-16 자리 영 대/소문자, 숫자, 특수문자 조합"
        textfield.font = FontLiteral.subheadline(style: .regular)
        return textfield
    }()
    
    let PassWordToggleButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "eyeOpen"), for: .normal)
        button.addTarget(target, action: #selector(PassWordToggleButtonClicked), for: .touchUpInside)
        return button
    }()
    
    let PassWordTextFieldUnderLine: UIProgressView = {
        let line = UIProgressView(progressViewStyle: .bar)
        line.trackTintColor = .lightGray
        line.progressTintColor = .systemBlue
        line.transform = CGAffineTransform(scaleX: 1.0, y: 0.5)
        return line
    }()
    
    let PassWordCheckLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let PassWordReLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호 재입력"
        label.font = FontLiteral.body(style: .bold)
        return label
    }()
    
    let PassWordReTextField: UITextField = {
        let textfield = UITextField()
        textfield.isSecureTextEntry = true
        textfield.placeholder = "8-16 자리 영 대/소문자, 숫자, 특수문자 조합"
        textfield.font = FontLiteral.subheadline(style: .regular)
        return textfield
    }()
    
    let PassWordReToggleButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "eyeOpen"), for: .normal)
        button.addTarget(target, action: #selector(PassWordReToggleButtonClicked), for: .touchUpInside)
        return button
    }()
    
    let PassWordReTextFieldUnderLine: UIProgressView = {
        let line = UIProgressView(progressViewStyle: .bar)
        line.trackTintColor = .lightGray
        line.progressTintColor = .systemBlue
        line.transform = CGAffineTransform(scaleX: 1.0, y: 0.5)
        return line
    }()
    
    let PassWordCorrectLabel: UILabel = {
        let label = UILabel()
        return label
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
        label.numberOfLines = 2
        return label
    }()
    
    let NextPageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("다음", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = .mainThemeColor
        button.layer.cornerRadius = 5
        button.addTarget(target, action: #selector(NextPageButtonClicked), for: .touchUpInside)
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
        view.addSubview(IDCheckButton)
        view.addSubview(IDTextFieldUnderLine)
        view.addSubview(IDCheckLabel)
        
        view.addSubview(NameLabel)
        view.addSubview(NameTextField)
        view.addSubview(NameTextFieldUnderLine)
        
        view.addSubview(PassWordLabel)
        view.addSubview(PassWordTextField)
        view.addSubview(PassWordToggleButton)
        view.addSubview(PassWordTextFieldUnderLine)
        view.addSubview(PassWordCheckLabel)
        
        view.addSubview(PassWordReLabel)
        view.addSubview(PassWordReTextField)
        view.addSubview(PassWordReToggleButton)
        view.addSubview(PassWordReTextFieldUnderLine)
        view.addSubview(PassWordCorrectLabel)
        
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
        
        view.addSubview(NextPageButton)
    }
    
    private func setUpConstraint() {
        IDLabel.snp.makeConstraints({
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(topPaddingValue)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
        })
        IDTextField.snp.makeConstraints({
            $0.top.equalTo(IDLabel.snp.bottom).offset(5)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-sidePaddingValue)
        })
        IDCheckButton.snp.makeConstraints({
            $0.centerY.equalTo(IDTextField.snp.centerY)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-sidePaddingValue)
            $0.width.equalTo(100)
        })
        IDTextFieldUnderLine.snp.makeConstraints({
            $0.top.equalTo(IDTextField.snp.bottom).offset(5)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
            $0.width.equalTo(IDTextField.snp.width)
        })
        IDCheckLabel.snp.makeConstraints({
            $0.top.equalTo(IDTextFieldUnderLine.snp.bottom).offset(1)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
        })
        NameLabel.snp.makeConstraints({
            $0.top.equalTo(IDTextField.snp.bottom).offset(topPaddingValue)
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
            $0.width.equalTo(IDTextField.snp.width)
        })
        PassWordLabel.snp.makeConstraints({
            $0.top.equalTo(NameTextFieldUnderLine.snp.bottom).offset(topPaddingValue)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
        })
        PassWordTextField.snp.makeConstraints({
            $0.top.equalTo(PassWordLabel.snp.bottom).offset(5)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-sidePaddingValue)
        })
        PassWordToggleButton.snp.makeConstraints({
            $0.centerY.equalTo(PassWordTextField.snp.centerY)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-sidePaddingValue)
            $0.width.equalTo(20)
            $0.height.equalTo(20)
        })
        PassWordTextFieldUnderLine.snp.makeConstraints({
            $0.top.equalTo(PassWordTextField.snp.bottom).offset(5)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
            $0.width.equalTo(IDTextField.snp.width)
        })
        PassWordCheckLabel.snp.makeConstraints({
            $0.top.equalTo(PassWordTextFieldUnderLine.snp.bottom).offset(1)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
        })
        PassWordReLabel.snp.makeConstraints({
            $0.top.equalTo(PassWordTextFieldUnderLine.snp.bottom).offset(topPaddingValue)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
        })
        PassWordReTextField.snp.makeConstraints({
            $0.top.equalTo(PassWordReLabel.snp.bottom).offset(5)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-sidePaddingValue)
        })
        PassWordReToggleButton.snp.makeConstraints({
            $0.centerY.equalTo(PassWordReTextField.snp.centerY)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-sidePaddingValue)
            $0.width.equalTo(20)
            $0.height.equalTo(20)
        })
        PassWordReTextFieldUnderLine.snp.makeConstraints({
            $0.top.equalTo(PassWordReTextField.snp.bottom).offset(5)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
            $0.width.equalTo(IDTextField.snp.width)
        })
        PassWordCorrectLabel.snp.makeConstraints({
            $0.top.equalTo(PassWordReTextFieldUnderLine.snp.bottom).offset(1)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
        })
        PhoneCertLabel.snp.makeConstraints({
            $0.top.equalTo(PassWordReTextFieldUnderLine.snp.bottom).offset(topPaddingValue)
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
            $0.width.equalTo(IDTextField.snp.width)
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
            $0.width.equalTo(40)
            $0.height.equalTo(30)
        })
        CertNumberDeleteButton.snp.makeConstraints({
            $0.width.equalTo(30)
            $0.height.equalTo(30)
        })
        CheckCertNumberButton.snp.makeConstraints({
            $0.width.equalTo(50)
        })
        CertContentStackView.snp.makeConstraints({
            $0.top.equalToSuperview().offset(5)
            $0.left.equalToSuperview().offset(5)
            $0.right.equalToSuperview().offset(-5)
            $0.bottom.equalToSuperview().offset(-5)
        })
        CertNumberAvailableLabel.snp.makeConstraints({
            $0.top.equalTo(CertUIView.snp.bottom).offset(1)
            $0.left.equalTo(sidePaddingValue)
        })
        NextPageButton.snp.makeConstraints({
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-sidePaddingValue)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
            $0.height.equalTo(50)
        })
    }
}
