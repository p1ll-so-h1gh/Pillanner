//
//  IntakeDateCell.swift
//  Pillanner
//
//  Created by 박민정 on 2/29/24.
//

import UIKit
import SnapKit

// 복용 날짜 데이터 받아와서 라벨 색칠된 상태로 표시될 수 있도록

protocol IntakeDateCellDelegate: AnyObject {
    func updateDays(_ days: [String])
}

final class IntakeDateCell: UITableViewCell {
    
    private var selectedDate = [String]()
    static let identifier = "IntakeDateCell"
    private let sidePaddingSizeValue = 20
    private let cornerRadiusValue: CGFloat = 13
    
    private let intakedateLabel: UILabel = {
        let label = UILabel()
        label.text = "섭취 요일"
        label.font = FontLiteral.subheadline(style: .bold).withSize(18)
        label.alpha = 0.6
        return label
    }()
    
    private let editButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "button"), for: .normal)
        return button
    }()
    
    private let HorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 15
        return stackView
    }()
    
    private lazy var monView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexCode: "E6E6E6")
        view.layer.cornerRadius = cornerRadiusValue
        return view
    }()
    
    private let monLabel: UILabel = {
        let label = UILabel()
        label.text = "월"
        label.font = FontLiteral.body(style: .regular).withSize(14)
        label.frame = CGRect(x: 0, y: 0, width: 33, height: 33)
        return label
    }()
    
    private lazy var tueView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexCode: "E6E6E6")
        view.layer.cornerRadius = cornerRadiusValue
        return view
    }()
    
    private let tueLabel: UILabel = {
        let label = UILabel()
        label.text = "화"
        label.font = FontLiteral.body(style: .regular).withSize(14)
        label.frame = CGRect(x: 0, y: 0, width: 33, height: 33)
        return label
    }()
    
    private lazy var wedView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexCode: "E6E6E6")
        view.layer.cornerRadius = cornerRadiusValue
        return view
    }()
    
    private let wedLabel: UILabel = {
        let label = UILabel()
        label.text = "수"
        label.font = FontLiteral.body(style: .regular).withSize(14)
        label.frame = CGRect(x: 0, y: 0, width: 33, height: 33)
        return label
    }()
    
    private lazy var thuView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexCode: "E6E6E6")
        view.layer.cornerRadius = cornerRadiusValue
        return view
    }()
    
    private let thuLabel: UILabel = {
        let label = UILabel()
        label.text = "목"
        label.font = FontLiteral.body(style: .regular).withSize(14)
        label.frame = CGRect(x: 0, y: 0, width: 33, height: 33)
        return label
    }()
    
    private lazy var friView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexCode: "E6E6E6")
        view.layer.cornerRadius = cornerRadiusValue
        return view
    }()
    
    private let friLabel: UILabel = {
        let label = UILabel()
        label.text = "금"
        label.font = FontLiteral.body(style: .regular).withSize(14)
        label.frame = CGRect(x: 0, y: 0, width: 33, height: 33)
        return label
    }()
    
    private lazy var satView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexCode: "E6E6E6")
        view.layer.cornerRadius = cornerRadiusValue
        return view
    }()
    
    private let satLabel: UILabel = {
        let label = UILabel()
        label.text = "토"
        label.font = FontLiteral.body(style: .regular).withSize(14)
        label.frame = CGRect(x: 0, y: 0, width: 33, height: 33)
        return label
    }()
    
    private lazy var sunView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexCode: "E6E6E6")
        view.layer.cornerRadius = cornerRadiusValue
        return view
    }()
    
    private let sunLabel: UILabel = {
        let label = UILabel()
        label.text = "일"
        label.font = FontLiteral.body(style: .regular).withSize(14)
        label.frame = CGRect(x: 0, y: 0, width: 33, height: 33)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        //        self.setupLayout()
        
        self.checkWeekdayViewWithIntakeData(days: selectedDate)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func checkWeekdayViewWithIntakeData(days: [String]) {
        print("####################### \(days)")
        for day in days {
            if day == "Mon" {
                monView.backgroundColor = .pointThemeColor2
            } else if day == "Tue" {
                tueView.backgroundColor = .pointThemeColor2
            } else if day == "Wed" {
                wedView.backgroundColor = .pointThemeColor2
            } else if day == "Thu" {
                thuView.backgroundColor = .pointThemeColor2
            } else if day == "Fri" {
                friView.backgroundColor = .pointThemeColor2
            } else if day == "Sat" {
                satView.backgroundColor = .pointThemeColor2
            } else if day == "Sun" {
                sunView.backgroundColor = .pointThemeColor2
            }
        }
    }
    
    func setupLayoutOnEditingProcess(days: [String]) {
        
        checkWeekdayViewWithIntakeData(days: days)
        
        [intakedateLabel, editButton, HorizontalStackView].forEach {
            self.contentView.addSubview($0)
        }
        monView.addSubview(monLabel)
        tueView.addSubview(tueLabel)
        wedView.addSubview(wedLabel)
        thuView.addSubview(thuLabel)
        friView.addSubview(friLabel)
        satView.addSubview(satLabel)
        sunView.addSubview(sunLabel)
        [monView, tueView, wedView, thuView, friView, satView, sunView].forEach {
            self.HorizontalStackView.addArrangedSubview($0)
        }
        self.monLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.left.right.equalToSuperview().inset(10)
        }
        self.tueLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.left.right.equalToSuperview().inset(10)
        }
        self.wedLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.left.right.equalToSuperview().inset(10)
        }
        self.thuLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.left.right.equalToSuperview().inset(10)
        }
        self.friLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.left.right.equalToSuperview().inset(10)
        }
        self.satLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.left.right.equalToSuperview().inset(10)
        }
        self.sunLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.left.right.equalToSuperview().inset(10)
        }
        self.intakedateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(sidePaddingSizeValue)
            $0.left.equalToSuperview().inset(sidePaddingSizeValue)
        }
        self.editButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(sidePaddingSizeValue)
            $0.right.equalToSuperview().inset(sidePaddingSizeValue)
        }
        self.HorizontalStackView.snp.makeConstraints {
            $0.top.equalTo(intakedateLabel.snp.bottom).inset(-sidePaddingSizeValue)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(sidePaddingSizeValue)
        }
    }
    
    func setupLayout() {
        [intakedateLabel, editButton, HorizontalStackView].forEach {
            self.contentView.addSubview($0)
        }
        monView.addSubview(monLabel)
        tueView.addSubview(tueLabel)
        wedView.addSubview(wedLabel)
        thuView.addSubview(thuLabel)
        friView.addSubview(friLabel)
        satView.addSubview(satLabel)
        sunView.addSubview(sunLabel)
        [monView, tueView, wedView, thuView, friView, satView, sunView].forEach {
            self.HorizontalStackView.addArrangedSubview($0)
        }
        self.monLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.left.right.equalToSuperview().inset(10)
        }
        self.tueLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.left.right.equalToSuperview().inset(10)
        }
        self.wedLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.left.right.equalToSuperview().inset(10)
        }
        self.thuLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.left.right.equalToSuperview().inset(10)
        }
        self.friLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.left.right.equalToSuperview().inset(10)
        }
        self.satLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.left.right.equalToSuperview().inset(10)
        }
        self.sunLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.left.right.equalToSuperview().inset(10)
        }
        self.intakedateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(sidePaddingSizeValue)
            $0.left.equalToSuperview().inset(sidePaddingSizeValue)
        }
        self.editButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(sidePaddingSizeValue)
            $0.right.equalToSuperview().inset(sidePaddingSizeValue)
        }
        self.HorizontalStackView.snp.makeConstraints {
            $0.top.equalTo(intakedateLabel.snp.bottom).inset(-sidePaddingSizeValue)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(sidePaddingSizeValue)
        }
    }
    
    //cell 초기화 함수 - 색깔이 변한 섭취요일 다시 원상복구
    internal func reset() {
    }
}

//extension IntakeDateCell: WeekdaySelectionDelegate {
//    func updateIntakeDate(_ date: [String]) {
//        print(#function, self.selectedDate)
//        self.selectedDate = date
//    }
//}
