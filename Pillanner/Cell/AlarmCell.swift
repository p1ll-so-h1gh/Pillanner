//
//  AlarmCell.swift
//  Pillanner
//
//  Created by 박민정 on 3/25/24.
//

import UIKit
import SnapKit

protocol AlarmCellDelegate: AnyObject {
    func updateAlarmStatus(status: Bool)
}

final class AlarmCell: UITableViewCell {
    
    static let identifier = "AlarmCell"
    private let sidePaddingSizeValue = 20
    
    weak var delegate: AlarmCellDelegate?
    
    private let alarmSettingLabel: UILabel = {
        let label = UILabel()
        label.text = "알람설정"
        label.font = FontLiteral.subheadline(style: .bold).withSize(18)
        label.frame = CGRect(x: 0, y: 0, width: 50, height: 24)
        label.alpha = 0.6
        return label
    }()
    
    private let alarmStatusLabel: UILabel = {
        let label = UILabel()
        label.font = FontLiteral.body(style: .bold)
        label.textColor = UIColor.pointThemeColor2
        label.text = "off"
        return label
    }()
    
    private lazy var alarmToggle: UISwitch = {
        let control = UISwitch()
        control.onTintColor = UIColor.pointThemeColor2
        control.addTarget(self, action: #selector(alarmToggleChanged), for: .valueChanged)
        return control
    }()
    
    // 토글 액션 줄 때 상태 레이블 업데이트 함수 호출
    @objc func alarmToggleChanged(_ toggle: UISwitch) {
        updateAlarmStatusLabel(isOn: toggle.isOn)
        self.delegate?.updateAlarmStatus(status: toggle.isOn)
    }
    
    // 토글에 따라 상태 레이블 업데이트
    private func updateAlarmStatusLabel(isOn: Bool) {
        alarmStatusLabel.text = isOn ? "on" : "off"
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setupLayoutOnEditingProcess(alarmStatus: Bool) {
        if alarmStatus == true {
            self.alarmToggle.isOn = true
        } else {
            self.alarmToggle.isOn = false
        }
        
        self.contentView.addSubview(alarmSettingLabel)
        self.contentView.addSubview(alarmStatusLabel)
        self.contentView.addSubview(alarmToggle)
        
        alarmSettingLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(sidePaddingSizeValue)
            $0.top.bottom.equalToSuperview().inset(sidePaddingSizeValue)
        }
        alarmStatusLabel.snp.makeConstraints {
            $0.leading.equalTo(alarmSettingLabel.snp.trailing).offset(10)
            $0.centerY.equalTo(alarmSettingLabel.snp.centerY)
        }
        alarmToggle.snp.makeConstraints {
            $0.centerY.equalTo(alarmSettingLabel.snp.centerY)
            $0.trailing.equalToSuperview().inset(sidePaddingSizeValue)
        }
    }
    
}
