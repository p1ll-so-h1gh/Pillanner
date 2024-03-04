//
//  IntakeSettingCell.swift
//  Pillanner
//
//  Created by 박민정 on 2/29/24.
//

import UIKit
import SnapKit

final class IntakeSettingCell: UITableViewCell {
    static let id = "IntakeSettingCell"
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "섭취 설정"
        label.font = FontLiteral.subheadline(style: .bold).withSize(18)
        label.alpha = 0.6
        return label
    }()
    let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "섭취횟수 3회"
        label.font = FontLiteral.body(style: .regular).withSize(16)
        return label
    }()
    //사이에 테이블 뷰 넣어줘야 함
    let intakeaddBtnView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = UIColor.mainThemeColor
        return view
    }()
    let intakeaddBtn: UIButton = {
        let button = UIButton()
        button.setTitle("복용 횟수 추가하기", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 439, height: 45)
        return button
    }()
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
        self.contentView.addSubview(infoLabel)
        self.contentView.addSubview(intakeaddBtnView)
        intakeaddBtnView.addSubview(intakeaddBtn)
        self.titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.left.equalToSuperview().inset(16)
        }
        self.infoLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.right.equalToSuperview().inset(20)
        }
        self.intakeaddBtn.snp.makeConstraints {
            $0.top.equalToSuperview().inset(1)
            $0.bottom.equalToSuperview().inset(1)
            $0.left.equalToSuperview().inset(80)
            $0.right.equalToSuperview().inset(80)
        }
        self.intakeaddBtnView.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).inset(-20)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(20)
        }
    }
}
