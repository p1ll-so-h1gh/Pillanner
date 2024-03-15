//
//  IntakePillCell.swift
//  Pillanner
//
//  Created by 박민정 on 3/4/24.
//

import UIKit
import SnapKit

class IntakePillCell: UITableViewCell {
    static let identifier = "IntakePillCell"
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = FontLiteral.body(style: .regular).withSize(18)
        label.alpha = 0.7
        return label
    }()
    
    let alarmLabel: UILabel = {
        let label = UILabel()
        label.font = FontLiteral.body(style: .bold).withSize(14)
        label.alpha = 0.6
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
//        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setupLayoutOnEditingProcess(intake: String) {
        self.timeLabel.text = "\(intake)"
        
        self.contentView.addSubview(timeLabel)
        self.contentView.addSubview(alarmLabel)
        self.contentView.addSubview(editBtn)
        timeLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.left.equalToSuperview().inset(6)
        }
        alarmLabel.snp.makeConstraints {
            $0.centerY.equalTo(timeLabel.snp.centerY)
            $0.right.equalTo(editBtn.snp.left).inset(-5)
        }
        editBtn.snp.makeConstraints {
            $0.centerY.equalTo(timeLabel.snp.centerY)
            $0.right.equalToSuperview().inset(6)
        }
    }
    
    func setupLayout() {
        self.contentView.addSubview(timeLabel)
        self.contentView.addSubview(alarmLabel)
        self.contentView.addSubview(editBtn)
        timeLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.left.equalToSuperview().inset(6)
        }
        alarmLabel.snp.makeConstraints {
            $0.centerY.equalTo(timeLabel.snp.centerY)
            $0.right.equalTo(editBtn.snp.left).inset(-5)
        }
        editBtn.snp.makeConstraints {
            $0.centerY.equalTo(timeLabel.snp.centerY)
            $0.right.equalToSuperview().inset(6)
        }
    }
}
