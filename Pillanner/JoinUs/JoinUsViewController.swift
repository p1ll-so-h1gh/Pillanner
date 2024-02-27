//
//  JoinUsViewController.swift
//  Pillanner
//
//  Created by 영현 on 2/22/24.
//

import UIKit
import SnapKit

class JoinUsViewController: UIViewController, UITextFieldDelegate {
    let IDList: [String] = ["ykyo"] // ID 중복확인 테스트용 리스트
    
    var myPhoneNumber: String = ""
    private let sidePaddingValue = 24
    private let topPaddingValue = 30
    
    private let IDLabel: UILabel = {
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
    
    private let IDTextFieldUnderLine: UIProgressView = {
        let line = UIProgressView(progressViewStyle: .bar)
        line.trackTintColor = .lightGray
        line.progressTintColor = .systemBlue
        line.transform = CGAffineTransform(scaleX: 1.0, y: 0.5)
        return line
    }()
    
    private let IDCheckButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("중복확인", for: .normal)
        button.setTitleColor(UIColor.lightGray, for: .normal)
        button.backgroundColor = .mainThemeColor
        button.layer.cornerRadius = 5
        button.addTarget(target, action: #selector(IDCheckButtonClicked), for: .touchUpInside)
        return button
    }()
    
    var IDCheckLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let NameLabel: UILabel = {
        let label = UILabel()
        label.text = "이름 입력"
        label.font = FontLiteral.body(style: .bold)
        return label
    }()
    
    private let NameTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "이름을 입력해주세요."
        textfield.font = FontLiteral.subheadline(style: .regular)
        return textfield
    }()
    
    private let NameTextFieldUnderLine: UIProgressView = {
        let line = UIProgressView(progressViewStyle: .bar)
        line.trackTintColor = .lightGray
        line.progressTintColor = .systemBlue
        line.transform = CGAffineTransform(scaleX: 1.0, y: 0.5)
        return line
    }()
    
    private let PassWordLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호"
        label.font = FontLiteral.body(style: .bold)
        return label
    }()
    
    private let PassWordTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "8-30 자리 영 대/소문자, 숫자, 특수문자 조합"
        textfield.font = FontLiteral.subheadline(style: .regular)
        return textfield
    }()
    
    private let PassWordTextFieldUnderLine: UIProgressView = {
        let line = UIProgressView(progressViewStyle: .bar)
        line.trackTintColor = .lightGray
        line.progressTintColor = .systemBlue
        line.transform = CGAffineTransform(scaleX: 1.0, y: 0.5)
        return line
    }()
    
    private let PassWordReLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호 재입력"
        label.font = FontLiteral.body(style: .bold)
        return label
    }()
    
    private let PassWordReTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "8-30 자리 영 대/소문자, 숫자, 특수문자 조합"
        textfield.font = FontLiteral.subheadline(style: .regular)
        return textfield
    }()
    
    private let PassWordReTextFieldUnderLine: UIProgressView = {
        let line = UIProgressView(progressViewStyle: .bar)
        line.trackTintColor = .lightGray
        line.progressTintColor = .systemBlue
        line.transform = CGAffineTransform(scaleX: 1.0, y: 0.5)
        return line
    }()
    
    private let PhoneCertLabel: UILabel = {
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
    
    private let PhoneCertTextFieldUnderLine: UIProgressView = {
        let line = UIProgressView(progressViewStyle: .bar)
        line.trackTintColor = .lightGray
        line.progressTintColor = .systemBlue
        line.transform = CGAffineTransform(scaleX: 1.0, y: 0.5)
        return line
    }()
    
    private let GetCertNumberButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("인증번호 받기", for: .normal) // 재전송
        button.setTitleColor(UIColor.lightGray, for: .normal)
        button.backgroundColor = .mainThemeColor
        button.layer.cornerRadius = 5
        button.addTarget(target, action: #selector(GetCertNumberButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private let CertUIView: UIView = {
        let uiView = UIView()
        uiView.layer.cornerRadius = 5
        uiView.layer.borderColor = UIColor.lightGray.cgColor
        uiView.layer.borderWidth = 1
        return uiView
    }()

    private let CertContentStackView: UIStackView = {
        let stackView = UIStackView()
        return stackView
    }()
    
    private let CertNumberTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "인증번호 6자리 입력"
        textfield.font = FontLiteral.subheadline(style: .regular)
        return textfield
    }()
    
    private let CertNumberDeleteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "xmark"), for: .normal)
        return button
    }()
    
    private let ReGetCertNumberButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("확인", for: .normal)
        button.setTitleColor(UIColor.lightGray, for: .normal)
        button.backgroundColor = .mainThemeColor
        button.layer.cornerRadius = 5
        return button
    }()
    
    private let NextPageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("다음", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = .mainThemeColor
        button.layer.cornerRadius = 5
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setUpTextFieldDelegate()
        addView()
        setUpConstraint()
    }
    
    private func setUpTextFieldDelegate() {
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
        view.addSubview(PassWordTextFieldUnderLine)
        view.addSubview(PassWordReLabel)
        view.addSubview(PassWordReTextField)
        view.addSubview(PassWordReTextFieldUnderLine)
        view.addSubview(PhoneCertLabel)
        view.addSubview(PhoneCertTextField)
        view.addSubview(PhoneCertTextFieldUnderLine)
        view.addSubview(GetCertNumberButton)
        CertUIView.addSubview(CertContentStackView)
        CertContentStackView.addArrangedSubview(CertNumberTextField)
        CertContentStackView.addArrangedSubview(CertNumberDeleteButton)
        CertContentStackView.addArrangedSubview(ReGetCertNumberButton)
        view.addSubview(CertUIView)
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
        PassWordTextFieldUnderLine.snp.makeConstraints({
            $0.top.equalTo(PassWordTextField.snp.bottom).offset(5)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
            $0.width.equalTo(IDTextField.snp.width)
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
        PassWordReTextFieldUnderLine.snp.makeConstraints({
            $0.top.equalTo(PassWordReTextField.snp.bottom).offset(5)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
            $0.width.equalTo(IDTextField.snp.width)
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
        CertNumberDeleteButton.snp.makeConstraints({
            $0.width.equalTo(30)
            $0.height.equalTo(30)
        })
        ReGetCertNumberButton.snp.makeConstraints({
            $0.width.equalTo(50)
        })
        CertContentStackView.snp.makeConstraints({
            $0.top.equalToSuperview().offset(5)
            $0.left.equalToSuperview().offset(5)
            $0.right.equalToSuperview().offset(-5)
            $0.bottom.equalToSuperview().offset(-5)
        })
        NextPageButton.snp.makeConstraints({
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-sidePaddingValue)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
            $0.height.equalTo(50)
        })
    }
}
