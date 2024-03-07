//
//  IntakeSettingCell.swift
//  Pillanner
//
//  Created by 박민정 on 2/29/24.
//

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
    static let id = "IntakeSettingCell"
    private let sidePaddingSizeValue = 20
    private let cornerRadiusValue: CGFloat = 13
    weak var delegate: IntakeSettingDelegate?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "섭취 설정"
        label.font = FontLiteral.subheadline(style: .bold).withSize(18)
        label.alpha = 0.6
        return label
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "섭취횟수 3회"
        label.font = FontLiteral.body(style: .regular).withSize(16)
        return label
    }()
    
    private let pillTableView: PillTableView = {
        let tableview = PillTableView()
        tableview.register(IntakePillCell.self, forCellReuseIdentifier: IntakePillCell.id)
        tableview.separatorStyle = .none
        tableview.isScrollEnabled = true
        return tableview
    }()
    
    private lazy var intakeaddBtnView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = cornerRadiusValue
        view.backgroundColor = UIColor.mainThemeColor
        return view
    }()
    
    private lazy var intakeaddBtn: UIButton = {
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
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupLayout() {
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(infoLabel)
        self.contentView.addSubview(pillTableView)
        self.contentView.addSubview(intakeaddBtnView)
        intakeaddBtnView.addSubview(intakeaddBtn)
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
        self.intakeaddBtn.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        self.intakeaddBtnView.snp.makeConstraints {
            $0.top.equalTo(self.pillTableView.snp.bottom).inset(-15)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(45)
            $0.width.equalTo(339)
            $0.bottom.equalToSuperview().inset(sidePaddingSizeValue)
        }
    }
}

extension IntakeSettingCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IntakePillCell.id, for: indexPath) as! IntakePillCell
        cell.timeLabel.text = "오전 11시 1정"
        cell.alarmLabel.text = "알림 ON"
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableView.invalidateIntrinsicContentSize()
        tableView.layoutIfNeeded()
    }
}
