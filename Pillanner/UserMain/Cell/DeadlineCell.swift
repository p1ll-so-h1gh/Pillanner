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
        switchControl.tintColor = UIColor.mainThemeColor
        switchControl.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        return switchControl
    }()
    private let calendarView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    @objc func switchValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            self.contentView.addSubview(calendarView)
            self.contentView.snp.makeConstraints {
                $0.top.equalTo(titleLabel.snp.bottom).inset(-10)
                $0.left.equalToSuperview().inset(10)
            }
        } else {
            self.contentView.removeFromSuperview()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setupLayout()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    private func setupLayout() {
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(popswitch)
        self.titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.left.equalToSuperview().inset(16)
        }
        self.popswitch.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.right.equalToSuperview().inset(16)
        }
    }
}

