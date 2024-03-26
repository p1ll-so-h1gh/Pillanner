//
//  DeadlineCell.swift
//  Pillanner
//
//  Created by 박민정 on 2/29/24.
//

import UIKit
import SnapKit
import FSCalendar

// 날짜 눌렀을 때 반환값 필요 ("yyyy-MM-dd" string값)

protocol DueDateCellDelegate: AnyObject {
    func updateDueDateCellHeight()
    func updateDueDate(date: String)
}

final class DueDateCell: UITableViewCell {
    static let identifier = "DeadlineCell"
    private let sidePaddingSizeValue = 20
    
    weak var delegate: DueDateCellDelegate?
    
    private let topView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "복용 기한"
        label.font = FontLiteral.subheadline(style: .bold).withSize(18)
        label.alpha = 0.6
        return label
    }()
    
    private lazy var popSwitch: UISwitch = {
        let switchControl = UISwitch()
        switchControl.onTintColor = UIColor.pointThemeColor2
        switchControl.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        return switchControl
    }()
    
    private let calendarView: CalendarView = {
        let view = CalendarView()
        return view
    }()
    
    private let verticalStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 10
        return view
    }()
    
    @objc func switchValueChanged(_ sender: UISwitch) {
        self.calendarView.isHidden = !sender.isOn
        self.delegate?.updateDueDateCellHeight()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.calendarView.isHidden = true
        self.calendarView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setupLayoutOnEditingProcess(dueDate: String) {
        
        self.topView.addSubview(titleLabel)
        self.topView.addSubview(popSwitch)
        self.verticalStackView.addArrangedSubview(topView)
        self.verticalStackView.addArrangedSubview(calendarView)
        self.contentView.addSubview(verticalStackView)
        self.titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(sidePaddingSizeValue)
            $0.height.equalTo(24)
            $0.width.equalTo(84)
        }
        self.popSwitch.snp.makeConstraints {
            $0.top.right.bottom.equalToSuperview().inset(sidePaddingSizeValue)
            $0.height.equalTo(28)
            $0.width.equalTo(55)
        }
        self.calendarView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(sidePaddingSizeValue)
            $0.width.equalTo(351)
            //            $0.height.equalTo(320)
        }
        self.verticalStackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(sidePaddingSizeValue)
        }
    }
    
    //cell 초기화 함수 - 스위치 off 시키고 캘린더 선택된 날 안보이게 하기
    internal func reset() {
    }
}

//collection에서 받은 데이터 다시 또 DueDateCell의 delegate로 연결
extension DueDateCell: CalendarCollectionDelegate {
    func sendDateData(date: String) {
        self.delegate?.updateDueDate(date: date)
    }
}
