//
//  CustomLaunchScreenViewController.swift
//  Pillanner
//
//  Created by 영현 on 3/5/24.
//

import UIKit
import SnapKit
import FirebaseAuth

class CustomLaunchScreenViewController: UIViewController {
    private lazy var backgroundLayer = CAGradientLayer.dayBackgroundLayer(view: self.view)
    let credential = PhoneAuthProvider.provider().credential(
        withVerificationID: UserDefaults.standard.string(forKey: "firebaseVerificationID") ?? "",
        verificationCode: UserDefaults.standard.string(forKey: "firebaseVerificationCode") ?? ""
    )
    var myID: String {
        return UserDefaults.standard.string(forKey: "ID") ?? ""
    }
    
    var myPW: String {
        return UserDefaults.standard.string(forKey: "Password") ?? ""
    }
    
    var autoLoginActivate: Bool {
        return UserDefaults.standard.bool(forKey: "isAutoLoginActivate")
    }
    
    let logoFlagImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "PillannerFlagImage"))
        return image
    }()
    
    let welcomeMessageLabel : UILabel = {
        let label = UILabel()
        label.text = "알약, 달력 넘기듯 간편하게"
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = FontLiteral.subheadline(style: .bold)
        return label
    }()
    
    let logoImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "PillannerLogoImage"))
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.layer.addSublayer(backgroundLayer)
        addViews()
        setConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("====================================================================")
        print("UserDefaults UID : ", UserDefaults.standard.string(forKey: "UID") ?? "nil")
        print("UserDefaults ID : ", UserDefaults.standard.string(forKey: "ID") ?? "nil")
        print("UserDefaults Password : ", UserDefaults.standard.string(forKey: "Password") ?? "nil")
        print("UserDefaults Nickname : ", UserDefaults.standard.string(forKey: "Nickname") ?? "nil")
        print("UserDefaults SignUpPath : ", UserDefaults.standard.string(forKey: "SignUpPath") ?? "nil")
        print("UserDefaults isAutoLoginActivate : ", UserDefaults.standard.bool(forKey: "isAutoLoginActivate")) // true : 자동 로그인 체크
        print("====================================================================")
        super.viewDidAppear(animated)
        print("자동로그인 on/off? : ", autoLoginActivate)
        sleep(3)
        
        switch(autoLoginActivate){
        case true :
            DataManager.shared.readUserData(userID: myID) { userData in
                guard let userData = userData else { return }
                if self.myID == userData["ID"] && self.myPW == userData["Password"] && userData["SignUpPath"] == "일반회원가입" {
                    Auth.auth().signIn(with: self.credential) { authData, error in
                        let currentUser = Auth.auth().currentUser
                        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                            if let error = error { return }
                        }
                    }
                    let mainVC = TabBarController()
                    mainVC.modalPresentationStyle = .fullScreen
                    self.present(mainVC, animated: true, completion: nil)
                } else if userData["SignUpPath"] == "애플" || userData["SignUpPath"] == "카카오" || userData["SignUpPath"] == "네이버" {
                    Auth.auth().signIn(withEmail: self.myID, password: "123456")
                    let mainVC = TabBarController()
                    mainVC.modalPresentationStyle = .fullScreen
                    self.present(mainVC, animated: true, completion: nil)
                } else {
                    let navVC = UINavigationController(rootViewController: LoginViewController())
                        navVC.modalPresentationStyle = .fullScreen
                    self.present(navVC, animated: true)
                }
            }
            
        case false : let navVC = UINavigationController(rootViewController: LoginViewController())
            navVC.modalPresentationStyle = .fullScreen
            present(navVC, animated: true)
        }
    }
    
    private func addViews() {
        view.addSubview(logoFlagImage)
        view.addSubview(welcomeMessageLabel)
        view.addSubview(logoImage)
    }
    
    private func setConstraints() {
        logoFlagImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(100)
        }
        welcomeMessageLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(logoFlagImage.snp.bottom).offset(20)
        }
        logoImage.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.equalTo(250)
            $0.height.equalTo(180)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
