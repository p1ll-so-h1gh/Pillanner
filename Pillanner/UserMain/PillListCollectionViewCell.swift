//
//  PillListTableViewCell.swift
//  Pillanner
//
//  Created by 박민정 on 2/27/24.
//

import UIKit
import SnapKit

protocol PillListViewDelegate: AnyObject {
    func editPill(pillData: Pill)
    func deletePill(pillData: String)
}

// 데이터받아서 셀 그려주는 함수 구현 필요

class PillListCollectionViewCell: UICollectionViewCell {
    
    static let id = "PillListCollectionViewCell"
    weak var pillListViewDelegate: PillListViewDelegate?
    
    let typeLabelView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = UIColor.pointThemeColor3
        return view
    }()
    
    private lazy var typeLabel: UILabel = {
        let label = UILabel()
        label.font = FontLiteral.body(style: .bold).withSize(14)
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = FontLiteral.body(style: .bold).withSize(18)
        label.alpha = 0.8
        return label
    }()
    
    private let alarmImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "clock")
        return image
    }()
    
    private lazy var alarmLabel: UILabel = {
        let label = UILabel()
        label.font = FontLiteral.body(style: .regular).withSize(12)
        label.alpha = 0.5
        return label
    }()
    
    private let alarmStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        return stackView
    }()
    
    private let pillnumImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "pill_gray")
        return image
    }()
    
    private lazy var pillnumLabel: UILabel = {
        let label = UILabel()
        label.font = FontLiteral.body(style: .regular).withSize(12)
        label.alpha = 0.5
        return label
    }()
    
    private let pillStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        return stackView
    }()
    
    private let editButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "dots"), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
//        configureButton(title: "유산균")
    }
    
    func configureCell(with pill: Pill) {
        self.nameLabel.text = pill.title
        self.typeLabel.text = pill.type
        self.alarmLabel.text = pill.alarmStatus ? "on" : "off"
        self.pillnumLabel.text = "하루 \(pill.dosage)정" // 복용단위 업데이트
        configureButton(title: pill.title)
    }

    // pill name 대신 pill data 넘겨서 사용할 수 있도록 수정해야 됨
    private func configureButton(title: String) {
        let edit = UIAction(title: "수정", state: .off) { _ in
            DataManager.shared.readPillData(pillTitle: title) { pillData in
                if let pillData = pillData {
                    print(pillData)
                    let pill = Pill(title: pillData["Title"] as? String ?? "ftitle",
                                    type: pillData["Type"] as? String ?? "ftype",
                                    day: pillData["Day"] as? [String] ?? ["fday"],
                                    dueDate: pillData["DueDate"] as? String ?? "fduedate",
                                    intake: pillData["Intake"] as? [String] ?? ["fintake"],
                                    dosage: pillData["Dosage"] as? String ?? "fdosage",
                                    alarmStatus: pillData["AlarmStatus"] as? Bool ?? true)
                    self.pillListViewDelegate?.editPill(pillData: pill)
                }
            }

//            guard let pillname = self.nameLabel.text else { return }
//            self.pillListViewDelegate?.editPill(pillData: pillname)
        }
        let delete = UIAction(title: "삭제", state: .off) { _ in
            guard let pillname = self.nameLabel.text else { return }
            self.pillListViewDelegate?.deletePill(pillData: pillname)
        }
        let menu = UIMenu(title: "", options: .displayInline, children: [edit, delete])
        editButton.menu = menu
        editButton.showsMenuAsPrimaryAction = true
        editButton.changesSelectionAsPrimaryAction = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        typeLabelView.addSubview(typeLabel)
        
        [alarmImage, alarmLabel].forEach {
            alarmStackView.addArrangedSubview($0)
        }
        [pillnumImage, pillnumLabel].forEach {
            pillStackView.addArrangedSubview($0)
        }
        [typeLabelView, nameLabel, alarmStackView, pillStackView, editButton].forEach {
            self.contentView.addSubview($0)
        }
        typeLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(6)
            $0.right.equalToSuperview().inset(6)
            $0.top.equalToSuperview().inset(3)
            $0.bottom.equalToSuperview().inset(3)
        }
        typeLabelView.snp.makeConstraints {
            $0.left.equalToSuperview().inset(10)
            $0.top.equalToSuperview().inset(15)
        }
        nameLabel.snp.makeConstraints {
            $0.centerY.equalTo(typeLabelView.snp.centerY)
            $0.left.equalTo(typeLabelView.snp.right).inset(-12)
            $0.top.equalToSuperview().inset(7)
        }
        alarmStackView.snp.makeConstraints {
            $0.leading.equalTo(nameLabel.snp.leading)
            $0.top.equalTo(nameLabel.snp.bottom).inset(-5)
            $0.bottom.equalToSuperview().inset(6)
        }
        pillStackView.snp.makeConstraints {
            $0.left.equalTo(alarmStackView.snp.right).inset(-15)
            $0.centerY.equalTo(alarmStackView.snp.centerY)
            $0.bottom.equalToSuperview().inset(6)
        }
        editButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(5)
            $0.top.equalToSuperview().inset(7)
        }
    }
}
