//
// LaunchScreenViewController.swift
// Pillanner
//
// Created by 영현 on 2/22/24.
//
import UIKit
import SnapKit

class LaunchScreenViewController: UIViewController {
    
    private let sidePaddingValue = 30
    private let paddingBetweenComponents = 30

    lazy var gradientLayer = CAGradientLayer.dayBackgroundLayer(view: view)

    private let pillannerFlagImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "PillannerFlag"))
        return image
    }()
    
    private let idTextfield: UITextField = {
        let field = UITextField()
        field.placeholder = "아이디 입력"
        field.textAlignment = .left
        return field
    }()
    
    private let pwdTextfield: UITextField = {
        let field = UITextField()
        field.placeholder = "비밀번호 입력"
        field.textAlignment = .left
        return field
    }()
    
    private let autoLoginImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "CheckImage"))
        image.layer.frame.size = CGSize(width: 20.0, height: 20.0)
        return image
    }()
    
    private let autoLoginLabel: UILabel = {
        let label = UILabel()
        label.text = "자동 로그인"
        label.textColor = .lightGray
        label.textAlignment = .left
        return label
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.titleLabel?.font = FontLiteral.body(style: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.mainThemeColor
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let noAccountLabel: UILabel = {
        let label = UILabel()
        label.text = "SNS 계정으로 로그인 하기"
        label.font = FontLiteral.body(style: .regular)
        label.textColor = .lightGray
        return label
    }()
    
    private let kakaoLoginImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "KakaoLoginImage"))
        return image
    }()
    
    private let signInLabel: UILabel = {
        let label = UILabel()
        label.text = "계정이 없으신가요?"
        label.font = FontLiteral.body(style: .regular)
        label.textColor = .lightGray
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("did load Frame:", view.bounds)
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.layer.addSublayer(gradientLayer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpSize()
        
        addViews()
        
        setConstraints()
    }
    
    //MARK: - UI Settings
    private func addViews() {
        self.view.addSubview(pillannerFlagImage)
        self.view.addSubview(idTextfield)
        self.view.addSubview(pwdTextfield)
//        self.view.addSubview(autoLoginImage)
        self.view.addSubview(autoLoginLabel)
        self.view.addSubview(loginButton)
        self.view.addSubview(noAccountLabel)
        self.view.addSubview(kakaoLoginImage)
    }
    
    private func setUpSize() {
        pillannerFlagImage.frame.size.width = self.view.frame.width * 0.4
        pillannerFlagImage.frame.size.height = self.view.frame.height * 0.1
        idTextfield.frame.size.width = self.view.frame.width * 0.8
        idTextfield.frame.size.height = self.view.frame.height * 0.03
        idTextfield.layer.addBorder([.bottom], color: UIColor.lightGray, width: 1.0)
        pwdTextfield.frame.size.width = self.view.frame.width * 0.8
        pwdTextfield.frame.size.height = self.view.frame.height * 0.03
        pwdTextfield.layer.addBorder([.bottom], color: UIColor.lightGray, width: 1.0)
//        autoLoginImage.frame.size.width = self.view.frame.height * 0.03
//        autoLoginImage.frame.size.height = self.view.frame.height * 0.03
        loginButton.frame.size.width = self.view.frame.width * 0.8
        loginButton.frame.size.height = self.view.frame.height * 0.08
    }
    
    private func setConstraints() {
        pillannerFlagImage.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(150)
        }
        idTextfield.snp.makeConstraints{
            $0.top.equalTo(pillannerFlagImage.snp.bottom).offset(paddingBetweenComponents)
            $0.leading.equalToSuperview().offset(sidePaddingValue)
            $0.trailing.equalToSuperview().offset(-sidePaddingValue)
            $0.centerX.equalToSuperview()
        }
        pwdTextfield.snp.makeConstraints{
            $0.top.equalTo(idTextfield.snp.bottom).offset(paddingBetweenComponents)
            $0.leading.equalToSuperview().offset(sidePaddingValue)
            $0.trailing.equalToSuperview().offset(-sidePaddingValue)
            $0.centerX.equalToSuperview()
        }
//        autoLoginImage.snp.makeConstraints{
//            $0.top.equalTo(pwdTextfield.snp.bottom).offset(paddingBetweenComponents)
//            $0.leading.equalToSuperview().offset(sidePaddingValue)
//        }
        autoLoginLabel.snp.makeConstraints{
            $0.top.equalTo(pwdTextfield.snp.bottom).offset(paddingBetweenComponents)
//            $0.leading.equalTo(autoLoginImage.snp.trailing).offset(paddingBetweenComponents)
//            $0.trailing.equalToSuperview().offset(sidePaddingValue)
            $0.leading.equalToSuperview().offset(sidePaddingValue)
        }
        loginButton.snp.makeConstraints{
            $0.top.equalTo(autoLoginLabel.snp.bottom).offset(paddingBetweenComponents)
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().offset(sidePaddingValue)
            $0.trailing.equalToSuperview().offset(-sidePaddingValue)
        }
        noAccountLabel.snp.makeConstraints{
            $0.top.equalTo(loginButton.snp.bottom).offset(paddingBetweenComponents)
            $0.centerX.equalToSuperview()
        }
        kakaoLoginImage.snp.makeConstraints{
            $0.top.equalTo(noAccountLabel.snp.bottom).offset(1.5 * Double(paddingBetweenComponents))
            $0.centerX.equalToSuperview()
        }
    }
}
