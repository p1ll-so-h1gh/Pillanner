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

class MonthYearBarView: UIView {
    private let labelBtn1: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Down"), for: .normal)
        return button
    }()
    private let labelBtn2: UIButton = {
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
    private let btnRightView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 19
        return view
    }()
    lazy var btnRight: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "rightmove"), for: .normal)
        button.addTarget(self, action: #selector(btnLeftRightAction(sender:)), for: .touchUpInside)
        return button
    }()
    private let btnLeftView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 19
        return view
    }()
    lazy var btnLeft: UIButton = {
        let button=UIButton()
        button.setImage(UIImage(named: "leftmove"), for: .normal)
        button.addTarget(self, action: #selector(btnLeftRightAction(sender:)), for: .touchUpInside)
        button.setTitleColor(UIColor.lightGray, for: .disabled)
        return button
    }()
    var monthsArr = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
    var currentMonthIndex = 0
    var currentYear: Int = 0
    var delegate: MonthYearBarViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        
        currentMonthIndex = Calendar.current.component(.month, from: Date()) - 1
        currentYear = Calendar.current.component(.year, from: Date())
        setupView()
        
        btnLeft.isEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func btnLeftRightAction(sender: UIButton) {
        if sender == btnRight {
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
        btnLeftView.addSubview(btnLeft)
        btnLeft.snp.makeConstraints {
            $0.top.bottom.leading.trailing.centerX.centerY.equalToSuperview()
        }
        btnRightView.addSubview(btnRight)
        btnRight.snp.makeConstraints {
            $0.top.bottom.leading.trailing.centerX.centerY.equalToSuperview()
        }
        monthLabelView.addSubview(monthLabel)
        monthLabelView.addSubview(labelBtn1)
        monthLabel.snp.makeConstraints {
            $0.top.left.bottom.equalToSuperview().inset(3)
        }
        labelBtn1.snp.makeConstraints {
            $0.left.equalTo(monthLabel.snp.right).inset(1)
            $0.top.bottom.right.equalToSuperview().inset(3)
        }
        yearLabelView.addSubview(yearLabel)
        yearLabelView.addSubview(labelBtn2)
        yearLabel.snp.makeConstraints {
            $0.top.left.bottom.equalToSuperview().inset(3)
        }
        labelBtn2.snp.makeConstraints {
            $0.left.equalTo(yearLabel.snp.right).inset(-1)
            $0.top.bottom.right.equalToSuperview().inset(3)
        }
        [btnLeftView, monthLabelView, yearLabelView, btnRightView].forEach {
            self.addSubview($0)
        }
        btnLeftView.snp.makeConstraints {
            $0.size.equalTo(38)
            $0.leading.top.bottom.equalToSuperview()
        }
        monthLabelView.snp.makeConstraints {
            $0.left.equalTo(btnLeftView.snp.right).inset(-70)
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
        btnRightView.snp.makeConstraints {
            $0.size.equalTo(38)
            $0.trailing.top.bottom.equalToSuperview()
        }
        
    }

}

