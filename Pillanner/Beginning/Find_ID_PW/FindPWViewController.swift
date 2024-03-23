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
    var limitTime: Int = 180 // 3분
    var availableGetCertNumberFlag: Bool = true // 인증번호 받고 나서 3분 동안만 false. false 상태에선 인증번호를 받을 수 없다.
    var availableFindPWFlag: Bool = false // 번호인증이 완료 될 경우 true 값으로 전환.
    
    private let sidePaddingValue = 20
    private let topPaddingValue = 40
    
    private lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "xmark")?.withRenderingMode(.alwaysOriginal).withTintColor(.black),
                                     style: .plain, target: self, action: #selector(dismissView))
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "PW 찾기"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.sizeToFit()
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
    
    let idLabel: UILabel = {
        let label = UILabel()
        label.text = "아이디"
        label.font = FontLiteral.body(style: .bold)
        return label
    }()
    
    let idTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "아이디 혹은 이메일을 입력해주세요."
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
        return label
    }()
    
    let findPWButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("비밀번호 찾기", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = .mainThemeColor
        button.layer.cornerRadius = 5
        button.addTarget(target, action: #selector(findPWButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setUpTextFieldDelegate()
        addView()
        setUpConstraint()
        
        navigationItem.leftBarButtonItem = backButton
        navigationItem.titleView = titleLabel
    }
    
    private func addView() {
        view.addSubview(idLabel)
        view.addSubview(idTextField)
        view.addSubview(idTextFieldUnderLine)
        
        view.addSubview(phoneCertLabel)
        view.addSubview(phoneCertTextField)
        view.addSubview(phoneCertTextFieldUnderLine)
        view.addSubview(getCertNumberButton)
        view.addSubview(ifPhoneNumberIsEmptyLabel)
        
        certUIView.addSubview(certContentStackView)
        certContentStackView.addArrangedSubview(certNumberTextField)
        certContentStackView.addArrangedSubview(timerLabel)
        certContentStackView.addArrangedSubview(certNumberDeleteButton)
        certContentStackView.addArrangedSubview(checkCertNumberButton)
        view.addSubview(certUIView)
        view.addSubview(certNumberAvailableLabel)
        
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(nameTextFieldUnderLine)
        
        view.addSubview(findPWButton)
    }
    
    private func setUpConstraint() {
        // 이름 입력부분
        nameLabel.snp.makeConstraints({
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(topPaddingValue)
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
        // 아이디 입력부분
        idLabel.snp.makeConstraints({
            $0.top.equalTo(nameTextField.snp.bottom).offset(topPaddingValue)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
        })
        idTextField.snp.makeConstraints({
            $0.top.equalTo(idLabel.snp.bottom).offset(5)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-sidePaddingValue)
        })
        idTextFieldUnderLine.snp.makeConstraints({
            $0.top.equalTo(idTextField.snp.bottom).offset(5)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
            $0.width.equalTo(idTextField.snp.width)
        })
        // 휴대전화번호 인증부분
        phoneCertLabel.snp.makeConstraints({
            $0.top.equalTo(idTextField.snp.bottom).offset(topPaddingValue)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
        })
        phoneCertTextField.snp.makeConstraints({
            $0.top.equalTo(phoneCertLabel.snp.bottom).offset(5)
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
        })
        ifPhoneNumberIsEmptyLabel.snp.makeConstraints({
            $0.top.equalTo(phoneCertTextFieldUnderLine.snp.bottom).offset(1)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
        })
        // 인증번호 입력부분
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
        })
        certContentStackView.snp.makeConstraints({
            $0.top.left.equalToSuperview().offset(5)
            $0.right.bottom.equalToSuperview().offset(-5)
        })
        certNumberAvailableLabel.snp.makeConstraints({
            $0.top.equalTo(certUIView.snp.bottom).offset(1)
            $0.left.equalTo(sidePaddingValue)
        })
        // 비밀번호 찾기 버튼
        findPWButton.snp.makeConstraints({
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-sidePaddingValue)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
            $0.height.equalTo(50)
        })
    }
}
