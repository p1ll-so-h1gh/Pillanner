//
//  UserInfoView.swift
//  Pillanner
//
//  Created by 김가빈 on 3/12/24.
//


import UIKit
import SnapKit

class UserInfoView: UIViewController, UITextFieldDelegate {
    private let sidePaddingValue = 20
    private let topPaddingValue = 40
    private let buttonHeightValue = 35
    private let withdrawalButton = UIButton()
    
    var myUID: String {
        return UserDefaults.standard.string(forKey: "UID") ?? ""
    }
    
    var myID: String {
        return UserDefaults.standard.string(forKey: "ID") ?? ""
    }
    
    var myPW: String {
        return UserDefaults.standard.string(forKey: "Password") ?? ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "회원 정보 관리"
        self.navigationController?.isNavigationBarHidden = false
        view.backgroundColor = .white
        nameTextField.delegate = self
        configureWithdrawalButton()
        addView()
        setUpConstraint()
    }
    
    func configureWithdrawalButton() {
        withdrawalButton.setTitle("회원탈퇴", for: .normal)
        withdrawalButton.titleLabel?.font = FontLiteral.body(style: .regular)
        
        withdrawalButton.setTitleColor(UIColor.secondaryLabel, for: .normal)
        withdrawalButton.addTarget(self, action: #selector(handleWithdrawal), for: .touchUpInside)
        view.addSubview(withdrawalButton)
    }
    
    
    @objc func handleWithdrawal() {
        // Show logout alert
        let alert = UIAlertController(title: "회원탈퇴", message: "정말 탈퇴하시겠습니까? 탈퇴시 PILLANNER에 기록된 정보들이 모두 삭제됩니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "네", style: .destructive, handler: { _ in
            // 만약 카카오 로그인 한 경우, 카카오 토큰해제
            if UserDefaults.standard.string(forKey: "SignUpPath")! == "카카오" {
                UserApi.shared.unlink {(error) in
                    if let error = error {
                        print(error)
                    }
                    else {
                        print("unlink() success.")
                    }
                }
            }
            var currentViewController: UIViewController? = self.presentingViewController
            while let presentingViewController = currentViewController?.presentingViewController {
                currentViewController = presentingViewController
            }
            currentViewController?.dismiss(animated: true, completion: nil)
            DataManager.shared.deleteUserData(UID: self.myUID)
        }))
        alert.addAction(UIAlertAction(title: "아니오", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "이름(닉네임) 변경하기"
        label.font = FontLiteral.body(style: .bold)
        return label
    }()
    
    let nameTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "변경할 이름(닉네임)을 입력해주세요 :)"
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
    
    let nameChangeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("변경하기", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = .pointThemeColor2
        button.layer.cornerRadius = 5
        button.addTarget(target, action: #selector(nameChangeButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private func addView() {
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(nameChangeButton)
        view.addSubview(nameTextFieldUnderLine)
        
        view.addSubview(withdrawalButton)
        
    }
    
    private func setUpConstraint() {
        nameLabel.snp.makeConstraints({
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(topPaddingValue)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
        })
        nameTextField.snp.makeConstraints({
            $0.top.equalTo(nameLabel.snp.bottom).offset(10)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
            $0.right.equalTo(nameChangeButton.snp.left).offset(-10)
        })
        nameChangeButton.snp.makeConstraints({
            $0.centerY.equalTo(nameTextField.snp.centerY).offset(-10)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-sidePaddingValue)
            $0.width.equalTo(100)
            $0.height.equalTo(buttonHeightValue)
        })
        nameTextFieldUnderLine.snp.makeConstraints({
            $0.top.equalTo(nameTextField.snp.bottom).offset(10)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(sidePaddingValue)
            $0.width.equalTo(nameTextField.snp.width)
        })
        withdrawalButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20) // Adjust the offset as needed
        }
    }
}


import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth
import KakaoSDKUser

extension UserInfoView {
    
    // 이름(닉네임) 변경 버튼 클릭 메서드
    @objc func nameChangeButtonClicked(_ sender: UIButton) {
        let newName: String = nameTextField.text!
        
        let alert = UIAlertController(title: "이름 변경", message: "\(newName)으로 변경하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "네", style: .destructive, handler: { _ in
            DataManager.shared.updateUserData(userID: self.myID, changedPassword: self.myPW, changedName: newName)
            self.dismiss(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "아니오", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    // 키보드 외부 터치할 경우 키보드 숨김처리
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // 텍스트필드 언더라인 활성화 메서드
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.4) {
            switch(textField) {
            case self.nameTextField : self.nameTextFieldUnderLine.setProgress(1.0, animated: true)
            default : break
            }
        }
    }
    
    // 텍스트필드 언더라인 비활성화 메서드
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) {
            switch(textField) {
            case self.nameTextField : self.nameTextFieldUnderLine.setProgress(0.0, animated: true)
            default : break
            }
        }
    }
    
}
