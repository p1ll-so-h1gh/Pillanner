//
//  CustomLaunchScreenViewController.swift
//  Pillanner
//
//  Created by 영현 on 3/5/24.
//

import UIKit
import SnapKit

class CustomLaunchScreenViewController: UIViewController {
    var loginStatus: Bool = false // false : LoginVC 로 전환, true : (회원가입을 방금한 상태) CustomLaunchVC - 유저메인으로 이동
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

    init(message: String, status: Bool) {
        super.init(nibName: nil, bundle: nil)
        welcomeMessageLabel.text = message
        loginStatus = status
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
        sleep(3)
        
        switch(loginStatus){
        case false : let navVC = UINavigationController(rootViewController: LoginViewController())
            navVC.modalPresentationStyle = .fullScreen
            present(navVC, animated: true)
        case true : let nextVC = TabBarController()
            nextVC.modalPresentationStyle = .fullScreen
            present(nextVC, animated: true)
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
