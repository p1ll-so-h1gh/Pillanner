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
        stackView.spacing = 15
        return stackView
    }()
    private let MonView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexCode: "E6E6E6")
        view.layer.cornerRadius = 13
        return view
    }()
    private let MonLabel: UILabel = {
        let label = UILabel()
        label.text = "월"
        label.font = FontLiteral.body(style: .regular).withSize(14)
        label.frame = CGRect(x: 0, y: 0, width: 33, height: 33)
        return label
    }()
    private let TueView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexCode: "E6E6E6")
        view.layer.cornerRadius = 13
        return view
    }()
    private let TueLabel: UILabel = {
        let label = UILabel()
        label.text = "화"
        label.font = FontLiteral.body(style: .regular).withSize(14)
        label.frame = CGRect(x: 0, y: 0, width: 33, height: 33)
        return label
    }()
    private let WedView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexCode: "E6E6E6")
        view.layer.cornerRadius = 13
        return view
    }()
    private let WedLabel: UILabel = {
        let label = UILabel()
        label.text = "수"
        label.font = FontLiteral.body(style: .regular).withSize(14)
        label.frame = CGRect(x: 0, y: 0, width: 33, height: 33)
        return label
    }()
    private let ThuView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexCode: "E6E6E6")
        view.layer.cornerRadius = 13
        return view
    }()
    private let ThuLabel: UILabel = {
        let label = UILabel()
        label.text = "목"
        label.font = FontLiteral.body(style: .regular).withSize(14)
        label.frame = CGRect(x: 0, y: 0, width: 33, height: 33)
        return label
    }()
    private let FriView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexCode: "E6E6E6")
        view.layer.cornerRadius = 13
        return view
    }()
    private let FriLabel: UILabel = {
        let label = UILabel()
        label.text = "금"
        label.font = FontLiteral.body(style: .regular).withSize(14)
        label.frame = CGRect(x: 0, y: 0, width: 33, height: 33)
        return label
    }()
    private let SatView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexCode: "E6E6E6")
        view.layer.cornerRadius = 13
        return view
    }()
    private let SatLabel: UILabel = {
        let label = UILabel()
        label.text = "토"
        label.font = FontLiteral.body(style: .regular).withSize(14)
        label.frame = CGRect(x: 0, y: 0, width: 33, height: 33)
        return label
    }()
    private let SunView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexCode: "E6E6E6")
        view.layer.cornerRadius = 13
        return view
    }()
    private let SunLabel: UILabel = {
        let label = UILabel()
        label.text = "일"
        label.font = FontLiteral.body(style: .regular).withSize(14)
        label.frame = CGRect(x: 0, y: 0, width: 33, height: 33)
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
        MonView.addSubview(MonLabel)
        TueView.addSubview(TueLabel)
        WedView.addSubview(WedLabel)
        ThuView.addSubview(ThuLabel)
        FriView.addSubview(FriLabel)
        SatView.addSubview(SatLabel)
        SunView.addSubview(SunLabel)
        [MonView, TueView, WedView, ThuView, FriView, SatView, SunView].forEach {
            self.HStackView.addArrangedSubview($0)
        }
        self.MonLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview().inset(8)
            $0.left.equalToSuperview().inset(10)
            $0.right.equalToSuperview().inset(10)
        }
        self.TueLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview().inset(8)
            $0.left.equalToSuperview().inset(10)
            $0.right.equalToSuperview().inset(10)
        }
        self.WedLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview().inset(8)
            $0.left.equalToSuperview().inset(10)
            $0.right.equalToSuperview().inset(10)
        }
        self.ThuLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview().inset(8)
            $0.left.equalToSuperview().inset(10)
            $0.right.equalToSuperview().inset(10)
        }
        self.FriLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview().inset(8)
            $0.left.equalToSuperview().inset(10)
            $0.right.equalToSuperview().inset(10)
        }
        self.SatLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview().inset(8)
            $0.left.equalToSuperview().inset(10)
            $0.right.equalToSuperview().inset(10)
        }
        self.SunLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview().inset(8)
            $0.left.equalToSuperview().inset(10)
            $0.right.equalToSuperview().inset(10)
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
