//
//  IntakeDateCell.swift
//  Pillanner
//
//  Created by 박민정 on 2/29/24.
//

import UIKit
import SnapKit

final class IntakeDateCell: UITableViewCell {
    static let id = "IntakeDateCell"
    
    private let intakedateLabel: UILabel = {
        let label = UILabel()
        label.text = "섭취 요일"
        label.font = FontLiteral.subheadline(style: .bold).withSize(18)
        label.alpha = 0.6
        return label
    }()
    private let detailBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "button"), for: .normal)
        return button
    }()
    private let HStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        return stackView
    }()
    private let MonView: UIView = {
        let view = UIView()
        return view
    }()
    private let MonLabel: UILabel = {
        let label = UILabel()
        label.text = "월"
        label.font = FontLiteral.body(style: .regular).withSize(14)
        label.frame = CGRect(x: 0, y: 0, width: 33, height: 33)
        label.layer.cornerRadius = label.frame.width/2
        label.clipsToBounds = true
        label.backgroundColor = UIColor(hexCode: "E6E6E6")
        return label
    }()
    private let TueLabel: UILabel = {
        let label = UILabel()
        label.text = "화"
        label.font = FontLiteral.body(style: .regular).withSize(14)
        label.frame = CGRect(x: 0, y: 0, width: 33, height: 33)
        label.layer.cornerRadius = label.frame.width/2
        label.clipsToBounds = true
        label.backgroundColor = UIColor(hexCode: "E6E6E6")
        return label
    }()
    private let WenLabel: UILabel = {
        let label = UILabel()
        label.text = "수"
        label.font = FontLiteral.body(style: .regular).withSize(14)
        label.frame = CGRect(x: 0, y: 0, width: 33, height: 33)
        label.layer.cornerRadius = label.frame.width/2
        label.clipsToBounds = true
        label.backgroundColor = UIColor(hexCode: "E6E6E6")
        return label
    }()
    private let ThuLabel: UILabel = {
        let label = UILabel()
        label.text = "목"
        label.font = FontLiteral.body(style: .regular).withSize(14)
        label.frame = CGRect(x: 0, y: 0, width: 33, height: 33)
        label.layer.cornerRadius = label.frame.width/2
        label.clipsToBounds = true
        label.backgroundColor = UIColor(hexCode: "E6E6E6")
        return label
    }()
    private let FriLabel: UILabel = {
        let label = UILabel()
        label.text = "금"
        label.font = FontLiteral.body(style: .regular).withSize(14)
        label.frame = CGRect(x: 0, y: 0, width: 33, height: 33)
        label.layer.cornerRadius = label.frame.width/2
        label.clipsToBounds = true
        label.backgroundColor = UIColor(hexCode: "E6E6E6")
        return label
    }()
    private let SatLabel: UILabel = {
        let label = UILabel()
        label.text = "토"
        label.font = FontLiteral.body(style: .regular).withSize(14)
        label.frame = CGRect(x: 0, y: 0, width: 33, height: 33)
        label.layer.cornerRadius = label.frame.width/2
        label.clipsToBounds = true
        label.backgroundColor = UIColor(hexCode: "E6E6E6")
        return label
    }()
    private let SunLabel: UILabel = {
        let label = UILabel()
        label.text = "일"
        label.font = FontLiteral.body(style: .regular).withSize(14)
        label.frame = CGRect(x: 0, y: 0, width: 33, height: 33)
        label.layer.cornerRadius = label.frame.width/2
        label.clipsToBounds = true
        label.backgroundColor = UIColor(hexCode: "E6E6E6")
        return label
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
        [intakedateLabel, detailBtn, HStackView].forEach {
            self.contentView.addSubview($0)
        }
        [MonLabel, TueLabel, WenLabel, ThuLabel, FriLabel, SatLabel, SunLabel].forEach {
            self.HStackView.addArrangedSubview($0)
        }
        self.intakedateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.left.equalToSuperview().inset(20)
        }
        self.detailBtn.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.right.equalToSuperview().inset(20)
        }
        self.HStackView.snp.makeConstraints {
            $0.top.equalTo(intakedateLabel.snp.bottom).inset(-20)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(20)
        }
    }
}
