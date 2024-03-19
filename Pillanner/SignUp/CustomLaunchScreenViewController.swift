//
//  CustomLaunchScreenViewController.swift
//  Pillanner
//
//  Created by 영현 on 3/5/24.
//

import UIKit
import SnapKit

class CustomLaunchScreenViewController: UIViewController {
    private let myID: String = UserDefaults.standard.string(forKey: "ID") ?? ""
    private let myPW: String = UserDefaults.standard.string(forKey: "Password") ?? ""
    private let autoLoginActivate: Bool = UserDefaults.standard.bool(forKey: "isAutoLoginActivate")
    private lazy var backgroundLayer = CAGradientLayer.dayBackgroundLayer(view: self.view)
    
    let logoFlagImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "PillannerFlagImage"))
        return image
    }()
    
    let welcomeMessageLabel : UILabel = {
        let label = UILabel()
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

    init(message: String) {
        super.init(nibName: nil, bundle: nil)
        welcomeMessageLabel.text = message
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        super.viewDidAppear(animated)
        print("자동로그인 on/off? : ", autoLoginActivate)
        sleep(3)
        
        switch(autoLoginActivate){
        case true : 
            DataManager.shared.readUserData(userID: myID) { userData in
                guard let userData = userData else { return }
                if self.myID == userData["ID"] && self.myPW == userData["Password"] && userData["SignUpPath"] == "일반회원가입" {
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
