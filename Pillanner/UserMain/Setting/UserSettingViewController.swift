//
//  UserSettingViewController.swift
//  Pillanner
//
//  Created by 김가빈 on 3/12/24.
//

import UIKit
import SnapKit

enum SettingSection: CaseIterable {
    case userInfo
    case support
    case policy
    case appInfo

    var title: String {
        switch self {
            
        case .userInfo:
            return "회원정보"
        case .support:
            return "고객지원"
        case .policy:
            return "약관 및 정책"
        case .appInfo:
            return "앱 정보"
        }
    }
    static let userInfoList = ["회원정보관리"]
    static let supportList = ["공지사항", "1:1문의"]
    static let policyList = ["이용약관", "개인 정보 처리 방침"]
    static let appInfoList = ["버전 정보"]
}


class UserSettingViewController: UIViewController {
    private let sidePaddingSizeValue = 20
    //MARK: - Properties
    private let topView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "앱 설정"
        label.font = FontLiteral.title2(style: .bold).withSize(20)
        return label
    }()
    
    private lazy var backBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark")?.withRenderingMode(.alwaysOriginal).withTintColor(.black), for: .normal)
        button.addTarget(self, action: #selector(goBackPage), for: .touchUpInside)
        return button
    }()
    
    @objc func goBackPage() {
        dismiss(animated: true)
    }
    
    private let seperateLine1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexCode: "F0EFEF")
        return view
    }()
    
    private let topAlarmView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let alarmactivateLabel: UILabel = {
        let label = UILabel()
        label.text = "푸시 알람 수신 활성화"
        label.font = FontLiteral.body(style: .regular).withSize(16)
        return label
    }()
    
    private let alarmActivateSwitch: UISwitch = {
        let switchControl = UISwitch()
        switchControl.onTintColor = UIColor.mainThemeColor
        return switchControl
    }()
    
    private let alarmDetailImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "exclamationmark.circle")
        image.tintColor = .black
        return image
    }()
    
    private let alarmDetailLabel1: UILabel = {
        let label = UILabel()
        label.text = "어플로 받는 푸시 알림의 수신여부를 선택합니다."
        label.font = FontLiteral.body(style: .bold).withSize(15)
        return label
    }()
    
    private let alarmDetailLabel2: UILabel = {
        let label = UILabel()
        label.text = "정기구독, 결제, 배송, 계정보안, 약관변경, 공지사항 등과 같은 중요 정보는 앱 푸시 알림 설정여부와 상관없이 이메일, 문자메시지 등으로 발송됩니다."
        label.numberOfLines = 0
        label.font = FontLiteral.body(style: .regular).withSize(14)
        label.alpha = 0.8
        return label
    }()
    
    private let alarmDetailInfoView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let seperateLine2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexCode: "F0EFEF")
        return view
    }()
    
    private let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    

    private let bottomTableView: UITableView = {
        let tableview = UITableView()
        tableview.register(SettingSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: SettingSectionHeaderView.reuseIdentifier)
        tableview.sectionHeaderTopPadding = 0
        tableview.register(settingCell.self, forCellReuseIdentifier: settingCell.identifier)
        return tableview
    }()
    
    private var sectionList: [SettingSection] = SettingSection.allCases
    private lazy var navBackBtn = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navBackBtn.tintColor = .black
        self.navigationItem.backBarButtonItem = navBackBtn
        
        bottomTableView.delegate = self
        bottomTableView.dataSource = self
        bottomTableView.rowHeight = UITableView.automaticDimension
        configureLogoutButton()
        
        setupView()
    }
    
    func configureLogoutButton() {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        let logoutButton = UIButton(type: .system)
        logoutButton.setTitle("로그아웃", for: .normal)
        logoutButton.titleLabel?.font = FontLiteral.body(style: .regular) // 폰트 설정
        logoutButton.setTitleColor(UIColor.secondaryLabel, for: .normal) // 컬러 설정
        logoutButton.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        footerView.addSubview(logoutButton)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoutButton.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
            logoutButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor)
        ])
        bottomTableView.tableFooterView = footerView
    }

    @objc func handleLogout() {
        // Show logout alert
        let alert = UIAlertController(title: "로그아웃", message: "정말 로그아웃 하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "네", style: .destructive, handler: { _ in
            // Handle logout logic here
            print("User logged out")
        }))
        alert.addAction(UIAlertAction(title: "아니오", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setupView() {
        // 뷰를 뷰 계층에 추가
        view.addSubview(topView)
        topView.addSubview(backBtn)
        topView.addSubview(titleLabel)
        
        view.addSubview(seperateLine1)
        view.addSubview(topAlarmView)
        topAlarmView.addSubview(alarmactivateLabel)
        topAlarmView.addSubview(alarmActivateSwitch)
        topAlarmView.addSubview(alarmDetailImage)
        topAlarmView.addSubview(alarmDetailLabel1)
        topAlarmView.addSubview(alarmDetailLabel2)
        
        
        view.addSubview(seperateLine2)
        view.addSubview(bottomTableView)
        
        // topView 제약 조건 설정
        topView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(60)
        }
        
        // backBtn 제약 조건 설정
        backBtn.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(sidePaddingSizeValue)
        }
        
        // titleLabel 제약 조건 설정
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(backBtn.snp.centerY)
            make.centerX.equalToSuperview()
        }
        
        // seperateLine1 제약 조건 설정
        seperateLine1.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.leading.trailing.equalTo(view)
            make.height.equalTo(1)
        }
        
        // topAlarmView 제약 조건 설정
        topAlarmView.snp.makeConstraints { make in
            make.top.equalTo(seperateLine1.snp.bottom)
            make.leading.trailing.equalTo(view)
            make.height.equalTo(140) // 예시 높이, 필요에 따라 조정
        }
        
        // alarmDetailImage 제약 조건 설정
        alarmDetailImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.top.equalToSuperview().inset(10)
            make.size.equalTo(15)
        }
        
        // alarmDetailLabel1 제약 조건 설정
        alarmDetailLabel1.snp.makeConstraints { make in
            make.leading.equalTo(alarmDetailImage.snp.trailing).offset(10)
            make.centerY.equalTo(alarmDetailImage.snp.centerY)
        }
        
        // alarmDetailLabel2 제약 조건 설정
        alarmDetailLabel2.snp.makeConstraints { make in
            make.top.equalTo(alarmDetailLabel1.snp.bottom).offset(3)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        // alarmactivateLabel 제약 조건 설정
        alarmactivateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(sidePaddingSizeValue)
            make.top.equalTo(alarmDetailLabel2.snp.bottom).offset(15)
        }
        
        // alarmActivateSwitch 제약 조건 설정
        alarmActivateSwitch.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(sidePaddingSizeValue)
            make.centerY.equalTo(alarmactivateLabel.snp.centerY)
        }
        
        // seperateLine2 제약 조건 설정
        seperateLine2.snp.makeConstraints { make in
            make.top.equalTo(topAlarmView.snp.bottom)
            make.leading.trailing.equalTo(view)
            make.height.equalTo(5)
        }
        
        // bottomTableView 제약 조건 설정
        bottomTableView.snp.makeConstraints { make in
            make.top.equalTo(seperateLine2.snp.bottom)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

//extension UserSettingViewController: UITableViewDataSource, UITableViewDelegate {
//    //섹션 만들기
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        
//        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: SettingSectionHeaderView.reuseIdentifier) as? SettingSectionHeaderView else { return nil }
//        
//        headerView.setTitle(with: sectionList[section].title)
//        return headerView
//    }

extension UserSettingViewController: UITableViewDataSource, UITableViewDelegate {
    // 섹션 헤더 뷰 설정
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: SettingSectionHeaderView.reuseIdentifier) as? SettingSectionHeaderView else { return nil }
        headerView.setTitle(with: sectionList[section].title)
        return headerView
    }
    
    //섹션 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionList.count
    }
    
    //각 섹션마다 몇개의 로우가 들어가는지 정의
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sectionList[section] {
        case .userInfo: // Add this line
            return SettingSection.userInfoList.count
        case .support:
            return SettingSection.supportList.count
        case .policy:
            return SettingSection.policyList.count
        case .appInfo:
            return SettingSection.appInfoList.count
        }
    }
    
    // 셀 설정
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: settingCell.identifier, for: indexPath) as! settingCell
            switch sectionList[indexPath.section] {
            case .userInfo:
                cell.titleLabel.text = SettingSection.userInfoList[indexPath.row]
            case .support:
                cell.titleLabel.text = SettingSection.supportList[indexPath.row]
            case .policy:
                cell.titleLabel.text = SettingSection.policyList[indexPath.row]
            case .appInfo:
                cell.titleLabel.text = "버전 정보"
                cell.versionLabel.text = "1.0.2" // 예시 버전 정보
                cell.pageBtn.isHidden = true
            }
            return cell
        }
    
    // 셀 선택 시 동작 설정
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            
            switch sectionList[indexPath.section] {
            case .userInfo:
                let userInfoVC = UserInfoView() // UserInfoView 인스턴스 생성
                navigateTo(userInfoVC) // 화면 전환 수행
            case .support:
                supportSectionAction(indexPath: indexPath)
            case .policy:
                policySectionAction(indexPath: indexPath)
            case .appInfo:
                // appInfo 섹션은 화면 전환을 수행하지 않음
                break
            }
        }
    
    // support 섹션 처리
        private func supportSectionAction(indexPath: IndexPath) {
            switch indexPath.row {
            case 0:
                let noticeVC = NoticeViewController() // 공지사항 화면 인스턴스 생성
                navigateTo(noticeVC)
            case 1:
                sendEmail() // 1:1 문의 이메일 전송
            default:
                break
            }
        }
    
    // policy 섹션 처리
        private func policySectionAction(indexPath: IndexPath) {
            switch indexPath.row {
            case 0:
                let termsVC = TermsofUseViewController() // 이용약관 화면 인스턴스 생성
                navigateTo(termsVC)
            case 1:
                let privacyVC = PrivacyPolicyViewController() // 개인정보 처리방침 화면 인스턴스 생성
                navigateTo(privacyVC)
            default:
                break
            }
        }
        
        // 화면 전환 유틸리티 함수
        private func navigateTo(_ viewController: UIViewController) {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    
    
    private func showEmailWithTemplate(subject: String, body: String) {
        var components = URLComponents()
        components.scheme = "mailto"
        components.path = "pillanner@gmail.com" // 메일 주소
        components.queryItems = [
            URLQueryItem(name: "subject", value: subject), // 메일 제목
            URLQueryItem(name: "body", value: body)        // 메일 내용
        ]
        
        guard let url = components.url else { return }

        // 현재 앱에서 기본 이메일 앱을 띄움
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//
////        switch sectionList[indexPath.section] {
////        case .userInfo: // "회원정보" 섹션 처리
////            userInfoSectionAction(indexPath: indexPath)
////            
////        case .support:
////            supportSectionAction(indexPath: indexPath)
////            
////        case .policy:
////            policySectionAction(indexPath: indexPath)
////            
////        case .appInfo:
////            appInfoSectionAction(indexPath: indexPath)
////
////        }
////    }
//        switch sectionList[indexPath.section] {
//            case .userInfo:
//                userInfoSectionAction(indexPath: indexPath)
//            case .support:
//                supportSectionAction(indexPath: indexPath)
//            case .policy:
//                policySectionAction(indexPath: indexPath)
//            case .appInfo:
//                appInfoSectionAction(indexPath: indexPath)
//            }
//        }

    // 각 섹션별 처리 함수 예시
//    private func supportSectionAction(indexPath: IndexPath) {
//        switch indexPath.row {
//        case 0:
//            let noticeVC = NoticeViewController()
//            self.navigationController?.pushViewController(noticeVC, animated: true)
//        case 1:
//            sendEmail()
//        default:
//            break
//        }
//    }

//    private func policySectionAction(indexPath: IndexPath) {
//        switch indexPath.row {
//        case 0:
//            navigateTo(TermsofUseViewController())
//        case 1:
//            navigateTo(PrivacyPolicyViewController())
//        default:
//            break
//        }
//    }

//    private func appInfoSectionAction(indexPath: IndexPath) {
//        switch indexPath.row {
//        case 0:
//            print("버전 정보 페이지로 이동")
//        case 1:
//            logoutAlert()
//        case 2: // "회원탈퇴" 가정
//            print("회원탈퇴 처리")
//        default:
//            break
//        }
//    }

//    private func userInfoSectionAction(indexPath: IndexPath) {
//        // 예: 회원 정보 관리 화면으로 이동
//        navigateTo(UserInfoView())
//        print("회원 정보 관리 화면으로 이동")
//    }
    private func userInfoSectionAction(indexPath: IndexPath) {
        // 예: 회원 정보 관리 화면으로 이동
        let userInfoVC = UserInfoView() // UserInfoView 인스턴스 생성
        navigateTo(userInfoVC) // 화면 전환 수행
        print("회원 정보 관리 화면으로 이동")
    }

    // 주어진 뷰 컨트롤러로 이동하는 유틸리티 함수
//    private func navigateTo(_ viewController: UIViewController) {
//        self.navigationController?.pushViewController(viewController, animated: true)
//    }
    
//    private func navigateTo(_ viewController: UIViewController) {
//        // 네비게이션 컨트롤러를 사용하여 화면 전환
//        if let navigationController = self.navigationController {
//            navigationController.pushViewController(viewController, animated: true)
//        } else {
//            // 네비게이션 컨트롤러가 없는 경우, 모달 방식으로 화면 전환을 수행할 수 있습니다.
//            self.present(viewController, animated: true, completion: nil)
//        }
//    }

    // 로그아웃 알림 표시 함수
    private func logoutAlert() {
        let alert = UIAlertController(title: "로그아웃", message: "정말 로그아웃 하시겠습니까?", preferredStyle: .alert)
        let actionYes = UIAlertAction(title: "네", style: .destructive) { _ in
            // 로그아웃 로직 처리
            print("로그아웃 처리")
        }
        let actionNo = UIAlertAction(title: "아니오", style: .cancel)
        alert.addAction(actionYes)
        alert.addAction(actionNo)
        self.present(alert, animated: true)
    }

    // 이메일 전송 처리 함수
    private func sendEmail() {
        let subject = "1:1 문의"
        let body = """
                   안녕하세요, Pillanner 사용자님! 문의하실 내용을 아래 템플릿에 맞춰 작성해주세요.
                   \n\n
                   1. 문의 내용:
                   2. 사용자 이메일:
                   3. 기타 참고사항:
                   """
        showEmailWithTemplate(subject: subject, body: body)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

//MARK: - Class settingCell
class settingCell: UITableViewCell {
    static let identifier: String = String(describing: settingCell.self)
    private let sidePaddingSizeValue = 10
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = FontLiteral.body(style: .regular).withSize(16)
        label.textColor = UIColor(hexCode: "828282")
        return label
    }()
    
    // versionLabel 추가
        var versionLabel: UILabel = {
            let label = UILabel()
            label.font = FontLiteral.body(style: .regular).withSize(16)
            label.textColor = UIColor.black // 적절한 색상 설정
            return label
        }()
    
    // pageBtn 접근 제한자 변경 (예: internal)
        internal let pageBtn: UIButton = {
            let button = UIButton()
            button.setImage(UIImage(named: "button"), for: .normal)
            button.tintColor = UIColor(hexCode: "5F5F5F")
            return button
        }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            self.selectionStyle = .none
            setupCell()
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(5)
            $0.leading.equalToSuperview().inset(sidePaddingSizeValue)
        }
        contentView.addSubview(pageBtn)
        pageBtn.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(5)
            $0.trailing.equalToSuperview().inset(sidePaddingSizeValue)
        }
    }
}


//MARK: - SettingSectionHeaderView
final class SettingSectionHeaderView: UITableViewHeaderFooterView {
    static let reuseIdentifier: String = String(describing: SettingSectionHeaderView.self)
    
    private let titleLabel: UILabel =  {
        let label: UILabel = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textColor = .black
        label.font = FontLiteral.title3(style: .bold).withSize(18)
        
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func setTitle(with text: String) {
        titleLabel.text = text
    }
    
    private func configureTitleLabel() {
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
        ])
    }
    
}
