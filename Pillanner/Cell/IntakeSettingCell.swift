//
//  IntakeSettingCell.swift
//  Pillanner
//
//  Created by 박민정 on 2/29/24.
//

// ################################################################################################
// 섭취 설정은 할 떄 마다 dosage, unit을 결정하도록 하는 것이 아니라
// 횟수 추가 시에는 시간만 설정할 수 있도록 하고,
// 알람 여부, dosage, unit은 PillAdd, PillEdit, InitialSetting 뷰 에서 한 번만 설정할 수 있도록
// 수정이 필요
// ################################################################################################

import UIKit
import SnapKit

protocol IntakeSettingDelegate: AnyObject {
    func addIntake()
}

final class PillTableView: UITableView {
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var contentSize: CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        let height = self.contentSize.height + self.contentInset.top + self.contentInset.bottom
        return CGSize(width: self.contentSize.width, height: height)
    }
}

final class IntakeSettingCell: UITableViewCell {
    
    static let identifier = "IntakeSettingCell"
    private let sidePaddingSizeValue = 20
    private let cornerRadiusValue: CGFloat = 13
    weak var delegate: IntakeSettingDelegate?
    
    private var intake = [String]()
    private var alarmStatus = Bool()
    private var dosage = String()
    private var unit = String()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "시간 설정"
        label.font = FontLiteral.subheadline(style: .bold).withSize(18)
        label.alpha = 0.6
        return label
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = FontLiteral.body(style: .regular).withSize(16)
        return label
    }()
    
    private let pillTableView: PillTableView = {
        let tableview = PillTableView()
        tableview.register(IntakePillCell.self, forCellReuseIdentifier: IntakePillCell.identifier)
        tableview.separatorStyle = .none
        tableview.isScrollEnabled = true
        return tableview
    }()
    
    private lazy var intakeAddButtonView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = cornerRadiusValue
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray.cgColor
        view.backgroundColor = UIColor.white
        return view
    }()
    
    private lazy var intakeAddButton: UIButton = {
        let button = UIButton()
        button.setTitle("복용 알람 추가하기", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 439, height: 45)
        button.addTarget(self, action: #selector(goDosageAddVC), for: .touchUpInside)
        return button
    }()
    
    @objc func goDosageAddVC() {
        self.delegate?.addIntake()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.pillTableView.dataSource = self
        self.pillTableView.delegate = self
        self.pillTableView.rowHeight = UITableView.automaticDimension
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setupLayoutOnEditingProcess(intake: [String]) {
        
        self.infoLabel.text = "복용 횟수 \(intake.count)회"
        self.intake = intake
        
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(infoLabel)
        self.contentView.addSubview(pillTableView)
        self.contentView.addSubview(intakeAddButtonView)
        
        intakeAddButtonView.addSubview(intakeAddButton)
        
        self.titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(sidePaddingSizeValue)
            $0.left.equalToSuperview().inset(sidePaddingSizeValue)
            $0.height.equalTo(24)
        }
        self.infoLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(sidePaddingSizeValue)
            $0.right.equalToSuperview().inset(sidePaddingSizeValue)
        }
        self.pillTableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).inset(-10)
            $0.left.equalToSuperview().inset(sidePaddingSizeValue)
            $0.right.equalToSuperview().inset(sidePaddingSizeValue)
            $0.height.greaterThanOrEqualTo(1)
        }
        self.intakeAddButton.snp.makeConstraints {
            $0.top.bottom.leading.trailing.centerX.centerY.equalToSuperview()
        }
        self.intakeAddButtonView.snp.makeConstraints {
            $0.top.equalTo(self.pillTableView.snp.bottom).inset(-15)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(45)
            $0.width.equalTo(339)
            $0.bottom.equalToSuperview().inset(sidePaddingSizeValue)
        }
        self.pillTableView.reloadData()
    }
    
    //cell 초기화 함수 - 테이블에 추가된 항목들 삭제하고 섭취횟수 0회로 초기화
    internal func reset() {
    }
}

extension IntakeSettingCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.intake.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IntakePillCell.identifier, for: indexPath) as! IntakePillCell
        cell.setupLayoutOnEditingProcess(intake: self.intake[indexPath.row])
        // delegate 설정 필요
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.goDosageAddVC()
//    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableView.invalidateIntrinsicContentSize()
        tableView.layoutIfNeeded()
    }
}
