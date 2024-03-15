//
//  TermsofUseViewController.swift
//  Pillanner
//
//  Created by 김가빈 on 3/12/24.
//
//


import UIKit

class TermsofUseViewController: UIViewController {
    
    private let termsOfServiceTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "이용약관"
        view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = false
        setupUI()
        setupTermsOfServiceText()
    }

    private func setupUI() {
        view.addSubview(termsOfServiceTextView)
        NSLayoutConstraint.activate([
            termsOfServiceTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            termsOfServiceTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            termsOfServiceTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            termsOfServiceTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupTermsOfServiceText() {
        let termsOfServiceText = """
        [목적]\n
        본 약관은 Pillanner 서비스(이하 '서비스')의 이용에 관한 조건 및 절차, 이용자와 서비스 제공자의 권리, 의무 및 책임사항 등 기본적인 사항을 규정함을 목적으로 합니다.\n
        [서비스 이용]\n
        서비스 이용자는 본 서비스를 개인적인 용도로만 이용할 수 있으며, 타인에게 임의로 양도하거나 상업적인 목적으로 이용할 수 없습니다.\n
        [개인정보 수집 및 이용]\n
        서비스 이용자가 서비스를 이용함에 있어 필요한 최소한의 개인정보는 수집될 수 있습니다.\n
        [서비스 제공 중지 및 변경]\n
        서비스 운영상 또는 기술상의 필요에 따라 서비스의 전부 또는 일부 제공이 중지될 수 있습니다.\n
        [책임제한]\n
        서비스 제공자는 서비스를 제공함에 있어 일반적으로 요구되는 주의와 선의를 기준으로 서비스를 제공합니다.\n
        [분쟁해결]\n
        서비스 이용자와 서비스 제공자 간에 발생한 분쟁에 대해는 우선적으로 합의를 이루어 해결하도록 합니다.\n
        [약관 효력 및 변경]\n
        본 약관은 서비스 제공자의 사전 공지 없이 변경될 수 있습니다.\n
        """
        
        let attributedString = NSMutableAttributedString(string: termsOfServiceText)
        
        let boldAttributes: [NSAttributedString.Key: Any] = [
            .font: FontLiteral.title2(style: .bold)
        ]
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .font: FontLiteral.body(style: .regular)
        ]
        
        // "목적", "서비스 이용" 등의 부분을 굵게 만듦
        let boldStrings = ["[목적]", "[서비스 이용]", "[개인정보 수집 및 이용]", "[서비스 제공 중지 및 변경]", "[책임제한]", "[분쟁해결]", "[약관 효력 및 변경]"]
        boldStrings.forEach { boldString in
            let range = (termsOfServiceText as NSString).range(of: boldString)
            attributedString.addAttributes(boldAttributes, range: range)
        }
        
        // 나머지 텍스트에 일반 스타일 적용
        attributedString.addAttributes(normalAttributes, range: NSRange(location: 0, length: attributedString.length))
        
        termsOfServiceTextView.attributedText = attributedString
    }
}
