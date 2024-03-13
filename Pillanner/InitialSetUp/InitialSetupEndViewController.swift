//
//  InitialSetupEndViewController.swift
//  Pillanner
//
//  Created by 박민정 on 3/12/24.
//

import UIKit
import SnapKit

class InitialSetupEndViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //뷰가 나타날 때 네비게이션 바 숨김
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
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
        titleLabel.text = "감사합니다! 알약 플래너가\n완성되었어요 :)"
        titleLabel.textAlignment = .center
        titleLabel.font = FontLiteral.title2(style: .bold)
        view.addSubview(titleLabel)
        
        let descriptionLabel = UILabel()
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = "앞으로 Pillanner가 OOO님의 약을 챙겨드릴 준비가 모두 끝났어요."
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
        let endButton = UIButton(type: .system)
        endButton.setTitle("약 먹으러 가기", for: .normal)
        endButton.titleLabel?.font = FontLiteral.title2(style: .bold)
        endButton.backgroundColor = UIColor.pointThemeColor2
        endButton.setTitleColor(.white, for: .normal)
        endButton.layer.cornerRadius = 20
        endButton.addTarget(self, action: #selector(endButtonTapped), for: .touchUpInside)
        view.addSubview(endButton)
        
        endButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-40)
            make.left.right.equalTo(view).inset(20)
            make.height.equalTo(50)
        }
    }
    
    @objc private func endButtonTapped() {
        let mainVC = TabBarController()
        navigationController?.pushViewController(mainVC, animated: true)
    }
}
