//
//  IntakePillCell.swift
//  Pillanner
//
//  Created by 박민정 on 3/4/24.
//

import UIKit
import SnapKit

class IntakePillCell: UITableViewCell {
    static let id = "IntakePillCell"
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = FontLiteral.body(style: .regular).withSize(18)
        return label
    }()
    let alarmLabel: UILabel = {
        let label = UILabel()
        label.font = FontLiteral.body(style: .bold).withSize(14)
        return label
    }()
    private let editBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "button"), for: .normal)
        return button
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setupLayout()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    private func setupLayout() {
        self.contentView.addSubview(dateLabel)
        self.contentView.addSubview(alarmLabel)
        self.contentView.addSubview(editBtn)
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(5)
            $0.left.equalToSuperview().inset(6)
            $0.bottom.equalToSuperview().inset(5)
        }
        alarmLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(5)
            $0.right.equalTo(editBtn.snp.left).inset(-5)
        }
        editBtn.snp.makeConstraints {
            $0.top.equalToSuperview().inset(5)
            $0.right.equalToSuperview().inset(5)
        }
    }
}
