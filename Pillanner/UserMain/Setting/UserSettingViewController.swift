//
//  UserSettingViewController.swift
//  Pillanner
//
//  Created by 박민정 on 3/5/24.
//

import UIKit
import SnapKit

enum SettingSection: CaseIterable {
    case support
    case policy
    case appInfo
    
    var title: String {
        switch self {
        case .support:
            "고객지원"
        case .policy:
            "약관 및 정책"
        case .appInfo:
            "앱 정보"
        }
    }
    
    static let supportList = ["공지사항", "1:1문의"]
    static let policyList = ["이용약관", "개인 정보 처리 방침", "마케팅 수신 동의"]
    static let appInfoList = ["버전 정보", "사업자 정보", "로그아웃", "회원탈퇴"]
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
    
    private let userInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "회원 정보 관리"
        label.font = FontLiteral.title3(style: .bold).withSize(18)
        return label
    }()
    
    private lazy var userInfoBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "button"), for: .normal)
        button.addTarget(self, action: #selector(goUserInfoPage), for: .touchUpInside)
        return button
    }()
    
    @objc func goUserInfoPage() {
        let userview = UserInfoView()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.pushViewController(userview, animated: true)
    }
    
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
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setupView() {
        [backBtn, titleLabel].forEach {
            topView.addSubview($0)
        }
        
        backBtn.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(sidePaddingSizeValue)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(sidePaddingSizeValue)
            $0.centerX.equalToSuperview()
        }
        
        [alarmDetailImage, alarmDetailLabel1, alarmDetailLabel2].forEach {
            alarmDetailInfoView.addSubview($0)
        }
        
        alarmDetailImage.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(3)
            $0.top.equalToSuperview()
            $0.size.equalTo(15)
        }
        alarmDetailLabel1.snp.makeConstraints {
            $0.leading.equalTo(alarmDetailImage.snp.trailing).inset(-2)
            $0.centerY.equalTo(alarmDetailImage.snp.centerY)
        }
        alarmDetailLabel2.snp.makeConstraints {
            $0.top.equalTo(alarmDetailImage.snp.bottom).inset(-3)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        [alarmactivateLabel, alarmActivateSwitch, alarmDetailInfoView].forEach {
            topAlarmView.addSubview($0)
        }
        
        alarmactivateLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(sidePaddingSizeValue)
        }
        alarmActivateSwitch.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(sidePaddingSizeValue)
            $0.centerY.equalTo(alarmactivateLabel.snp.centerY)
        }
        alarmDetailInfoView.snp.makeConstraints {
            $0.top.equalTo(alarmactivateLabel.snp.bottom).inset(-sidePaddingSizeValue)
            $0.leading.trailing.equalToSuperview().inset(sidePaddingSizeValue)
            $0.bottom.equalToSuperview().inset(10)
        }
        
        [userInfoLabel, userInfoBtn, bottomTableView].forEach {
            bottomView.addSubview($0)
        }
        
        userInfoLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview().inset(sidePaddingSizeValue)
        }
        userInfoBtn.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(sidePaddingSizeValue)
        }
        bottomTableView.snp.makeConstraints {
            $0.top.equalTo(userInfoLabel.snp.bottom).inset(-sidePaddingSizeValue)
            $0.leading.trailing.bottom.equalToSuperview().inset(12)
        }
        
        [topView, seperateLine1, topAlarmView, seperateLine2, bottomView].forEach {
            view.addSubview($0)
        }
        
        topView.snp.makeConstraints {
            $0.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(60)
        }
        seperateLine1.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(1)
            $0.top.equalTo(topView.snp.bottom)
        }
        topAlarmView.snp.makeConstraints {
            $0.top.equalTo(seperateLine1.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(150)
        }
        seperateLine2.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(5)
            $0.top.equalTo(topAlarmView.snp.bottom)
        }
        bottomView.snp.makeConstraints {
            $0.top.equalTo(seperateLine2.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension UserSettingViewController: UITableViewDataSource, UITableViewDelegate {
    //섹션 만들기
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
        case .support:
            return SettingSection.supportList.count
        case .policy:
            return SettingSection.policyList.count
        case .appInfo:
            return SettingSection.appInfoList.count
        }
    }
    
    //각각의 셀에 커스텀 셀 넣어주기
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: settingCell.identifier, for: indexPath) as! settingCell
        switch sectionList[indexPath.section] {
        case .support:
            cell.titleLabel.text = SettingSection.supportList[indexPath.row]
            return cell
        case .policy:
            cell.titleLabel.text = SettingSection.policyList[indexPath.row]
            return cell
        case .appInfo:
            cell.titleLabel.text = SettingSection.appInfoList[indexPath.row]
            return cell
        }
    }
    
    //셀 선택시 액션 넣는 곳
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sectionList[indexPath.section] {
        case .support:
            switch indexPath.row {
            case 0:
                print("공지사항")
            case 1:
                print("1:1문의")
            default:
                return
            }
        case .policy:
            switch indexPath.row {
            case 0:
                print("이용약관")
            case 1:
                print("개인 정보 처리 방침")
            case 2:
                print("마케팅 수신 동의")
            default:
                return
            }
        case .appInfo:
            switch indexPath.row {
            case 0:
                print("버전 정보")
            case 1:
                print("사업자 정보")
            case 2:
                print("로그아웃")
            case 3:
                print("회원탈퇴")
            default:
                return
            }
        }
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
    
    private let pageBtn: UIButton = {
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
