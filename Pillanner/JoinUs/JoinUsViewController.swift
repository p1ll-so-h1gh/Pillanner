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
        return label
    }()
    
    private let IDTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "아이디를 입력해주세요."
        return textfield
    }()
    
    private let myUnderLine: UIProgressView = {
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
        return label
    }()
    
    private let PassWordLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호"
        return label
    }()
    
    private let PassWordReLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호 재입력"
        return label
    }()
    
    private let PhoneCertLabel: UILabel = {
        let label = UILabel()
        label.text = "휴대전화 번호인증"
        return label
    }()
    
    private let CertNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "인증번호"
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
        view.addSubview(myUnderLine)
        view.addSubview(NameLabel)
        view.addSubview(PassWordLabel)
        view.addSubview(PassWordReLabel)
        view.addSubview(PhoneCertLabel)
        view.addSubview(CertNumberLabel)
    }
    
    private func setUpConstraint() {
        IDLabel.snp.makeConstraints({
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(24)
        })
        IDTextField.snp.makeConstraints({
            $0.top.equalTo(IDLabel.snp.bottom).offset(20)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(24)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-24)
        })
        IDCheckButton.snp.makeConstraints({
            $0.centerY.equalTo(IDTextField.snp.centerY)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-24)
            $0.width.equalTo(100)
        })
        myUnderLine.snp.makeConstraints({
            $0.top.equalTo(IDTextField.snp.bottom).offset(5)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(24)
            $0.width.equalTo(IDTextField.snp.width)
        })
        NameLabel.snp.makeConstraints({
            $0.top.equalTo(IDTextField.snp.bottom).offset(100)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(24)
        })
        PassWordLabel.snp.makeConstraints({
            $0.top.equalTo(NameLabel.snp.bottom).offset(20)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(24)
        })
        PassWordReLabel.snp.makeConstraints({
            $0.top.equalTo(PassWordLabel.snp.bottom).offset(20)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(24)
        })
        PhoneCertLabel.snp.makeConstraints({
            $0.top.equalTo(PassWordReLabel.snp.bottom).offset(20)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(24)
        })
        CertNumberLabel.snp.makeConstraints({
            $0.top.equalTo(PhoneCertLabel.snp.bottom).offset(20)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(24)
        })
    }
}
