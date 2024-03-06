//
//  PillListTableViewCell.swift
//  Pillanner
//
//  Created by 박민정 on 2/27/24.
//

import UIKit
import SnapKit

class PillListCollectionViewCell: UICollectionViewCell {
    static let id = "PillListCollectionViewCell"
    
    let typeLabelView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = UIColor.pointThemeColor3
        return view
    }()
    let typeLabel: UILabel = {
        let label = UILabel()
        label.font = FontLiteral.body(style: .bold).withSize(14)
        return label
    }()
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = FontLiteral.body(style: .bold).withSize(18)
        label.alpha = 0.8
        return label
    }()
    private let alarmImg: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "clock")
        return image
    }()
    let alarmLabel: UILabel = {
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
    private let pillnumImg: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Pin")
        return image
    }()
    let pillnumLabel: UILabel = {
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
    private let editBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "dots"), for: .normal)
        
        let edit = UIAction(title: "수정", state: .off) { _ in
            print("수정")
        }
        let delete = UIAction(title: "삭제", state: .off) { _ in
            print("삭제")
        }
        let menu = UIMenu(title: "", options: .displayInline, children: [edit, delete])
        button.menu = menu
        button.showsMenuAsPrimaryAction = true
        button.changesSelectionAsPrimaryAction = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupLayout() {
        typeLabelView.addSubview(typeLabel)
        
        [alarmImg, alarmLabel].forEach {
            alarmStackView.addArrangedSubview($0)
        }
        [pillnumImg, pillnumLabel].forEach {
            pillStackView.addArrangedSubview($0)
        }
        [typeLabelView, nameLabel, alarmStackView, pillStackView, editBtn].forEach {
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
            $0.left.equalTo(typeLabelView.snp.right).inset(-10)
            $0.top.equalToSuperview().inset(7)
        }
        alarmStackView.snp.makeConstraints {
            $0.left.equalToSuperview().inset(40)
            $0.top.equalTo(nameLabel.snp.bottom).inset(-8)
            $0.bottom.equalToSuperview().inset(6)
        }
        pillStackView.snp.makeConstraints {
            $0.left.equalTo(alarmStackView.snp.right).inset(-15)
            $0.centerY.equalTo(alarmStackView.snp.centerY)
            $0.bottom.equalToSuperview().inset(6)
        }
        editBtn.snp.makeConstraints {
            $0.right.equalToSuperview().inset(5)
            $0.top.equalToSuperview().inset(7)
        }
    }
}