//
//  TermsofUseViewController.swift
//  Pillanner
//
//  Created by 김가빈 on 3/12/24.
//
//



import UIKit

class TermsofUseViewController: UIViewController {
    
override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationItem.title = "이용약관"
    view.backgroundColor = .white
    self.navigationController?.isNavigationBarHidden = false
    setupUI()
    setupTermsOfService()
}

// 개인정보 처리방침 내용 레이블
private let setupTermsOfServiceLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0 // 여러 줄 표시 가능하도록 설정
    label.textAlignment = .left
    label.font = UIFont.systemFont(ofSize: 14.0) // 폰트 크기 조절
    label.textColor = .black // 텍스트 색상 설정
    return label
}()

private func setupUI() {
    let scrollView = UIScrollView()
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(scrollView)
    
    scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    
    // 개인정보 처리방침 내용 레이블 추가
    scrollView.addSubview(setupTermsOfServiceLabel)
    
    setupTermsOfServiceLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
        setupTermsOfServiceLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
        setupTermsOfServiceLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
        setupTermsOfServiceLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
        setupTermsOfServiceLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40) // ScrollView와 같은 너비로 설정하여 가로 스크롤이 나타나지 않도록 함
    ])
    
    // 마지막 서브뷰의 하단을 ScrollView의 contentSize의 하단에 맞춰줌
    NSLayoutConstraint.activate([
        setupTermsOfServiceLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20)
    ])
}


private func setupTermsOfService() {
    let privacyPolicyText = """
  1. 목적

본 약관은 Pillanner 서비스(이하 '서비스')의 이용에 관한 조건 및 절차, 이용자와 서비스 제공자의 권리, 의무 및 책임사항 등 기본적인 사항을 규정함을 목적으로 합니다.


2. 서비스 이용

서비스 이용자는 본 서비스를 개인적인 용도로만 이용할 수 있으며, 타인에게 임의로 양도하거나 상업적인 목적으로 이용할 수 없습니다.


3. 개인정보 수집 및 이용
서비스 이용자가 서비스를 이용함에 있어 필요한 최소한의 개인정보는 수집될 수 있습니다


4. 서비스 제공 중지 및 변경

서비스 운영상 또는 기술상의 필요에 따라 서비스의 전부 또는 일부 제공이 중지될 수 있습니다.


5. 책임제한

서비스 제공자는 서비스를 제공함에 있어 일반적으로 요구되는 주의와 선의를 기준으로 서비스를 제공합니다.


6. 분쟁해결

서비스 이용자와 서비스 제공자 간에 발생한 분쟁에 대해는 우선적으로 합의를 이루어 해결하도록 합니다.


7. 약관 효력 및 변경

본 약관은 서비스 제공자의 사전 공지 없이 변경될 수 있습니다.

"""
    
    let attributedString = NSMutableAttributedString(string: privacyPolicyText)
    let boldFontAttribute = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16.0)]
    
    // 각 번호에 해당하는 부분의 범위를 찾아서 볼드 처리
    let boldStrings = ["1. 목적","2. 서비스 이용", "3. 개인정보 수집 및 이용", "4. 서비스 제공 중지 및 변경", "5. 책임제한", "6. 분쟁해결", "7. 약관 효력 및 변경"]
    for boldString in boldStrings {
        let range = (privacyPolicyText as NSString).range(of: boldString)
        attributedString.addAttributes(boldFontAttribute, range: range)
    }
    
    setupTermsOfServiceLabel.attributedText = attributedString
}
}
