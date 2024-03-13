//
//  InitialSetupStartViewController.swift
//  Pillanner
//
//  Created by 김가빈 on 2/29/24.
//

import UIKit
import SnapKit

class InitialSetupStartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        setGradientBackground()
        setupCharacterImages()
        setupTitleAndDescription()
        setupStartButton()
    }
    
    private func setGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.dayBackgroundPurpleColor.cgColor, UIColor.dayBackgroundBlueColor.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setupCharacterImages() {
        let characterImageView1 = UIImageView(image: UIImage(named: "character1"))
        let characterImageView2 = UIImageView(image: UIImage(named: "character2"))
        
        view.addSubview(characterImageView1)
        view.addSubview(characterImageView2)
        
        characterImageView1.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.centerY).offset(50)
            make.left.equalTo(view).offset(20)
            make.height.equalTo(225)
            make.width.equalTo(200)
        }
        
        characterImageView2.snp.makeConstraints { make in
            make.top.equalTo(view.snp.centerY).offset(20)
            make.right.equalTo(view).offset(-20)
            make.width.height.equalTo(250)
        }
    }
    
    private func setupTitleAndDescription() {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.text = "건강한 루틴을 위한\n알약 플래너 만들기"
        titleLabel.textAlignment = .center
        titleLabel.font = FontLiteral.title2(style: .bold)
        view.addSubview(titleLabel)
        
        let descriptionLabel = UILabel()
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = "지금부터 Pillanner가 약을\n챙겨드리기 위한 정보를 요청드리려 해요!"
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = FontLiteral.body(style: .regular)
        view.addSubview(descriptionLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            make.left.right.equalTo(view).inset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.right.equalTo(view).inset(20)
        }
    }
    
    private func setupStartButton() {
        let startButton = UIButton(type: .system)
        startButton.setTitle("바로 시작하기", for: .normal)
        startButton.titleLabel?.font = FontLiteral.title2(style: .bold)
        startButton.backgroundColor = UIColor.pointThemeColor2
        startButton.setTitleColor(.white, for: .normal)
        startButton.layer.cornerRadius = 20
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        view.addSubview(startButton)
        
        startButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-40)
            make.left.right.equalTo(view).inset(20)
            make.height.equalTo(50)
        }
    }
    
    @objc private func startButtonTapped() {
        let initialSetupVC = InitialSetUpViewController()
        navigationController?.pushViewController(initialSetupVC, animated: true)
    }
}
