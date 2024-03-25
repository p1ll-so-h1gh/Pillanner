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
    
    private let editButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "button"), for: .normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setupLayoutOnEditingProcess(intake: String, dosage: String, unit: String, alarm: Bool) {
        
//        self.timeLabel.text = "\(intake) \(dosage)\(unit)"
        self.timeLabel.text = "\(intake)"
        if alarm {
            self.alarmLabel.text = "알람 ON"
            self.alarmLabel.textColor = .pointThemeColor2
        } else {
            self.alarmLabel.text = "알람 OFF"
        }
//        self.alarmLabel.text = "알림 \(alarm)"
        
        self.contentView.addSubview(timeLabel)
        self.contentView.addSubview(alarmLabel)
        self.contentView.addSubview(editButton)
        timeLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.left.equalToSuperview().inset(6)
        }
        alarmLabel.snp.makeConstraints {
            $0.centerY.equalTo(timeLabel.snp.centerY)
            $0.right.equalTo(editButton.snp.left).inset(-5)
        }
        editButton.snp.makeConstraints {
            $0.centerY.equalTo(timeLabel.snp.centerY)
            $0.right.equalToSuperview().inset(6)
        }
    }
    
    func setupLayout() {
        self.contentView.addSubview(timeLabel)
        self.contentView.addSubview(alarmLabel)
        self.contentView.addSubview(editButton)
        timeLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.left.equalToSuperview().inset(6)
        }
        alarmLabel.snp.makeConstraints {
            $0.centerY.equalTo(timeLabel.snp.centerY)
            $0.right.equalTo(editButton.snp.left).inset(-5)
        }
        editButton.snp.makeConstraints {
            $0.centerY.equalTo(timeLabel.snp.centerY)
            $0.right.equalToSuperview().inset(6)
        }
    }
}
