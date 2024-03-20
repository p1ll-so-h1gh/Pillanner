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
    func addDosage()
    
}

final class PillTableView: UITableView {
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    private var alarmStatus = [Bool]()
    private var dosage = [String]()
    private var unit = [String]()
    
//    private var intake = ["11:20", "12:20"]
//    private var alarmStatus = [true, false]
//    private var dosage = ["1", "2"]
//    private var unit = ["개", "정"]

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "섭취 설정"
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
        button.setTitle("복용 횟수 추가하기", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 439, height: 45)
        button.addTarget(self, action: #selector(goDosageAddVC), for: .touchUpInside)
        return button
    }()
    
    @objc func goDosageAddVC() {
        self.delegate?.addDosage()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.pillTableView.dataSource = self
        self.pillTableView.delegate = self
        self.pillTableView.rowHeight = UITableView.automaticDimension
//        self.pillTableView.reloadData()
        print("########", self.intake)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setupLayoutOnEditingProcess(alarm: Bool, intake: [String], dosage: String, unit: String) {
        
        self.infoLabel.text = "복용횟수 \(intake.count)회"
        
        self.intake = intake
        if self.alarmStatus == [false] {
            self.alarmStatus = [alarm]
            self.dosage = [dosage]
            self.unit = [unit]
        } else {
            self.alarmStatus.append(alarm)
            self.dosage.append(dosage)
            self.unit.append(unit)
        }
        print("##########", self.intake, self.alarmStatus, self.dosage, self.unit)
        
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
//            $0.height.greaterThanOrEqualTo(1)
            $0.height.equalTo(120)
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
    
    func setupLayout() {
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
//            $0.height.greaterThanOrEqualTo(1)
            $0.height.equalTo(120)
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
    }
    
    //cell 초기화 함수 - 테이블에 추가된 항목들 삭제하고 섭취횟수 0회로 초기화
    internal func reset() {
    }
}

extension IntakeSettingCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("####", self.intake.count)
        return self.intake.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IntakePillCell.identifier, for: indexPath) as! IntakePillCell
        print("#####", self.intake[indexPath.row], indexPath.row)
        cell.setupLayoutOnEditingProcess(intake: self.intake[indexPath.row],
                                         dosage: self.dosage[indexPath.row],
                                         unit: self.unit[indexPath.row],
                                         alarm: self.alarmStatus[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // 높이 동적으로 주지말고 그냥 고정? 아니면 처음 데이터 들어갔을 떄 높이 반영 안되는 부분 해결이 필요
        tableView.invalidateIntrinsicContentSize()
        tableView.layoutIfNeeded()
    }
}
