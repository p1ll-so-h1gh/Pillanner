//
//  PillTyeCell.swift
//  Pillanner
//
//  Created by 박민정 on 2/29/24.
//

import UIKit
import SnapKit

// 버튼 눌렀을 떄 반환값 필요

final class PillTypeCell: UITableViewCell {
    
    static let identifier = "PillTypeCell"
    private let sidePaddingSizeValue = 20
    private let cornerRadiusValue: CGFloat = 13
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "일반 / 처방"
        label.font = FontLiteral.subheadline(style: .bold).withSize(18)
        label.alpha = 0.6
        return label
    }()
    
    private lazy var generalPillView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = cornerRadiusValue
        view.backgroundColor = UIColor(hexCode: "E6E6E6")
        return view
    }()
    
    private let generalPillBtn: UIButton = {
        let button = UIButton()
        button.setTitle("일반약", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        return button
    }()
    
    private lazy var prescriptionPillView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = cornerRadiusValue
        view.backgroundColor = UIColor(hexCode: "E6E6E6")
        return view
    }()
    
    private let prescriptionPillBtn: UIButton = {
        let button = UIButton()
        button.setTitle("처방약", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        return button
    }()
    
    private let HStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .horizontal
        stackview.spacing = 15
        return stackview
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setupLayout()
        generalPillBtn.addTarget(self, action: #selector(tappedgeneralPillBtn), for: .touchUpInside)
        prescriptionPillBtn.addTarget(self, action: #selector(tappedprescriptionPillBtn), for: .touchUpInside)
    }
    
    @objc func tappedgeneralPillBtn() {
        generalPillView.layer.borderWidth = 2
        generalPillView.backgroundColor = .white
        generalPillView.layer.borderColor = UIColor.pointThemeColor2.cgColor
        prescriptionPillView.layer.borderColor = UIColor(hexCode: "E6E6E6").cgColor
        prescriptionPillView.backgroundColor = UIColor(hexCode: "E6E6E6")
    }
    
    @objc func tappedprescriptionPillBtn() {
        prescriptionPillView.layer.borderWidth = 2
        prescriptionPillView.backgroundColor = .white
        prescriptionPillView.layer.borderColor = UIColor.pointThemeColor2.cgColor
        generalPillView.layer.borderColor = UIColor(hexCode: "E6E6E6").cgColor
        generalPillView.backgroundColor = UIColor(hexCode: "E6E6E6")
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setupLayoutOnEditingProcess(type: String) {
        generalPillView.addSubview(generalPillBtn)
        generalPillBtn.snp.makeConstraints {
            $0.top.bottom.leading.trailing.centerX.centerY.equalToSuperview()
        }
        prescriptionPillView.addSubview(prescriptionPillBtn)
        prescriptionPillBtn.snp.makeConstraints {
            $0.top.bottom.leading.trailing.centerX.centerY.equalToSuperview()
        }
        HStackView.addArrangedSubview(generalPillView)
        HStackView.addArrangedSubview(prescriptionPillView)
        [titleLabel, HStackView].forEach {
            contentView.addSubview($0)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(sidePaddingSizeValue)
            $0.left.equalToSuperview().inset(sidePaddingSizeValue)
        }
        generalPillView.snp.makeConstraints {
            $0.width.equalTo(157)
            $0.height.equalTo(47)
        }
        prescriptionPillView.snp.makeConstraints {
            $0.width.equalTo(157)
            $0.height.equalTo(47)
        }
        HStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).inset(-sidePaddingSizeValue)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(sidePaddingSizeValue)
        }
    }
    
    func setupLayout() {
        generalPillView.addSubview(generalPillBtn)
        generalPillBtn.snp.makeConstraints {
            $0.top.bottom.leading.trailing.centerX.centerY.equalToSuperview()
        }
        prescriptionPillView.addSubview(prescriptionPillBtn)
        prescriptionPillBtn.snp.makeConstraints {
            $0.top.bottom.leading.trailing.centerX.centerY.equalToSuperview()
        }
        HStackView.addArrangedSubview(generalPillView)
        HStackView.addArrangedSubview(prescriptionPillView)
        [titleLabel, HStackView].forEach {
            contentView.addSubview($0)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(sidePaddingSizeValue)
            $0.left.equalToSuperview().inset(sidePaddingSizeValue)
        }
        generalPillView.snp.makeConstraints {
            $0.width.equalTo(157)
            $0.height.equalTo(47)
        }
        prescriptionPillView.snp.makeConstraints {
            $0.width.equalTo(157)
            $0.height.equalTo(47)
        }
        HStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).inset(-sidePaddingSizeValue)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(sidePaddingSizeValue)
        }
    }
    
    //cell 초기화 함수 - 선택된 버튼 없도록
    internal func reset() {
    }
}
