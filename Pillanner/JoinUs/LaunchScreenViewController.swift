//
// LaunchScreenViewController.swift
// Pillanner
//
// Created by 영현 on 2/22/24.
//
import UIKit
import SnapKit

class LaunchScreenViewController: UIViewController {
    private let sidePaddingValue = 20
    private let paddingBetweenComponents = 30
    lazy var gradientLayer = CAGradientLayer.dayBackgroundLayer(in: view.bounds)
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
    //  private let idCheckButton: UIButton = {
    //    let button = UIButton()
    //    button.setTitle("중복 확인", for: .normal)
    //    button.backgroundColor = .mainThemeColor
    //    button.setTitleColor(UIColor.lightGray, for: .normal)
    //    return button
    //  }()
    //
    //  private let idStack: UIStackView = {
    //    let stack = UIStackView()
    //    stack.axis = .horizontal
    //    stack.alignment = .fill
    //    stack.distribution = .fill
    //    stack.spacing = 1.0
    //    return stack
    //  }()
    private let pwdTextfield: UITextField = {
        let field = UITextField()
        field.placeholder = "비밀번호 입력"
        field.textAlignment = .left
        return field
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
        addViews()
        setUpSize()
        setConstraints()
    }
    //MARK: - UI Settings
    private func addViews() {
        //    idStack.addArrangedSubview(idTextfield)
        //    idStack.addArrangedSubview(idCheckButton)
        self.view.addSubview(pillannerFlagImage)
        //    self.view.addSubview(idStack)
        self.view.addSubview(idTextfield)
        self.view.addSubview(pwdTextfield)
    }
    private func setUpSize() {
        pillannerFlagImage.frame.size.width = self.view.frame.width * 0.4
        pillannerFlagImage.frame.size.height = self.view.frame.height * 0.1
        idTextfield.frame.size.width = self.view.frame.width * 0.8
        idTextfield.frame.size.height = self.view.frame.height * 0.05
        idTextfield.layer.addBorder([.bottom], color: UIColor.lightGray, width: 1.0)
        //    idCheckButton.frame.size.width = self.view.frame.width * 0.3
        //    idCheckButton.frame.size.height = self.view.frame.height * 0.15
        //    idCheckButton.layer.cornerRadius = 5
        pwdTextfield.frame.size.width = self.view.frame.width * 0.8
        pwdTextfield.frame.size.height = self.view.frame.height * 0.05
        pwdTextfield.layer.addBorder([.bottom], color: UIColor.lightGray, width: 1.0)
    }
    private func setConstraints() {
        pillannerFlagImage.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(100)
        }
        idTextfield.snp.makeConstraints{
            $0.top.equalTo(pillannerFlagImage.snp.bottom).offset(paddingBetweenComponents)
            $0.leading.equalToSuperview().offset(sidePaddingValue)
            $0.trailing.equalToSuperview().offset(sidePaddingValue)
            $0.centerX.equalToSuperview()
        }
        pwdTextfield.snp.makeConstraints{
            $0.top.equalTo(idTextfield.snp.bottom).offset(paddingBetweenComponents)
            $0.leading.equalToSuperview().offset(sidePaddingValue)
            $0.trailing.equalToSuperview().offset(sidePaddingValue)
            $0.centerX.equalToSuperview()
        }
        //    idStack.snp.makeConstraints {
        //      $0.centerX.equalToSuperview()
        //      $0.leading.equalToSuperview().offset(sidePaddingValue)
        //      $0.trailing.equalToSuperview().offset(-(sidePaddingValue))
        //      $0.top.equalTo(pillannerFlagImage.snp.bottom).offset(30)
        //    }
    }
}
