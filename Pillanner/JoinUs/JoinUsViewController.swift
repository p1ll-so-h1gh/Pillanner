//
//  JoinUsViewController.swift
//  Pillanner
//
//  Created by 영현 on 2/22/24.
//

import UIKit
import SnapKit

class JoinUsViewController: UIViewController {
    
    private let IDLabel: UILabel = {
        let label = UILabel()
        label.text = "아이디"
        label.font = FontLiteral.body(style: .regular)
        return label
    }()
    
    private let IDTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "아이디를 입력해주세요."
        return textfield
    }()
    
    private let IDTextFieldUnderLine: UIProgressView = {
        let line = UIProgressView(progressViewStyle: .bar)
        line.trackTintColor = .lightGray
        line.progressTintColor = .green
        line.transform = CGAffineTransform(scaleX: 1.0, y: 0.5)
        return line
    }()
    
    private let IDCheckButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("중복확인", for: .normal)
        button.setTitleColor(UIColor.lightGray, for: .normal)
        button.backgroundColor = .mainThemeColor
        button.layer.cornerRadius = 5
        return button
    }()
    
    private let NameLabel: UILabel = {
        let label = UILabel()
        label.text = "이름 입력"
        label.font = FontLiteral.body(style: .regular)
        return label
    }()
    
    private let NameTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "이름을 입력해주세요."
        return textfield
    }()
    
    private let NameTextFieldUnderLine: UIProgressView = {
        let line = UIProgressView(progressViewStyle: .bar)
        line.trackTintColor = .lightGray
        line.progressTintColor = .green
        line.transform = CGAffineTransform(scaleX: 1.0, y: 0.5)
        return line
    }()
    
    private let PassWordLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호"
        label.font = FontLiteral.body(style: .regular)
        return label
    }()
    
    private let PassWordTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "8-30 자리 영 대/소문자, 숫자, 특수문자 조합"
        return textfield
    }()
    
    private let PassWordTextFieldUnderLine: UIProgressView = {
        let line = UIProgressView(progressViewStyle: .bar)
        line.trackTintColor = .lightGray
        line.progressTintColor = .green
        line.transform = CGAffineTransform(scaleX: 1.0, y: 0.5)
        return line
    }()
    
    private let PassWordReLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호 재입력"
        label.font = FontLiteral.body(style: .regular)
        return label
    }()
    
    private let PassWordReTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "8-30 자리 영 대/소문자, 숫자, 특수문자 조합"
        return textfield
    }()
    
    private let PassWordReTextFieldUnderLine: UIProgressView = {
        let line = UIProgressView(progressViewStyle: .bar)
        line.trackTintColor = .lightGray
        line.progressTintColor = .green
        line.transform = CGAffineTransform(scaleX: 1.0, y: 0.5)
        return line
    }()
    
    private let PhoneCertLabel: UILabel = {
        let label = UILabel()
        label.text = "휴대전화 번호인증"
        label.font = FontLiteral.body(style: .regular)
        return label
    }()
    
    
    private let CertNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "인증번호"
        label.font = FontLiteral.body(style: .regular)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        addView()
        setUpConstraint()
    }
    
    private func addView() {
        view.addSubview(IDLabel)
        view.addSubview(IDTextField)
        view.addSubview(IDCheckButton)
        view.addSubview(IDTextFieldUnderLine)
        view.addSubview(NameLabel)
        view.addSubview(NameTextField)
        view.addSubview(NameTextFieldUnderLine)
        view.addSubview(PassWordLabel)
        view.addSubview(PassWordTextField)
        view.addSubview(PassWordTextFieldUnderLine)
        view.addSubview(PassWordReLabel)
        view.addSubview(PassWordReTextField)
        view.addSubview(PassWordReTextFieldUnderLine)
        view.addSubview(PhoneCertLabel)
        view.addSubview(CertNumberLabel)
    }
    
    private func setUpConstraint() {
        IDLabel.snp.makeConstraints({
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(24)
        })
        IDTextField.snp.makeConstraints({
            $0.top.equalTo(IDLabel.snp.bottom).offset(5)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(24)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-24)
        })
        IDCheckButton.snp.makeConstraints({
            $0.centerY.equalTo(IDTextField.snp.centerY)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-24)
            $0.width.equalTo(100)
        })
        IDTextFieldUnderLine.snp.makeConstraints({
            $0.top.equalTo(IDTextField.snp.bottom).offset(5)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(24)
            $0.width.equalTo(IDTextField.snp.width)
        })
        NameLabel.snp.makeConstraints({
            $0.top.equalTo(IDTextField.snp.bottom).offset(100)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(24)
        })
        NameTextField.snp.makeConstraints({
            $0.top.equalTo(NameLabel.snp.bottom).offset(5)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(24)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-24)
        })
        NameTextFieldUnderLine.snp.makeConstraints({
            $0.top.equalTo(NameTextField.snp.bottom).offset(5)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(24)
            $0.width.equalTo(IDTextField.snp.width)
        })
        PassWordLabel.snp.makeConstraints({
            $0.top.equalTo(NameTextFieldUnderLine.snp.bottom).offset(20)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(24)
        })
        PassWordTextField.snp.makeConstraints({
            $0.top.equalTo(PassWordLabel.snp.bottom).offset(5)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(24)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-24)
        })
        PassWordTextFieldUnderLine.snp.makeConstraints({
            $0.top.equalTo(PassWordTextField.snp.bottom).offset(5)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(24)
            $0.width.equalTo(IDTextField.snp.width)
        })
        PassWordReLabel.snp.makeConstraints({
            $0.top.equalTo(PassWordTextFieldUnderLine.snp.bottom).offset(20)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(24)
        })
        PassWordReTextField.snp.makeConstraints({
            $0.top.equalTo(PassWordReLabel.snp.bottom).offset(5)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(24)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-24)
        })
        PassWordReTextFieldUnderLine.snp.makeConstraints({
            $0.top.equalTo(PassWordReTextField.snp.bottom).offset(5)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(24)
            $0.width.equalTo(IDTextField.snp.width)
        })
        PhoneCertLabel.snp.makeConstraints({
            $0.top.equalTo(PassWordReTextFieldUnderLine.snp.bottom).offset(20)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(24)
        })
        CertNumberLabel.snp.makeConstraints({
            $0.top.equalTo(PhoneCertLabel.snp.bottom).offset(20)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(24)
        })
    }
}

extension JoinUsViewController {

}
