//
//  WeekdaysView.swift
//  Pillanner
//
//  Created by 박민정 on 3/4/24.
//

import UIKit
import SnapKit

class WeekdaysView: UIView {
    
    let weekStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(weekStackView)
        weekStackView.snp.makeConstraints {
            $0.top.left.right.bottom.equalToSuperview()
        }
        
        let daysArr = ["일", "월", "화", "수", "목", "금", "토"]
        for i in 0..<7 {
            let label = UILabel()
            label.text = daysArr[i]
            label.textAlignment = .center
            weekStackView.addArrangedSubview(label)
        }
    }
}
