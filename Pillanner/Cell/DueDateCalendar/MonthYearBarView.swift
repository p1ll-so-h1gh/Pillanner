//
//  MonthYearBarView.swift
//  Pillanner
//
//  Created by 박민정 on 3/4/24.
//

import UIKit
import SnapKit

protocol MonthYearBarViewDelegate: AnyObject {
    func didChangeMonth(monthIndex: Int, year: Int)
}

final class MonthYearBarView: UIView {
    private let labelButton1: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Down"), for: .normal)
        return button
    }()
    
    private let labelButton2: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Down"), for: .normal)
        return button
    }()
    
    private let monthLabelView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.backgroundColor = .white
        return view
    }()
    
    let monthLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = FontLiteral.title3(style: .bold).withSize(20)
        return label
    }()
    
    private let yearLabelView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.backgroundColor = .white
        return view
    }()
    
    let yearLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = FontLiteral.title3(style: .bold).withSize(20)
        return label
    }()
    
    private let buttonRightView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 19
        return view
    }()
    
    lazy var buttonRight: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "rightmove"), for: .normal)
        button.addTarget(self, action: #selector(buttonLeftRightAction(sender:)), for: .touchUpInside)
        return button
    }()
    
    private let buttonLeftView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 19
        return view
    }()
    
    lazy var buttonLeft: UIButton = {
        let button=UIButton()
        button.setImage(UIImage(named: "leftmove"), for: .normal)
        button.addTarget(self, action: #selector(buttonLeftRightAction(sender:)), for: .touchUpInside)
        button.setTitleColor(UIColor.lightGray, for: .disabled)
        return button
    }()
    
    private var monthsArr = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
    private var currentMonthIndex = 0
    private var currentYear: Int = 0
    var delegate: MonthYearBarViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        
        currentMonthIndex = Calendar.current.component(.month, from: Date()) - 1
        currentYear = Calendar.current.component(.year, from: Date())
        setupView()
        
        buttonLeft.isEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func buttonLeftRightAction(sender: UIButton) {
        if sender == buttonRight {
            currentMonthIndex += 1
            if currentMonthIndex > 11 {
                currentMonthIndex = 0
                currentYear += 1
            }
        } else {
            currentMonthIndex -= 1
            if currentMonthIndex < 0 {
                currentMonthIndex = 11
                currentYear -= 1
            }
        }
        monthLabel.text="\(monthsArr[currentMonthIndex])"
        yearLabel.text = "\(currentYear)"
        delegate?.didChangeMonth(monthIndex: currentMonthIndex, year: currentYear)
    }
    
    func setupView() {
        buttonLeftView.addSubview(buttonLeft)
        buttonLeft.snp.makeConstraints {
            $0.top.bottom.leading.trailing.centerX.centerY.equalToSuperview()
        }
        buttonRightView.addSubview(buttonRight)
        buttonRight.snp.makeConstraints {
            $0.top.bottom.leading.trailing.centerX.centerY.equalToSuperview()
        }
        monthLabelView.addSubview(monthLabel)
        monthLabelView.addSubview(labelButton1)
        monthLabel.snp.makeConstraints {
            $0.top.left.bottom.equalToSuperview().inset(3)
        }
        labelButton1.snp.makeConstraints {
            $0.left.equalTo(monthLabel.snp.right).inset(1)
            $0.top.bottom.right.equalToSuperview().inset(3)
            $0.size.equalTo(6)
        }
        yearLabelView.addSubview(yearLabel)
        yearLabelView.addSubview(labelButton2)
        yearLabel.snp.makeConstraints {
            $0.top.left.bottom.equalToSuperview().inset(3)
        }
        labelButton2.snp.makeConstraints {
            $0.left.equalTo(yearLabel.snp.right).inset(-1)
            $0.top.bottom.right.equalToSuperview().inset(3)
            $0.size.equalTo(6)
        }
        [buttonLeftView, monthLabelView, yearLabelView, buttonRightView].forEach {
            self.addSubview($0)
        }
        buttonLeftView.snp.makeConstraints {
            $0.size.equalTo(38)
            $0.leading.top.bottom.equalToSuperview()
        }
        monthLabelView.snp.makeConstraints {
            $0.left.equalTo(buttonLeftView.snp.right).inset(-70)
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(43)
        }
        monthLabel.text = "\(monthsArr[currentMonthIndex])"
        yearLabelView.snp.makeConstraints {
            $0.left.equalTo(monthLabelView.snp.right).inset(-3)
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(78)
        }
        yearLabel.text = "\(currentYear)"
        buttonRightView.snp.makeConstraints {
            $0.size.equalTo(38)
            $0.trailing.top.bottom.equalToSuperview()
        }
    }
}

