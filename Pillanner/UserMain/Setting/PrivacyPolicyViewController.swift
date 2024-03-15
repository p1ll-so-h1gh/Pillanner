//
//  PrivacyPolicyViewController.swift
//  Pillanner
//
//  Created by 김가빈 on 3/12/24.
//



import UIKit

class PrivacyPolicyViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "개인 정보 처리 방침"
        view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = false
        setupUI()
        setupPrivacyPolicy()
    }
    
    // 개인정보 처리방침 내용 레이블
    private let privacyPolicyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0 // 여러 줄 표시 가능하도록 설정
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14.0) // 폰트 크기 조절
        label.textColor = .black // 텍스트 색상 설정
        return label
    }()

    private func setupUI() {
        // ScrollView 추가
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

        // 개인정보 처리방침 내용 레이블 추가
        scrollView.addSubview(privacyPolicyLabel)

        privacyPolicyLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            privacyPolicyLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            privacyPolicyLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            privacyPolicyLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            privacyPolicyLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40) // ScrollView와 같은 너비로 설정하여 가로 스크롤이 나타나지 않도록 함
        ])
        
        // 마지막 서브뷰의 하단을 ScrollView의 contentSize의 하단에 맞춰줌
        NSLayoutConstraint.activate([
            privacyPolicyLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupPrivacyPolicy() {
        // Pillanner 서비스 개인정보 처리방침 내용 가져오기
        let privacyPolicyText = """
        개인정보 처리방침

        본 개인정보 처리방침은 Pillanner 앱(이하 '서비스')을 이용하는 사용자(이하 '이용자')의 개인정보 보호를 위해 제공자가 준수해야 하는 사항을 규정합니다.

        1. 수집하는 개인정보 항목
           - 이용자가 서비스를 이용하기 위해 제공한 개인정보: 알람 설정, 복용 스케줄, 복용 기록 등
           - 자동으로 수집되는 정보: 이용자의 디바이스 정보, 앱 이용 로그 등

        2. 개인정보의 수집 및 이용목적
           - 서비스 제공: 알람 설정과 알약 복용 기록 관리를 위해 개인정보를 수집하고 이용합니다.
           - 개인화 서비스 제공: 이용자의 알약 복용 스케줄 및 기록을 분석하여 개인화된 서비스를 제공합니다.

        3. 개인정보의 보유 및 이용기간
           - 서비스 이용 종료 시 또는 이용자의 요청에 따라 개인정보를 파기합니다.

        4. 개인정보의 제공 및 위탁
           - 이용자의 동의를 받은 경우나 법령의 규정에 따라 개인정보를 제3자에게 제공하거나 위탁할 수 있습니다.

        5. 개인정보의 보호조치
           - 개인정보 보호를 위해 기술적, 관리적, 물리적 보안 조치를 취합니다.
           - 개인정보 처리와 관련한 접근 권한은 최소한의 직원에게만 제공하고 있습니다.

        6. 이용자의 권리와 행사
           - 개인정보에 대한 열람, 정정, 삭제, 처리정지 요청을 할 수 있습니다.

        7. 개인정보의 파기절차 및 방법
           - 서비스 이용 종료 시 또는 이용자의 요청에 따라 파기됩니다.

        8. 개인정보 관련 문의
           - 개인정보 처리에 대한 문의사항은 서비스 내 고객센터를 통해 문의하실 수 있습니다.

        본 개인정보 처리방침은 법령, 정부지침 또는 서비스의 변경에 따라 변경될 수 있습니다. 변경 시에는 변경 내용을 서비스 내에 공지하겠습니다.

        """
        privacyPolicyLabel.text = privacyPolicyText
    }
}
