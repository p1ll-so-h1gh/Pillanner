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
    
    func setupLayoutOnEditingProcess(intake: String) {
        self.timeLabel.text = "\(intake)"
        self.contentView.addSubview(timeLabel)
        self.contentView.addSubview(editButton)
        
        timeLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.left.equalToSuperview().inset(6)
        }
        editButton.snp.makeConstraints {
            $0.centerY.equalTo(timeLabel.snp.centerY)
            $0.right.equalToSuperview().inset(6)
        }
    }
    
    @objc private func editButtonTapped() {
        // 구현 필요
    }
}
