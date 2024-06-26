//
//  SNSLoginViewController.swift
//  Pillanner
//
//  Created by 윤규호 on 3/12/24.
//

import UIKit
import SnapKit
import FirebaseAuth


class SNSLoginViewController: UIViewController, UITextFieldDelegate {
    
    lazy var gradientLayer = CAGradientLayer.dayBackgroundLayer(view: view)
    
    private let sidePaddingValue = 20
    private let paddingBetweenComponents = 30
    private let buttonHeight = 50
    
    //MARK: - UI Property 선언부
    private let pillannerFlagImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "PillannerFlagImage"))
        return image
    }()
    
    private let setNameLabel : UILabel = {
        let label = UILabel()
        label.text = "Pillanner 에서 사용할 닉네임(이름)을 설정해주세요!"
        label.font = FontLiteral.subheadline(style: .bold)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    private let setNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "닉네임 입력"
        textField.textAlignment = .center
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let setNameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("확인", for: .normal)
        button.titleLabel?.font = FontLiteral.body(style: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.pointThemeColor2
        button.layer.cornerRadius = 8
        button.addTarget(target, action: #selector(setNameButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setNameTextField.delegate = self
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
        self.view.addSubview(setNameLabel)
        self.view.addSubview(setNameTextField)
        self.view.addSubview(setNameButton)
    }
    
    private func setUpSize() {
        pillannerFlagImage.frame.size.width = self.view.frame.width * 0.4
        pillannerFlagImage.frame.size.height = self.view.frame.height * 0.1
    }
    
    private func setConstraints() {
        pillannerFlagImage.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(self.view.frame.height * 0.33)
        }
        setNameLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(pillannerFlagImage.snp.bottom).offset(paddingBetweenComponents)
        }
        setNameTextField.snp.makeConstraints{
            $0.left.equalToSuperview().offset(sidePaddingValue)
            $0.right.equalToSuperview().offset(-sidePaddingValue)
            $0.centerX.centerY.equalToSuperview()
        }
        setNameButton.snp.makeConstraints({
            $0.left.equalToSuperview().offset(sidePaddingValue)
            $0.right.equalToSuperview().offset(-sidePaddingValue)
            $0.bottom.equalToSuperview().offset(-self.view.frame.height * 0.1)
            $0.height.equalTo(buttonHeight)
        })
    }
    
    //MARK: - Action Method
    @objc func setNameButtonTapped() {
        let userID = UserDefaults.standard.string(forKey: "ID")! // optional binding
        let alert = UIAlertController(title: "닉네임 설정", message: "'\(self.setNameTextField.text!)'로 설정하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
            UserDefaults.standard.set(true, forKey: "isAutoLoginActivate") //SNS 회원가입은 자동로그인을 기본값으로 설정(true)
            UserDefaults.standard.set(self.setNameTextField.text!, forKey: "Nickname")
            DataManager.shared.updateUserData(userID: userID, changedPassword: "sns", changedName: self.setNameTextField.text!)
            
            Auth.auth().signIn(withEmail: userID, password: "123456")
            let initialSetUpStartVC = UINavigationController(rootViewController: InitialSetupStartViewController(nickName: self.setNameTextField.text!))
            initialSetUpStartVC.modalPresentationStyle = .fullScreen
            self.present(initialSetUpStartVC, animated: true)
        }))
        self.present(alert, animated: true)
    }
    
    // 키보드 외부 터치할 경우 키보드 숨김처리
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // 키보드 리턴 버튼 누를경우 키보드 숨김처리
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
