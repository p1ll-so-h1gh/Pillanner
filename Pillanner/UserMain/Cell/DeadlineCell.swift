//
//  DeadlineCell.swift
//  Pillanner
//
//  Created by 박민정 on 2/29/24.
//

import UIKit
import SnapKit
import FSCalendar

final class DeadlineCell: UITableViewCell {
    static let id = "DeadlineCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "데드라인"
        label.font = FontLiteral.subheadline(style: .bold).withSize(18)
        label.alpha = 0.6
        return label
    }()
    private let popswitch: UISwitch = {
        let switchControl = UISwitch()
        switchControl.thumbTintColor = UIColor.mainThemeColor
        switchControl.onTintColor = UIColor(hexCode: "F0EFEF")
        switchControl.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        return switchControl
    }()
    private let calendarView: CalendarView = {
        let view = CalendarView()
        return view
    }()
    @objc func switchValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            self.calendarView.isHidden = false
        } else {
            self.calendarView.isHidden = true
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setupLayout()
        self.calendarView.isHidden = true
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    private func setupLayout() {
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(popswitch)
        self.contentView.addSubview(calendarView)
        self.titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.left.equalToSuperview().inset(16)
        }
        self.popswitch.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.right.equalToSuperview().inset(16)
        }
        self.calendarView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).inset(-20)
            $0.left.bottom.equalToSuperview().inset(20)
            $0.width.equalTo(351)
            $0.height.equalTo(318)
        }
    }
}

