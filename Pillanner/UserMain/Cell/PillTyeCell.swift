//
//  PillTyeCell.swift
//  Pillanner
//
//  Created by 박민정 on 2/29/24.
//

import UIKit
import SnapKit

final class PillTyeCell: UITableViewCell {
    static let id = "PillTyeCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "일반 / 처방"
        label.font = FontLiteral.subheadline(style: .bold).withSize(18)
        label.alpha = 0.6
        return label
    }()
    lazy private var typesegCon: UISegmentedControl = {
        let control = UISegmentedControl(items: array)
        control.backgroundColor = UIColor(hexCode: "E6E6E6")
        control.selectedSegmentTintColor = UIColor.mainThemeColor
        control.addTarget(self, action: #selector(segconChanged(segcon:)), for: UIControl.Event.valueChanged)
        control.setWidth(150, forSegmentAt: 0)
        control.setWidth(150, forSegmentAt: 1)
        return control
    }()
    @objc func segconChanged(segcon: UISegmentedControl) {
        //이후 저장 작업
    }
    
    private let array: [String] = ["일반", "처방"]
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setupLayout()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupLayout() {
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.typesegCon)
        self.titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.left.equalToSuperview().inset(16)
        }
        self.typesegCon.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).inset(-20)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(35)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
    
}
