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
    
    fileprivate var currentNonce: String?
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
        return field
    }()
    
    private let pwdTextfield: UITextField = {
        let field = UITextField()
        field.placeholder = "비밀번호 입력"
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
        button.backgroundColor = UIColor.mainThemeColor
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
        return button
    }()
    
    private let appleLoginButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "AppleLoginImage"), for: .normal)
        return button
    }()
    
    private let naverLoginButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "NaverLoginImage"), for: .normal)
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
        let button = UIButton()
        button.setTitle("회원가입 하기", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.setTitleColor(.black, for: .selected)
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
        let button = UIButton()
        button.setTitle("ID 찾기", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.setTitleColor(.black, for: .selected)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(findIDButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var findPasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("PW 찾기", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.setTitleColor(.black, for: .selected)
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
    @objc func logInButtonTapped() {
        let id = idTextfield.text
        let password = pwdTextfield.text
        
        if UserDefaults.standard.bool(forKey: "isAutoLoginActivate") {
            UserDefaults.standard.setValue(id, forKey: "ID")
            UserDefaults.standard.setValue(password, forKey: "Password")
        }
        
        // 일단 메인 화면(탭바)로 넘어가는 기능 넣기
        let mainVC = TabBarController()
        mainVC.modalPresentationStyle = .fullScreen
        present(mainVC, animated: true, completion: nil)
        
    }
    
    @objc func signInButtonTapped() {
        print(#function)
        // ????
//        let signInVC = self.storyboard?.instantiateViewController(identifier: "SignUpViewController")
        let signUpVC = SignUpViewController()
        self.navigationController?.pushViewController(signUpVC, animated: true)
//        present(SignUpViewController(), animated: true)
    }
    
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
    
    @objc func appleLoginButtonTapped() {
        startSignInWithApple()
    }
    
    @objc func naverLoginButtonTapped() {
        
    }
    
    @objc func kakaoLoginButtonTapped() {
        
    }
    
    @objc func findIDButtonTapped() {
        self.navigationController?.pushViewController(FindIDViewController(), animated: true)
    }
    
    @objc func findPasswordButtonTapped() {
        self.navigationController?.pushViewController(FindPWViewController(), animated: true)
    }
    
    // Apple Login 관련
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    private func startSignInWithApple() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        // request 요청을 했을 때 none가 포함되어서 릴레이 공격을 방지
        // 추후 파베에서도 무결성 확인을 할 수 있게끔 함
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            // Initialize a Firebase credential, including the user's full name.
            let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                           rawNonce: nonce,
                                                           fullName: appleIDCredential.fullName)
            // Sign in with Firebase.
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    // Error. If error.code == .MissingOrInvalidNonce, make sure
                    // you're sending the SHA256-hashed nonce as a hex string with
                    // your request to Apple.
                    print(error.localizedDescription)
                    return
                }
                print("로그인에 성공했습니다.")
                // User is signed in to Firebase with Apple.
                // ...
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

