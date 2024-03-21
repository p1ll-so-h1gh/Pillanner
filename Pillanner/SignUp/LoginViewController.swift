//
// LaunchScreenViewController.swift
// Pillanner
//
// Created by 영현 on 2/22/24.
//

import UIKit

import FirebaseAuth
import SnapKit
import AuthenticationServices
import CryptoKit

class LoginViewController: UIViewController, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    var currentNonce: String?
    private let sidePaddingValue = 20
    private let paddingBetweenComponents = 30

    lazy var gradientLayer = CAGradientLayer.dayBackgroundLayer(view: view)
    
    private let pillannerFlagImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "PillannerFlagImage"))
        return image
    }()
    
    private let idTextfield: UITextField = {
        let field = UITextField()
        field.placeholder = "아이디 입력"
        field.textAlignment = .left
        field.autocapitalizationType = .none
        return field
    }()
    
    private let pwdTextfield: UITextField = {
        let field = UITextField()
        field.placeholder = "비밀번호 입력"
        field.isSecureTextEntry = true
        field.textAlignment = .left
        return field
    }()
    
    private let autoLoginButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "checkButtonImage"), for: .normal)
        button.setImage(UIImage(named: "checkButtonSelectedImage"), for: .selected)
        button.addTarget(target, action: #selector(autoLoginButtonTapped), for: .touchUpInside)
        return button
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
        button.backgroundColor = UIColor.pointThemeColor2
        button.layer.cornerRadius = 8
        button.addTarget(target, action: #selector(logInButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let socialLoginLabel: UILabel = {
        let label = UILabel()
        label.text = "SNS 계정으로 로그인 하기"
        label.font = FontLiteral.body(style: .regular)
        label.textColor = .lightGray
        return label
    }()
    
    private let kakaoLoginButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "KakaoLoginImage"), for: .normal)
        button.addTarget(target, action: #selector(kakaoLoginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let appleLoginButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "AppleLoginImage"), for: .normal)
        button.addTarget(target, action: #selector(appleLoginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let naverLoginButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "NaverLoginImage"), for: .normal)
        button.addTarget(target, action: #selector(naverLoginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let signInLabel: UILabel = {
        let label = UILabel()
        label.text = "계정이 없으신가요?"
        label.font = FontLiteral.body(style: .regular)
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var signInButton: UIButton = {
        let attributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .underlineColor: UIColor.lightGray
        ]
        let attributedTitle = NSAttributedString(string: "회원가입 하기", attributes: attributes)
        let button = UIButton(type: .system)
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let signInStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 20.0
        return stack
    }()
    
    private lazy var findIDButton: UIButton = {
        let attributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .underlineColor: UIColor.lightGray
        ]
        let attributedTitle = NSAttributedString(string: "ID 찾기", attributes: attributes)
        let button = UIButton(type: .system)
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(findIDButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var findPasswordButton: UIButton = {
        let attributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .underlineColor: UIColor.lightGray
        ]
        let attributedTitle = NSAttributedString(string: "PW 찾기", attributes: attributes)
        let button = UIButton(type: .system)
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(findPasswordButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let findStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 20.0
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // 자동 로그인 기능 활성화 되어있을 때, 로그인화면 거치지 않고 바로 메인화면으로 이동할 수 있도록 하는 기능
//        if let id = UserDefaults.standard.string(forKey: "ID"), let password = UserDefaults.standard.string(forKey: "Password") {
//            
//        }
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
    
    
    //MARK: - Annoying Keyboard Good Bye
    // 키보드 외부 터치할 경우 키보드 숨김처리
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // 키보드 리턴 버튼 누를경우 키보드 숨김처리
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      textField.resignFirstResponder()
      return true
    }

    
    //MARK: - UI Settings
    private func addViews() {
        self.view.addSubview(pillannerFlagImage)
        self.view.addSubview(idTextfield)
        self.view.addSubview(pwdTextfield)
        self.view.addSubview(autoLoginButton)
        self.view.addSubview(autoLoginLabel)
        self.view.addSubview(loginButton)
        self.view.addSubview(appleLoginButton)
        self.view.addSubview(kakaoLoginButton)
        self.view.addSubview(naverLoginButton)
        self.view.addSubview(socialLoginLabel)
        self.view.addSubview(signInStack)
        [signInLabel, signInButton].forEach({ signInStack.addArrangedSubview($0) })
        self.view.addSubview(findStack)
        [findIDButton, findPasswordButton].forEach({ findStack.addArrangedSubview($0) })
    }
    
    private func setUpSize() {
        pillannerFlagImage.frame.size.width = self.view.frame.width * 0.4
        pillannerFlagImage.frame.size.height = self.view.frame.height * 0.1
        idTextfield.frame.size.width = self.view.frame.width * 0.9
        idTextfield.frame.size.height = self.view.frame.height * 0.03
        idTextfield.layer.addBorder([.bottom], color: UIColor.lightGray, width: 1.0)
        pwdTextfield.frame.size.width = self.view.frame.width * 0.9
        pwdTextfield.frame.size.height = self.view.frame.height * 0.03
        pwdTextfield.layer.addBorder([.bottom], color: UIColor.lightGray, width: 1.0)
        loginButton.frame.size.width = self.view.frame.width * 0.8
        loginButton.frame.size.height = self.view.frame.height * 0.15
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
            $0.centerX.equalTo(self.view.snp.centerX)
        }
        pwdTextfield.snp.makeConstraints{
            $0.top.equalTo(idTextfield.snp.bottom).offset(paddingBetweenComponents)
            $0.leading.equalToSuperview().offset(sidePaddingValue)
            $0.trailing.equalToSuperview().offset(-sidePaddingValue)
            $0.centerX.equalTo(self.view.snp.centerX)
        }
        autoLoginButton.snp.makeConstraints{
            $0.width.height.equalTo(25)
            $0.top.equalTo(pwdTextfield.snp.bottom).offset(paddingBetweenComponents)
            $0.leading.equalToSuperview().offset(sidePaddingValue)
        }
        autoLoginLabel.snp.makeConstraints{
            $0.centerY.equalTo(autoLoginButton.snp.centerY)
            $0.leading.equalTo(autoLoginButton.snp.trailing).offset(paddingBetweenComponents)
            $0.leading.equalTo(autoLoginButton.snp.trailing).offset(10)
        }
        loginButton.snp.makeConstraints{
            $0.top.equalTo(autoLoginLabel.snp.bottom).offset(paddingBetweenComponents)
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().offset(sidePaddingValue)
            $0.trailing.equalToSuperview().offset(-sidePaddingValue)
            $0.height.equalTo(50)
        }
        socialLoginLabel.snp.makeConstraints{
            $0.top.equalTo(loginButton.snp.bottom).offset(paddingBetweenComponents)
            $0.centerX.equalToSuperview()
        }
        appleLoginButton.snp.makeConstraints{
            $0.width.height.equalTo(30)
            $0.top.equalTo(socialLoginLabel.snp.bottom).offset(1.5 * Double(paddingBetweenComponents))
            $0.trailing.equalTo(kakaoLoginButton.snp.leading).offset(-50)
        }
        kakaoLoginButton.snp.makeConstraints{
            $0.width.height.equalTo(30)
            $0.top.equalTo(socialLoginLabel.snp.bottom).offset(1.5 * Double(paddingBetweenComponents))
            $0.centerX.equalToSuperview()
        }
        naverLoginButton.snp.makeConstraints{
            $0.width.height.equalTo(30)
            $0.top.equalTo(socialLoginLabel.snp.bottom).offset(1.5 * Double(paddingBetweenComponents))
            $0.leading.equalTo(kakaoLoginButton.snp.trailing).offset(50)
        }
        signInStack.snp.makeConstraints{
            $0.top.equalTo(appleLoginButton.snp.bottom).offset(paddingBetweenComponents)
            $0.centerX.equalToSuperview()
        }
        findStack.snp.makeConstraints {
            $0.top.equalTo(signInStack.snp.bottom).offset(2.0 * Double(paddingBetweenComponents))
            $0.centerX.equalToSuperview()
        }
    }
    
    //MARK: - Button Actions
    // 로그인 버튼
    @objc func logInButtonTapped() {
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: UserDefaults.standard.string(forKey: "firebaseVerificationID") ?? "",
            verificationCode: UserDefaults.standard.string(forKey: "firebaseVerificationCode") ?? ""
        )
        if let id = idTextfield.text, let password = pwdTextfield.text {
            
            DataManager.shared.readUserData(userID: id) { userData in
                guard let userData = userData else { return }
                if id == userData["ID"]! && password == userData["Password"]! && userData["SignUpPath"]! == "일반회원가입" {
                    UserDefaults.standard.set(userData["UID"]!, forKey: "UID")
                    UserDefaults.standard.set(userData["ID"]!, forKey: "ID")
                    UserDefaults.standard.set(userData["Password"]!, forKey: "Password")
                    UserDefaults.standard.set(userData["Nickname"]!, forKey: "Nickname")
                    UserDefaults.standard.set(userData["SignUpPath"]!, forKey: "SignUpPath")
                    
                    Auth.auth().signIn(with: credential) { authData, error in
                        let currentUser = Auth.auth().currentUser
                        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                            if let error = error { return }
                        }
                    }
                    let mainVC = TabBarController()
                    mainVC.modalPresentationStyle = .fullScreen
                    self.present(mainVC, animated: true, completion: nil)
                } else {
                    let loginFailedAlert: UIAlertController = {
                        let alert = UIAlertController(title: "로그인에 실패하셨습니다.", message: "회원 정보를 다시 확인하시고 로그인을 시도해주세요.", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "확인", style: .destructive)
                        alert.addAction(okAction)
                        return alert
                    }()
                    self.present(loginFailedAlert, animated: true)
                }
            }
        }
    }
    
    // 회원가입하기 버튼
    @objc func signInButtonTapped() {
        let signUpVC = SignUpViewController()
        self.navigationController?.pushViewController(signUpVC, animated: true)

    }
    
    // 자동로그인
    @objc func autoLoginButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        if sender.isSelected {
            // 자동 로그인 유지할 수 있는 기능
            UserDefaults.standard.set(true, forKey: "isAutoLoginActivate")
            sender.setImage(UIImage(named: "checkButtonSelectedImage"), for: .normal)
        } else {
            // 자동 로그인 해제
            UserDefaults.standard.set(false, forKey: "isAutoLoginActivate")
            sender.setImage(UIImage(named: "checkButtonImage"), for: .selected)
        }
    }
    
    
    @objc func findIDButtonTapped() {
        self.navigationController?.pushViewController(FindIDViewController(), animated: true)
    }
    
    @objc func findPasswordButtonTapped() {
        self.navigationController?.pushViewController(FindPWViewController(), animated: true)
    }
}

