//
//  PillCell.swift
//  Pillanner
//
//  Created by 박민정 on 2/29/24.
//

import UIKit
import SnapKit
import SwiftUI

final class PillCell: UITableViewCell {
    static let id = "PillCell"
    
    private let pillnameLabel: UILabel = {
        let label = UILabel()
        label.text = "제품명"
        label.font = FontLiteral.subheadline(style: .bold).withSize(18)
        label.alpha = 0.6
        return label
    }()
    private let pillnametext = UITextField()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setupLayout()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    private func setupLayout() {
        self.contentView.addSubview(self.pillnameLabel)
        self.contentView.addSubview(self.pillnametext)
        self.pillnameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.left.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(20)
        }
        self.pillnametext.snp.makeConstraints {
            $0.left.equalTo(self.pillnameLabel.snp.right).offset(8)
            $0.right.lessThanOrEqualToSuperview().inset(16)
        }
    }
}
